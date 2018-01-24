//
//  WebSocketService.swift
//  survivor
//
//  Created by Nikita Titov on 04/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import Cocoa
import CocoaLumberjack
import Starscream

protocol WebSocketServiceDelegate {
    
    func didConnect(service: WebSocketService)
    func didDisconnect(service: WebSocketService)
    func didEnter(service: WebSocketService, body: Enter)
    func didReceiveMap(service: WebSocketService, body: Map)
    func didLeave(service: WebSocketService, body: Leave)
    func didTeleport(service: WebSocketService, teleport: Teleport)
    
}

class WebSocketService: WebSocketDelegate {
    
    private let socket: WebSocket
    var delegate: WebSocketServiceDelegate?
    var timer: Timer?
    
    deinit {
        timer?.invalidate()
    }
    
    init() {
        let url = URL(string: "ws://localhost:9000/websocket")!
//        let url = URL(string: "ws://titov.link:9000/websocket")!
        let request = URLRequest(url: url)
        socket = WebSocket(request: request)
        socket.delegate = self
    }
    
    func connect() {
        socket.connect()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { (timer) in
            self.socket.write(ping: Data())
        })
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    // MARK: Actions
    
    let encoder = JSONEncoder()
    
    func actionEnter() {
        let message = EnterMessage()
        let jsonData = try! encoder.encode(message)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        socket.write(string: jsonString)
    }
    
    func actionLeave() {
        let message = LeaveMessage()
        let jsonData = try! encoder.encode(message)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        socket.write(string: jsonString)
    }
    
    func actionTeleport(point: CGPoint) {
        let message = InputMessage(x: Float(point.x), y: Float(point.y))
        let jsonData = try! encoder.encode(message)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        socket.write(string: jsonString)
    }
    
    // MARK: - WebSocketDelegate
    
    func websocketDidConnect(socket: WebSocketClient) {
        DDLogInfo("\(#function)")
        delegate?.didConnect(service: self)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        DDLogInfo("\(#function)")
        delegate?.didDisconnect(service: self)
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let data = text.data(using: .utf8)!
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        let message = try! MessageDecodable.decode(json)
        switch message.type {
        case "teleport":
            let concrete = try! TeleportDecodable.decode(message.body)
            let plain = concrete.poso()
            delegate?.didTeleport(service: self, teleport: plain)
        case "enter":
            let concrete = try! EnterDecodable.decode(message.body)
            let plain = concrete.poso()
            delegate?.didEnter(service: self, body: plain)
        case "map":
            let concrete = try! MapDecodable.decode(message.body)
            let plain = concrete.poso()
            delegate?.didReceiveMap(service: self, body: plain)
        case "leave":
            let concrete = try! LeaveDecodable.decode(message.body)
            let plain = concrete.poso()
            delegate?.didLeave(service: self, body: plain)
        default:
            DDLogError("Unknown message type = \(message.type)")
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        DDLogInfo("\(#function): \(data)")
    }

}

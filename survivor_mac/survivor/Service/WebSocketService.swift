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
    func didId(service: WebSocketService, body: Id)
    func didInit(service: WebSocketService, body: Init)
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
    
    private static var urlString: String {
        return "ws://localhost:9000/websocket"
//        let url = URL(string: "ws://titov.link:9000/websocket")!
    }
    
    init() {
        let url = URL(string: WebSocketService.urlString)!
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
    
    func actionClick(point: CGPoint) {
        let message = ClickMessage(x: Float(point.x), y: Float(point.y))
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
        let message = try! Message.decode(json)
        switch message.type {
        case "id":
            let b = try! Id.decode(message.body)
            delegate?.didId(service: self, body: b)
        case "teleport":
            let concrete = try! Teleport.decode(message.body)
            delegate?.didTeleport(service: self, teleport: concrete)
        case "init":
            let b = try! Init.decode(message.body)
            delegate?.didInit(service: self, body: b)
        case "enter":
            let concrete = try! Enter.decode(message.body)
            delegate?.didEnter(service: self, body: concrete)
        case "map":
            let concrete = try! Map.decode(message.body)
            delegate?.didReceiveMap(service: self, body: concrete)
        case "leave":
            let concrete = try! Leave.decode(message.body)
            delegate?.didLeave(service: self, body: concrete)
        default:
            DDLogError("Unknown message type = \(message.type)")
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        DDLogInfo("\(#function): \(data)")
    }

}

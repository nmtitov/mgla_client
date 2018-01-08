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
        let url = URL(string: "ws://localhost:8000/websocket")!
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
    
    func actionTeleport(point: CGPoint) {
        let dict = ["x": Double(point.x), "y": Double(point.y)]
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(dict)
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
        DDLogInfo("\(#function): \(text)")
        let data = text.data(using: .utf8)!
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        let td = try! TeleportDecodable.decode(json)
        let t = td.poso()
        delegate?.didTeleport(service: self, teleport: t)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        DDLogInfo("\(#function): \(data)")
    }

}

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
    func didReceiveTeleport(service: WebSocketService, point: CGPoint)
    
}

class WebSocketService: WebSocketDelegate {
    
    private let socket: WebSocket
    var delegate: WebSocketServiceDelegate?
    
    init() {
        let url = URL(string: "ws://localhost:8000/websocket")!
        let request = URLRequest(url: url)
        socket = WebSocket(request: request)
        socket.delegate = self
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    // MARK: Actions
    
    func actionEcho(string: String) {
        socket.write(string: string)
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
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        DDLogInfo("\(#function): \(data)")
    }

}

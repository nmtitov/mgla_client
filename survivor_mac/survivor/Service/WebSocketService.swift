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

class WebSocketService: WebSocketDelegate {
    
    private let socket: WebSocket
    
    init() {
        let url = URL(string: "ws://localhost:8000/websocket")!
        socket = WebSocket(url: url)
        socket.delegate = self
    }
    
    // MARK: - WebSocketDelegate
    
    func websocketDidConnect(socket: WebSocketClient) {
        DDLogInfo("\(#function)")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        DDLogInfo("\(#function)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        DDLogInfo("\(#function)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        DDLogInfo("\(#function)")
    }

}

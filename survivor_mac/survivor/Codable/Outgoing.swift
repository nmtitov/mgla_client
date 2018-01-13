//
//  Outgoing.swift
//  survivor
//
//  Created by Nikita Titov on 13/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import Foundation

struct InputMessage: Codable {
    let type = "input"
    let body: [String: Float]
    
    init(x: Float, y: Float) {
        body = ["x": x, "y": y]
    }
}

struct EnterMessage: Codable {
    let type = "enter"
    let body: [String: Float]
    
    init() {
        body = ["map": 0]
    }
}

struct LeaveMessage: Codable {
    let type = "leave"
    let body = [String: Float]()
}

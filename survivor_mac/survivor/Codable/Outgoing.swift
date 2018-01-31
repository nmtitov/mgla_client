//
//  Outgoing.swift
//  survivor
//
//  Created by Nikita Titov on 13/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import Foundation

struct ClickMessage: Codable {
    let type = "click"
    let body: ClickBody
    
    init(body: ClickBody) {
        self.body = body
    }
}

struct ClickBody: Codable {
    let point: [String: Float]
    let avatar_id: Int?
    
    init(x: Float, y: Float, avatar_id: Int?) {
        self.point = ["x": x, "y": y]
        self.avatar_id = avatar_id
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

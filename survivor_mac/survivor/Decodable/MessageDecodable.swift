//
//  MessageDecodable.swift
//  survivor
//
//  Created by Nikita Titov on 12/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import Foundation
import protocol Decodable.Decodable
import enum Decodable.DecodingError
import Decodable
import CocoaLumberjack

struct MessageDecodable: Decodable {
    let type: String
    let body: Any
    
    init(type: String, body: Any) {
        self.type = type
        self.body = body
    }
    
    static func decode(_ json: Any) throws -> MessageDecodable {
        return try MessageDecodable(
            type: json => "type",
            body: json => "body"
        )
    }
}

struct EnterDecodable: Decodable {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    static func decode(_ json: Any) throws -> EnterDecodable {
        return try EnterDecodable(
            id: json => "id"
        )
    }
    
    func poso() -> Enter {
        return Enter(id: id)
    }
}

struct LeaveDecodable: Decodable {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    static func decode(_ json: Any) throws -> LeaveDecodable {
        return try LeaveDecodable(
            id: json => "id"
        )
    }
    
    func poso() -> Leave {
        return Leave(id: id)
    }
}

struct TeleportDecodable: Decodable {
    let id: Int
    let point: PointDecodable
    
    init(id: Int, point: PointDecodable) {
        self.id = id
        self.point = point
    }
    
    static func decode(_ json: Any) throws -> TeleportDecodable {
        return try TeleportDecodable(
            id: json => "id",
            point: json => "point"
        )
    }
    
    func poso() -> Teleport {
        return Teleport(id: id, point: CGPoint(x: point.x, y: point.y))
    }
}

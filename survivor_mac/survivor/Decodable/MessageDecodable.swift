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

//{
//    "name": "grass",
//    "position": {
//        "x": 64.0,
//        "y": 0.0
//    },
//    "size": {
//        "width": 64.0,
//        "height": 64.0
//    },
//    "z": 0
//},

struct AssetDecodable: Decodable {
    let name: String
    let position: PointDecodable
    let size: SizeDecodable
    let z: Int

    init(name: String, position: PointDecodable, size: SizeDecodable, z: Int) {
        self.name = name
        self.position = position
        self.size = size
        self.z = z
    }
    
    static func decode(_ json: Any) throws -> AssetDecodable {
        return try AssetDecodable(
            name: json => "name",
            position: json => "position",
            size: json => "size",
            z: json => "z"
        )
    }
    
    func poso() -> Asset {
        return Asset(
            name: name,
            position: CGPoint(x: position.x, y: position.y),
            size: CGSize(width: size.width, height: size.height),
            z: z
        )
    }
}

//{
//    "type": "block",
//    "position": {
//        "x": 100.0,
//        "y": 200.0
//    },
//    "size": {
//        "width": 100.0,
//        "height": 100.0
//    }
//},

struct BlockDecodable: Decodable {
    let type: String
    let position: PointDecodable
    let size: SizeDecodable
    
    init(type: String, position: PointDecodable, size: SizeDecodable) {
        self.type = type
        self.position = position
        self.size = size
    }
    
    static func decode(_ json: Any) throws -> BlockDecodable {
        return try BlockDecodable(
            type: json => "type",
            position: json => "position",
            size: json => "size"
        )
    }
    
    func poso() -> Block {
        return Block(
            type: type,
            position: CGPoint(x: position.x, y: position.y),
            size: CGSize(width: size.width, height: size.height)
        )
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

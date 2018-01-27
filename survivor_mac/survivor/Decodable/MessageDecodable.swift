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

struct Message: Decodable {
    let type: String
    let body: Any
    
    static func decode(_ json: Any) throws -> Message {
        return try Message(
            type: json => "type",
            body: json => "body"
        )
    }
}

struct Init: Decodable {
    let id: Int
    let name: String
    let position: Point
    let health_percent: Double
    let mana_percent: Double
    let state: String
    
    static func decode(_ j: Any) throws -> Init {
        return try Init(
            id: j => "id",
            name: j => "name",
            position: j => "position",
            health_percent: j => "health_percent",
            mana_percent: j => "mana_percent",
            state: j => "state"
        )
    }
}

struct Enter: Decodable {
    let id: Int
    
    static func decode(_ json: Any) throws -> Enter {
        return try Enter(
            id: json => "id"
        )
    }
}

struct Leave: Decodable {
    let id: Int
    
    static func decode(_ json: Any) throws -> Leave {
        return try Leave(
            id: json => "id"
        )
    }
}

struct Map: Decodable {
    let name: String
    let size: Size
    let assets: [Asset]
    let blocks: [Block]
    
    static func decode(_ json: Any) throws -> Map {
        return try Map(
            name: json => "name",
            size: json => "size",
            assets: json => "assets",
            blocks: json => "blocks"
        )
    }
}

struct Asset: Decodable {
    let name: String
    let position: Point
    let size: Size
    let z: Int

    static func decode(_ json: Any) throws -> Asset {
        return try Asset(
            name: json => "name",
            position: json => "position",
            size: json => "size",
            z: json => "z"
        )
    }
}

struct Block: Decodable {
    let type: String
    let position: Point
    let size: Size
    
    static func decode(_ json: Any) throws -> Block {
        return try Block(
            type: json => "type",
            position: json => "position",
            size: json => "size"
        )
    }
}

struct Teleport: Decodable {
    let id: Int
    let point: Point
    let newState: String?

    static func decode(_ json: Any) throws -> Teleport {
        return try Teleport(
            id: json => "id",
            point: json => "point",
            newState: json => "new_state"
        )
    }
}

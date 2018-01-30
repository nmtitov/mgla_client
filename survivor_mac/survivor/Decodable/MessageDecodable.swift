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
    
    static func decode(_ j: Any) throws -> Message {
        return try Message(
            type: j => "type",
            body: j => "body"
        )
    }
}

struct Id: Decodable {
    let id: Int
    
    static func decode(_ j: Any) throws -> Id {
        return try Id(
            id: j => "id"
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
    
    static func decode(_ j: Any) throws -> Enter {
        return try Enter(
            id: j => "id"
        )
    }
}

struct Leave: Decodable {
    let id: Int
    
    static func decode(_ j: Any) throws -> Leave {
        return try Leave(
            id: j => "id"
        )
    }
}

struct Map: Decodable {
    let name: String
    let size: Size
    let assets: [Asset]
    let blocks: [Block]
    
    static func decode(_ j: Any) throws -> Map {
        return try Map(
            name: j => "name",
            size: j => "size",
            assets: j => "assets",
            blocks: j => "blocks"
        )
    }
}

struct Asset: Decodable {
    let name: String
    let position: Point
    let size: Size
    let z: Int

    static func decode(_ j: Any) throws -> Asset {
        return try Asset(
            name: j => "name",
            position: j => "position",
            size: j => "size",
            z: j => "z"
        )
    }
}

struct Block: Decodable {
    let type: String
    let position: Point
    let size: Size
    
    static func decode(_ j: Any) throws -> Block {
        return try Block(
            type: j => "type",
            position: j => "position",
            size: j => "size"
        )
    }
}

struct Update: Decodable {
    let id: Int
    let position: Point?
    let state: String?
    let health_percent: Double?
    let mana_percent: Double?
    
    static func decode(_ j: Any) throws -> Update {
        return try Update(
            id: j => "id",
            position: j => "position",
            state: j => "state",
            health_percent: j => "health_percent",
            mana_percent: j => "mana_percent"
        )
    }
}

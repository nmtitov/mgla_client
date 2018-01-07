//
//  TeleportDecodable.swift
//  survivor
//
//  Created by Nikita Titov on 07/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import Foundation
import protocol Decodable.Decodable
import enum Decodable.DecodingError
import Decodable
import CocoaLumberjack

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

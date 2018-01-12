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


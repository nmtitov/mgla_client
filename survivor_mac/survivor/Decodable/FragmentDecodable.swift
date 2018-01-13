//
//  FragmentDecodable.swift
//  survivor
//
//  Created by Nikita Titov on 05/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import Foundation
import protocol Decodable.Decodable
import enum Decodable.DecodingError
import Decodable
import CocoaLumberjack

struct PointDecodable: Decodable {
    
    let x: Double
    let y: Double

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    static func decode(_ json: Any) throws -> PointDecodable {
        return try PointDecodable(
            x: json => "x",
            y: json => "y"
        )
    }

}

struct SizeDecodable: Decodable {
    let width: Double
    let height: Double
    
    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    
    static func decode(_ json: Any) throws -> SizeDecodable {
        return try SizeDecodable(
            width: json => "width",
            height: json => "height"
        )
    }
}

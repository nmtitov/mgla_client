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

struct Point: Decodable {
    let x: Double
    let y: Double

    static func decode(_ j: Any) throws -> Point {
        return try Point(
            x: j => "x",
            y: j => "y"
        )
    }
    
    func cgPoint() -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}

struct Size: Decodable {
    let width: Double
    let height: Double
    
    static func decode(_ j: Any) throws -> Size {
        return try Size(
            width: j => "width",
            height: j => "height"
        )
    }
    
    func cgSize() -> CGSize {
        return CGSize(width: width, height: height)
    }
}

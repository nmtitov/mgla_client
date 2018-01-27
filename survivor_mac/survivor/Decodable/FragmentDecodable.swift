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

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    static func decode(_ json: Any) throws -> Point {
        return try Point(
            x: json => "x",
            y: json => "y"
        )
    }
    
    func cgPoint() -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}

struct Size: Decodable {
    let width: Double
    let height: Double
    
    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    
    static func decode(_ json: Any) throws -> Size {
        return try Size(
            width: json => "width",
            height: json => "height"
        )
    }
    
    func cgSize() -> CGSize {
        return CGSize(width: width, height: height)
    }
}

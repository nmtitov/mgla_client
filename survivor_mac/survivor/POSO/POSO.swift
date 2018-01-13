//
//  POSO.swift
//  survivor
//
//  Created by Nikita Titov on 07/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import Foundation

struct Enter {
    let id: Int
}

struct Asset {
    let name: String
    let position: CGPoint
    let size: CGSize
    let z: Int
}

struct Block {
    let type: String
    let position: CGPoint
    let size: CGSize
}

struct Leave {
    let id: Int
}

struct Teleport {
    let id: Int
    let point: CGPoint
}

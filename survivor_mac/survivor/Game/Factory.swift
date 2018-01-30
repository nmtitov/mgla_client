//
//  Factory.swift
//  survivor
//
//  Created by Nikita Titov on 30/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import SpriteKit

class Factory {    
    static func createAssetNode(from asset: Asset) -> SKSpriteNode {
        let image = NSImage(named: .init(rawValue: asset.name))!
        let texture = SKTexture(image: image)
        let node = SKSpriteNode(texture: texture)
        node.anchorPoint = CGPoint.zero
        node.size = asset.size.cgSize()
        node.zPosition = CGFloat(asset.z)
        node.position = asset.position.cgPoint()
        return node
    }
    
    static func createBlockNode(from block: Block) -> SKShapeNode {
        let node = SKShapeNode(rect: CGRect(origin: block.position.cgPoint(), size: block.size.cgSize()))
        node.name = "\(block.type)"
        node.fillColor = .clear
        node.strokeColor = .black
        node.zPosition = CGFloat(NodeLevel.block.rawValue)
        return node
    }
    
    static func createFrontierNode(size: CGSize) -> SKShapeNode {
        let node = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: size))
        node.name = "frontier"
        node.fillColor = .clear
        node.strokeColor = .white
        node.lineWidth = 2
        node.zPosition = CGFloat(NodeLevel.frontier.rawValue)
        return node
    }
}

//
//  Factory.swift
//  survivor
//
//  Created by Nikita Titov on 30/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import SpriteKit

class Factory {
    static func createNode(id: Int, point: CGPoint) -> SKNode {
        let node = SKShapeNode(circleOfRadius: 1)
        node.name = "\(id)"
        node.fillColor = .white
        node.position = point
        node.zPosition = CGFloat(NodeLevel.other_player.rawValue)
        return node
    }
    
    static func createMage(_ body: Init) -> SKNode {
        let image1 = NSImage(named: .init(rawValue: "mage-walk1"))!
        let textureWalk1 = SKTexture(image: image1)
        
        let image2 = NSImage(named: .init(rawValue: "mage-walk2"))!
        let _ = SKTexture(image: image2)
        
        let node = SKSpriteNode(texture: textureWalk1)
        node.name = "\(body.id)"
        node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        node.zPosition = CGFloat(NodeLevel.other_player.rawValue)
        node.position = body.position.cgPoint()
        
        return node
    }
    
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

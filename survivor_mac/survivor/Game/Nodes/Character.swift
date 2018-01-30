//
//  Character.swift
//  survivor
//
//  Created by Nikita Titov on 30/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import SpriteKit

class Character: SKSpriteNode {
    enum Key: String {
        case idleAnimation
        case walkAnimation
    }
    
    init() {
        let texture = SKTexture(imageNamed: "mage-walk1")
        super.init(texture: texture, color: .clear, size: texture.size())
        anchorPoint = CGPoint(x: 0.5, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleWalkAnimation() {
        if action(forKey: Key.walkAnimation.rawValue) != nil {
            return
        }
        run(SKAction.repeatForever(SKAction.animate(with: [
            SKTexture(imageNamed: "mage-walk1"),
            SKTexture(imageNamed: "mage-walk2"),
        ], timePerFrame: 0.2, resize: true, restore: false)), withKey: Key.walkAnimation.rawValue)
    }
    
    func toggleIdleAnimation() {
        removeAction(forKey: Key.walkAnimation.rawValue)
    }
    
    func look(at point: CGPoint) {
        guard let scene = scene, let parent = parent else {
            return
        }
        let inScene = scene.convert(position, from: parent)
        xScale = point.x - inScene.x > 0 ? 1 : -1
    }
}

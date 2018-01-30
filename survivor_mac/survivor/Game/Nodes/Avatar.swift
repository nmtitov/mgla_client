//
//  Avatar.swift
//  survivor
//
//  Created by Nikita Titov on 30/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import SpriteKit

class Avatar: SKNode {
    /* meta */
    let id: Int
    let isPlayer: Bool
    
    /* objects */
    let nameLabel: SKLabelNode
    let character: Character
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ body: Init, isPlayer: Bool) {
        nameLabel = SKLabelNode(text: body.name)
        nameLabel.fontName = "Helvetica-Neue"
        nameLabel.fontSize = 12
        
        self.id = body.id
        self.isPlayer = isPlayer
        self.character = Character()
        super.init()
        addChild(character)
        addChild(nameLabel)
        zPosition = (self.isPlayer ? NodeLevel.player : NodeLevel.other_player).rawValue
        position = body.position.cgPoint()
        
        nameLabel.zPosition = zPosition + 10
        nameLabel.position = CGPoint(x: nameLabel.position.x, y: character.frame.maxY + 10)
    }
    
    func handleTeleport(_ body: Teleport) {
        let b = body.point.cgPoint()
        character.look(at: b)
        
        if let newState = body.newState, newState == "walk" {
            character.toggleWalkAnimation()
        }
        
        let action = SKAction.move(to: b, duration: 0.16)
        let seq = SKAction.sequence([action, SKAction.run {
            if let newState = body.newState, newState == "idle" {
                self.character.toggleIdleAnimation()
            }
        }])
        run(seq)
    }
}

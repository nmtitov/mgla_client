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
        
        nameLabel.zPosition = 10
        nameLabel.position = CGPoint(x: nameLabel.position.x, y: character.frame.maxY + 16)
        
        let w: CGFloat = 40
        let h: CGFloat = 4
        let healthRect = CGRect(x: -w/2, y: character.frame.maxY + 10, width: w, height: h)
        let healthBgBar = SKShapeNode(rect: healthRect, cornerRadius: 0)
        healthBgBar.strokeColor = .clear
        healthBgBar.fillColor = .darkGray
        healthBgBar.zPosition = 5

        let manaRect = CGRect(x: -w/2, y: character.frame.maxY + 4, width: w, height: h)
        let manaBgBar = SKShapeNode(rect: manaRect, cornerRadius: 0)
        manaBgBar.strokeColor = .clear
        manaBgBar.fillColor = .darkGray
        manaBgBar.zPosition = 5
        
        addChild(healthBgBar)
        addChild(manaBgBar)
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

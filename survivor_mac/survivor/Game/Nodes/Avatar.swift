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
    let character: Character
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ body: Init, isPlayer: Bool) {
        self.id = body.id
        self.isPlayer = isPlayer
        self.character = Character()
        super.init()
        addChild(character)
        zPosition = (self.isPlayer ? NodeLevel.player : NodeLevel.other_player).rawValue
        position = body.position.cgPoint()
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

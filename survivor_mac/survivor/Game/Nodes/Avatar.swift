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
    var nameLabel: SKLabelNode!
    var character: Character!
    var healthBar: SKShapeNode!
    var manaBar: SKShapeNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        fatalError("init(coder:) has not been implemented")
    }
    
    let barWidth: CGFloat = 40
    let barHeight: CGFloat = 4
    
    init(_ body: Init, isPlayer: Bool) {
        self.id = body.id
        self.isPlayer = isPlayer
        super.init()
        
        zPosition = (self.isPlayer ? NodeLevel.player : NodeLevel.other_player).rawValue
        position = body.position.cgPoint()

        character = Character()
        
        nameLabel = SKLabelNode(text: body.name)
        nameLabel.fontName = "Helvetica-Neue"
        nameLabel.fontSize = 12
        nameLabel.zPosition = 10
        nameLabel.position = CGPoint(x: nameLabel.position.x, y: character.frame.maxY + 16)
        
        let healthBgRect = createHealthRect(percent: 1.0)
        let healthBgBar = SKShapeNode(rect: healthBgRect, cornerRadius: 0)
        healthBgBar.strokeColor = .clear
        healthBgBar.fillColor = .darkGray
        healthBgBar.zPosition = 5
        
        let manaBgRect = createManaRect(percent: 1.0)
        let manaBgBar = SKShapeNode(rect: manaBgRect, cornerRadius: 0)
        manaBgBar.strokeColor = .clear
        manaBgBar.fillColor = .darkGray
        manaBgBar.zPosition = 5
        
        let healthRect = createHealthRect(percent: body.health_percent)
        healthBar = SKShapeNode(rect: healthRect, cornerRadius: 0)
        healthBar.strokeColor = .clear
        healthBar.fillColor = .red
        healthBar.zPosition = healthBgBar.zPosition + 1
        
        let manaRect = createManaRect(percent: body.mana_percent)
        manaBar = SKShapeNode(rect: manaRect, cornerRadius: 0)
        manaBar.strokeColor = .clear
        manaBar.fillColor = .blue
        manaBar.zPosition = manaBgBar.zPosition + 1
        
        addChild(character)
        addChild(nameLabel)

        addChild(healthBgBar)
        addChild(manaBgBar)
        
        addChild(healthBar)
        addChild(manaBar)
    }
    
    func createHealthRect(percent: Double) -> CGRect {
        return CGRect(x: -barWidth / 2, y: character.frame.maxY + 10, width: barWidth * CGFloat(percent), height: barHeight)
    }

    func createManaRect(percent: Double) -> CGRect {
        return CGRect(x: -barWidth/2, y: character.frame.maxY + 4, width: barWidth*CGFloat(percent), height: barHeight)
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
    
    func handleHealthPercent(_ percent: Double) {
//        healthBar.xScale = CGFloat(percent)
    }
    
    func handleManaPercent(_ percent: Double) {
//        manaBar.xScale = CGFloat(percent)
    }
}

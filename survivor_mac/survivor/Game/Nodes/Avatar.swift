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
    var healthBar: SKSpriteNode!
    var manaBar: SKSpriteNode!
    
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
        let healthBgBar = SKSpriteNode(color: .darkGray, size: healthBgRect.size)
        healthBgBar.anchorPoint = CGPoint(x: 0, y: 0)
        healthBgBar.position = healthBgRect.origin
        healthBgBar.zPosition = 5
        
        let manaBgRect = createManaRect(percent: 1.0)
        let manaBgBar = SKSpriteNode(color: .darkGray, size: manaBgRect.size)
        manaBgBar.anchorPoint = CGPoint(x: 0, y: 0)
        manaBgBar.position = manaBgRect.origin
        manaBgBar.zPosition = 5
        
        let healthRect = createHealthRect(percent: body.health_percent)
        healthBar = SKSpriteNode(color: .red, size: healthRect.size)
        healthBar.anchorPoint = CGPoint(x: 0, y: 0)
        healthBar.position = healthRect.origin
        healthBar.zPosition = healthBgBar.zPosition + 1
        
        let manaRect = createManaRect(percent: body.mana_percent)
        manaBar = SKSpriteNode(color: .blue, size: healthRect.size)
        manaBar.anchorPoint = CGPoint(x: 0, y: 0)
        manaBar.position = manaRect.origin
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

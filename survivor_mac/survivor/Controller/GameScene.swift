//
//  GameScene.swift
//  survivor
//
//  Created by Nikita Titov on 04/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String: GKGraph]()
    
    var me: SKNode?
    
    override func sceneDidLoad() {
        
    }
    
    func touchDown(atPoint pos: CGPoint) {
        print(pos)
        AppDelegate.shared.webSocketService.actionTeleport(point: pos)
    }
    
    func touchMoved(toPoint pos: CGPoint) {
        
    }
    
    func touchUp(atPoint pos: CGPoint) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    // MARK: - API
    
    func actionTeleport(_ point: CGPoint) {
        if let me = me  {
            me.position = point
        } else {
            let node = SKShapeNode(circleOfRadius: 5)
            node.fillColor = .white
            node.position = point
            addChild(node)
            me = node
        }
    }
    
    // MARK: - Input Handling (OS X)

    override func keyDown(with _: NSEvent) {
        
    }
    
    override func mouseDown(with event: NSEvent) {
        let clickLocation = event.location(in: self)
        self.touchDown(atPoint: clickLocation)
    }
    
    override func mouseDragged(with event: NSEvent) {
        let clickLocation = event.location(in: self)
        self.touchMoved(toPoint: clickLocation)
    }

}

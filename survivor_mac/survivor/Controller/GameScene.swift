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
    
    var nodes = [SKNode]()
    
    override func sceneDidLoad() {
        
    }
    
    func touchDown(atPoint pos: CGPoint) {
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
    
    func actionTeleport(_ teleport: Teleport) {
        let id = teleport.id
        let point = teleport.point
        
        let node = nodes.first(where:{ (node) -> Bool in
            return node.name == "\(id)"
        })
        
        if let node = node {
            node.position = point
        } else {
            let node = createNode(id: id, point: point)
            nodes.append(node)
            addChild(node)
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

    // MARK: - Factory
    
    private func createNode(id: Int, point: CGPoint) -> SKNode {
        let node = SKShapeNode(circleOfRadius: 1)
        node.name = "\(id)"
        node.fillColor = .white
        node.position = point
        return node
    }
}

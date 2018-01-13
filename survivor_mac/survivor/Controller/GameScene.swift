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
    var cam: SKCameraNode!
    var player: SKNode?
    
    override func sceneDidLoad() {
        
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        cam = SKCameraNode()
        camera = cam
        addChild(cam)
    }
    
    func touchDown(atPoint pos: CGPoint) {
        AppDelegate.shared.webSocketService.actionTeleport(point: pos)
    }
    
    func touchMoved(toPoint pos: CGPoint) {
        
    }
    
    func touchUp(atPoint pos: CGPoint) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if let player = player {
            cam.position = player.position
        }
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
            if player == nil {
                player = node
            }
            nodes.append(node)
            addChild(node)
        }
    }
    
    func actionLoad(assets: [Asset], blocks: [Block]) {
        for asset in assets {
            let image = NSImage(named: .init(rawValue: asset.name))!
            let texture = SKTexture(image: image)
            let node = SKSpriteNode(texture: texture)
            node.size = asset.size
            node.zPosition = CGFloat(asset.z)
            node.position = asset.position
            addChild(node)
        }
        for block in blocks {
            let node = SKShapeNode(rect: CGRect(origin: block.position, size: block.size))
            node.name = "\(block.type)"
            node.fillColor = .black
            node.zPosition = 100
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
        node.zPosition = 1000
        return node
    }
    
}

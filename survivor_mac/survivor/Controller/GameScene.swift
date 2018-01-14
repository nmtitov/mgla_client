//
//  GameScene.swift
//  survivor
//
//  Created by Nikita Titov on 04/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import SpriteKit
import GameplayKit

enum NodeLevel: Int {
    case ground = 0
    case frontier = 100
    case block = 1000
    case other_player = 5000
    case player = 10000
}

class GameScene: SKScene, Ensurable {
    
    var entities = [GKEntity]()
    var graphs = [String: GKGraph]()
    
    var nodes = [SKNode]()
    var cam: SKCameraNode!
    var player: SKNode?
    
    func ensure() {
        assert(cam != nil)
    }
    
    override func sceneDidLoad() {
        
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        cam = SKCameraNode()
        camera = cam
        addChild(cam)
        ensure()
    }
    
    func touchDown(atPoint point: CGPoint) {
        AppDelegate.shared.webSocketService.actionTeleport(point: point)
    }
    
    func touchMoved(toPoint point: CGPoint) {
        
    }
    
    func touchUp(atPoint point: CGPoint) {
        
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
            let action = SKAction.move(to: point, duration: 0.33)
            node.run(action)
        } else {
            let node = createNode(id: id, point: point)
            if player == nil {
                player = node
            }
            nodes.append(node)
            addChild(node)
        }
    }
    
    func actionLoad(frontier: CGSize, assets: [Asset], blocks: [Block]) {
        let node = createFrontierNode(size: frontier)
        addChild(node)
        
        for item in assets {
            let node = createAssetNode(from: item)
            addChild(node)
        }
        for item in blocks {
            let node = createBlockNode(from: item)
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
        node.zPosition = CGFloat(NodeLevel.other_player.rawValue)
        return node
    }
    
    private func createAssetNode(from asset: Asset) -> SKSpriteNode {
        let image = NSImage(named: .init(rawValue: asset.name))!
        let texture = SKTexture(image: image)
        let node = SKSpriteNode(texture: texture)
        node.anchorPoint = CGPoint.zero
        node.size = asset.size
        node.zPosition = CGFloat(asset.z)
        node.position = asset.position
        return node
    }
    
    private func createBlockNode(from block: Block) -> SKShapeNode {
        let node = SKShapeNode(rect: CGRect(origin: block.position, size: block.size))
        node.name = "\(block.type)"
        node.fillColor = .clear
        node.strokeColor = .black
        node.zPosition = CGFloat(NodeLevel.block.rawValue)
        return node
    }
    
    private func createFrontierNode(size: CGSize) -> SKShapeNode {
        let node = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: size))
        node.name = "frontier"
        node.fillColor = .clear
        node.strokeColor = .white
        node.lineWidth = 2
        node.zPosition = CGFloat(NodeLevel.frontier.rawValue)
        return node
    }
    
}

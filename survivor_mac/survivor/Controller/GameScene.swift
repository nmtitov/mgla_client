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
        
        let existing = nodes.first(where:{ (node) -> Bool in
            return node.name == "\(id)"
        })
        
        if let node = existing {
            let direction = CGPoint(x: point.x - node.position.x, y: point.y - node.position.y)
            node.xScale = direction.x > 0 ? 1 : -1
            let action = SKAction.move(to: point, duration: 0.16)
            let seq = SKAction.sequence([action, SKAction.customAction(withDuration: 0, actionBlock: { (_, _) in
                let node = self.nodes.first(where:{ (node) -> Bool in
                    return node.name == "\(id)"
                })
                if let node = node, let newState = teleport.newState {
                    switch newState {
                    case "idle":
                        node.removeAction(forKey: "walk")
                        break
                    case "walk":
                        break
                    default:
                        break
                    }
                }
            })])
            node.run(seq)
        } else {
            let node = createMageNode(id: id, point: point)
            if player == nil {
                player = node
            }
            nodes.append(node)
            addChild(node)
        }
        let node = self.nodes.first(where:{ (node) -> Bool in
            return node.name == "\(id)"
        })
        if let node = node, let newState = teleport.newState {
            switch newState {
            case "idle":
                break
            case "walk":
                node.removeAllActions()
                let image1 = NSImage(named: .init(rawValue: "mage-walk1"))!
                let textureWalk1 = SKTexture(image: image1)
                
                let image2 = NSImage(named: .init(rawValue: "mage-walk2"))!
                let textureWalk2 = SKTexture(image: image2)
                
                let walkAction = SKAction.repeatForever(SKAction.animate(with: [textureWalk2, textureWalk1], timePerFrame: 0.2))
                node.run(walkAction, withKey: "walk")
                break
            default:
                break
            }
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
    
    override func rightMouseDown(with event: NSEvent) {
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
    
    private func createMageNode(id: Int, point: CGPoint) -> SKNode {
        let image1 = NSImage(named: .init(rawValue: "mage-walk1"))!
        let textureWalk1 = SKTexture(image: image1)
        
        let image2 = NSImage(named: .init(rawValue: "mage-walk2"))!
        let textureWalk2 = SKTexture(image: image2)
        
        let node = SKSpriteNode(texture: textureWalk1)
        node.name = "\(id)"
        node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        node.zPosition = CGFloat(NodeLevel.other_player.rawValue)
        node.position = point

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

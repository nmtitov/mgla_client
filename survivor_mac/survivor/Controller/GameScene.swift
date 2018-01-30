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
        AppDelegate.shared.webSocketService.actionClick(point: point)
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
    
    var serverId: Int!
    
    func actionId(body: Id) {
        serverId = body.id
    }
    
    func actionInit(body: Init) {
        let n = Factory.createMageNode(id: body.id, point: body.position.cgPoint())
        if body.id == serverId {
            n.zPosition = CGFloat(NodeLevel.player.rawValue)
            player = n
        }
        nodes.append(n)
        addChild(n)
    }
    
    func actionEnter(body: Enter) {
        
    }
    
    func actionTeleport(_ teleport: Teleport) {
        let id = teleport.id
        let point = teleport.point
        
        guard let node = nodes.first(where:{ (node) -> Bool in
            return node.name == "\(id)"
        }) else {
            return
        }
        
        let direction = CGPoint(x: CGFloat(point.x) - node.position.x, y: CGFloat(point.y) - node.position.y)
        node.xScale = direction.x > 0 ? 1 : -1
        let action = SKAction.move(to: point.cgPoint(), duration: 0.16)
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

        if let newState = teleport.newState {
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
        let node = Factory.createFrontierNode(size: frontier)
        addChild(node)
        
        for item in assets {
            let node = Factory.createAssetNode(from: item)
            addChild(node)
        }
        for item in blocks {
            let node = Factory.createBlockNode(from: item)
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
    
}

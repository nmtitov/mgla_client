//
//  GameScene.swift
//  survivor
//
//  Created by Nikita Titov on 04/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import SpriteKit
import GameplayKit

enum NodeLevel: CGFloat {
    case ground = 0
    case frontier = 100
    case block = 1000
    case other_player = 5000
    case player = 10000
}

class GameScene: SKScene, Ensurable {
    
    var entities = [GKEntity]()
    var graphs = [String: GKGraph]()
    
    var avatars = [Int: Avatar]()
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
        let node = Avatar(body, isPlayer: serverId == body.id)
        if node.isPlayer {
            player = node
        }
        avatars[body.id] = node
        addChild(node)
    }
    
    func actionEnter(body: Enter) {
        
    }
    
    func actionTeleport(_ body: Teleport) {
        guard let node = avatars[body.id] else {
            return
        }
        node.handleTeleport(body)
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

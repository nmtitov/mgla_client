//
//  ViewController.swift
//  survivor
//
//  Created by Nikita Titov on 04/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController, WebSocketServiceDelegate {
    
    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        func setupScene() {
            // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
            // including entities and graphs.
            let scene = GKScene(fileNamed: "GameScene")!
            
            // Get the SKScene from the loaded GKScene
            let sceneNode = scene.rootNode as! GameScene
            
            // Copy gameplay related content over to the scene
            sceneNode.entities = scene.entities
            sceneNode.graphs = scene.graphs
            
            // Set the scale mode to scale to fit the window
            sceneNode.scaleMode = .aspectFill
            
            // Present the scene
            let view = self.skView!
            
            sceneNode.size = view.bounds.size
            
            view.presentScene(sceneNode)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        super.viewDidLoad()
        setupScene()
        AppDelegate.shared.webSocketService.delegate = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        AppDelegate.shared.webSocketService.connect()
    }
    
    // MARK: - WebSocketServiceDelegate
    
    func didConnect(service: WebSocketService) {
        AppDelegate.shared.webSocketService.actionEcho(string: "Hello")
    }
    
    func didDisconnect(service: WebSocketService) {
        
    }
    
    func didReceiveTeleport(service: WebSocketService, point: CGPoint) {
        
    }
    
}

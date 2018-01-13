//
//  GameController.swift
//  survivor
//
//  Created by Nikita Titov on 04/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit
import CocoaLumberjack

class GameController: NSViewController, Identifiable, Ensurable, WebSocketServiceDelegate {
    
    @IBOutlet var skView: SKView!
    @IBOutlet weak var leaveButton: NSButton!
    
    var scene: GameScene!
    
    func ensure() {
        assert(skView != nil)
        assert(scene != nil)
        assert(leaveButton != nil)
        assert(leaveButton.target != nil)
        assert(leaveButton.action != nil)
    }
    
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
            
            self.scene = sceneNode
        }
        super.viewDidLoad()
        setupScene()
        AppDelegate.shared.webSocketService.delegate = self
        ensure()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        AppDelegate.shared.webSocketService.actionEnter()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        AppDelegate.shared.webSocketService.actionLeave()
    }
    
    // MARK: - Actions
    
    @IBAction func actionLeave(_ sender: Any) {
        AppDelegate.shared.webSocketService.actionLeave()
    }
    
    // MARK: - WebSocketServiceDelegate
    
    func didConnect(service: WebSocketService) {
        
    }
    
    func didDisconnect(service: WebSocketService) {
        
    }
    
    func didEnter(service: WebSocketService, body: Enter) {
        DDLogInfo("\(#function)")
    }
    
    func didReceiveMap(service: WebSocketService, body: Map) {
        DDLogInfo("\(#function)")
        scene.actionLoad(body.assets)
    }
    
    func didLeave(service: WebSocketService, body: Leave) {
        DDLogInfo("\(#function)")
        view.window?.close()
    }
    
    func didTeleport(service: WebSocketService, teleport: Teleport) {
        scene.actionTeleport(teleport)
    }
    
}

//
//  MainController.swift
//  survivor
//
//  Created by Nikita Titov on 13/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import Cocoa
import CocoaLumberjack

class MainController: NSViewController, Identifiable, Ensurable {

    func ensure() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ensure()
    }
    
    // MARK: - Actions
    
    @IBAction func actionConnect(_ sender: Any) {
        performGameControllerSegue()
    }
    
    // MARK: - Segue
    
    func performGameControllerSegue() {
        performSegue(withIdentifier: .init(GameController.identifier), sender: self)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case NSStoryboardSegue.Identifier.init(rawValue: GameController.identifier):
            let controller = segue.destinationController as! GameController
            DDLogInfo("\(controller)")
        default:
            DDLogError("Unknown segue identifier: \(segue.identifier!)")
        }
    }
}

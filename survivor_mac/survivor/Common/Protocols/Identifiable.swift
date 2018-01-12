//
//  UIViewController+Identifiable.swift
//  survivor
//
//  Created by Nikita Titov on 13/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import Foundation

protocol Identifiable {}

extension Identifiable {
    // Returns class name as a string
    static var identifier: String {
        return String(describing: self)
    }
}

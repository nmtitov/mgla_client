//
//  UIColor+Survivor.swift
//  survivor
//
//  Created by Nikita Titov on 13/01/2018.
//  Copyright © 2018 N. M. Titov. All rights reserved.
//

import Foundation
import AppKit

extension NSColor: SurvivorExtensionsProvider {}

extension Survivor where Base: NSColor {
    
    static var white: NSColor { return NSColor(hex: "ffffff") }

}

/// Extenstion proxy inspired by ReactiveCocoa sources
/// Following code adapted from ReactiveCocoa4

/// Describes a provider of reactive extensions.
///
/// - note: `SurvivorExtensionsProvider` is intended for extensions to types that are not owned
///         by the module in order to avoid name collisions and return type
///         ambiguities.
protocol SurvivorExtensionsProvider: class {}

extension SurvivorExtensionsProvider {
    
    /// A proxy which hosts reactive extensions for `self`.
    var survivor: Survivor<Self> {
        return Survivor(self)
    }
    
    /// A proxy which hosts static reactive extensions for the type of `self`.
    static var survivor: Survivor<Self>.Type {
        return Survivor<Self>.self
    }
    
}

/// A proxy which hosts Survivor extensions of `Base`.
struct Survivor<Base> {
    
    /// The `Base` instance the extensions would be invoked with.
    let base: Base
    
    /// Construct a proxy
    ///
    /// - parameters:
    ///   - base: The object to be proxied.
    fileprivate init(_ base: Base) {
        self.base = base
    }
    
}

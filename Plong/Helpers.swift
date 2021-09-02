//
//  Helpers.swift
//  Plong
//
//  Created by Gabriel Maldonado Almendra on 2/9/21.
//

import Foundation

class Helpers {
    
    /// Returns a random value based on the type of randomization provided
    enum calcType { case impulse, spawnPosition }
    static func randomize(forType: calcType) -> Int {
        
        switch forType {
            /// Ball impulse
            case .impulse:
                let range = 15..<25
                return Int.random(in: range)
            /// Ball spawn position
            case .spawnPosition:
                let range = -200..<200
                return Int.random(in: range)
        }
    }
}

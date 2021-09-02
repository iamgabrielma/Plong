//
//  Helpers.swift
//  Plong
//
//  Created by Gabriel Maldonado Almendra on 2/9/21.
//

import Foundation

class Helpers {
    
    enum calcType { case impulse, spawnPosition }
    
    static func randomize(forType: calcType) -> Int {
        
        switch forType {
        case .impulse:
            let range = 15..<25
            return Int.random(in: range)
        
        case .spawnPosition:
            let range = -200..<200
            return Int.random(in: range)
        }
     
    }
}

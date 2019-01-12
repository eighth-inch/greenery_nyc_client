//
//  Plant.swift
//  greenery_nyc_client
//
//  Created by Daniel Panzer on 1/12/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

struct Plant : Codable, Equatable, CustomStringConvertible, CustomDebugStringConvertible {
    
    let id: String
    let name: String
    let lightRequired: LightLevel
    let createdAt: Date
    let updatedAt: Date
    
    enum LightLevel : String, Codable, CaseIterable {
        case low
        case med
        case high
    }
    
    private enum CodingKeys : String, CodingKey {
        case id
        case name
        case lightRequired = "light_required"
        case createdAt
        case updatedAt
    }
    
    var description: String {
        return "*Plant* id: \(id), name: \(name), lightRequired: \(lightRequired)"
    }
    
    var debugDescription: String {
        return description
    }
}

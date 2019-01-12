//
//  NetworkParser.swift
//  greenery_nyc_client
//
//  Created by Daniel Panzer on 1/12/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

protocol ResponseHandlerInterface {
    func handleMultiPlantsResponse(_ response: (data: Data?, error: Error?)) -> ([Plant]?, Error?)
    func handleSinglePlantResponse(_ response: (data: Data?, error: Error?)) -> (Plant?, Error?)
}

class ResponseHandler {
 
    private static let millisecondPreciseDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(millisecondPreciseDate)
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(millisecondPreciseDate)
        return decoder
    }()
    
    struct PlantsResponse : Decodable {
        let plants: [Plant]
    }
    
    struct PlantResponse : Decodable {
        let plant: Plant
    }
    
    struct PlantPayload : Encodable {
        let plant: Element
        
        struct Element : Encodable {
            let name: String
            let light_required: Plant.LightLevel
        }
    }
}

extension ResponseHandler : ResponseHandlerInterface {
    
    func handleMultiPlantsResponse(_ response: (data: Data?, error: Error?)) -> ([Plant]?, Error?) {
        guard let data = response.data else {return (nil, response.error)}
        
        do {
            let payload = try ResponseHandler.decoder.decode(PlantsResponse.self, from: data)
            return (payload.plants, response.error)
        } catch {
            return (nil, error)
        }
    }
    
    func handleSinglePlantResponse(_ response: (data: Data?, error: Error?)) -> (Plant?, Error?) {
        guard let data = response.data else {return (nil, response.error)}
        
        do {
            let payload = try ResponseHandler.decoder.decode(PlantResponse.self, from: data)
            return (payload.plant, response.error)
        } catch {
            return (nil, error)
        }
    }
}

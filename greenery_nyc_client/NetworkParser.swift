//
//  NetworkParser.swift
//  greenery_nyc_client
//
//  Created by Daniel Panzer on 1/12/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

protocol NetworkParserInterface {
    func handleMultiPlantResponse(_ response: (data: Data?, error: Error?)) -> ([Plant]?, Error?)
    func handleSinglePlantResponse(_ response: (data: Data?, error: Error?)) -> (Plant?, Error?)
    func handleNoContentResponse(_ response: (data: Data?, error: Error?)) -> (Error?)
    func payload(for plant: Plant) -> [String : Any]
}

class NetworkParser {
 
    private static let millisecondPreciseDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(millisecondPreciseDate)
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(millisecondPreciseDate)
        return decoder
    }()
    
    private struct PlantsResponse : Decodable {
        let plants: [Plant]
    }
    
    private struct PlantResponse : Decodable {
        let plant: Plant
    }
    
    private struct PlantPayload : Encodable {
        let plant: Element
        
        struct Element : Encodable {
            let name: String
            let light_required: Plant.LightLevel
        }
    }
}

extension NetworkParser : NetworkParserInterface {
    
    func handleMultiPlantResponse(_ response: (data: Data?, error: Error?)) -> ([Plant]?, Error?) {
        guard let data = response.data else {return (nil, response.error)}
        
        do {
            let content = try NetworkParser.decoder.decode(PlantsResponse.self, from: data)
            return (content.plants, response.error)
        } catch {
            return (nil, error)
        }
    }
    
    func handleSinglePlantResponse(_ response: (data: Data?, error: Error?)) -> (Plant?, Error?) {
        guard let data = response.data else {return (nil, response.error)}
        
        do {
            let content = try NetworkParser.decoder.decode(PlantResponse.self, from: data)
            return (content.plant, response.error)
        } catch {
            return (nil, error)
        }
    }
    
    func handleNoContentResponse(_ response: (data: Data?, error: Error?)) -> (Error?) {
        switch response.error {
        case .some(let error): return error
        case .none:
            //TODO: Custom error handling
            return nil
        }
    }
    
    func payload(for plant: Plant) -> [String : Any] {
        let newElement = PlantPayload.Element(name: plant.name, light_required: plant.lightRequired)
        let payload = try! NetworkParser.encoder.encodeAsDictionary(PlantPayload(plant: newElement))
        return payload
    }
}

//
//  NetworkService.swift
//  greenery_nyc_client
//
//  Created by Daniel Panzer on 1/12/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

protocol NetworkServiceInterface : class {
    func getPlants(ofTypes types: Set<Plant.LightLevel>, completion: @escaping ([Plant]?, Error?) -> ())
    func getPlant(withId id: String, completion: @escaping (Plant?, Error?) -> ())
    func create(_ plant: Plant, completion: @escaping (Plant?, Error?) -> ())
    func update(_ plant: Plant, completion: @escaping (Plant?, Error?) -> ())
    func delete(_ plant: Plant, completion: @escaping (Error?) -> ())
}

class NetworkService {
    
    init(with network: NetworkInterface, parser: NetworkParserInterface) {
        self.network = network
        self.parser = parser
    }
    
    private let network: NetworkInterface
    private let parser: NetworkParserInterface
    
}

extension NetworkService : NetworkServiceInterface {
    
    func getPlants(ofTypes types: Set<Plant.LightLevel>, completion: @escaping ([Plant]?, Error?) -> ()) {
        network.getPlants(ofTypes: types) { (response, error) in
            let parsedResponse = self.parser.handleMultiPlantResponse((response, error))
            completion(parsedResponse.0, parsedResponse.1)
        }
    }
    
    func getPlant(withId id: String, completion: @escaping (Plant?, Error?) -> ()) {
        network.getPlant(withId: id) { (response, error) in
            let parsedResponse = self.parser.handleSinglePlantResponse((response, error))
            completion(parsedResponse.0, parsedResponse.1)
        }
    }
    
    func create(_ plant: Plant, completion: @escaping (Plant?, Error?) -> ()) {
        let payload = parser.payload(for: plant)
        network.post(plantPayload: payload) { (response, error) in
            let parsedResponse = self.parser.handleSinglePlantResponse((response, error))
            completion(parsedResponse.0, parsedResponse.1)
        }
    }
    
    func update(_ plant: Plant, completion: @escaping (Plant?, Error?) -> ()) {
        let payload = parser.payload(for: plant)
        network.put(plantId: plant.id, plantPayload: payload) { (response, error) in
            let parsedResponse = self.parser.handleSinglePlantResponse((response, error))
            completion(parsedResponse.0, parsedResponse.1)
        }
    }
    
    func delete(_ plant: Plant, completion: @escaping (Error?) -> ()) {
        network.deletePlant(withId: plant.id) { (response, error) in
            let parsedResponse = self.parser.handleNoContentResponse((response, error))
            completion(parsedResponse)
        }
    }
}

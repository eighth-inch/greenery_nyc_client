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
}

class NetworkService {
    
    init(with network: NetworkInterface, responseHandler: ResponseHandlerInterface) {
        self.network = network
        self.responseHandler = responseHandler
    }
    
    private let network: NetworkInterface
    private let responseHandler: ResponseHandlerInterface
    
}

extension NetworkService : NetworkServiceInterface {
    
    func getPlants(ofTypes types: Set<Plant.LightLevel>, completion: @escaping ([Plant]?, Error?) -> ()) {
        network.getPlants(ofTypes: types) { (response, error) in
            let parsedResponse = self.responseHandler.handleMultiPlantsResponse((response, error))
            completion(parsedResponse.0, parsedResponse.1)
        }
    }
}

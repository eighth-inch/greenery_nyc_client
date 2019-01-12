//
//  ResponseParser.swift
//  greenery_nyc_client
//
//  Created by Daniel Panzer on 1/12/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkInterface : class {
    func getPlants(ofTypes types: Set<Plant.LightLevel>, completion: @escaping (Data?, Error?) -> ())
    func getPlant(withId id: String, completion: @escaping (Data?, Error?) -> ())
}

class Network {
    
    init(with url: URL) {
        self.url = url
    }
    
    let url: URL
    
}

extension Network : NetworkInterface {
    
    func getPlants(ofTypes types: Set<Plant.LightLevel>, completion: @escaping (Data?, Error?) -> ()) {
        
        let parameters: [String : Any] = {
            switch types {
            case Set(Plant.LightLevel.allCases): return [:]
            default: return ["light_required" : types.map({$0.rawValue}).joined(separator: ",")]
            }
        }()
        
        Alamofire
            .request(url, parameters: parameters, encoding: URLEncoding.default)
            .responseData { (response) in
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    func getPlant(withId id: String, completion: @escaping (Data?, Error?) -> ()) {
        let url = self.url.appendingPathComponent(id)
        
        Alamofire
            .request(url)
            .responseData { (response) in
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
}

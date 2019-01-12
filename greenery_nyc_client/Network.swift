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
    func post(plantPayload payload: [String : Any], completion: @escaping (Data?, Error?) -> ())
    func put(plantId id: String, plantPayload payload: [String : Any], completion: @escaping (Data?, Error?) -> ())
    func deletePlant(withId id: String, completion: @escaping (Data?, Error?) -> ())
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
    
    func post(plantPayload payload: [String : Any], completion: @escaping (Data?, Error?) -> ()) {
        
        Alamofire
            .request(url, method: .post, parameters: payload)
            .responseData { (response) in
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    func put(plantId id: String, plantPayload payload: [String : Any], completion: @escaping (Data?, Error?) -> ()) {
        let url = self.url.appendingPathComponent(id)
        
        Alamofire
            .request(url, method: .put, parameters: payload)
            .responseData { (response) in
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    func deletePlant(withId id: String, completion: @escaping (Data?, Error?) -> ()) {
        let url = self.url.appendingPathComponent(id)
        
        Alamofire
            .request(url, method: .delete)
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

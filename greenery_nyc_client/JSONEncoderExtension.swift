//
//  JSONEncoderExtension.swift
//  greenery_nyc_client
//
//  Created by Daniel Panzer on 1/12/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

extension JSONEncoder {
    
    func encodeAsDictionary<T>(_ value: T) throws -> [String : Any] where T : Encodable {
        let data = try encode(value)
        return try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
    }
}

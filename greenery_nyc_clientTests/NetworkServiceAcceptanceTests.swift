//
//  NetworkServiceAcceptanceTests.swift
//  greenery_nyc_clientTests
//
//  Created by Daniel Panzer on 1/12/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import greenery_nyc_client

class NetworkServiceAcceptanceTests: QuickSpec {

    private var subject: NetworkService!
    private var interface: Network!
    private var responseHandler: ResponseHandler!
    private var response: ([Plant]?, Error?)?
    
    override func spec() {
        
        describe("A NetworkService") {
            
            beforeSuite {
                Nimble.AsyncDefaults.Timeout = 5
            }
            
            afterSuite {
                Nimble.AsyncDefaults.Timeout = 1
            }
            
            beforeEach {
                let url = URL(string: "https://greenery-nyc-test-dev.herokuapp.com/api/plants")!
                self.interface = Network(with: url)
                self.responseHandler = ResponseHandler()
                self.subject = NetworkService(with: self.interface, responseHandler: self.responseHandler)
            }
            
            afterEach {
                self.interface = nil
                self.responseHandler = nil
                self.subject = nil
            }
            
            context("when queried for all plants") {
                
                beforeEach {
                    waitUntil { done in
                        self.subject.getPlants(ofTypes: Set(Plant.LightLevel.allCases), completion: { (response, error) in
                            self.response = (response, error)
                            done()
                        })
                    }
                }
                
                afterEach {
                    self.response = nil
                }
                
                it("returns a response") {
                    expect(self.response).toNot(beNil())
                }
                
                it("returns content") {
                    expect(self.response?.0).toNot(beNil())
                }
                
                it("does not return an error") {
                    expect(self.response?.1).to(beNil())
                }
            }
            
            context("when queried for only low light plants") {
                
                beforeEach {
                    waitUntil { done in
                        self.subject.getPlants(ofTypes: Set(arrayLiteral: .low), completion: { (response, error) in
                            self.response = (response, error)
                            done()
                        })
                    }
                }
                
                afterEach {
                    self.response = nil
                }
                
                it("returns a response") {
                    expect(self.response).toNot(beNil())
                }
                
                it("returns content") {
                    expect(self.response?.0).toNot(beNil())
                }
                
                it("returns only low light level plants") {
                    expect(self.response?.0?.filter({$0.lightRequired != .low})).to(beEmpty())
                }
                
                it("does not return an error") {
                    expect(self.response?.1).to(beNil())
                }
            }
            
            context("when queried for only mid light plants") {
                
                beforeEach {
                    waitUntil { done in
                        self.subject.getPlants(ofTypes: Set(arrayLiteral: .med), completion: { (response, error) in
                            self.response = (response, error)
                            done()
                        })
                    }
                }
                
                afterEach {
                    self.response = nil
                }
                
                it("returns a response") {
                    expect(self.response).toNot(beNil())
                }
                
                it("returns content") {
                    expect(self.response?.0).toNot(beNil())
                }
                
                it("returns only low light level plants") {
                    expect(self.response?.0?.filter({$0.lightRequired != .med})).to(beEmpty())
                }
                
                it("does not return an error") {
                    expect(self.response?.1).to(beNil())
                }
            }
            
            context("when queried for only high light plants") {
                
                beforeEach {
                    waitUntil { done in
                        self.subject.getPlants(ofTypes: Set(arrayLiteral: .high), completion: { (response, error) in
                            self.response = (response, error)
                            done()
                        })
                    }
                }
                
                afterEach {
                    self.response = nil
                }
                
                it("returns a response") {
                    expect(self.response).toNot(beNil())
                }
                
                it("returns content") {
                    expect(self.response?.0).toNot(beNil())
                }
                
                it("returns only low light level plants") {
                    expect(self.response?.0?.filter({$0.lightRequired != .high})).to(beEmpty())
                }
                
                it("does not return an error") {
                    expect(self.response?.1).to(beNil())
                }
            }
            
            context("when queried for only low and high light plants") {
                
                beforeEach {
                    waitUntil { done in
                        self.subject.getPlants(ofTypes: Set(arrayLiteral: .low, .high), completion: { (response, error) in
                            self.response = (response, error)
                            done()
                        })
                    }
                }
                
                afterEach {
                    self.response = nil
                }
                
                it("returns a response") {
                    expect(self.response).toNot(beNil())
                }
                
                it("returns content") {
                    expect(self.response?.0).toNot(beNil())
                }
                
                it("returns only low light level plants") {
                    expect(self.response?.0?.filter({$0.lightRequired != .high && $0.lightRequired != .low})).to(beEmpty())
                }
                
                it("does not return an error") {
                    expect(self.response?.1).to(beNil())
                }
            }
        }
    }
}

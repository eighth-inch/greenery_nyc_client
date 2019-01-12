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
    private var parser: NetworkParser!
    private var multiResponse: ([Plant]?, Error?)?
    private var singleResponse: (Plant?, Error?)?
    private var noContentResponse: Error?
    
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
                self.parser = NetworkParser()
                self.subject = NetworkService(with: self.interface, parser: self.parser)
            }
            
            afterEach {
                self.interface = nil
                self.parser = nil
                self.subject = nil
            }
            
            context("when queried for all plants") {
                
                beforeEach {
                    waitUntil { done in
                        self.subject.getPlants(ofTypes: Set(Plant.LightLevel.allCases), completion: { (response, error) in
                            self.multiResponse = (response, error)
                            done()
                        })
                    }
                }
                
                afterEach {
                    self.multiResponse = nil
                }
                
                it("returns a response") {
                    expect(self.multiResponse).toNot(beNil())
                }
                
                it("returns content") {
                    expect(self.multiResponse?.0).toNot(beNil())
                }
                
                it("does not return an error") {
                    expect(self.multiResponse?.1).to(beNil())
                }
            }
            
            context("when queried for only low light plants") {
                
                beforeEach {
                    waitUntil { done in
                        self.subject.getPlants(ofTypes: Set(arrayLiteral: .low), completion: { (response, error) in
                            self.multiResponse = (response, error)
                            done()
                        })
                    }
                }
                
                afterEach {
                    self.multiResponse = nil
                }
                
                it("returns a response") {
                    expect(self.multiResponse).toNot(beNil())
                }
                
                it("returns content") {
                    expect(self.multiResponse?.0).toNot(beNil())
                }
                
                it("returns only low light level plants") {
                    expect(self.multiResponse?.0?.filter({$0.lightRequired != .low})).to(beEmpty())
                }
                
                it("does not return an error") {
                    expect(self.multiResponse?.1).to(beNil())
                }
            }
            
            context("when queried for only mid light plants") {
                
                beforeEach {
                    waitUntil { done in
                        self.subject.getPlants(ofTypes: Set(arrayLiteral: .med), completion: { (response, error) in
                            self.multiResponse = (response, error)
                            done()
                        })
                    }
                }
                
                afterEach {
                    self.multiResponse = nil
                }
                
                it("returns a response") {
                    expect(self.multiResponse).toNot(beNil())
                }
                
                it("returns content") {
                    expect(self.multiResponse?.0).toNot(beNil())
                }
                
                it("returns only low light level plants") {
                    expect(self.multiResponse?.0?.filter({$0.lightRequired != .med})).to(beEmpty())
                }
                
                it("does not return an error") {
                    expect(self.multiResponse?.1).to(beNil())
                }
            }
            
            context("when queried for only high light plants") {
                
                beforeEach {
                    waitUntil { done in
                        self.subject.getPlants(ofTypes: Set(arrayLiteral: .high), completion: { (response, error) in
                            self.multiResponse = (response, error)
                            done()
                        })
                    }
                }
                
                afterEach {
                    self.multiResponse = nil
                }
                
                it("returns a response") {
                    expect(self.multiResponse).toNot(beNil())
                }
                
                it("returns content") {
                    expect(self.multiResponse?.0).toNot(beNil())
                }
                
                it("returns only low light level plants") {
                    expect(self.multiResponse?.0?.filter({$0.lightRequired != .high})).to(beEmpty())
                }
                
                it("does not return an error") {
                    expect(self.multiResponse?.1).to(beNil())
                }
            }
            
            context("when queried for only low and high light plants") {
                
                beforeEach {
                    waitUntil { done in
                        self.subject.getPlants(ofTypes: Set(arrayLiteral: .low, .high), completion: { (response, error) in
                            self.multiResponse = (response, error)
                            done()
                        })
                    }
                }
                
                afterEach {
                    self.multiResponse = nil
                }
                
                it("returns a response") {
                    expect(self.multiResponse).toNot(beNil())
                }
                
                it("returns content") {
                    expect(self.multiResponse?.0).toNot(beNil())
                }
                
                it("returns only low light level plants") {
                    expect(self.multiResponse?.0?.filter({$0.lightRequired != .high && $0.lightRequired != .low})).to(beEmpty())
                }
                
                it("does not return an error") {
                    expect(self.multiResponse?.1).to(beNil())
                }
            }
        
        }
        
        describe("A NetworkService after querying for available plants") {
            
            var availablePlants: [Plant]!
            
            beforeSuite {
                Nimble.AsyncDefaults.Timeout = 5
            }
            
            afterSuite {
                Nimble.AsyncDefaults.Timeout = 1
            }
            
            beforeEach {
                let url = URL(string: "https://greenery-nyc-test-dev.herokuapp.com/api/plants")!
                self.interface = Network(with: url)
                self.parser = NetworkParser()
                self.subject = NetworkService(with: self.interface, parser: self.parser)
                
                waitUntil { done in
                    self.subject.getPlants(ofTypes: Set(Plant.LightLevel.allCases)) { response, error in
                        assert(response!.count > 0, "there must be plants on the server to run this describe")
                        availablePlants = response!
                        done()
                    }
                }
            }
            
            afterEach {
                self.interface = nil
                self.parser = nil
                self.subject = nil
                availablePlants = nil
            }
            
            context("when querying for the details of the first available plant") {
                
                beforeEach {
                    waitUntil { done in
                        self.subject.getPlant(withId: availablePlants.first!.id) { response, error in
                            self.singleResponse = (response, error)
                            done()
                        }
                    }
                }
                
                afterEach {
                    self.singleResponse = nil
                }
                
                it("returns a response") {
                    expect(self.singleResponse).toNot(beNil())
                }
                
                it("returns content") {
                    expect(self.singleResponse?.0).toNot(beNil())
                }
                
                it("returns the expected content") {
                    expect(self.singleResponse?.0) == availablePlants.first
                }
                
                it("does not return an error") {
                    expect(self.singleResponse?.1).to(beNil())
                }
            }
            
            context("when creating a new plant") {
                
                let newPlantSubmission = Plant(id: UUID().uuidString, name: "Clementine Tree", lightRequired: .low, createdAt: Date(), updatedAt: Date())
                var newlyCreatedPlant: Plant?
                
                beforeEach {
                    waitUntil { done in
                        self.subject.create(newPlantSubmission, completion: { (response, error) in
                            self.singleResponse = (response, error)
                            newlyCreatedPlant = response
                            done()
                        })
                    }
                }
                
                afterEach {
                    waitUntil { done in
                        guard let plantToDelete = newlyCreatedPlant else {return}
                        self.subject.delete(plantToDelete) {error in
                            print(error?.localizedDescription ?? "deleted test plant successfully")
                            done()
                        }
                    }
                }
                
                it("does not return an error") {
                    expect(self.singleResponse?.1).to(beNil())
                }
                
                it("returns a created plant") {
                    expect(self.singleResponse?.0).toNot(beNil())
                }
                
                it("returns a created plant with matching name") {
                    expect(self.singleResponse?.0?.name) == newPlantSubmission.name
                }
                
                it("returns a created plant with matching light requirement") {
                    expect(self.singleResponse?.0?.lightRequired) == newPlantSubmission.lightRequired
                }
                
                it("contains the new content when queried") {
                    waitUntil { done in
                        self.subject.getPlant(withId: self.singleResponse?.0?.id ?? "") { response, error in
                            expect(response) == self.singleResponse?.0
                            done()
                        }
                    }
                }
                
                context("when updating a plant") {
                    
                    let newPlantSubmission = Plant(id: UUID().uuidString, name: "Clementine Tree", lightRequired: .low, createdAt: Date(), updatedAt: Date())
                    var newlyCreatedPlant: Plant!
                    var updatePlantSubmission: Plant!
                    
                    beforeEach {
                        waitUntil { done in
                            self.subject.create(newPlantSubmission) { (response, error) in
                                newlyCreatedPlant = response
                                
                                updatePlantSubmission = Plant(id: newlyCreatedPlant.id,
                                                              name: "Updated Name",
                                                              lightRequired: .high,
                                                              createdAt: newlyCreatedPlant.createdAt,
                                                              updatedAt: newlyCreatedPlant.updatedAt)
                                
                                self.subject.update(updatePlantSubmission) { (response, error) in
                                    self.singleResponse = (response, error)
                                    done()
                                }
                            }
                        }
                    }
                    
                    afterEach {
                        waitUntil { done in
                            guard let plantToDelete = newlyCreatedPlant else {return}
                            self.subject.delete(plantToDelete) {error in
                                print(error?.localizedDescription ?? "deleted test plant successfully")
                                done()
                            }
                        }
                    }
                    
                    it("does not return an error") {
                        expect(self.singleResponse?.1).to(beNil())
                    }
                    
                    it("returns an updated plant") {
                        expect(self.singleResponse?.0).toNot(beNil())
                    }
                    
                    it("returns an updated plant with the updated name") {
                        expect(self.singleResponse?.0?.name) == updatePlantSubmission.name
                    }
                    
                    it("returns a created plant with the updated light requirement") {
                        expect(self.singleResponse?.0?.lightRequired) == updatePlantSubmission.lightRequired
                    }
                    
                    it("contains the updated content when queried") {
                        waitUntil { done in
                            self.subject.getPlant(withId: self.singleResponse?.0?.id ?? "") { response, error in
                                expect(response) == self.singleResponse?.0
                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}

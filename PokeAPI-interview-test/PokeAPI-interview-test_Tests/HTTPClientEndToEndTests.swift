//
//  HTTPClientEndToEndTests.swift
//  PokeAPI-interview-test_Tests
//
//  Created by Judy Tsai on 2024/10/18.
//

import XCTest
@testable import PokeAPI_interview_test

final class HTTPClientEndToEndTests: XCTestCase {

    func test_request_onSuccessfulRequestCase() {
        let sut = makeSUT()
        let requestTypeSpy = RequestTypeSpy(pokemonName: "pikachu")
        let expectation = XCTestExpectation(description: "Wait for completion...")
        
        sut.request(with: requestTypeSpy) { result in
            
            switch result {
            case .success(let (data, _)):
                do {
                    let json = try JSONSerialization.jsonObject(with: data)
                    if let jsonDict = json as? [String: Any] {
                        let elementCount = jsonDict.keys.count
                        print("ElementCount = \(elementCount)")
                        XCTAssertEqual(elementCount, 20)
                        expectation.fulfill()
                    } else {
                        XCTFail("Should successfully parse json to array")
                        expectation.fulfill()
                    }
                } catch {
                    XCTFail("The data should be parsed to Json! Error: \(error)")
                    expectation.fulfill()
                }
                
            case .failure(let error):
                XCTFail("The API should be successful! Error: \(error)")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 30)
    }
    
    func test_request_onInvalidPathCase() {
        let sut = makeSUT()
        let requestTypeSpy = RequestTypeSpy(pokemonName: "non-existent-pokemon123456")
        let expectation = XCTestExpectation(description: "Wait for completion...")
        
        sut.request(with: requestTypeSpy) { result in
            switch result {
            case .success:
                XCTFail("The request should fail with invalid path")
                expectation.fulfill()
                
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 30)
    }
}

private extension HTTPClientEndToEndTests {
    
    struct RequestTypeSpy: RequestType {
        
        let pokemonName: String
        init(pokemonName: String) {
            self.pokemonName = pokemonName
        }
        
        var baseURL: URL { URL(string: "https://pokeapi.co/api/v2/pokemon")! }
        
        var path: String { "/\(pokemonName)" }
        
        var queryItems: [URLQueryItem] = []
        
        var method: PokeAPI_interview_test.HTTPMethod { .get }
        
        var headers: [String : String]? { nil }
        
        var body: Data? { nil }
    }
    
    func makeSUT() -> HTTPClient {
        let session = URLSession(configuration: .ephemeral) // ensure no cache
        let client = URLSessionHTTPClient(session: session)
        return client
    }
}

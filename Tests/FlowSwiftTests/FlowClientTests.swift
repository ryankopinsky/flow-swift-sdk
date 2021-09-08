    import XCTest
    import Flow
    @testable import FlowSwift

    final class FlowClientTests: XCTestCase {
        let client = FlowClient(host: "access.mainnet.nodes.onflow.org", port: 9000)
        
        func testFlowClientConnection() {
            let expectation = XCTestExpectation(description: "Test Flow Client Connection.")

            self.client.ping { error in
                XCTAssertNil(error, "Client connection error: \(String(describing: error?.localizedDescription)).")
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5)
        }
        
        func testGetFlowAccountBalance() {
            let expectation = XCTestExpectation(description: "Test Getting Flow Account Balance.")

            let randomMainnetAddress = "0xead892083b3e2c6c"
            self.client.getAccount(address: randomMainnetAddress) { account, error in
                print("DEBUG")
                XCTAssertNotNil(account, "Error getting account: \(String(describing: error?.localizedDescription))")
                
                XCTAssertGreaterThanOrEqual(account!.balance, 0, "Negative account balance.")
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5)
        }
        
        func testExecuteScript() {
            let expectation = XCTestExpectation(description: "Test Execute Flow Script.")
            
            let script = "pub fun main(): Int { return 1 }".data(using: .utf8)!
            
            self.client.executeScript(script: script, arguments: []) { jsonData, error in
                guard let jsonData = jsonData else {
                    XCTFail("No jsonData from execute script response.")
                    return
                }
                
                guard jsonData["type"] != nil else {
                    XCTFail("No value for 'type' key.")
                    return
                }
                
                guard jsonData["value"] != nil else {
                    XCTFail("No value for 'type' key.")
                    return
                }
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5)
        }
    }
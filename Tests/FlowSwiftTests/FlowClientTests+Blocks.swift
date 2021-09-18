    import XCTest
    import Flow
    @testable import FlowSwift

    final class FlowClientTestsBlocks: XCTestCase {
        let client = FlowClient()
        var latestBlock:FlowBlock = FlowBlock()
        
        public override func setUp() {
            self.latestBlock = try! self.client.getLatestBlock(isSealed: true).wait()

        }
        
        func testRetrieveBlockById() {
            let expectation = XCTestExpectation(description: "retrieve a block by ID")
            self.client.getBlockById(id: self.latestBlock.id){ response in
                XCTAssertNil(response.error, "getBlockById error: \(String(describing: response.error?.localizedDescription)).")
                expectation.fulfill()
                
                let block = response.result as! FlowBlock
                print(block.pretty)
                XCTAssertEqual(self.latestBlock, block)
            }
            wait(for: [expectation], timeout: 5)
        }
        
        func testRetrieveBlockByHeight() {
            let expectation = XCTestExpectation(description: "retrieve a block by height")
            self.client.getBlockByHeight(height: self.latestBlock.height){ response in
                XCTAssertNil(response.error, "getBlockByHeight error: \(String(describing: response.error?.localizedDescription)).")
                expectation.fulfill()
                
                let block = response.result as! FlowBlock
                print(block.pretty)
                XCTAssertEqual(self.latestBlock, block)
            }
        wait(for: [expectation], timeout: 5)
        }
        
        
        func testRetrieveLatestBlock() {
            let expectation = XCTestExpectation(description: "retrieve the latest block")
            
            self.client.getLatestBlock(isSealed: true){ latestBlockResponse in
                XCTAssertNil(latestBlockResponse.error, "getLatestBlock error: \(String(describing: latestBlockResponse.error?.localizedDescription)).")
               // let latestBlock = latestBlockResponse.result as! FlowBlock
            }
            wait(for: [expectation], timeout: 5)
        }
        
       
        
    }
    
    

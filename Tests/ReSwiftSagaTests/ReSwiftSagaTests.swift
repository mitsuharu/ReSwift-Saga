import XCTest
@testable import ReSwiftSaga

final class ReSwiftSagaTests: XCTestCase {
        
    let store = makeStore()
    
    override class func setUp() {
        super.setUp()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    func testPut() async throws {

        let nextCount = 1234
        let subscriber = StateSubscriber<Int>()
        
        store.subscribe(subscriber) {
            $0.select { $0.count }
        }
        
        // 現状だと、一度何しからの dispatch をしないと、put が有効にならない
        store.dispatch(Clear())

        try? await put(Move(count: nextCount))
        
        // put が非同期実行なので、待つ
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertEqual(subscriber.value, nextCount)
    }
    
    func testSelector() async throws {
        let nextCount = 10
        store.dispatch(Move(count: nextCount))
        
        func selectCount(store: State) -> Int {
            store.count
        }
        
        do {
            let count = try await selector(selectCount)
            XCTAssertEqual(count, nextCount)
        } catch {
            print(error)
            XCTFail(error.localizedDescription)
        }
    }
    
    
    func testTake() async throws {
        
        let expectation = expectation(description: "test take")
        Task.detached {
            let action = await take(Increase.self)
            XCTAssertTrue(action is Increase)
            expectation.fulfill()
        }
        
        // Task.detached で take の準備が揃うまで待つ（要修正）
        try? await Task.sleep(nanoseconds: 1_000_000)
        store.dispatch(Increase())
          
        await fulfillment(of: [expectation], timeout: 1.0, enforceOrder: false)
    }
}

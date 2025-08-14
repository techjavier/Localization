import XCTest
@testable import Localization

final class SearchTests: XCTestCase {
    func testSearchFindsCity() {
        let vm = SearchViewModel()
        let result = vm.results(for: "Rome").cities
        XCTAssertTrue(result.contains { $0.name == "Rome" })
    }
}

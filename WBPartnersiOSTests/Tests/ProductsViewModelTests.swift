import XCTest
@testable import WBPartnersiOS

// MARK: - ProductsViewModelTests
@MainActor
final class ProductsViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var viewModel: ProductsViewModel!
    private var mockRepo: MockProductRepository!

    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        viewModel = ProductsViewModel.shared
        mockRepo = MockProductRepository()
        viewModel.setRepository(mockRepo)
    }

    override func tearDown() {
        viewModel = nil
        mockRepo = nil
        super.tearDown()
    }

    // MARK: - Network & Local Loading
    func testLoadProducts_fromNetwork_fallbackToLocal() async {
        mockRepo.throwNetworkError = true
        mockRepo.mockLocalProducts = [
            Product(id: 3, name: "C", category: "Cat", article: "c", wbArticle: "wb", originalPrice: 150, discount: 5)
        ]

        await viewModel.loadProducts()

        XCTAssertFalse(viewModel.isError)
        XCTAssertEqual(viewModel.allProducts.count, 1)
        XCTAssertEqual(viewModel.allProducts.first?.name, "C")
    }

    func testLoadProducts_networkAndLocalFail() async {
        mockRepo.throwNetworkError = true
        mockRepo.mockLocalProducts = []

        await viewModel.loadProducts()

        XCTAssertTrue(viewModel.isError)
        XCTAssertTrue(viewModel.allProducts.isEmpty)
    }

    // MARK: - Filtering Logic
    func testFilteringLogic() {
        viewModel.allProducts = [
            Product(id: 1, name: "A", category: "C", article: "a", wbArticle: "wb", originalPrice: 100, discount: 10),
            Product(id: 2, name: "B", category: "C", article: "b", wbArticle: "wb")
        ]

        XCTAssertEqual(viewModel.withPrice.count, 1)
        XCTAssertEqual(viewModel.withoutPrice.count, 1)

        viewModel.filter = .all
        XCTAssertEqual(viewModel.filteredProducts.count, 1)

        viewModel.filter = .noPrice
        XCTAssertEqual(viewModel.filteredProducts.count, 1)
    }

    // MARK: - Empty State Checks
    func testIsEmptyFiltered() {
        viewModel.filter = .noPrice
        viewModel.allProducts = [
            Product(id: 1, name: "A", category: "C", article: "a", wbArticle: "wb", originalPrice: 100, discount: 10)
        ]
        XCTAssertTrue(viewModel.isEmptyFiltered)
    }

    func testIsTotallyEmpty() {
        viewModel.allProducts = []
        XCTAssertTrue(viewModel.isTotallyEmpty)
    }
}

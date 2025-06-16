import XCTest
import SwiftData
@testable import WBPartnersiOS

// MARK: - ProductRepositoryTests
@MainActor
final class ProductRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    var container: ModelContainer!
    var context: ModelContext!
    var repository: ProductRepository!

    // MARK: - Setup & Teardown
    override func setUpWithError() throws {
        container = try ModelContainer(
            for: Product.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        context = ModelContext(container)
        repository = ProductRepository(modelContext: context)
    }

    override func tearDownWithError() throws {
        container = nil
        context = nil
        repository = nil
    }

    // MARK: - Tests
    func testSaveToLocalAndLoad() throws {
        let products = [
            Product(id: 1, name: "Product A", category: "Cat1", article: "123", wbArticle: "WB1", originalPrice: 100, discount: 10, imageUrl: nil),
            Product(id: 2, name: "Product B", category: "Cat2", article: "456", wbArticle: "WB2", originalPrice: nil, discount: nil, imageUrl: nil)
        ]

        try repository.saveToLocal(products)
        let loaded = try repository.loadFromLocal()

        XCTAssertEqual(loaded.count, 2)
        XCTAssertEqual(loaded[0].name, "Product A")
    }

    func testClearLocal() throws {
        let product = Product(id: 1, name: "ToRemove", category: "Cat", article: "A", wbArticle: "B", originalPrice: 50, discount: 5, imageUrl: nil)
        try repository.saveToLocal([product])
        try repository.clearLocal()

        let loaded = try repository.loadFromLocal()
        XCTAssertEqual(loaded.count, 0)
    }

    func testReplaceLocalProducts() throws {
        let oldProduct = Product(id: 1, name: "Old", category: "OldCat", article: "Old", wbArticle: "Old", originalPrice: 10, discount: 1, imageUrl: nil)
        try repository.saveToLocal([oldProduct])

        let newProducts = [
            Product(id: 2, name: "New", category: "NewCat", article: "New", wbArticle: "New", originalPrice: 20, discount: 2, imageUrl: nil)
        ]
        try repository.replaceLocalProducts(with: newProducts)

        let loaded = try repository.loadFromLocal()
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded[0].id, 2)
        XCTAssertEqual(loaded[0].name, "New")
    }

    func testFetchFromNetwork_success() async throws {
        let repo = ProductRepository(modelContext: context)
        let result = try await repo.fetchFromNetwork()

        XCTAssertFalse(result.isEmpty)
        XCTAssertNotNil(result.first?.name)
    }
}

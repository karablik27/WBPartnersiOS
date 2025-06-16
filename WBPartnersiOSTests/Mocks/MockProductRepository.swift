import Foundation
@testable import WBPartnersiOS

// MARK: - MockProductRepository
final class MockProductRepository: ProductRepositoryProtocol {
    
    // MARK: - Mock Data
    var mockNetworkProducts: [Product] = []
    var mockLocalProducts: [Product] = []
    var throwNetworkError = false

    // MARK: - Network
    func fetchFromNetwork() async throws -> [Product] {
        if throwNetworkError {
            throw URLError(.notConnectedToInternet)
        }
        return mockNetworkProducts
    }

    // MARK: - Local Storage
    func loadFromLocal() throws -> [Product] {
        return mockLocalProducts
    }

    func saveToLocal(_ products: [Product]) throws {
        mockLocalProducts = products
    }

    func clearLocal() throws {
        mockLocalProducts = []
    }

    func replaceLocalProducts(with products: [Product]) throws {
        try clearLocal()
        try saveToLocal(products)
    }
}

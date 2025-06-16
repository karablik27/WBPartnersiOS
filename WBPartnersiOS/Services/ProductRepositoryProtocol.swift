import Foundation

// MARK: - ProductRepositoryProtocol
@MainActor
protocol ProductRepositoryProtocol {
    
    // MARK: - Network

    func fetchFromNetwork() async throws -> [Product]
    
    // MARK: - Local Storage

    func saveToLocal(_ products: [Product]) throws
    func clearLocal() throws
    func loadFromLocal() throws -> [Product]
    func replaceLocalProducts(with products: [Product]) throws
}

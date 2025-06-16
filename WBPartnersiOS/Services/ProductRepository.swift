import Foundation
import SwiftData

// MARK: - ProductRepository
@MainActor
final class ProductRepository: ProductRepositoryProtocol {
    
    // MARK: - Properties
    private let context: ModelContext

    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.context = modelContext
    }

    // MARK: - Network
    func fetchFromNetwork() async throws -> [Product] {
        let url = URL(string: "https://gist.githubusercontent.com/karablik27/105586aabb2b9b0dc0801534da198072/raw/af6db2c3f00757cd297bd8de28d1c92fe3a0e092/gistfile1.txt")!

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([Product].self, from: data)
    }

    // MARK: - Local Storage
    func saveToLocal(_ products: [Product]) throws {
        for product in products {
            context.insert(product)
        }
        try context.save()
    }

    func clearLocal() throws {
        let existing = try context.fetch(FetchDescriptor<Product>())
        existing.forEach { context.delete($0) }
        try context.save()
    }

    func loadFromLocal() throws -> [Product] {
        let descriptor = FetchDescriptor<Product>(
            sortBy: [SortDescriptor(\.id)]
        )
        return try context.fetch(descriptor)
    }

    func replaceLocalProducts(with products: [Product]) throws {
        try clearLocal()
        try saveToLocal(products)
    }
}

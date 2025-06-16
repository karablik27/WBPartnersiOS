import Foundation
import SwiftData

// MARK: - ProductsViewModel
@MainActor
final class ProductsViewModel: ObservableObject {
    
    // MARK: - Singleton
    static let shared = ProductsViewModel()
    
    // MARK: - Dependencies
    private var context: ModelContext?
    private var repository: ProductRepositoryProtocol?
    
    // MARK: - Published Properties
    @Published var allProducts: [Product] = []
    @Published var isLoading = false
    @Published var isError = false
    @Published var filter: ProductFilter = .all
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Setup
    func setContext(_ context: ModelContext) {
        self.context = context
        self.repository = ProductRepository(modelContext: context)
    }

    func setRepository(_ repository: ProductRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Data Loading
    func loadProducts() async {
        guard let repository else { return }

        isLoading = true
        isError = false
        defer { isLoading = false }

        do {
            let fetched = try await repository.fetchFromNetwork()
            try repository.replaceLocalProducts(with: fetched)
            allProducts = try repository.loadFromLocal()
        } catch {
            print("Ошибка загрузки из сети: \(error.localizedDescription)")
            do {
                let local = try repository.loadFromLocal()
                if local.isEmpty {
                    isError = true
                    allProducts = []
                } else {
                    allProducts = local
                }
            } catch {
                print("Ошибка загрузки из локального хранилища: \(error.localizedDescription)")
                isError = true
                allProducts = []
            }
        }
    }

    // MARK: - Helpers
    var withPrice: [Product] {
        allProducts.filter { $0.originalPrice != nil && $0.discount != nil }
    }

    var withoutPrice: [Product] {
        allProducts.filter { $0.originalPrice == nil || $0.discount == nil }
    }

    var filteredProducts: [Product] {
        switch filter {
        case .all:     return withPrice
        case .noPrice: return withoutPrice
        }
    }

    var hasPricedProducts: Bool {
        !withPrice.isEmpty
    }

    var hasUnpricedProducts: Bool {
        !withoutPrice.isEmpty
    }

    var isEmptyFiltered: Bool {
        !isLoading && !isError && filteredProducts.isEmpty
    }

    var isTotallyEmpty: Bool {
        !isLoading && !isError && !hasPricedProducts && !hasUnpricedProducts
    }
}

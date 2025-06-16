import SwiftUI
import SwiftData

// MARK: - ContentView
struct ContentView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var vm = ProductsViewModel.shared
    @State private var actionProduct: Product?
    @State private var toastMessage: String?

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                if vm.isLoading {
                    Color(.systemGray6).ignoresSafeArea()
                    RingSpinner()
                } else if vm.isError {
                    ErrorStateView {
                        Task { await vm.loadProducts() }
                    }
                } else if vm.isTotallyEmpty || vm.isEmptyFiltered {
                    EmptyStateView()
                } else {
                    List(vm.filteredProducts) { product in
                        ProductView(product: product) {
                            actionProduct = product
                        }
                        .padding(.vertical, 16)
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .listRowInsets(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .listRowBackground(Color(.systemGray6))
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color(.systemGray6))
                }
            }
            .navigationTitle("Цены и скидки")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .top, spacing: 8) {
                filterPickerSection
            }
            .confirmationDialog("", isPresented: Binding(
                get: { actionProduct != nil },
                set: { if !$0 { actionProduct = nil } }
            ), titleVisibility: .hidden) {
                confirmationDialogContent
            }
            .overlay(alignment: .bottom) {
                if let msg = toastMessage {
                    Text(msg)
                        .font(.footnote.weight(.semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.thinMaterial, in: Capsule())
                        .padding(.bottom, 30)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: toastMessage)
                }
            }
        }
        .task {
            vm.setContext(context)
            await vm.loadProducts()
        }
    }

    // MARK: - Subviews
    private var filterPickerSection: some View {
        Group {
            if !vm.isLoading && !vm.isError && (vm.hasPricedProducts || vm.hasUnpricedProducts) {
                VStack(spacing: 8) {
                    Picker("", selection: $vm.filter) {
                        ForEach(ProductFilter.allCases) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical, 8)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(maxWidth: 360)
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
            }
        }
    }

    private var confirmationDialogContent: some View {
        Group {
            if let product = actionProduct {
                Button("Скопировать артикул") {
                    UIPasteboard.general.string = product.article
                    showToast("Артикул скопирован")
                }
                Button("Скопировать артикул WB") {
                    UIPasteboard.general.string = product.wbArticle
                    showToast("Артикул WB скопирован")
                }
            }
            Button("Закрыть", role: .cancel) {
                actionProduct = nil
            }
        }
    }

    // MARK: - Toast
    private func showToast(_ message: String) {
        withAnimation { toastMessage = message }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { toastMessage = nil }
        }
    }
}

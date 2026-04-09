import SwiftUI
import CoreData

struct ProductDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.productName, ascending: true)],
        animation: .default)
    private var products: FetchedResults<Product>

    @State private var currentIndex: Int = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                BauhausHeader(title: "Product Browser")

                if products.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        productCard
                            .padding(.horizontal, 16)
                            .padding(.top, 24)
                    }

                    Spacer()

                    navigationControls
                }
            }
            .background(BauhausTheme.gray)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            Circle()
                .fill(BauhausTheme.yellow)
                .frame(width: 80, height: 80)
                .overlay(
                    Text("!")
                        .font(.system(size: 40, weight: .black))
                        .foregroundColor(BauhausTheme.black)
                )
            Text("NO PRODUCTS")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(BauhausTheme.black)
                .kerning(2)
            Text("Add a product to get started")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
            Spacer()
        }
    }

    private var productCard: some View {
        let product = products[currentIndex]

        return VStack(alignment: .leading, spacing: 0) {
            HStack {
                Rectangle()
                    .fill(BauhausTheme.blue)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text("\(currentIndex + 1)")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(BauhausTheme.white)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(product.productName ?? "Unknown")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(BauhausTheme.black)
                    Text(product.productProvider ?? "Unknown")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                        .tracking(1)
                }

                Spacer()
            }
            .padding(.bottom, 16)

            GeometricAccent()
                .padding(.bottom, 16)

            VStack(alignment: .leading, spacing: 16) {
                detailRow(label: "ID", value: product.productID?.uuidString.prefix(8).uppercased() ?? "N/A", color: BauhausTheme.red)
                detailRow(label: "DESCRIPTION", value: product.productDescription ?? "No description", color: BauhausTheme.blue)
                detailRow(label: "PRICE", value: String(format: "$%.2f", product.productPrice), color: BauhausTheme.yellow)
                detailRow(label: "PROVIDER", value: product.productProvider ?? "Unknown", color: BauhausTheme.red)
            }
        }
        .bauhausCard()
    }

    private func detailRow(label: String, value: String, color: Color) -> some View {
        HStack(alignment: .top) {
            Rectangle()
                .fill(color)
                .frame(width: 4, height: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.secondary)
                    .kerning(2)
                Text(value)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(BauhausTheme.black)
            }

            Spacer()
        }
    }

    private var navigationControls: some View {
        VStack(spacing: 0) {
            GeometricAccent(colors: [BauhausTheme.black, BauhausTheme.black, BauhausTheme.black])
                .frame(height: 2)

            HStack(spacing: 0) {
                Button(action: previousProduct) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .bold))
                        Text("PREV")
                            .font(.system(size: 14, weight: .bold))
                            .kerning(1)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundColor(currentIndex > 0 ? BauhausTheme.white : BauhausTheme.white.opacity(0.5))
                    .background(currentIndex > 0 ? BauhausTheme.blue : BauhausTheme.blue.opacity(0.3))
                }
                .disabled(currentIndex == 0)

                Rectangle()
                    .fill(BauhausTheme.black)
                    .frame(width: 2)

                Text("\(currentIndex + 1) / \(products.count)")
                    .font(.system(size: 16, weight: .black, design: .monospaced))
                    .foregroundColor(BauhausTheme.black)
                    .frame(width: 80)
                    .padding(.vertical, 16)
                    .background(BauhausTheme.yellow)

                Rectangle()
                    .fill(BauhausTheme.black)
                    .frame(width: 2)

                Button(action: nextProduct) {
                    HStack(spacing: 6) {
                        Text("NEXT")
                            .font(.system(size: 14, weight: .bold))
                            .kerning(1)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundColor(currentIndex < products.count - 1 ? BauhausTheme.white : BauhausTheme.white.opacity(0.5))
                    .background(currentIndex < products.count - 1 ? BauhausTheme.red : BauhausTheme.red.opacity(0.3))
                }
                .disabled(currentIndex >= products.count - 1)
            }
            .frame(height: 50)
        }
    }

    private func previousProduct() {
        if currentIndex > 0 {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentIndex -= 1
            }
        }
    }

    private func nextProduct() {
        if currentIndex < products.count - 1 {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentIndex += 1
            }
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

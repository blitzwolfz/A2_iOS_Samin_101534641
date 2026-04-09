import SwiftUI
import CoreData

struct ProductListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.productName, ascending: true)],
        animation: .default)
    private var products: FetchedResults<Product>

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                BauhausHeader(title: "All Products")

                if products.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Text("NO PRODUCTS FOUND")
                            .font(.system(size: 18, weight: .bold))
                            .kerning(2)
                            .foregroundColor(BauhausTheme.black)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(Array(products.enumerated()), id: \.element.objectID) { index, product in
                                productRow(product: product, index: index)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .background(BauhausTheme.gray)
        }
    }

    private func productRow(product: Product, index: Int) -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(rowColor(for: index))
                .frame(width: 6)

            HStack(spacing: 12) {
                Rectangle()
                    .fill(rowColor(for: index))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text("\(index + 1)")
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(BauhausTheme.white)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(product.productName ?? "Unknown")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(BauhausTheme.black)
                        .lineLimit(1)

                    Text(product.productDescription ?? "No description")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Text(String(format: "$%.2f", product.productPrice))
                    .font(.system(size: 15, weight: .bold, design: .monospaced))
                    .foregroundColor(BauhausTheme.black)
            }
            .padding(12)
        }
        .background(BauhausTheme.white)
        .overlay(
            Rectangle()
                .stroke(BauhausTheme.black, lineWidth: 2)
        )
    }

    private func rowColor(for index: Int) -> Color {
        let colors = [BauhausTheme.red, BauhausTheme.blue, BauhausTheme.yellow]
        return colors[index % colors.count]
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

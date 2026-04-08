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
            VStack(spacing: 16) {
                if products.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Text("No products available")
                            .font(.headline)
                        Spacer()
                    }
                } else {
                    let product = products[currentIndex]

                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(product.productName ?? "Unknown")
                                .font(.title2.bold())

                            Text("ID: \(product.productID?.uuidString.prefix(8) ?? "N/A")")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text(product.productDescription ?? "No description")
                                .font(.body)

                            Text(String(format: "Price: $%.2f", product.productPrice))
                                .font(.title3.bold())

                            Text("Provider: \(product.productProvider ?? "Unknown")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }

                    Spacer()

                    HStack {
                        Button("Previous") {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                        }
                        .disabled(currentIndex == 0)

                        Spacer()

                        Text("\(currentIndex + 1) / \(products.count)")
                            .font(.headline)

                        Spacer()

                        Button("Next") {
                            if currentIndex < products.count - 1 {
                                currentIndex += 1
                            }
                        }
                        .disabled(currentIndex >= products.count - 1)
                    }
                    .padding()
                }
            }
            .navigationTitle("Product Browser")
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView()
    }
}

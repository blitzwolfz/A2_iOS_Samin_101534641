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
                    Text("No products available")
                        .font(.headline)
                } else {
                    let product = products[currentIndex]

                    VStack(alignment: .leading, spacing: 12) {
                        Text(product.productName ?? "Unknown")
                            .font(.title2.bold())

                        Text(product.productDescription ?? "No description")
                            .font(.body)

                        Text(String(format: "$%.2f", product.productPrice))
                            .font(.title3)

                        Text(product.productProvider ?? "Unknown")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }

                Spacer()
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

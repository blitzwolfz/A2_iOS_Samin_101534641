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
            List {
                ForEach(products, id: \.objectID) { product in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.productName ?? "Unknown")
                            .font(.headline)

                        Text(product.productDescription ?? "No description")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("All Products")
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}

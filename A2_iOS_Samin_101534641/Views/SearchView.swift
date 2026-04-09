import SwiftUI
import CoreData

struct SearchView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var searchText: String = ""
    @State private var searchResults: [Product] = []
    @State private var hasSearched: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)

                        TextField("Search by name or description", text: $searchText)
                            .onSubmit { performSearch() }

                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                searchResults = []
                                hasSearched = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                    Button("Search") {
                        performSearch()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()

                if !hasSearched {
                    Spacer()
                    Text("Enter a product name or description")
                        .foregroundColor(.secondary)
                    Spacer()
                } else if searchResults.isEmpty {
                    Spacer()
                    Text("No results found")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    List(searchResults, id: \.objectID) { product in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.productName ?? "Unknown")
                                .font(.headline)

                            Text(product.productDescription ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)

                            HStack {
                                Text(String(format: "$%.2f", product.productPrice))
                                    .font(.callout.bold())
                                Spacer()
                                Text(product.productProvider ?? "")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
            .navigationTitle("Search")
        }
    }

    private func performSearch() {
        let trimmed = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "productName CONTAINS[cd] %@", trimmed),
            NSPredicate(format: "productDescription CONTAINS[cd] %@", trimmed)
        ])
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Product.productName, ascending: true)]

        do {
            searchResults = try viewContext.fetch(fetchRequest)
        } catch {
            searchResults = []
        }
        hasSearched = true
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

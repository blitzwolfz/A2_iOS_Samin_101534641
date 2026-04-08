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
                    TextField("Search products...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit { performSearch() }

                    Button("Search") {
                        performSearch()
                    }
                }
                .padding()

                if !hasSearched {
                    Spacer()
                    Text("Search by name or description")
                        .foregroundColor(.secondary)
                    Spacer()
                } else if searchResults.isEmpty {
                    Spacer()
                    Text("No results found")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    List(searchResults, id: \.objectID) { product in
                        VStack(alignment: .leading) {
                            Text(product.productName ?? "Unknown")
                                .font(.headline)
                            Text(product.productDescription ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
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

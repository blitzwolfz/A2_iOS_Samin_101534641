import SwiftUI
import CoreData

struct SearchView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var searchText: String = ""
    @State private var searchResults: [Product] = []
    @State private var hasSearched: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                BauhausHeader(title: "Search")

                searchBar

                GeometricAccent()

                if !hasSearched {
                    initialStateView
                } else if searchResults.isEmpty {
                    noResultsView
                } else {
                    resultsList
                }

                Spacer()
            }
            .background(BauhausTheme.gray)
        }
    }

    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(BauhausTheme.black)
                    .font(.system(size: 16, weight: .bold))

                TextField("Search by name or description", text: $searchText)
                    .font(.system(size: 15, weight: .regular))
                    .onSubmit {
                        performSearch()
                    }

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
            .padding(12)
            .background(BauhausTheme.white)
            .overlay(
                Rectangle()
                    .stroke(BauhausTheme.black, lineWidth: 2)
            )

            Button(action: performSearch) {
                Text("GO")
                    .font(.system(size: 15, weight: .black))
                    .kerning(1)
                    .foregroundColor(BauhausTheme.white)
                    .frame(width: 50, height: 46)
                    .background(BauhausTheme.red)
                    .overlay(
                        Rectangle()
                            .stroke(BauhausTheme.black, lineWidth: 2)
                    )
            }
        }
        .padding(16)
    }

    private var initialStateView: some View {
        VStack(spacing: 16) {
            Spacer()

            HStack(spacing: 8) {
                Circle()
                    .fill(BauhausTheme.red)
                    .frame(width: 24, height: 24)
                Rectangle()
                    .fill(BauhausTheme.blue)
                    .frame(width: 24, height: 24)
                Triangle()
                    .fill(BauhausTheme.yellow)
                    .frame(width: 28, height: 24)
            }

            Text("SEARCH PRODUCTS")
                .font(.system(size: 18, weight: .bold))
                .kerning(2)
                .foregroundColor(BauhausTheme.black)

            Text("Enter a product name or description")
                .font(.system(size: 14))
                .foregroundColor(.secondary)

            Spacer()
        }
    }

    private var noResultsView: some View {
        VStack(spacing: 16) {
            Spacer()
            Rectangle()
                .fill(BauhausTheme.yellow)
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(45))
                .overlay(
                    Text("0")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(BauhausTheme.black)
                        .rotationEffect(.degrees(-45))
                )
            Text("NO RESULTS FOUND")
                .font(.system(size: 18, weight: .bold))
                .kerning(2)
                .foregroundColor(BauhausTheme.black)
            Text("Try a different search term")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            Spacer()
        }
    }

    private var resultsList: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    Text("\(searchResults.count) RESULT\(searchResults.count == 1 ? "" : "S")")
                        .font(.system(size: 12, weight: .bold))
                        .kerning(2)
                        .foregroundColor(BauhausTheme.black)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)

                LazyVStack(spacing: 8) {
                    ForEach(searchResults, id: \.objectID) { product in
                        searchResultRow(product: product)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }

    private func searchResultRow(product: Product) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(product.productName ?? "Unknown")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(BauhausTheme.black)

                Spacer()

                Text(String(format: "$%.2f", product.productPrice))
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(BauhausTheme.yellow)
            }

            Text(product.productDescription ?? "No description")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .lineLimit(2)

            HStack(spacing: 4) {
                Rectangle()
                    .fill(BauhausTheme.blue)
                    .frame(width: 4, height: 14)
                Text(product.productProvider ?? "Unknown")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(BauhausTheme.blue)
            }
        }
        .padding(14)
        .background(BauhausTheme.white)
        .overlay(
            Rectangle()
                .stroke(BauhausTheme.black, lineWidth: 2)
        )
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

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

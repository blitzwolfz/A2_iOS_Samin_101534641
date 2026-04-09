import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ProductDetailView()
                .tabItem {
                    Label("Browse", systemImage: "square.grid.2x2")
                }

            ProductListView()
                .tabItem {
                    Label("All Products", systemImage: "list.bullet")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            AddProductView()
                .tabItem {
                    Label("Add", systemImage: "plus.circle")
                }
        }
        .tint(BauhausTheme.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

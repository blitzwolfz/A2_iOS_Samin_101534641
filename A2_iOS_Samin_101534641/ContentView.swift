import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("Browse")
                .tabItem {
                    Label("Browse", systemImage: "square.grid.2x2")
                }

            Text("All Products")
                .tabItem {
                    Label("All Products", systemImage: "list.bullet")
                }

            Text("Search")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            Text("Add")
                .tabItem {
                    Label("Add", systemImage: "plus.circle")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

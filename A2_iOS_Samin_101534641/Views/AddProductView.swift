import SwiftUI
import CoreData

struct AddProductView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var productName: String = ""
    @State private var productDescription: String = ""
    @State private var productPrice: String = ""
    @State private var productProvider: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Product Information")) {
                    TextField("Product Name", text: $productName)
                    TextField("Description", text: $productDescription)
                    TextField("Price", text: $productPrice)
                        .keyboardType(.decimalPad)
                    TextField("Provider", text: $productProvider)
                }

                Section {
                    Button("Save Product") {
                        saveProduct()
                    }
                }
            }
            .navigationTitle("Add Product")
        }
    }

    private func saveProduct() {
        guard let price = Double(productPrice) else { return }

        let newProduct = Product(context: viewContext)
        newProduct.productID = UUID()
        newProduct.productName = productName
        newProduct.productDescription = productDescription
        newProduct.productPrice = price
        newProduct.productProvider = productProvider

        do {
            try viewContext.save()
            clearForm()
        } catch {
            print("Failed to save: \(error)")
        }
    }

    private func clearForm() {
        productName = ""
        productDescription = ""
        productPrice = ""
        productProvider = ""
    }
}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
    }
}

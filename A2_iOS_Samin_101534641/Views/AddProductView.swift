import SwiftUI
import CoreData

struct AddProductView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var productName: String = ""
    @State private var productDescription: String = ""
    @State private var productPrice: String = ""
    @State private var productProvider: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showSuccess: Bool = false

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

                    Button("Clear Form") {
                        clearForm()
                    }
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Add Product")
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .alert("Success", isPresented: $showSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Product added successfully.")
            }
        }
    }

    private func saveProduct() {
        guard !productName.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Product name is required."
            showAlert = true
            return
        }

        guard !productDescription.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Product description is required."
            showAlert = true
            return
        }

        guard let price = Double(productPrice), price >= 0 else {
            alertMessage = "Please enter a valid price."
            showAlert = true
            return
        }

        guard !productProvider.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Product provider is required."
            showAlert = true
            return
        }

        let newProduct = Product(context: viewContext)
        newProduct.productID = UUID()
        newProduct.productName = productName.trimmingCharacters(in: .whitespaces)
        newProduct.productDescription = productDescription.trimmingCharacters(in: .whitespaces)
        newProduct.productPrice = price
        newProduct.productProvider = productProvider.trimmingCharacters(in: .whitespaces)

        do {
            try viewContext.save()
            showSuccess = true
            clearForm()
        } catch {
            alertMessage = "Failed to save product. Please try again."
            showAlert = true
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

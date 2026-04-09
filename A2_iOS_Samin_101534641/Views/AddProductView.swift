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
            VStack(spacing: 0) {
                BauhausHeader(title: "Add Product")

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        formField(label: "PRODUCT NAME", text: $productName, placeholder: "Enter product name")
                        formField(label: "DESCRIPTION", text: $productDescription, placeholder: "Enter description")
                        priceField
                        formField(label: "PROVIDER", text: $productProvider, placeholder: "Enter provider name")

                        GeometricAccent()
                            .padding(.vertical, 8)

                        Button(action: saveProduct) {
                            HStack {
                                Spacer()
                                Text("ADD PRODUCT")
                                    .kerning(2)
                                Spacer()
                            }
                            .bauhausPrimaryButton(color: BauhausTheme.blue)
                        }

                        Button(action: clearForm) {
                            HStack {
                                Spacer()
                                Text("CLEAR FORM")
                                    .font(.system(size: 14, weight: .bold))
                                    .kerning(1)
                                    .foregroundColor(BauhausTheme.black)
                                Spacer()
                            }
                            .padding(.vertical, 12)
                            .overlay(
                                Rectangle()
                                    .stroke(BauhausTheme.black, lineWidth: 2)
                            )
                        }
                    }
                    .padding(16)
                }
                .background(BauhausTheme.gray)
            }
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

    private func formField(label: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(BauhausTheme.black)
                .kerning(2)

            TextField(placeholder, text: text)
                .bauhausTextField()
        }
    }

    private var priceField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("PRICE ($)")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(BauhausTheme.black)
                .kerning(2)

            TextField("0.00", text: $productPrice)
                .keyboardType(.decimalPad)
                .bauhausTextField()
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
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        seedProducts(context: viewContext)
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ProductModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true

        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let count = (try? container.viewContext.count(for: fetchRequest)) ?? 0
        if count == 0 {
            PersistenceController.seedProducts(context: container.viewContext)
        }
    }

    static func seedProducts(context: NSManagedObjectContext) {
        let products: [(String, String, Double, String)] = [
            ("Bauhaus Desk Lamp",
             "Geometric desk lamp with adjustable chrome arm and frosted glass shade",
             89.99,
             "Dessau Design Co."),
            ("Tubular Steel Chair",
             "Cantilever chair inspired by Marcel Breuer with leather seat and back",
             249.00,
             "Modernform AG"),
            ("Primary Color Clock",
             "Wall clock featuring bold red, blue, and yellow geometric segments",
             45.50,
             "Klee Timepieces"),
            ("Grid Pattern Rug",
             "Hand-woven wool rug with black grid lines on cream background",
             320.00,
             "Weimar Textiles"),
            ("Abstract Mobile",
             "Hanging kinetic sculpture with balanced geometric shapes in primary colors",
             175.00,
             "Kandinsky Studios"),
            ("Cylinder Vase Set",
             "Set of three concrete cylinder vases in graduated sizes",
             62.00,
             "FormLab"),
            ("Flat Roof Birdhouse",
             "Miniature modernist birdhouse with asymmetric windows and white facade",
             38.95,
             "Gropius Garden"),
            ("Nesting Side Tables",
             "Three stackable triangular tables in red, yellow, and blue lacquer",
             199.99,
             "De Stijl Furnishings"),
            ("Helvetica Print Set",
             "Set of four typographic art prints showcasing geometric letterforms",
             55.00,
             "Type Workshop"),
            ("Modular Bookshelf",
             "Cube-based shelving system that can be configured in multiple arrangements",
             410.00,
             "Rietveld Home")
        ]

        for (index, item) in products.enumerated() {
            let product = Product(context: context)
            product.productID = UUID()
            product.productName = item.0
            product.productDescription = item.1
            product.productPrice = item.2
            product.productProvider = item.3
        }

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

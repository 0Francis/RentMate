import SwiftUI

struct AddPropertyView: View {
    @EnvironmentObject var propertyVM: PropertyViewModel
    @Binding var isPresented: Bool
    @State private var title = ""
    @State private var address = ""
    @State private var rent = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Property Info") {
                    TextField("Title", text: $title)
                    TextField("Address", text: $address)
                    TextField("Rent (Ksh)", text: $rent)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add Property")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let rentValue = Double(rent) {
                            propertyVM.addLocalProperty(title: title, address: address, rent: rentValue)
                            isPresented = false
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
            }
        }
    }
}

#Preview {
    AddPropertyView(isPresented: .constant(true))
        .environmentObject(PropertyViewModel())
}

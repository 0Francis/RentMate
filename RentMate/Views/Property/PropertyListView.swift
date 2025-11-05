import SwiftUI

struct PropertyListView: View {
    @ObservedObject var propertyVM: PropertyViewModel
    @EnvironmentObject var authVM: AuthViewModel

    @State private var showingAdd = false
    @State private var title = ""
    @State private var address = ""
    @State private var rent = ""

    var body: some View {
        NavigationView {
            VStack {
                if propertyVM.properties.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "house")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        Text("No properties added yet")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                } else {
                    List {
                        ForEach(propertyVM.properties) { prop in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(prop.title)
                                    .font(.headline)
                                Text(prop.address)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Rent: Ksh \(Int(prop.rent))")
                                    .font(.caption)
                            }
                        }
                        .onDelete(perform: deleteProperty)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("My Properties")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") { authVM.signOut() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                NavigationView {
                    Form {
                        Section("Property Info") {
                            TextField("Title", text: $title)
                            TextField("Address", text: $address)
                            TextField("Rent (Ksh)", text: $rent)
                                .keyboardType(.decimalPad)
                        }
                    }
                    .navigationTitle("Add Property")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showingAdd = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                guard let rentValue = Double(rent) else { return }
                                propertyVM.addProperty(
                                    title: title,
                                    address: address,
                                    rent: rentValue,
                                    landlordId: authVM.currentUser?.id ?? "local"
                                )
                                showingAdd = false
                                title = ""
                                address = ""
                                rent = ""
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            propertyVM.fetchProperties()
        }
    }

    private func deleteProperty(at offsets: IndexSet) {
        offsets.forEach { idx in
            let id = propertyVM.properties[idx].id
            propertyVM.deleteProperty(id: id)
        }
    }
}

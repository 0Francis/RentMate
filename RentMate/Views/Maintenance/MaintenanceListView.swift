import SwiftUI

struct MaintenanceListView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var maintenanceRequests: [MaintenanceModel] = []
    @State private var showNewRequestSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Maintenance")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                if maintenanceRequests.isEmpty {
                    EmptyMaintenanceView(action: { showNewRequestSheet = true })
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(maintenanceRequests) { request in
                            MaintenanceCard(request: request)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Maintenance")
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showNewRequestSheet = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showNewRequestSheet) {
            NewMaintenanceView(isPresented: $showNewRequestSheet)
                .environmentObject(authVM)
        }
        .onAppear {
            loadMaintenanceRequests()
        }
    }
    
    private func loadMaintenanceRequests() {
        maintenanceRequests = LocalDataService.shared.load([MaintenanceModel].self, from: AppConstants.Files.maintenance) ?? []
        
        // If no maintenance requests, create some sample data for demo
        if maintenanceRequests.isEmpty {
            maintenanceRequests = createSampleMaintenanceRequests()
        }
    }
    
    private func createSampleMaintenanceRequests() -> [MaintenanceModel] {
        let sampleRequests = [
            MaintenanceModel(
                id: UUID().uuidString,
                propertyId: "property-1",
                description: "Kitchen sink leaking and needs repair",
                dateReported: Date().addingTimeInterval(-7 * 24 * 3600), // 1 week ago
                status: "resolved"
            ),
            MaintenanceModel(
                id: UUID().uuidString,
                propertyId: "property-1",
                description: "AC not cooling properly in living room",
                dateReported: Date().addingTimeInterval(-2 * 24 * 3600), // 2 days ago
                status: "pending"
            )
        ]
        return sampleRequests
    }
}

struct MaintenanceCard: View {
    let request: MaintenanceModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Maintenance Request")
                        .font(.headline)
                    
                    Text("Property #\(request.propertyId.prefix(8))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(request.status.capitalized)
                    .font(.system(size: 12, weight: .medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor(request.status).opacity(0.2))
                    .foregroundColor(statusColor(request.status))
                    .cornerRadius(8)
            }
            
            Text(request.description)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(2)
            
            HStack {
                Image(systemName: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(request.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if request.isResolved {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                } else {
                    Image(systemName: "clock")
                        .foregroundColor(.orange)
                        .font(.caption)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "resolved": return .green
        case "pending": return .orange
        case "in progress": return .blue
        default: return .gray
        }
    }
}

struct EmptyMaintenanceView: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Maintenance Requests")
                    .font(.headline)
                Text("Submit your first maintenance request when needed")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: action) {
                Label("New Request", systemImage: "plus.circle.fill")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

struct NewMaintenanceView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Binding var isPresented: Bool
    @State private var description = ""
    @State private var selectedPropertyId = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Maintenance Details")) {
                    TextField("Describe the issue", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    
                    Picker("Property", selection: $selectedPropertyId) {
                        Text("Select Property").tag("")
                        // In real app, load user's properties here
                        Text("Blue Roof House").tag("property-1")
                        Text("Studio 5 Apartments").tag("property-2")
                    }
                }
                
                Section(header: Text("Additional Info")) {
                    Text("A maintenance team will contact you within 24 hours to schedule the repair.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("New Maintenance Request")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Submit") {
                        submitMaintenanceRequest()
                    }
                    .disabled(description.isEmpty || selectedPropertyId.isEmpty)
                }
            }
        }
    }
    
    private func submitMaintenanceRequest() {
        let newRequest = MaintenanceModel(
            id: UUID().uuidString,
            propertyId: selectedPropertyId,
            description: description,
            dateReported: Date(),
            status: "pending"
        )
        
        // Save to local storage
        var existingRequests = LocalDataService.shared.load([MaintenanceModel].self, from: AppConstants.Files.maintenance) ?? []
        existingRequests.append(newRequest)
        LocalDataService.shared.save(existingRequests, to: AppConstants.Files.maintenance)
        
        isPresented = false
    }
}

#Preview {
    NavigationStack {
        MaintenanceListView()
            .environmentObject(AuthViewModel())
    }
}

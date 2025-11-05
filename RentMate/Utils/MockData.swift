//
//  MockData.swift
//  RentMate
//
//  Created by Student1 on 04/11/2025.
//


import Foundation

struct MockData {
    static let demoUsers: [AppUser] = [
        AppUser(id: "admin-1", name: "Demo Admin", email: "admin@demo.com", role: AppConstants.Roles.admin),
        AppUser(id: "landlord-1", name: "Demo Landlord", email: "landlord@demo.com", role: AppConstants.Roles.landlord),
        AppUser(id: "tenant-1", name: "Demo Tenant", email: "tenant@demo.com", role: AppConstants.Roles.tenant)
    ]
}

//
//  AppConstants.swift
//  RentMate
//
//  Created by Student1 on 04/11/2025.
//


import Foundation

enum AppConstants {
    enum Files {
        static let users = "users.json"
        static let properties = "properties.json"
        static let payments = "payments.json"
        static let maintenance = "maintenance.json"
    }

    enum Roles {
        static let admin = "admin"
        static let landlord = "landlord"
        static let tenant = "tenant"
    }
    static let appName = "RentMate"
    static let baseColor = "PrimaryBlue"

}

//
//  JSONManager.swift
//  RentMate
//
//  Created by Student1 on 04/11/2025.
//


import Foundation

struct JSONManager {
    static func loadUsers() -> [AppUser] {
        LocalDataService.shared.load([AppUser].self, from: AppConstants.Files.users) ?? []
    }

    static func loadProperties() -> [PropertyModel] {
        LocalDataService.shared.load([PropertyModel].self, from: AppConstants.Files.properties) ?? []
    }
}

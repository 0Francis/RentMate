//
//  FileHelper.swift
//  RentMate
//
//  Created by Student1 on 04/11/2025.
//


import Foundation

enum FileHelper {
    static func documentsPath(for file: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(file)
    }
}

//
//  FileManagerRepositoryHandler.swift
//  VideoRecording
//
//  Created by Sharon Omoyeni Babatunde on 08/08/2023.
//

import Foundation


import Foundation

protocol FileManagerRepositoryHandlerDelegate {
    static func writeToFileStorage<T: Codable>(_ item: T, id: String?, path: String) -> [T]
    static func readFromFileStorage<T: Codable>(path: String) -> [T]
    static func saveToFileStorage<T: Codable>(_ dampers: [T], path: String)
}

enum FileManagerRepositoryHandler: FileManagerRepositoryHandlerDelegate {
    
    ///Write to Filemanager
    static func writeToFileStorage<T: Codable>(_ item: T, id: String?, path: String) -> [T] {

        let savedDampers: [T] = readFromFileStorage(path: path)
            var updatedDampers = savedDampers
            updatedDampers.append(item)
            saveToFileStorage(updatedDampers, path: path)
            return updatedDampers
    }

    /// Function to read from FileManager
    static func readFromFileStorage<T: Codable>(path: String) -> [T] {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(path) {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let dampers = try decoder.decode([T].self, from: data)
                return dampers
            } catch {
                print("Error reading AddNewDampers from FileManager: \(error)")
            }
        }
        
        return []
    }

    /// Function to save FileManager
    static func saveToFileStorage<T: Codable>(_ dampers: [T], path: String) {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(path) {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(dampers)
                try data.write(to: url)
            } catch {
                print("Error saving AddNewDampers to FileManager: \(error)")
            }
        }
    }

}


enum FileManagerPathConstants {
    
    static let ADD_NEW_DAMPERS = "AddNewDampers.json"
}



enum App_Constants {
    
    static let IS_FIRST_ENTRY = "IS_FIRST_ENTRY"
    static let IS_FIRST_LOGIN = "IS_FIRST_LOGIN"
}

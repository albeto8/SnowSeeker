//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Mario Alberto Barragán Espinosa on 05/01/20.
//  Copyright © 2020 Mario Alberto Barragán Espinosa. All rights reserved.
//

import Foundation

class Favorites: ObservableObject, Codable {
    // the actual resorts the user has favorited
    private var resorts: Set<String>

    // the key we're using to read/write in UserDefaults
    private static let saveKey = "Favorites"

    init() {
        // load our saved data
      if let items = UserDefaults.standard.data(forKey: Favorites.saveKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Set<String>.self, from: items) {
                self.resorts = decoded
                return
            }
        }
        // still here? Use an empty array
        self.resorts = []
    }

    // returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    // adds the resort to our set, updates all views, and saves the change
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }

    // removes the resort from our set, updates all views, and saves the change
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }

    func save() {
        // write out our data
        if let encoded = try? JSONEncoder().encode(resorts) {
            UserDefaults.standard.set(encoded, forKey: Favorites.saveKey)
        }
    }
}

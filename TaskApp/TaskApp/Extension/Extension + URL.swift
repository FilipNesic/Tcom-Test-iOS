//
//  Extension + URL.swift
//  TaskApp
//
//  Created by Filip Nesic on 19.4.24..
//

import Foundation

extension URL {
    static let baseURL = URL(string: "https://zadatak.tcom.rs/zadatak/public/api")
    static let loginURL = URL(string: "https://zadatak.tcom.rs/zadatak/public/api/login")
    static let allVehiclesURL = URL(string: "https://zadatak.tcom.rs/zadatak/public/api/allVehicles")
    static let vehicleURL = URL(string: "https://zadatak.tcom.rs/zadatak/public/api/vehicle")
    static let addFavouritesURL = URL(string: "https://zadatak.tcom.rs/zadatak/public/api/addToFavorites")
}

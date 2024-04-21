//
//  VehicleModel.swift
//  TaskApp
//
//  Created by Filip Nesic on 19.4.24..
//

import Foundation

struct VehicleModel: Codable {
    var vehicleID: Int
    var vehicleTypeID: Int
    var imageURL: String
    var name: String
    var location: Location
    var rating: Float
    var price: Int
    var isFavorite: Bool
}

struct Location: Codable {
    var latitude: Double
    var longitude: Double
}

struct Pins: Identifiable, Equatable {
    var id = UUID()
    var lat: Double
    var long: Double
}

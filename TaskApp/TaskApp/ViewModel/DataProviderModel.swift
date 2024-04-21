//
//  VehicleViewModel.swift
//  TaskApp
//
//  Created by Filip Nesic on 19.4.24..
//

import SwiftUI
import Combine
import OSLog

final class DataProviderModel: ObservableObject {
    private var logger: Logger = Logger(subsystem: "task.app", category: "DataProvider")
    @Published var email: String = "filip.nesic.developer@gmail.com"
    @Published var token: String?
    @Published var vehicles: [VehicleModel] = []
    @Published var favourites: [VehicleModel] = []
    @Published var carArray: [VehicleModel] = []
    @Published var motorcycleArray: [VehicleModel] = []
    @Published var truckArray: [VehicleModel] = []
    @Published var pins: [Pins] = []
    @Published var tokenIsValid = false
    @Published var searchVehicleText: String = ""
    
    @State var savedToken: String = UserDefaults.standard.string(forKey: "token") ?? ""
    // Not a best way to keep sensitive data, but for this purpose will do the job, the recommended way to securely store tokens or sensitive information is using and storing in the Keychain.
    
    private var cancellables: Set<AnyCancellable> = []
    var filteredItems: [VehicleModel] {
        if searchVehicleText.isEmpty {
            return vehicles
        } else {
            return vehicles.filter { $0.name.lowercased().contains(searchVehicleText.lowercased()) }
        }
    }
    
    //MARK: Generate Token for login
    func generateToken() {
        guard let url = URL.loginURL else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Constants.apiKey, forHTTPHeaderField: "X-api-key")
        
        let parameters: [String: String] = ["email": email]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
        } catch {
            logger.error("Error serializing JSON: \(error)")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.logger.error("\(error)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                UserDefaults.standard.setValue(response.token, forKey: "token")
                self.token = response.token
                self.tokenIsValid = true
                
            })
            .store(in: &cancellables)
    }
    
    //MARK: Fetching the data
    func fetchVehicles() {
        guard let url =  URL.allVehiclesURL else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(savedToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Constants.apiKey, forHTTPHeaderField: "X-api-key")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: [VehicleModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.logger.error("\(error)")
                case .finished:
                    break
                }
            }, receiveValue: { vehicles in
                
                // Clear favourites array
                self.favourites.removeAll()
                
                // Iterate through fetched vehicles
                for vehicle in vehicles {
                    // Add vehicle to appropriate array based on type
                    switch vehicle.vehicleTypeID {
                    case 1:
                        if !self.carArray.contains(where: { $0.vehicleID == vehicle.vehicleID }) {
                            self.carArray.append(vehicle)
                        }
                    case 2:
                        if !self.motorcycleArray.contains(where: { $0.vehicleID == vehicle.vehicleID }) {
                            self.motorcycleArray.append(vehicle)
                        }
                    case 3:
                        if !self.truckArray.contains(where: { $0.vehicleID == vehicle.vehicleID }) {
                            self.truckArray.append(vehicle)
                        }
                    default:
                        break
                    }
                    // Add to favourites if isFavorite is true
                    if vehicle.isFavorite {
                        self.favourites.append(vehicle)
                    }
                    // Add pins for the vehicle
                    self.pins.append(Pins(lat: vehicle.location.latitude, long: vehicle.location.longitude))
                }
                // Update the vehicles array
                self.vehicles = vehicles
            })
            .store(in: &cancellables)
    }
    
    //MARK: Fetch vehicle details
    func fetchVehicle() {
        guard let url =  URL.vehicleURL else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(savedToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Constants.apiKey, forHTTPHeaderField: "X-api-key")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: VehicleModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.logger.error("\(error)")
                case .finished:
                    break
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    //MARK: Add vehicle to favourites
    func addToFavorites(vehicleID: Int) {
        guard let url = URL.addFavouritesURL else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("Bearer \(savedToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Constants.apiKey, forHTTPHeaderField: "X-api-key")
        
        let parameters: [String: Int] = ["vehicleID": vehicleID]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
        } catch {
            logger.error("Error serializing JSON: \(error)")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.logger.error("\(error)")
                case .finished:
                    break
                }
            }, receiveValue: { data in
                if let responseString = String(data: data, encoding: .utf8) {
                    self.logger.info("Response: \(responseString)")
                }
            })
            .store(in: &cancellables)
    }
}

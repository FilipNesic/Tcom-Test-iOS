//
//  HeaderInfoView.swift
//  TaskApp
//
//  Created by Filip Nesic on 20.4.24..
//

import SwiftUI

struct HeaderVehicleInfoView: View {
    @Binding var selectedPin: Pins
    @StateObject var viewModel: DataProviderModel
    @State private var showVehicleDetailView = false

    var body: some View {
        VStack {
            if let selected = filteredObject() {
                HeaderItemView(viewModel: viewModel, vehicleModel: selected)
                //NavigationLink and NavigationStack make problem for rendering a map
                    .onTapGesture {
                        showVehicleDetailView = true
                    }
                    .navigationDestination(isPresented: $showVehicleDetailView) {
                        VehicleDetailView(selectedModel: selected)
                    }

            } else {
                EmptyView()
            }
            
            Spacer()
        }
    }
    
    func filteredObject() -> VehicleModel? {
        for vehicle in viewModel.vehicles {
            if selectedPin.lat == vehicle.location.latitude && selectedPin.long == vehicle.location.longitude {
                return vehicle
            }
        }
        
        return nil
    }
}


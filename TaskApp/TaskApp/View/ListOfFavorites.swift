//
//  ListOfFavorites.swift
//  TaskApp
//
//  Created by Filip Nesic on 20.4.24..
//

import SwiftUI

struct ListOfFavorites: View {
    @StateObject private var viewModel = DataProviderModel()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            ScrollView {
                ForEach(viewModel.favourites, id: \.vehicleID) { vehicle in
                    NavigationLink {
                        VehicleDetailView(selectedModel: vehicle)
                    } label: {
                        ListItemView(viewModel: viewModel, vehicleModel: vehicle)
                    }
                }
            }
            .onAppear {
                viewModel.fetchVehicles()
            }
        }
    }
}

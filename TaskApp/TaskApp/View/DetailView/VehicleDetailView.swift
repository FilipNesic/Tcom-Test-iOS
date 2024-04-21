//
//  VehicleDetailView.swift
//  TaskApp
//
//  Created by Filip Nesic on 19.4.24..
//

import SwiftUI

struct VehicleDetailView: View {
    var selectedModel: VehicleModel
    private var formattedNumber: String {
           let formatter = NumberFormatter()
           formatter.minimumFractionDigits = 0
           formatter.maximumFractionDigits = 6 // Set the maximum number of decimal places
           formatter.numberStyle = .decimal
           
         return formatter.string(from: NSNumber(value: selectedModel.rating)) ?? ""
       }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                AsyncImage(url: URL(string: selectedModel.imageURL)) { vehicleImage in
                    vehicleImage
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 30, height: 220)
                        .clipShape(.rect(cornerRadius: 12))
                    
                } placeholder: {
                    ProgressView()
                        .tint(Color.accentColor)
                        .controlSize(.large)
                }
                Group {
                    HStack {
                        Text("Model:")
                        
                        Spacer()
                        Text(selectedModel.name)
                    }
                    HStack {
                        Text("Rating:")
                        
                        Spacer()
                        HStack {
                            Text("\(formattedNumber)")
                                .foregroundStyle(Color.white)
                            Image(systemName: "star.fill")
                                .foregroundStyle(Color.white)
                        }
                    }
                    HStack {
                        Text("Cena:")
                        
                        Spacer()
                        Text("\(selectedModel.price)€")
                    }
                    HStack {
                        Text("Latitude:")
                        
                        Spacer()
                        Text("\(selectedModel.location.latitude)")
                    }
                    HStack {
                        Text("Longitude:")
                        
                        Spacer()
                        Text("\(selectedModel.location.longitude)")
                    }
                    
                    Spacer()
                }
                .foregroundStyle(Color.white)
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Vozilo")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
        .background(Color.black)
    }
}

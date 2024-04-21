//
//  ListViewItem.swift
//  TaskApp
//
//  Created by Filip Nesic on 19.4.24..
//

import SwiftUI

struct HeaderItemView: View {
   @ObservedObject var viewModel: DataProviderModel
    var vehicleModel: VehicleModel
    @State private var isFavorite = false
   
   private var formattedNumber: String {
          let formatter = NumberFormatter()
          formatter.minimumFractionDigits = 0
          formatter.maximumFractionDigits = 6 // Set the maximum number of decimal places
          formatter.numberStyle = .decimal
          
        return formatter.string(from: NSNumber(value: vehicleModel.rating)) ?? ""
      }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(width: UIScreen.main.bounds.width - 12, height: 280)
            .foregroundStyle(Color.backgroundGray)
            .opacity(0.7)
            .overlay {
                VStack {
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(Color.backgroundGray)
                            .overlay {
                                AsyncImage(url: URL(string: vehicleModel.imageURL)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                        .tint(Color.accentColor)
                                        .controlSize(.large)
                                }
                            }
                            .clipped()
                            .clipShape(.rect(cornerRadius: 12))
                        Button(action: {
                            isFavorite.toggle()
                            viewModel.addToFavorites(vehicleID: vehicleModel.vehicleID)
                            viewModel.fetchVehicles()
                        }, label: {
                            Image(systemName: vehicleModel.isFavorite || isFavorite ? "heart.fill": "heart")
                                .resizable()
                                .frame(width: 22, height: 20)
                        })
                        .padding([.top, .trailing], 15)
                    }
                    HStack {
                        VStack {
                            HStack {
                                Text(vehicleModel.name)
                                    .font(.system(size: 19))
                                    .foregroundStyle(Color.white)
                                
                                Spacer()
                            }
                            HStack {
                                HStack {
                                    Text("\(formattedNumber)")
                                        .foregroundStyle(Color.white)
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(Color.white)
                                }
                                
                                Spacer()
                                Text("\(vehicleModel.price)$")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color.white)
                            }
                        }
                    }
                }
                .padding(.all, 12)
            }
    }
}


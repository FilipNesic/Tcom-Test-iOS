//
//  AnnotationView.swift
//  TaskApp
//
//  Created by Filip Nesic on 20.4.24..
//

import SwiftUI

struct AnnotationView: View {
     var pinModel: Pins
    @ObservedObject var viewModel: DataProviderModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(width: 50, height: 30)
            .foregroundStyle(Color.backgroundGray)
            .overlay {
                if let model = filteredObject() {
                    Text("\(model.price)")
                        .foregroundStyle(Color.white)
                }
            }
    }
    
  private func filteredObject() -> VehicleModel? {
      for vehicle in viewModel.vehicles {
            
            if pinModel.lat == vehicle.location.latitude {
        
                return vehicle
            }
        }
        return nil
    }
}

//
//  MapView.swift
//  TaskApp
//
//  Created by Filip  on 21.4.24..
//

import SwiftUI
import MapKit
import Combine

struct MapView: View {
    @StateObject private var viewModel = DataProviderModel()
    @Binding var showHeaderInfo: Bool
    @State var selectedPin: Pins = Pins(lat: 0.0, long: 0.0)
    @State var pinIsSelected = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.7866, longitude: 20.4489),
        span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
    )
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: viewModel.pins, annotationContent: { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)) {
                    AnnotationView(pinModel: location, viewModel: viewModel)
                        .scaleEffect(selectedPin == location ? 1 : 0.7)
                        .onTapGesture {
                            print("Selected \(location)")
                            selectedPin = location
                            pinIsSelected = true
                            showHeaderInfo.toggle()
                            
                            withAnimation {
                                region = MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(latitude: selectedPin.lat, longitude: selectedPin.long),
                                    span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                                )
                            }
                        }
                }
            })
            .onAppear {
                viewModel.fetchVehicles()
            }
            .ignoresSafeArea(.all, edges: .top)
            if showHeaderInfo {
                HeaderVehicleInfoView(selectedPin: $selectedPin, viewModel: viewModel)
            }
        }
    }
}

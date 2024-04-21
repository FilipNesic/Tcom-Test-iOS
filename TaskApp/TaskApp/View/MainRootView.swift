//
//  MainView.swift
//  TaskApp
//
//  Created by Filip Nesic on 19.4.24..
//

import SwiftUI
import MapKit
import Combine
import OSLog

struct MainRootView: View {
    @ObservedObject private var viewModel = DataProviderModel()
    @State private var selectedTab = 0
    @State private var showHeaderInfo = false
    @State var selectedPin: Pins = Pins(lat: 0.0, long: 0.0)
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.7866, longitude: 20.4489),
        span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
    )
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                ZStack {
                    Map(coordinateRegion: $region, annotationItems: viewModel.pins, annotationContent: { location in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)) {
                            AnnotationView(pinModel: location, viewModel: viewModel)
                                .scaleEffect(selectedPin == location ? 1 : 0.7)
                                .onTapGesture {
                                    print("Selected Location: \(location)")
                                    selectedPin = location
                                    
                                    withAnimation {
                                        showHeaderInfo = true
                                        region = MKCoordinateRegion(
                                            center: CLLocationCoordinate2D(latitude: selectedPin.lat, longitude: selectedPin.long),
                                            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                                        )
                                    }
                                }
                        }
                    })
                    .ignoresSafeArea(.all, edges: .top)
                    if showHeaderInfo {
                        HeaderVehicleInfoView(selectedPin: $selectedPin, viewModel: viewModel)
                    }
                }
                .tabItem {
                    Image(systemName: "map")
                }
                .tag(0)
                
                SearchAndSortListView(viewModel: viewModel)
                    .onAppear {
                        showHeaderInfo = false
                    }
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle.fill")
                    }
                    .tag(1)
                
                ListOfFavorites()
                    .tabItem {
                        Image(systemName: "heart")
                    }
                    .tag(2)
            }
            .onAppear() {
                viewModel.fetchVehicles()
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                UITabBar.appearance().backgroundColor = .black
                UITabBar.appearance().barTintColor = .black
                UITabBar.appearance().unselectedItemTintColor = .gray
            }
        }
    }
}

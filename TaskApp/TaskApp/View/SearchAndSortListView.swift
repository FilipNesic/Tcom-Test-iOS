//
//  SearchAndSortListView.swift
//  TaskApp
//
//  Created by Filip Nesic on 20.4.24..
//

import SwiftUI

enum SegmentBar {
    case car
    case motorcycle
    case truck
}

enum Field {
    case text
}

struct SearchAndSortListView: View {
    @StateObject var viewModel: DataProviderModel
    @FocusState private var textFocus: Field?
    @State private var searchVehicleText = ""
    @State private var segment: SegmentBar = .car
    @State private var sortAscending = true
    @State private var isSortByCheaperSelected = false
    @State private var isSortByExpensiveSelected = false
    
    var filteredArray: [VehicleModel] {
        switch segment {
        case .car:
            return filterAndSortArray(array: viewModel.carArray)
        case .motorcycle:
            return filterAndSortArray(array: viewModel.motorcycleArray)
        case .truck:
            return filterAndSortArray(array: viewModel.truckArray)
        }
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all, edges: .top)
            VStack {
                VStack(spacing: 25) {
                    headerView
                    segmentBarView
                    listView
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button {
                            textFocus = nil
                        } label: {
                            Text("Done")
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchVehicles()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(height: 45)
                .foregroundStyle(Color.gray)
                .opacity(0.6)
                .overlay {
                    TextField("", text: $searchVehicleText, prompt: Text("Pretrazi vozila").foregroundColor(.gray))
                        .focused($textFocus, equals: .text)
                        .padding()
                        .foregroundStyle(Color.white)
                }
            Menu("Sortiraj") {
                Button(action: {
                    sortAscending = false
                    isSortByCheaperSelected = true
                    isSortByExpensiveSelected = false
                }, label: {
                    HStack {
                        Text("Po ceni - prvo skuplje")
                        if isSortByCheaperSelected {
                            Image(systemName: "checkmark")
                        }
                    }
                })
                
                Button(action: {
                    sortAscending = true
                    isSortByCheaperSelected = false
                    isSortByExpensiveSelected = true
                }, label: {
                    HStack {
                        Text("Po ceni - prvo jeftinije")
                        if isSortByExpensiveSelected {
                            Image(systemName: "checkmark")
                        }
                    }
                })
            }
        }
        .padding(.horizontal, 12)
    }
    
    private var listView: some View {
        ScrollView {
            ForEach(filteredArray, id: \.vehicleID) { vehicle in
                NavigationLink {
                    VehicleDetailView(selectedModel: vehicle)
                } label: {
                    ListItemView(viewModel: viewModel, vehicleModel: vehicle)
                }
            }
        }
    }
    
    private var segmentBarView: some View {
        HStack {
            Button(action: {
                segment = .car
            }, label: {
                Text("Auto")
                    .padding()
                    .foregroundColor(segment == .car ? Color.accentColor : Color.gray.opacity(0.6))
                    .cornerRadius(8)
            })
            Spacer()
            
            Button(action: {
                segment = .motorcycle
            }, label: {
                Text("Motor")
                    .padding()
                    .foregroundColor(segment == .motorcycle ? Color.accentColor : Color.gray.opacity(0.6))
                    .cornerRadius(8)
            })
            Spacer()
            
            Button(action: {
                segment = .truck
            }, label: {
                Text("Kamion")
                    .padding()
                    .foregroundColor(segment == .truck ? Color.accentColor : Color.gray.opacity(0.6))
                    .cornerRadius(8)
            })
        }
    }
    
    private func filterAndSortArray(array: [VehicleModel]) -> [VehicleModel] {
        var filtered = array
        
        if !searchVehicleText.isEmpty {
            filtered = filtered.filter { $0.name.lowercased().contains(searchVehicleText.lowercased()) }
        }
        
        return sortArray(array: filtered)
    }
    
    private func sortArray(array: [VehicleModel]) -> [VehicleModel] {
        return array.sorted(by: { sortAscending ? $0.price < $1.price : $0.price > $1.price })
    }
}

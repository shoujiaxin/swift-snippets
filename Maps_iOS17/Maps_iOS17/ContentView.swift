//
//  ContentView.swift
//  Maps_iOS17
//
//  Created by Jiaxin Shou on 2023/6/24.
//

import MapKit
import SwiftUI

extension CLLocationCoordinate2D {
    static let myLocation: CLLocationCoordinate2D = .init(latitude: 37.3346,
                                                          longitude: -122.0090)
}

extension MKCoordinateRegion {
    static let myRegion: MKCoordinateRegion = .init(center: .myLocation,
                                                    latitudinalMeters: 10000,
                                                    longitudinalMeters: 10000)
}

struct ContentView: View {
    @State
    private var cameraPosition: MapCameraPosition = .region(.myRegion)

    @Namespace
    private var locationScope

    @State
    private var searchText: String = ""

    @State
    private var showSearchBar: Bool = false

    var body: some View {
        NavigationStack {
            Map(position: $cameraPosition, scope: locationScope) {
                Annotation("Apple Park", coordinate: .myLocation) {
                    ZStack {
                        Image(systemName: "applelogo")
                            .font(.title3)

                        Image(systemName: "square")
                            .font(.largeTitle)
                    }
                }
                .annotationTitles(.hidden)

                UserAnnotation()
            }
            .overlay(alignment: .bottomTrailing) {
                VStack(spacing: 15) {
                    MapCompass(scope: locationScope)

                    MapPitchButton(scope: locationScope)

                    MapUserLocationButton(scope: locationScope)
                }
                .buttonBorderShape(.circle)
                .padding()
            }
            .mapScope(locationScope)
            .navigationTitle("Map")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, isPresented: $showSearchBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}

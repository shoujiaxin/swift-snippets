//
//  ContentView.swift
//  Maps_iOS17
//
//  Created by Jiaxin Shou on 2023/6/24.
//

import MapKit
import SwiftUI

extension CLLocationCoordinate2D {
    static let myLocation: CLLocationCoordinate2D = .init(latitude: 31.2398,
                                                          longitude: 121.4992)
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

    @State
    private var searchResults: [MKMapItem] = []

    @State
    private var mapSelection: MKMapItem? = nil

    @State
    private var showDetails: Bool = false

    @State
    private var lookAroundScene: MKLookAroundScene?

    var body: some View {
        NavigationStack {
            Map(position: $cameraPosition, selection: $mapSelection, scope: locationScope) {
                Annotation("Apple Park", coordinate: .myLocation) {
                    ZStack {
                        Image(systemName: "applelogo")
                            .font(.title3)

                        Image(systemName: "square")
                            .font(.largeTitle)
                    }
                }
                .annotationTitles(.hidden)

                ForEach(searchResults, id: \.self) { mapItem in
                    let placemark = mapItem.placemark
                    Marker(placemark.name ?? "Place", coordinate: placemark.coordinate)
                        .tint(.blue)
                }

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
            .sheet(isPresented: $showDetails) {
                mapDetails
                    .presentationDetents([.height(300)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(300)))
                    .presentationCornerRadius(25)
                    .interactiveDismissDisabled(true)
            }
        }
        .onSubmit(of: .search) {
            Task {
                guard !searchText.isEmpty else {
                    return
                }
                await searchPlaces()
            }
        }
        .onChange(of: showSearchBar, initial: false) { _, newValue in
            if !newValue {
                searchResults.removeAll(keepingCapacity: false)
                showDetails = false
            }
        }
        .onChange(of: mapSelection) { _, newValue in
            showDetails = newValue != nil
        }
    }

    @ViewBuilder
    private var mapDetails: some View {
        VStack(spacing: 15) {
            ZStack {
                if lookAroundScene == nil {
                    ContentUnavailableView("No Preview Available", image: "eye.slash")
                } else {
                    LookAroundPreview(scene: $lookAroundScene)
                }
            }
            .frame(height: 200)
            .clipShape(.rect(cornerRadius: 15))

            Button("Get Directions") {}
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.blue.gradient, in: .rect(cornerRadius: 15))
        }
        .padding(15)
    }

    private func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .myRegion

        let results = try? await MKLocalSearch(request: request).start()
        searchResults = results?.mapItems ?? []
    }
}

#Preview {
    ContentView()
}

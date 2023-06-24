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

    var body: some View {
        Map(position: $cameraPosition)
    }
}

#Preview {
    ContentView()
}

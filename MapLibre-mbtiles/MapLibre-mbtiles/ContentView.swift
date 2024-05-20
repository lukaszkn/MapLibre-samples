//
//  ContentView.swift
//  MapLibre-mbtiles
//
//  Created by Lukasz on 18/05/2024.
//

import SwiftUI
import MapLibre

struct ContentView: View {
    var body: some View {
        MapLibreTapView()
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}

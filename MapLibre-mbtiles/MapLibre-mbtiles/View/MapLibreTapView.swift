//
//  MapLibreTapView.swift
//  MapLibre-mbtiles
//
//  Created by Lukasz on 18/05/2024.
//

import MapLibre
import MapKit
import SwiftUI

struct MapLibreTapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MLNMapView {
        let mapView = MLNMapView()
        
        let singleTap = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleMapTap(sender:))
        )
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
        
        mapView.setCenter(CLLocationCoordinate2DMake(52.2, 19.1), zoomLevel: 7, animated: false)
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ mapView: MLNMapView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MLNMapViewDelegate {
        
        // add sources and layers after loading default style, mapView.style is nil prior to this
        func mapView(_ mapView: MLNMapView, didFinishLoading style: MLNStyle) {
            
            let mbURL = "mbtiles:///\(Bundle.main.url(forResource: "poland", withExtension: "mbtiles")!.path())"
            let railwaysSource = MLNVectorTileSource(identifier: "railway", tileURLTemplates: [mbURL], options: [
                .minimumZoomLevel: 4,
                .maximumZoomLevel: 24
            ])
            mapView.style?.addSource(railwaysSource)
            
            // add layer representing railway tracks
            let tracksLayer = MLNLineStyleLayer(identifier: "railway", source: railwaysSource)
            tracksLayer.sourceLayerIdentifier = "railway"
            tracksLayer.lineColor = NSExpression(forConstantValue: UIColor.blue)
            mapView.style?.addLayer(tracksLayer)
            
            // add layer with train stations
            let stationsLayer = MLNCircleStyleLayer(identifier: "railway_station", source: railwaysSource)
            stationsLayer.sourceLayerIdentifier = "railway_station"
            stationsLayer.circleColor = NSExpression(forConstantValue: UIColor.red)
            mapView.style?.addLayer(stationsLayer)
            
            let stationNameLayer = MLNSymbolStyleLayer(identifier: "railway_station_name", source: railwaysSource)
            stationNameLayer.sourceLayerIdentifier = "railway_station_name"
            stationNameLayer.text = NSExpression(forKeyPath: "name")
            mapView.style?.addLayer(stationNameLayer)
        }
        
        // Get features at tap point
        @objc func handleMapTap(sender: UITapGestureRecognizer) {
            guard let mapView = sender.view as? MLNMapView else { return }
            
            let tapPoint: CGPoint = sender.location(in: mapView)
            let features = mapView.visibleFeatures(at: tapPoint)
            print(features)
        }
    }
}



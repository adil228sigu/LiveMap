import SwiftUI
import GoogleMaps



struct GoogleMapView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition(latitude: 40.7128, longitude: -74.0060, zoom: 12)
        
        let mapView = GMSMapView(frame: .zero, camera: camera)
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
         
    }
    
    
}

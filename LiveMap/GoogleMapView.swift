import SwiftUI
import GoogleMaps



struct GoogleMapView: UIViewRepresentable {
    @Binding var zoom: Float
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition(latitude: 40.7128, longitude: -74.0060, zoom: zoom)

        let mapView = GMSMapView()
        mapView.camera = camera
        
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        
        let camera = GMSCameraPosition(latitude: uiView.camera.target.latitude, longitude: uiView.camera.target.longitude, zoom: zoom)
        uiView.animate(to: camera)
        
    }
}

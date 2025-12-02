//import GoogleMaps
//
//class GoogleMapManager {
//    static let shared = GoogleMapManager()
//    
//    var mapView: GMSMapView?
//    
//    func zoomIn() {
//        guard let mapView else { return }
//        mapView.animate(toZoom: mapView.camera.zoom + 1)
//    }
//    
//    func zoomOut() {
//        guard let mapView else { return }
//        mapView.animate(toZoom: mapView.camera.zoom - 1)
//    }
//    
//    func toggleStyle() {
//        guard let mapView else { return }
//        if mapView.mapStyle == nil {
//            mapView.mapStyle = try? GMSMapStyle(jsonString: )
//        } else {
//            mapView.mapStyle = nil
//        }
//    }
//}

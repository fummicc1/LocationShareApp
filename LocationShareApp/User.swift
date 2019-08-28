import Foundation
import CoreLocation

struct UserData {
    var locationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let uid: String
    let email: String
    let fcmToken: String
    
    init(data: [String: Any]) {
        latitude = data["latitude"] as! CLLocationDegrees
        longitude = data["longitude"] as! CLLocationDegrees
        uid = data["uid"] as! String
        email = data["email"] as! String
        fcmToken = data["fcmToken"] as? String ?? ""
    }
}

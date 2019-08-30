import UIKit
import Firebase
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    var token: String = ""
    var bearerToken: Data!
    var locationManager: CLLocationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        locationManager.requestAlwaysAuthorization()
        
        InstanceID.instanceID().instanceID { (result, error) in
            if error == nil, result != nil {
                self.token = result!.token
                Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).setData(
                    ["fcmToken": result!.token],
                    merge: true)
            }
        }
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
        return true
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        if Auth.auth().currentUser?.uid == nil { return }
        let uid = Auth.auth().currentUser!.uid
        Firestore.firestore().collection("users").document(uid).setData([
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            ], merge: true)
    }
}

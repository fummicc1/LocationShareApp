import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    var token: String = ""
    var bearerToken: Data!
    var locationManager: CLLocationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error  in }
        UNUserNotificationCenter.current().delegate = self
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
        locationManager.startUpdatingLocation()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
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

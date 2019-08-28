import UIKit
import MapKit
import Firebase

class MapViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var mapView: MKMapView!
    var pointAnnotation: MKPointAnnotation = MKPointAnnotation()
    var target: UserData? {
        return userList.first(where: { $0.email == emailTextField.text ?? "" })
    }
    var userList: [UserData] = []
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        emailTextField.delegate = self
        loadUsers()
        mapView.addAnnotation(pointAnnotation)
        if appDelegate.locationManager.location == nil { return }
        mapView.showsUserLocation = true
        mapView.userLocation.location
        mapView.setCenter(appDelegate.locationManager.location!.coordinate, animated: true)
        var region = mapView.region
        var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        region.span = span
        region.center = appDelegate.locationManager.location!.coordinate
        mapView.setRegion(region, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func loadUsers() {
        Firestore.firestore().collection("users").addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
            if snapshot?.metadata.hasPendingWrites == true { return }
            guard let snapshot = snapshot else { return }
            self.userList = []
            for document in snapshot.documents {
                let data = document.data()
                let user = UserData(data: data)
                self.userList.append(user)
            }
            if self.target == nil { return }
            self.mapView.setCenter(self.target!.locationCoordinate, animated: true)
            self.pointAnnotation.coordinate = self.target!.locationCoordinate
        }
    }
}

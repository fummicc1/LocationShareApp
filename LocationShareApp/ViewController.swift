//
//  ViewController.swift
//  LocationShareApp
//
//  Created by Fumiya Tanaka on 2019/08/26.
//  Copyright © 2019 Fumiya Tanaka. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    @IBAction func reloadButton() {
        let url = URL(string: "https://")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "更新完了", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

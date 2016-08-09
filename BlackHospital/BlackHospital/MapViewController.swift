//
//  MapViewController.swift
//  BlackHospital
//
//  Created by Stephen Zhuang on 16/8/4.
//  Copyright © 2016年 StephenZhuang. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import SwiftyJSON
import MapKit
import CoreLocation

class MapViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    
    var hospitals: Results<Hospital>!
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadData()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        for hospital in hospitals {
            let ann = MKPointAnnotation()
            ann.title = hospital.name
            let coordinate = CLLocation(latitude: hospital.lat, longitude: hospital.lng).coordinate
            ann.coordinate = coordinate
            mapView.addAnnotation(ann)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() -> Void {
        let realm = try! Realm()
        
        hospitals = realm.objects(Hospital)
        print("count = \(hospitals.count)")
        if hospitals.count == 0 {
            let path = NSBundle.mainBundle().pathForResource("hospital", ofType: "geojson")
            let data = NSFileManager.defaultManager().contentsAtPath(path!)
            
            let dic = try!  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            
            let json = JSON(dic!)
            
            print(json)
            
            let array = json["features"]
            for hos in array.array! {
                let name = hos["properties"]["name"].string
                let lng = hos["geometry"]["coordinates"][0].double
                let lat = hos["geometry"]["coordinates"][1].double
                
                let hospital: Hospital = Hospital()
                hospital.name = name!
                hospital.lat = lat!
                hospital.lng = lng!
                
                try! realm.write {
                    realm.add(hospital)
                }
            }
            
            hospitals = realm.objects(Hospital)
        }
        
        print("count = \(hospitals.count)")
    }
    
    //MARK: mapview delegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
//            pinView!.pinTintColor = UIColor.purpleColor()
//            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    var locationUpdated = false
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if locationUpdated == false {
            
            //创建一个MKCoordinateSpan对象，设置地图的范围（越小越精确）
            let latDelta = 0.5
            let longDelta = 0.5
            let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            
            //定义地图区域和中心坐标（
            //使用自定义位置
            let center:CLLocation = userLocation.location!
            let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate,
                                                                      span: currentLocationSpan)
            
            //设置显示区域
            mapView.setRegion(currentRegion, animated: true)
            locationUpdated = true
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "search" {
            let vc = segue.destinationViewController as! HospitalTableViewController
            vc.hospitals = hospitals
        }
    }
    

}

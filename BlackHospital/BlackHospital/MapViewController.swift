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

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let realm = try! Realm()
        
        var hospitals = realm.objects(Hospital)
        print("count = \(hospitals.count)")
        if hospitals.count == 0 {
            let path = NSBundle.mainBundle().pathForResource("hospital", ofType: "geojson")
            let data = NSFileManager.defaultManager().contentsAtPath(path!)
            //        let dic: NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! NSDictionary
            var dic: NSDictionary?
            do {
                try dic =  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            } catch _ as NSError? {
                
            }
            
            let json = JSON(dic!)
            //        let dic = NSDictionary(contentsOfURL: NSURL(fileURLWithPath: path!))
            
            
            print(json)
            
            let array = json["features"]
            for hos in array.array! {
                let name = hos["properties"]["name"].string
                let lng = hos["geometry"]["coordinates"][0].float
                let lat = hos["geometry"]["coordinates"][1].float
                
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

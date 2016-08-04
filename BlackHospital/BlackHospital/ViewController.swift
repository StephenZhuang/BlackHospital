//
//  ViewController.swift
//  BlackHospital
//
//  Created by Stephen Zhuang on 16/7/22.
//  Copyright © 2016年 StephenZhuang. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        
//        var config = Realm.Configuration()
//        config.fileURL = config.fileURL!.URLByDeletingLastPathComponent?.URLByAppendingPathComponent("BlackHospital.realm")
//        Realm.Configuration.defaultConfiguration = config
        
        let realm = try! Realm()
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


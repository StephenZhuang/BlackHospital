//
//  Hospital.swift
//  BlackHospital
//
//  Created by Stephen Zhuang on 16/7/29.
//  Copyright © 2016年 StephenZhuang. All rights reserved.
//

import Foundation
import RealmSwift

class Hospital: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var name: String = ""
    dynamic var lat: Double = 0
    dynamic var lng: Double = 0
    
    internal func shareToWeixin() {
        
    }
}

//
//  Night.swift
//  FadedNights
//
//  Created by Jonathan Youssef on 10/28/15.
//  Copyright © 2015 cs4720. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Night : NSObject, NSCoding {
    
    // MARK: Properties
    var title:String?
    var desc:String?
    var photo:UIImage?
    var date:String?
    var loc:String?
    var drinks:Int?
    var money:Double?
    var bac:Double?
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("nights")
    
    // MARK: Types
    struct PropertyKey {
        static let titleKey = "title"
        static let photoKey = "photo"
        static let descKey = "desc"
        static let dateKey = "date"
        static let locKey = "loc"
        static let drinksKey = "drinks"
        static let moneyKey = "money"
        static let bac = "bac"
    }
    
    // MARK: Initialization
    init?(title: String, photo: UIImage?, desc: String, date: String, loc: String, drinks: Int, money: Double, bac: Double) {
        // Initialize stored properties.
        self.title = title
        self.photo = photo
        self.desc = desc
        self.date = date
        self.loc = loc
        self.drinks = drinks
        self.money = money
        self.bac = bac
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if title.isEmpty {
            return nil
        }
    }
    
    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        
        let desc = aDecoder.decodeObjectForKey(PropertyKey.descKey) as? String
        
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as? String
        
        let loc = aDecoder.decodeObjectForKey(PropertyKey.locKey) as? String
        
        let drinks = aDecoder.decodeIntegerForKey(PropertyKey.drinksKey)
        
        let money = aDecoder.decodeDoubleForKey(PropertyKey.moneyKey)
        
        let bac = aDecoder.decodeDoubleForKey(PropertyKey.bac)
        
        // Must call designated initializer.
        self.init(title: title, photo: photo, desc: desc!, date: date!, loc: loc!, drinks: drinks, money: money, bac: bac)
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeObject(desc, forKey: PropertyKey.descKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(loc, forKey: PropertyKey.locKey)
        aCoder.encodeInteger(drinks!, forKey: PropertyKey.drinksKey)
        aCoder.encodeDouble(money!, forKey: PropertyKey.moneyKey)
        aCoder.encodeDouble(bac!, forKey: PropertyKey.bac)
        
    }
    
}

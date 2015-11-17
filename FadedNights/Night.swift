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
    }
    
    // MARK: Initialization
    init?(title: String, photo: UIImage?, desc: String, date: String, loc: String) {
        // Initialize stored properties.
        self.title = title
        self.photo = photo
        self.desc = desc
        self.date = date
        self.loc = loc
        
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
        
        // Must call designated initializer.
        self.init(title: title, photo: photo, desc: desc!, date: date!, loc: loc!)
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeObject(desc, forKey: PropertyKey.descKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(loc, forKey: PropertyKey.locKey)
        
    }
    
}

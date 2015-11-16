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
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("nights")
    
    // MARK: Types
    struct PropertyKey {
        static let titleKey = "title"
        static let photoKey = "photo"
        static let descKey = "desc"
    }
    
//     MARK: Initialization
    init?(title: String, photo: UIImage?, desc: String) {
        // Initialize stored properties.
        self.title = title
        self.photo = photo
        self.desc = desc
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if title.isEmpty {
            return nil
        }
    }
    
    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
//        self.init()
//        if let title = aDecoder.decodeObjectForKey("title") as? String {
//            self.title = title
//        }
//        if let desc = aDecoder.decodeObjectForKey("desc") as? String {
//            self.desc = desc
//        }
//        if let photo = aDecoder.decodeObjectForKey("photo") as? UIImage {
//            self.photo = photo
//        }
        
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        
        let desc = aDecoder.decodeObjectForKey(PropertyKey.descKey) as? String
        
//         Must call designated initializer.
        self.init(title: title, photo: photo, desc: desc!)
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
//        if let title = self.title {
//            aCoder.encodeObject(title, forKey: "title")
//        }
//        if let desc = self.desc {
//            aCoder.encodeObject(desc, forKey: "desc")
//        }
//        if let photo = self.photo {
//            aCoder.encodeObject(photo, forKey: "photo")
//        }
        
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeObject(desc, forKey: PropertyKey.descKey)
        
    }
    
}

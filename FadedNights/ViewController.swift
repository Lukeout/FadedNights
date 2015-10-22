//
//  ViewController.swift
//  FadedNights
//
//  Created by Luke Kim on 10/19/15.
//  Copyright © 2015 cs4720. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var UserInput: UITextField!
    @IBOutlet weak var Display: UILabel!
    let notificationName = "LastNightStory"
    
   
    @IBAction func DisplayInput(sender: AnyObject) {
        
        // displays text
        Display.text = UserInput.text;
        
        // Send a localNotification of our just inputted text 
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
        localNotification.alertBody = UserInput.text;
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        
       /** let notification = NSNotification(name: notificationName,
            object: self,
            userInfo: [
                "Key1" : "HelloWorld",
                "Key2" : 2]
        )
        
        NSNotificationCenter.defaultCenter().postNotification(notification) **/
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


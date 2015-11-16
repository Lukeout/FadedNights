//
//  ViewController.swift
//  FadedNights
//
//  Created by Luke Kim on 10/19/15.
//  Copyright © 2015 cs4720. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    @IBOutlet weak var Header: UILabel!
    
    @IBOutlet weak var nightTitle: UITextField!
 
    @IBOutlet weak var curloc: UILabel!
    @IBOutlet weak var curloc2: UILabel!
    
    
    @IBOutlet weak var createdNightTitle: UILabel!
    var newTitle:String? = ""
    
    @IBOutlet weak var createdNightDesc: UITextView!
    var newDesc:String? = ""
    
    @IBOutlet weak var createdNightPic: UIImageView!
    var newPic:UIImage!
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count == 0{
            //handle error here
            return
        }
        
        let newLocation = locations[0]
        
        print("Latitude = \(newLocation.coordinate.latitude)")
        print("Longitude = \(newLocation.coordinate.longitude)")
        curloc.text = String(newLocation.coordinate.latitude)
        curloc2.text = String(newLocation.coordinate.longitude)
        
    }
    
    func locationManager(manager: CLLocationManager,
        didFailWithError error: NSError){
            print("Location manager failed with error = \(error)")
    }
    
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus){
            
            print("The authorization status of location services is changed to: ", terminator: "")
            
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                print("Authorized")
            case .AuthorizedWhenInUse:
                print("Authorized when in use")
            case .Denied:
                print("Denied")
            case .NotDetermined:
                print("Not determined")
            case .Restricted:
                print("Restricted")
            }
            
    }
    
    func createLocationManager(startImmediately startImmediately: Bool){
        locationManager = CLLocationManager()
        if let manager = locationManager{
            print("Successfully created the location manager")
            manager.delegate = self
            if startImmediately{
                manager.startUpdatingLocation()
            }
        }
    }
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    // keyboard disappears upon hitting enter
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // needed so keyboard disappears when tapping elsewhere
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* Are location services available on this device? */
        if CLLocationManager.locationServicesEnabled(){
            
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                /* Yes, always */
                createLocationManager(startImmediately: true)
            case .AuthorizedWhenInUse:
                /* Yes, only when our app is in use */
                createLocationManager(startImmediately: true)
            case .Denied:
                /* No */
                displayAlertWithTitle("Not Determined",
                    message: "Location services are not allowed for this app")
            case .NotDetermined:
                /* We don't know yet, we have to ask */
                createLocationManager(startImmediately: false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .Restricted:
                /* Restrictions have been applied, we have no access
                to location services */
                displayAlertWithTitle("Restricted",
                    message: "Location services are not allowed for this app")
            }
            
            
        } else {
            /* Location services are not enabled.
            Take appropriate action: for instance, prompt the
            user to enable the location services */
            print("Location services are not enabled")
        }
        
        // needed so keyboard disappears upon hitting enter
        self.nightTitle.delegate = self
        
        // needed so keyboard disappears when tapping elsewhere
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        if ((self.newPic) != nil) {
            //createdNightPic.image = newPic
            let album = CustomAlbum()
            album.saveImage(newPic)
        }
        
        
        
        
        // setting values through local data - MS3
        let defaults = NSUserDefaults.standardUserDefaults()
        // loop through all saved keys
        for night in defaults.dictionaryRepresentation().keys {
           
            if let data = defaults.objectForKey("night") as? NSData {
                let unarc = NSKeyedUnarchiver(forReadingWithData: data)
                let newNight = unarc.decodeObjectForKey("root") as! Night
                
                createdNightTitle.text = newNight.title
                //print(newNight.title)
                if newNight.desc != "Enter a description" {
                    createdNightDesc.text = newNight.desc
                } else {
                    createdNightDesc.text = "No description"
                }
                
                createdNightDesc.editable = false

                createdNightPic.image = newNight.photo
//                if ((self.newPic) != nil) {
//                    CustomAlbum.sharedInstance.saveImage(newNight.photo!)
//                }
                
            }
            
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "toNewNight" {
            let newNightController = segue.destinationViewController as! NewNightController
            //newNightController.status = nightTitle.text;
        }
    // Pass the selected object to the new view controller.
    }
    

}


//
//  NewNightController.swift
//  FadedNights
//
//  Created by Jonathan Youssef on 10/28/15.
//  Copyright © 2015 cs4720. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import MapKit
import OAuthSwift

class NewNightController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var nightNameLabel: UITextField!

    @IBOutlet weak var Description: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var night: Night?
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var rest1: UILabel!
    @IBOutlet weak var rest2: UILabel!
    
    var apiClient = YelpAPIClient()
    

    // AUTHENTICATION
    
    
    @IBOutlet var imageView: UIImageView!
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    var image:UIImage?
    
    var imagePicker: UIImagePickerController!
    @IBAction func takePhoto(sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
        let text = nightNameLabel.text ?? ""
        saveButton.enabled = !text.isEmpty
        
    }
    
    // LOCATION GPS IMPLEMENTATION 
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count == 0{
            //handle error here
            return
        }
        
        let newLocation = locations[0]
        
        print("Latitude = \(newLocation.coordinate.latitude)")
        print("Longitude = \(newLocation.coordinate.longitude)")
        
        let geoCoder = CLGeocoder()
        let ourLocation = CLLocation(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(ourLocation, completionHandler: { (placemarks, error) -> Void in
            let placeArray = placemarks! as [CLPlacemark]
            
            var placeMark: CLPlacemark
            placeMark = placeArray[0]
            
            print(placeMark.addressDictionary)
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                print(street)
                if let city = placeMark.addressDictionary!["ZIP"] as? NSString {
                    print(city)
                    
                    //var parameters = ["ll": "37.788022,-122.399797", "category_filter": "burgers", "radius_filter": "3000", "sort": "0"]
                    
                    var parameters2 = ["location": String(city), "category_filter": "bars", "sort": "0"]
                    
                    self.apiClient.searchPlacesWithParameters(parameters2, successSearch: { (data, response) -> Void in
                        print(NSString(data: data, encoding: NSUTF8StringEncoding))
                        
                        var names = [String]()
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                            
                            if let businesses = json["businesses"] as? [[String: AnyObject]] {
                                for business in businesses {
                                    if let name = business["name"] as? String {
                                        names.append(name)
                                    }
                                }
                            }
                           
                        }
                        catch {
                            print("error serializing JSON: \(error)")
                        }
                        
                        print(names)
                        
                        
                        self.rest1.text = String(names[0])
                        self.rest2.text = String(names[1])
                        
                        }, failureSearch: { (error) -> Void in
                            print(error)
                    })
                    
                    let loc = String(street) + ", " + String(city)
                    self.location.text = String(loc)
                 }
            }
        })
        
        //location.text = String(newLocation.coordinate.latitude)
        //curloc2.text = String(newLocation.coordinate.longitude)
        
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
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
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
    
    // END GPS IMPLEMENTATION
    
    
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

        // Do any additional setup after loading the view.
        
        // DATE IMEPLEMENTATION 
        date.text = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        // END DATE IMPLEMENTATION
        
        // LOCATION GPS IMPLEMENTATION
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
        // END GPS IMPLEMENTATION
        
        // needed so keyboard disappears upon hitting enter
        self.nightNameLabel.delegate = self
        
        
        
        // enable the save button only if the text field has a valid Meal name.
        checkValidNightName()
        
        // needed so keyboard disappears when tapping elsewhere
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        Description.delegate = self //Without setting the delegate you won't be able to track UITextView events
        
        // setting Description border
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        Description.layer.borderWidth = 0.5
        Description.layer.borderColor = borderColor.CGColor
        Description.layer.cornerRadius = 5.0
        
        // sets up views if editing an existing meal
        if let night = night {
            navigationItem.title = night.title
            nightNameLabel.text = night.title
            if (night.desc! == "" || night.desc! == "Enter a description") {
                Description.text = "Enter a description"
                Description.textColor = UIColor.lightGrayColor()
            } else {
                Description.text = night.desc
            }
            imageView.image = night.photo
            date.text = night.date
            location.text = night.loc
        } else {
            Description.text = "Enter a description"
            Description.textColor = UIColor.lightGrayColor()
        }
    }
    
    // make description box have default text if empty
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter a description"
            textView.textColor = UIColor.lightGrayColor()
        }
        //saveButton.enabled = true
        let text = nightNameLabel.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    
    // for title
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidNightName() {
        // Disable the Save button if the text field is empty.
        let text = nightNameLabel.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidNightName()
        navigationItem.title = textField.text
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddNightMode = presentingViewController is UINavigationController
        if isPresentingInAddNightMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if saveButton === sender {
            
            // send picture through segue so it can be saved to album in next scene
            // this scene needs to finish rendering before the photo can be saved to album
            let viewController = segue.destinationViewController as! NightTableViewController
            viewController.newPic = imageView.image
            
            
            let title = nightNameLabel.text
            let desc = Description.text
            let photo = imageView.image
            
            var dateN: String?
            if let date2 = date.text {
                dateN = date2
            }
            
            var locN: String?
            if let loc = location.text {
                locN = loc
            }
            night = Night(title: title!, photo: photo, desc: desc, date: dateN!, loc: locN!)

            
        }
        
    }


}

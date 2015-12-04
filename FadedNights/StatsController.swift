//
//  StatsController.swift
//  FadedNights
//
//  Created by Jonathan Youssef on 12/4/15.
//  Copyright © 2015 cs4720. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import MapKit
import OAuthSwift

class StatsController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var bacLabel: UILabel!
    
    @IBOutlet weak var nightlyDrinks: UILabel!
    @IBOutlet weak var nightlyMoney: UILabel!
    
    
    @IBOutlet weak var totalDrinks: UILabel!
    @IBOutlet weak var numNights: UILabel!
    @IBOutlet weak var totalMoney: UILabel!
    
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
        
        self.weight.delegate = self
        weight.keyboardType = UIKeyboardType.NumberPad
        
        // needed so keyboard disappears when tapping elsewhere
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let defaults = NSUserDefaults.standardUserDefaults()
 
        if let s = defaults.stringForKey("nightlyDrinks") {
            nightlyDrinks.text = s
        }
        if let s = defaults.stringForKey("totalDrinks") {
            totalDrinks.text = s
        }
        if let s = defaults.stringForKey("numNights") {
            numNights.text = s
        }
        if let s = defaults.stringForKey("totalMoney") {
            totalMoney.text = "$" + s

        }
        if let s = defaults.stringForKey("nightlyMoney") {
            nightlyMoney.text = "$" + s
        }
        if let s = defaults.stringForKey("weight") {
            weight.text = String(Int(s)! / 454)
        }
        if let s = defaults.stringForKey("nightlyBac") {
            bacLabel.text = String(s)
        }
        
        
        
        if nightlyDrinks.text == "nan" {
            nightlyDrinks.text = "0"
        }
        if totalMoney.text == "$-0.00" {
            totalMoney.text = "$0.00"
        }
        if nightlyMoney.text == "$-0.00" {
            nightlyMoney.text = "$0.00"
        }
        if totalMoney.text == "$nan" {
            totalMoney.text = "$0.00"
        }
        if nightlyMoney.text == "$nan" {
            nightlyMoney.text = "$0.00"
        }

    }
    
    func textFieldDidEndEditing(textField: UITextField) {

        if textField.text != "" {
            let defaults = NSUserDefaults.standardUserDefaults()
            let weightG = Int(weight.text!)! * 454
            defaults.setValue(String(weightG), forKey: "weight")
            defaults.synchronize()
        } else {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(0, forKey: "weight")
            defaults.synchronize()
        }
        
    }
    
}

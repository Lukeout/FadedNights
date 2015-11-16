//
//  NewNightController.swift
//  FadedNights
//
//  Created by Jonathan Youssef on 10/28/15.
//  Copyright © 2015 cs4720. All rights reserved.
//

import UIKit
import AVFoundation

class NewNightController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nightNameLabel: UITextField!

    @IBOutlet weak var Description: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var night: Night?
    
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

        // Do any additional setup after loading the view.
        
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
        saveButton.enabled = true
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
            
            // Saving data locally - MS3
            //let defaults = NSUserDefaults.standardUserDefaults()
            
            let title = nightNameLabel.text
            let desc = Description.text
            let photo = imageView.image
            night = Night(title: title!, photo: photo, desc: desc)
            
            
            //defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(newNight), forKey: newNight.title!)
            //defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(night!), forKey: "night")
            
        }
        
    }


}

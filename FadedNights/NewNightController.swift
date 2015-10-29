//
//  NewNightController.swift
//  FadedNights
//
//  Created by Jonathan Youssef on 10/28/15.
//  Copyright © 2015 cs4720. All rights reserved.
//

import UIKit
import AVFoundation

class NewNightController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
    
    // set through segue from ViewController
    @IBOutlet weak var nightNameLabel: UILabel!
    var status:String? = ""
    
    
    
    @IBOutlet weak var Description: UITextView!
    
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
    
 
    // needed so keyboard disappears when tapping elsewhere
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set label to var status
        nightNameLabel.text = status
        
        // needed so keyboard disappears when tapping elsewhere
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        Description.delegate = self //Without setting the delegate you won't be able to track UITextView events
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        Description.layer.borderWidth = 0.5
        Description.layer.borderColor = borderColor.CGColor
        Description.layer.cornerRadius = 5.0
        
        Description.text = "Enter a description"
        Description.textColor = UIColor.lightGrayColor()
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter a description"
            textView.textColor = UIColor.lightGrayColor()
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
        
        if segue.identifier == "toMain" {
            let viewController = segue.destinationViewController as! ViewController
            viewController.newTitle = nightNameLabel.text
            viewController.newDesc = Description.text
            viewController.newPic = imageView.image
        }
        
        // Pass the selected object to the new view controller.
        
        // populate new class - unused for this milestone (2)
        //let newNight = Night(name: nightNameLabel.text!, description: Description.text)
    }


}

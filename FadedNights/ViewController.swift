//
//  ViewController.swift
//  FadedNights
//
//  Created by Luke Kim on 10/19/15.
//  Copyright © 2015 cs4720. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var Header: UILabel!
    
    @IBOutlet weak var nightTitle: UITextField!
 
    
    
    @IBOutlet weak var createdNightTitle: UILabel!
    var newTitle:String? = ""
    
    @IBOutlet weak var createdNightDesc: UITextView!
    var newDesc:String? = ""
    
    @IBOutlet weak var createdNightPic: UIImageView!
    var newPic:UIImage!
    
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
        
        if ((self.newPic) != nil) {
            self.createdNightPic.image = newPic
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // needed so keyboard disappears upon hitting enter
        self.nightTitle.delegate = self;
        
        // needed so keyboard disappears when tapping elsewhere
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        createdNightTitle.text = newTitle
        if newDesc != "Enter a description" {
            createdNightDesc.text = newDesc
        } else {
            createdNightDesc.text = ""
        }
        
        createdNightDesc.editable = false
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
            newNightController.status = nightTitle.text;
        }
    // Pass the selected object to the new view controller.
    }
    

}


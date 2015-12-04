//
//  NightTableViewController.swift
//  FadedNights
//
//  Created by Jonathan Youssef on 11/15/15.
//  Copyright © 2015 cs4720. All rights reserved.
//

import UIKit

class NightTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var nights = [Night]()
    var newPic:UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        if let savedNights = loadNights() {
            nights += savedNights
        }
        
        var nightlyDrinks = 0.0
        var numNights = 0
        var totalDrinks = 0
        var nightlyMoney = 0.0
        var totalMoney = 0.0
        var totalBac = 0.0
        var nightlyBac = 0.0
        
        for night in nights {
            totalDrinks += night.drinks!
            totalMoney += night.money!
            totalBac += night.bac!
            numNights++
        }
        
        nightlyDrinks = Double(totalDrinks)/Double(numNights)
        nightlyDrinks = Double(round(100*nightlyDrinks)/100)
        nightlyMoney = totalMoney/Double(numNights)
        nightlyBac = totalBac/Double(numNights)
        //nightlyMoney = Double(round(100*nightlyMoney)/100)
        //totalMoney = Double(round(100*totalMoney)/100)
        
        print(totalMoney)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(String(totalDrinks), forKey: "totalDrinks")
        defaults.setValue(String(nightlyDrinks), forKey: "nightlyDrinks")
        defaults.setValue(String(numNights), forKey: "numNights")
        defaults.setValue(String(format:"%.02f", totalMoney), forKey: "totalMoney")
        defaults.setValue(String(format:"%.02f", nightlyMoney), forKey: "nightlyMoney")
        defaults.setValue(String(format:"%.03f", nightlyBac), forKey: "nightlyBac")
        defaults.synchronize()
        
        
        if ((self.newPic) != nil) {
            //createdNightPic.image = newPic
            let album = CustomAlbum()
            album.saveImage(newPic)
        }
 
    }
    
    /*
    func loadSampleNights() {
        let photo1 = UIImage(named: "night1")!
        let night1 = Night(title: "night 1", photo: photo1, desc: "sample desc")!
//        let night1 = Night()
//        night1.photo = photo1
//        night1.title = "night 1"
//        night1.desc = "sample desc"
        nights += [night1]
        
    } */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nights.count    }

    // this allows table to only ask for the cells for rows that are currently on screen
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "NightTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NightTableViewCell
        
        // fetches the appropriate night for the data source layout
        let night = nights[indexPath.row]

        // setting cell data from appropriate night
        cell.nameLabel.text = night.title
        cell.photoImageView.image = night.photo
        cell.locLabel.text = night.loc
        cell.dateLabel.text = night.date

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            nights.removeAtIndex(indexPath.row)
            
            var nightlyDrinks = 0.0
            var numNights = 0
            var totalDrinks = 0
            var nightlyMoney = 0.0
            var totalMoney = 0.0
            var totalBac = 0.0
            var nightlyBac = 0.0
            
            for night in nights {
                totalDrinks += night.drinks!
                totalMoney += night.money!
                totalBac += night.bac!
                numNights++
            }
            
            nightlyDrinks = Double(totalDrinks)/Double(numNights)
            nightlyDrinks = Double(round(100*nightlyDrinks)/100)
            nightlyMoney = totalMoney/Double(numNights)
            nightlyBac = totalBac/Double(numNights)
            //nightlyMoney = Double(round(100*nightlyMoney)/100)
            //totalMoney = Double(round(100*totalMoney)/100)
            
            print(totalMoney)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setValue(String(totalDrinks), forKey: "totalDrinks")
            defaults.setValue(String(nightlyDrinks), forKey: "nightlyDrinks")
            defaults.setValue(String(numNights), forKey: "numNights")
            defaults.setValue(String(format:"%.02f", totalMoney), forKey: "totalMoney")
            defaults.setValue(String(format:"%.02f", nightlyMoney), forKey: "nightlyMoney")
            defaults.setValue(String(format:"%.03f", nightlyBac), forKey: "nightlyBac")
            defaults.synchronize()
            
            saveNights()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            
            let nightDetailViewController = segue.destinationViewController as! NewNightController
            
            // Get the cell that generated this segue.
            if let selectedNightCell = sender as? NightTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedNightCell)!
                let selectedNight = nights[indexPath.row]
                nightDetailViewController.night = selectedNight
            }
        }
            
        else if segue.identifier == "AddItem" {
            print("Adding new night.")
        }
    }

    @IBAction func unwindToNightList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? NewNightController, night = sourceViewController.night {
            
            // checks if row was selected - night is being edited. Update night
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                nights[selectedIndexPath.row] = night
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            
            // add a new night
            else {
                let newIndexPath = NSIndexPath(forRow: nights.count, inSection: 0)
                nights.append(night)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            var nightlyDrinks = 0.0
            var numNights = 0
            var totalDrinks = 0
            var nightlyMoney = 0.0
            var totalMoney = 0.0
            var totalBac = 0.0
            var nightlyBac = 0.0
            
            for night in nights {
                totalDrinks += night.drinks!
                totalMoney += night.money!
                totalBac += night.bac!
                numNights++
            }
            
            nightlyDrinks = Double(totalDrinks)/Double(numNights)
            nightlyDrinks = Double(round(100*nightlyDrinks)/100)
            nightlyMoney = totalMoney/Double(numNights)
            nightlyBac = totalBac/Double(numNights)
            //nightlyMoney = Double(round(100*nightlyMoney)/100)
            //totalMoney = Double(round(100*totalMoney)/100)
            
            print(totalMoney)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setValue(String(totalDrinks), forKey: "totalDrinks")
            defaults.setValue(String(nightlyDrinks), forKey: "nightlyDrinks")
            defaults.setValue(String(numNights), forKey: "numNights")
            defaults.setValue(String(format:"%.02f", totalMoney), forKey: "totalMoney")
            defaults.setValue(String(format:"%.02f", nightlyMoney), forKey: "nightlyMoney")
            defaults.setValue(String(format:"%.03f", nightlyBac), forKey: "nightlyBac")
            defaults.synchronize()
            
            saveNights()
        }
    }
    
    
    // MARK: NSCoding
    
    func saveNights() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(nights, toFile: Night.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save nights...")
        }
    }
    
    func loadNights() -> [Night]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Night.ArchiveURL.path!) as? [Night]
    }
    

}

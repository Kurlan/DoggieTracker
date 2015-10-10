//
//  DogTableViewController.swift
//  DoggieTracker
//
//  Created by STEVE HUYNH on 10/9/15.
//  Copyright © 2015 SLH. All rights reserved.
//

import UIKit

class DogTableViewController: UITableViewController {
    
    // MARK: Properties
    var dogs = [Dog]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem()
        if let savedDogs = loadDogs(){
            dogs += savedDogs
        } else {
            loadSampleDogs()
        }
    }
    
    func loadSampleDogs() {
        let photo1 = UIImage(named: "bogey1")!
        let dog1 = Dog(name: "Photo 1", photo: photo1, rating: 4)!
        
        let photo2 = UIImage(named: "bogey2")!
        let dog2 = Dog(name: "Photo 2", photo: photo2, rating: 5)!
        
        let photo3 = UIImage(named: "bogey3")!
        let dog3 = Dog(name: "Photo 3", photo: photo3, rating: 3)!
        
        dogs += [dog1, dog2, dog3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dogs.count
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "DogTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DogTableViewCell
        
        let dog = dogs[indexPath.row]
        
        cell.nameLabel.text = dog.name
        cell.photoImageView.image = dog.photo
        cell.ratingControl.rating = dog.rating

        return cell
    }
    
    
    @IBAction func unwindToDogList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? DogViewController, dog = sourceViewController.dog {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                dogs[selectedIndexPath.row] = dog
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                let newIndexPath = NSIndexPath(forRow: dogs.count, inSection:0)
                dogs.append(dog)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            saveDogs()
        }
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
            dogs.removeAtIndex(indexPath.row)
            saveDogs()
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
            let dogDetailViewController = segue.destinationViewController as! DogViewController
            if let selectedDogCell = sender as? DogTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedDogCell)!
                let selectedDog = dogs[indexPath.row]
                dogDetailViewController.dog = selectedDog
            }
        } else if segue.identifier == "AddItem" {
            print("Adding new dog.")
        }
    }
    
    // MARK: NSCoding
    
    func saveDogs() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dogs, toFile: Dog.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save dogs")
        }
    }
    
    func loadDogs() -> [Dog]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Dog.ArchiveURL.path!) as? [Dog]
    }
    
}

//
//  DogTableViewController.swift
//  DoggieTracker
//
//  Created by STEVE HUYNH on 10/9/15.
//  Copyright © 2015 SLH. All rights reserved.
//

import UIKit
import Alamofire

class DogTableViewController: UITableViewController {
    
    // MARK: Properties
    var dogs = [Dog]()
    let dogHelper = DogHelper()
    let user = User()
    var imageCache = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        loadDogs()
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

    func loadDogs() {
        let url = Config.baseURL + "/party/byUser/" + user.userId
        
        Alamofire.request(.GET, url).validate().responseJSON {response in
            
            if let JSON = response.result.value as? [AnyObject] {
                let newDogs = self.dogHelper.parseDog(JSON)
                self.dogs += newDogs
                for newDog in newDogs {
                    if let photoURL = newDog.photoURL {
                        Alamofire.request(.GET, photoURL).response() {
                            (_, _, data, _) in

                            newDog.photo  = UIImage(data: data!)
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                            return
                        })
                    }
                }
                print("JSON: \(JSON)")
            }
        }

    }
    
}

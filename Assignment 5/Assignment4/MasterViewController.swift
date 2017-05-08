//
//  MasterViewController.swift
//  Assignment4
//
//  Created by Darshan Patil on 11/2/16.
//  Copyright © 2016 Darshan Patil. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask { return .All                  //portrait upside down
    }

    let searchController = UISearchController(searchResultsController: nil)                                     // search controller variable
    var detailViewController: DetailViewController? = nil                                                       // object of detailviewcontroller
    var objects = [USPresidents]()                                                                              // object of USpresident class
    var filteredObjects = [USPresidents]()                                                                      // another object of USpresident class

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        readPropertyList()                                                                                      // calling a method to read data from url
        
        searchController.searchResultsUpdater = self                                                            // implementation for search bar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.delegate = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["All", "Democrat", "Republican", "Libertarian", "Whig"]
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        ImageProvider.sharedInstance.clearCache()                                                               // clearing cache of shared Instance
        // Dispose of any resources that can be recreated.
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {                                // filtering the content for searchbar
        filteredObjects = objects.filter { character in
            let categoryMatch = (scope == "All") || (character.politicalParty == scope)
            return categoryMatch && character.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()                                                                                  // reloading the table view
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {                               // segue for showing detail of president
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.navigationItem.title = object.name
            }
        }
    }
    
    func readPropertyList() {                                                                                   // method to fetch data from URL
        let session = NSURLSession.sharedSession()
        guard let url = NSURL(string: "https://www.prismnet.com/~mcmahon/CS321/presidents.json") else {
            // Perform some error handling
            showAlert("Invalid URL for JSON data")
            return
        }
        
        weak var weakSelf = self
        
        let task = session.dataTaskWithURL(url) {
            (data, response, error) in
            // The response is a NSHTTPURLResponse, so the app should check for unexpected // status codes
            let httpResponse = response as? NSHTTPURLResponse
            
            if httpResponse!.statusCode != 200 {                                                                // check for response from url
                weakSelf!.showAlert("HTTP Error: status Code \(httpResponse!.statusCode).")                     // error if http error
            } else if (data == nil && error != nil) {
                weakSelf!.showAlert("No data downloaded.")                                                      // error if no data
            } else {
                let array: [AnyObject]
                
                do {
                    array = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [AnyObject]
                } catch _ {
                    weakSelf!.showAlert("Unable to parse JSON data.")
                    return
                }
                
                for dictionary in array {                                                                       // create dictionary for storing data from url
                    let name = dictionary["Name"] as! String
                    let number = dictionary["Number"] as! Int
                    let startDate = dictionary["Start Date"] as! String
                    let endDate = dictionary["End Date"] as! String
                    let nickname = dictionary["Nickname"] as! String
                    let politicalParty = dictionary["Political Party"] as! String
                    let url = dictionary["URL"] as! String
                
                weakSelf!.objects.append(USPresidents(name: name, number: number, startDate: startDate, endDate: endDate, nickname: nickname, politicalParty: politicalParty, url: url))
                }
                
                weakSelf!.objects.sortInPlace {                                                                 // sorting the list
                    return $0.number < $1.number
                }
                
                dispatch_async(dispatch_get_main_queue()){
                    weakSelf!.tableView!.reloadData()
                }
            }
        }
        task.resume()
            
    }
    
    func showAlert(message: String) {                                                                                       // alert controller to display alerts
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredObjects.count
        }
        
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {          // assiging data to the master view
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! USPresidentsCell
        
        let character: USPresidents
        if searchController.active && searchController.searchBar.text != "" {
            character = filteredObjects[indexPath.row]
        } else {
            character = objects[indexPath.row]
        }
        
        ImageProvider.sharedInstance.imageWithURLString(character.url){
            (image) in
            cell.presidentImageView.image = image
        }
        cell.presidentNameLabel!.text = character.name
        cell.partyLabel!.text = character.politicalParty
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    // MARK: UISearchResultsUpdating methods
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    // MARK: UISearchBarDelegate methods
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    @IBAction func unwindToSave(segue: UIStoryboardSegue) {                                                                 // segue to save the add president form
        print("Save")
        if let addPresidentViewController = segue.sourceViewController as? AddPresidentViewController {
            if let character = addPresidentViewController.character {
                
                var index = objects.indexOf({
                    $0.number > character.number
                })
                
                if index == 0 {
                    index = objects.count
                    character.number = index!+1
                }
                
                objects.insert(character, atIndex: index!)
                
                let indexPath = NSIndexPath(forRow: index!, inSection: 0)
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
    }
    
    @IBAction func unwindToCancel(segue: UIStoryboardSegue) {                                                               // segue to cancel

    }

}


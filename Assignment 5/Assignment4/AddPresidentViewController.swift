//
//  AddCharacterViewController.swift
//  MCU
//
//  Created by Kurt McMahon on 10/16/16.
//  Copyright © 2016 Northern Illinois University. All rights reserved.
//

import UIKit

class AddPresidentViewController: UITableViewController, UITextFieldDelegate {

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask { return .All              // func to support portrait upside down
    }
    // MARK: Properties
    
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    var startDate = NSDate()
    var errorMessage = ""
    var character: USPresidents?
    
    // MARK: Outlets
    
    @IBOutlet weak var presidentName: UITextField!
    @IBOutlet weak var presidentNickName: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var partySegmentedControl: UISegmentedControl!
    
    
    var politicalParty = ""
    // MARK: UIViewController methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPickerView()
        self.presidentName.delegate = self
        self.presidentNickName.delegate = self
        segmentedControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segmentedControl() {                                                                           // assign segment control to a variable
        if partySegmentedControl.selectedSegmentIndex == 0 {
            politicalParty = "Democrat"
        }
        if partySegmentedControl.selectedSegmentIndex == 1 {
            politicalParty = "Republican"
        }
        if partySegmentedControl.selectedSegmentIndex == 2 {
            politicalParty = "Libertarian"
        }
        if partySegmentedControl.selectedSegmentIndex == 3 {
            politicalParty = "Green"
        }
        
    }
    
//    extension NSDate: Comparable { }
//
//    public func == (lhs: NSDate, rhs: NSDate) -> Bool {
//    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
//    }
//    
//    public func < (lhs: NSDate, rhs: NSDate) -> Bool {
//    return lhs.compare(rhs) == .OrderedAscending
//    }
    
    func setUpPickerView() {                                                                                // setting up picker view for start and end date and its UI
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        let doneButton = UIBarButtonItem(title: "Select", style: UIBarButtonItemStyle.Done, target: self, action: #selector(selectStartDate))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([space, doneButton, space], animated: false)
        
        startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = .Date
        startDatePicker.addTarget(self, action: #selector(startDateChanged),forControlEvents: .ValueChanged)
        
        endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = .Date
        endDatePicker.addTarget(self, action: #selector(endDateChanged),forControlEvents: .ValueChanged)
        
        startDateTextField.inputView = startDatePicker
        startDateTextField.inputAccessoryView = toolBar
        
        endDateTextField.inputView = endDatePicker
        endDateTextField.inputAccessoryView = toolBar

    }
    
    func selectStartDate() {                                                                                // select button funciton
        if startDatePicker.date == endDatePicker.date {
            errorMessage = "start and end dates cannot be same"
            alert(errorMessage)
        }else {
            startDate = startDatePicker.date
            startDateTextField.resignFirstResponder()
            endDateTextField.resignFirstResponder()
            endDatePicker.minimumDate = startDatePicker.date
        }
    }
    
    func startDateChanged() {                                                                               // formatting the selected start date
        let df = NSDateFormatter()
        df.dateStyle = NSDateFormatterStyle.MediumStyle
        df.timeStyle = NSDateFormatterStyle.NoStyle
        startDateTextField.text = df.stringFromDate(startDatePicker.date)
    }
    
    func endDateChanged() {                                                                                 // formatting the end date selected
        let df = NSDateFormatter()
        df.dateStyle = NSDateFormatterStyle.MediumStyle
        df.timeStyle = NSDateFormatterStyle.NoStyle
        if startDatePicker.date == endDatePicker.date {
            errorMessage = "start and end dates cannot be same"
            alert(errorMessage)
        }else {
//        if endDatePicker.date < startDatePicker.date {
//            errorMessage = "end dates cannot be smaller then start date"
//            alert(errorMessage)
//        }
            endDateTextField.text = df.stringFromDate(endDatePicker.date)
        }
    }
    
    
    
    // MARK: UITableViewDelegate methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            presidentName.becomeFirstResponder()
        }
        if indexPath.section == 1 {
            presidentNickName.becomeFirstResponder()
        }
        if indexPath.section == 2 {
            startDateTextField.becomeFirstResponder()
        }
        if indexPath.section == 3 {
            endDateTextField.becomeFirstResponder()
        }
        if indexPath.section == 4 {
            partySegmentedControl.becomeFirstResponder()
        }
    }

    // MARK: Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        segmentedControl()
        if segue.identifier == "SavePresident" {
            character = USPresidents(name: presidentName.text!, number: 0, startDate: startDateTextField.text!, endDate: endDateTextField.text!, nickname: presidentNickName.text!, politicalParty: politicalParty, url: "None")
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {                        // check for empty fields in the form, if found throw error
        if identifier == "SavePresident" {
            if presidentName.text!.isEmpty {
                errorMessage = "Please Enter Name of President"
                alert(errorMessage)
                return false
            } else if startDateTextField.text!.isEmpty {
                errorMessage = "Please Enter start date"
                alert(errorMessage)
                return false
            } else if endDateTextField.text!.isEmpty {
                errorMessage = "Please Enter end date"
                alert(errorMessage)
                return false
            } else if politicalParty.isEmpty {
                errorMessage = "Please select a political party"
                alert(errorMessage)
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    func alert(errorMessage: String){                                                                                       // error showing by alert controller
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: UIResponder methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: UITextFieldDelegate methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UIPickerView methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

}

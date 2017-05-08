//
//  DetailViewController.swift
//  Assignment4
//
//  Created by Darshan Patil on 11/2/16.
//  Copyright © 2016 Darshan Patil. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask { return .All
    }
    // properties from view
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var startEndDateLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var politicalpartyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var detailItem: USPresidents? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    //function to assign data to the view
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.nameLabel {                                                                     // name label display
                label.text = detail.name
            }
            if let label = self.numberLabel {
                if (detail.number % 10) == 1 && detail.number != 11{                                            // formatting the view for number
                    label.text = String(detail.number) + "st President of United States"
                } else if (detail.number % 10) == 2 && detail.number != 12 {
                    label.text = String(detail.number) + "nd President of United States"
                } else if (detail.number % 10) == 3 && detail.number != 13{
                    label.text = String(detail.number) + "rd President of United States"
                } else {
                    label.text = String(detail.number) + "th President of United States"
                }
            }
            if let imageView = self.imageView {                                                                 // fetching the image from the url if no image then display default
                ImageProvider.sharedInstance.imageWithURLString(detail.url) {
                    (image) in
                    imageView.image = image
                }
            }
            if let label = self.startEndDateLabel {                                                             // start and end date display
                label.text = "(" + detail.startDate + " to " + detail.endDate + ")"
            }
            if let label = self.nicknameLabel {                                                                 // nickname display
                label.text = detail.nickname
                label.lineBreakMode = .ByWordWrapping
                label.numberOfLines = 0
            }
            if let label = self.politicalpartyLabel {                                                           // political party label display
                label.text = detail.politicalParty
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


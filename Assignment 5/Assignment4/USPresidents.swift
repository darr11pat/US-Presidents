//
//  USPresidents.swift
//  Assignment4
//
//  Created by Darshan Patil on 11/2/16.
//  Copyright © 2016 Darshan Patil. All rights reserved.
//

import Foundation

class USPresidents {                                            // class for presidents
    
    var name = ""                                               // variables to hold data
    var number = 0
    var startDate = ""
    var endDate = ""
    var nickname = ""
    var politicalParty = ""
    var url = ""
    
    //assigning data to local variables from other functions
    init(name: String, number: Int, startDate: String, endDate: String, nickname: String, politicalParty: String, url: String) {
        self.name = name
        self.number = number
        self.startDate = startDate
        self.nickname = nickname
        self.politicalParty = politicalParty
        self.endDate = endDate
        self.url = url
    }

}

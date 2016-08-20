//
//  DeviceMode.swift
//  freezerinventoryscanner
//
//  Created by Sam Kheirandish on 2016-08-19.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

public class DeviceMode {

    enum State {
        case View
        case Archive
        case Defrost
    }
    private(set) var state: State = .View
    
    func setStateOfApp(selectedRow:Int)  {
        switch selectedRow {
        case 0:
            state = .View
        case 1:
            state = .Archive
        case 2:
            state = .Defrost
        default:
            break
        }
    }
}



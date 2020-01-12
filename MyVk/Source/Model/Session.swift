//
//  Session.swift
//  MyVk
//
//  Created by Андрей Закусов on 27.10.2019.
//  Copyright © 2019 Закусов Андрей. All rights reserved.
//

import Foundation

class Session {
    static let instance = Session()
    
    var token: String = ""
    var userID: Int = 0
    
    
    private init() {
        
    }
}

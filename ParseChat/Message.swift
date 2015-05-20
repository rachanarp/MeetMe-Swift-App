//
//  Message.swift
//  ParseChat
//
//  Created by Rachana Bedekar on 5/20/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import Foundation
import UIKit

class Message: NSObject {
    var text: String?
    var user: User?
    var destination: CLLocationCoordinate2D? // Store the group destination in Message so it can be updated on the fly?
}
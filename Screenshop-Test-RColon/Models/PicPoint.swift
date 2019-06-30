//
//  PicPoint.swift
//  Screenshop-Test-RColon
//
//  Created by Rafael Colon on 6/29/19.
//  Copyright © 2019 rafaelColon. All rights reserved.
//

import Foundation

/**
 Struct that models a CGPoint drawn on the main view controler image view.
 - Extends Codable to automate encoding struct representation into JSON.
*/
struct PicPoint: Codable {
    let x_coordinate:Float;
    let y_coordinate:Float;
}

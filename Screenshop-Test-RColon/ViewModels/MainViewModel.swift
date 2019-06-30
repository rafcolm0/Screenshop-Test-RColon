//
//  MainViewModel.swift
//  Screenshop-Test-RColon
//
//  Created by Rafael Colon on 6/29/19.
//  Copyright © 2019 rafaelColon. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

/**
 View Model class for the ViewController class.
 - Handles loading image from the web into the main ViewController UIImageView, modelling drawn CGPoints, and the ViewController's Reset and Done functionality.
 */
class MainViewModel: NSObject {
    static let LINK:String = "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/balenciaga-1538565239.jpg";
    var drawnCoordinates:[PicPoint] = [];
    
    /**
     Loads image from LINK url into the ViewController's main UIImageView.
     - Uses Kingfisher for loading image, initiating process indicators, and handling image loading callbacks.
     - NOTE: This method could have been implemented directly in ViewController but done here for modularization purposes.
     - Parameters:
        - imageView UIImageView to load we image into
        - completion callback handler for Kingfisher result callback
     */
    func loadImage(imageView:UIImageView, completion: @escaping (Bool) -> Void){
        let url = URL(string: MainViewModel.LINK);
        imageView.kf.indicatorType = .activity  //add progress indicator
        imageView.kf.setImage(with: url,
            options: [.scaleFactor(UIScreen.main.scale), .transition(.fade(1)), .cacheOriginalImage]){
                result in
                switch result {
                case .success( _):
                    completion(true);
                case .failure( _):
                    completion(false);
                }
        }
    }
    
    /**
     Appends a new PicPoint model into the main stored array.
     - Parameters:
        - point new CGPoint to be modeled and stored into main drawnCoordinates array
     */
    func modeledAndStoreDrawnCGPoint(point:CGPoint){
        drawnCoordinates.append(PicPoint(x_coordinate: Float(point.x), y_coordinate: Float(point.y)));
    }
    
    /**
     Clears the drawnCoordinates PicPoint array
     */
    func clearModeledPicPoints() -> Void {
        drawnCoordinates.removeAll();
    }
    
    /**
     Generates JSON representation of the drawnCoordinates array, and prints it to the console.
     - Uses JSONEncoder for automating encoding the PicPoint Codable models.
     */
    func generateAndPrintModeledPicPointsJSON(){
        let jsonEncoder = JSONEncoder();
        do{
            let jsonData = try jsonEncoder.encode(drawnCoordinates);
            let json = String(data: jsonData, encoding: String.Encoding.utf16);
            print("DRAWN COORDINATES:\n", json!.utf8CString);
        } catch {
            print("Something went wrong!");
        }
    }
}

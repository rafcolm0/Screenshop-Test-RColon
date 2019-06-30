//
//  ViewController.swift
//  Screenshop-Test-RColon
//
//  Created by Rafael Colon on 6/29/19.
//  Copyright © 2019 rafaelColon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainImageView: UIImageView!
    let viewModel = MainViewModel();  //main view model
    var lastPoint = CGPoint.zero;  //references the last CGPoint drawn in the imageview
    var isSwiped = false;  //determines whether current UIGesture recognizer call is for a point drawn of a full swipe
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage();  //loadimage
    }
    
    /**
     Loads image from the web into mainImageView using View Model method.
    */
    func loadImage(){
        mainImageView.image = nil;
        viewModel.loadImage(imageView: self.mainImageView, completion: { success in
            if(success){  //if success, allow user to draw on top of mainImageView
                self.mainImageView.isUserInteractionEnabled = true;
            } else {  //error, leave mainImageView user interaction disabled, and show message
                let alert = UIAlertController(title: "Alert", message: "Something went wrong. Try again!", preferredStyle: UIAlertController.Style.alert);
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil);
            }
        });
    }
    
    /**
     Draws line from current 'lastPoint' to parameter 'toPoint', and then model and store 'toPoint' using view model.
    */
    func generatePointOnImageViewAndStoreModeledPoint(toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size);
        let context = UIGraphicsGetCurrentContext();
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height));
        context!.move(to: CGPoint.init(x: lastPoint.x, y: lastPoint.y));
        context!.addLine(to: CGPoint.init(x: toPoint.x, y: toPoint.y));
        context!.setLineWidth(10.0);
        context!.setStrokeColor(UIColor.black.cgColor);
        context!.setBlendMode(CGBlendMode.init(rawValue: 1)!);
        context!.strokePath();
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        mainImageView.alpha = 1.0;
        UIGraphicsEndImageContext();
        viewModel.modeledAndStoreDrawnCGPoint(point: toPoint);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSwiped = false;
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSwiped = true;
        if let touch = touches.first {  //validate if touch is first from latest touches
            let currentPoint = touch.location(in: view);
            generatePointOnImageViewAndStoreModeledPoint(toPoint: currentPoint);
            lastPoint = currentPoint;  //overwrite current lastPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!isSwiped) {  //checks if touch is actually last latest touch, and then draw on image
            generatePointOnImageViewAndStoreModeledPoint(toPoint: lastPoint);
        }
    }

    @IBAction func resetBtnClicked(_ sender: Any) {
        resetImageView();
    }
    
    /**
     Clear stored model PicPoint from view model, and reloads mainImageView image.
     - Reload image by calling viewModel method: since KingFisher caches images automatically, no need for doing web call again.
    */
    func resetImageView(){
        viewModel.clearModeledPicPoints();
        loadImage();
    }
    
    @IBAction func doneBtnClicked(_ sender: Any) {
        viewModel.generateAndPrintModeledPicPointsJSON();
        resetImageView();
    }
}

//
//  CanvasViewController.swift
//  canvas
//
//  Created by Whitney Griffith on 10/16/18.
//  Copyright © 2018 Whitney Griffith. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    
    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    @IBOutlet weak var downArrow: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 230
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended {
            

            if velocity.y > 0 {
                UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(rawValue: UInt(0.5)), animations: { () -> Void in

                    self.trayView.center = self.trayDown
                }, completion: nil)
                
                downArrow.transform = downArrow.transform.rotated(by: CGFloat(180 * Double.pi / 180))
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(rawValue: UInt(0.5)), animations: { () -> Void in
                    
                    self.trayView.center = self.trayUp
                }, completion: nil)
                
                downArrow.transform = downArrow.transform.rotated(by: CGFloat(180 * Double.pi / 180))
            }

}
}
    

    @IBAction func moveEmoji(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        if sender.state == .began {
            
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanFaceOnCanvas(sender:)))
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
            
            tapGestureRecognizer.numberOfTapsRequired = 2
            
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(tapGestureRecognizer)
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5,y: 1.5)


        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended {
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1,y: 1)
        }
        
    }
    
    @objc func  didPanFaceOnCanvas(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            newlyCreatedFace = sender.view as? UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center // so we can offset by translation later.
        } else if sender.state == .changed {
            print("Gesture is changing")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("Gesture ended")
        }
        
    }
    
    @objc func didTap(sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        
        imageView.removeFromSuperview()
    }
    
    
}

//
//  SuccessViewController.swift
//  TesterApp
//
//  Created by Jack Rentz on 1/4/17.
//  Copyright © 2017 Boxer Property. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    var isMenuShowing : Bool = false
    
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var subViewOutlet: UIView!
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    @IBAction func goBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SuccessViewController.executeAfterTap))
        subViewOutlet.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(SuccessViewController.executeForPanning))
        view.addGestureRecognizer(panGesture)
        
        self.view.bringSubview(toFront: tableViewOutlet)
        menuLeadingConstraint.constant = -250
    }
    
    func executeAfterTap(tap: UITapGestureRecognizer) {
        if isMenuShowing {
            hideMenu()
            isMenuShowing = false
        }
    }
    
    var startLocation : CGPoint?
    
    func executeForPanning(gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            startLocation = gesture.location(in: self.subViewOutlet)
        } else if gesture.state == UIGestureRecognizerState.ended {
            let currentLocation = gesture.location(in: self.subViewOutlet)
            let distanceSwiped = startLocation!.x - currentLocation.x
            if distanceSwiped > 20 {
                self.hideMenu()
                isMenuShowing = false
            }
        } else if gesture.state == UIGestureRecognizerState.changed {
            let currentLocation = gesture.location(in: self.subViewOutlet)
            let distanceSwiped = startLocation!.x - currentLocation.x
            
            if distanceSwiped > 0 {
                menuLeadingConstraint.constant = menuLeadingConstraint.constant - distanceSwiped
                subViewOutlet.alpha = subViewOutlet.alpha + CGFloat(Double(distanceSwiped) / 250.0)
            } else {
                menuLeadingConstraint.constant = menuLeadingConstraint.constant - distanceSwiped
                subViewOutlet.alpha = subViewOutlet.alpha - CGFloat(Double(distanceSwiped) / 250.0)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openMenuButton(_ sender: Any) {
        if isMenuShowing {
            hideMenu()
        } else {
            showMenu()
        }
        
        isMenuShowing = !isMenuShowing
    }
    
    func hideMenu() {
        menuLeadingConstraint.constant = -250
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.subViewOutlet.alpha = 1
        })
    }
    
    func showMenu() {
        menuLeadingConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.subViewOutlet.alpha = 0.5
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

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
    var startLocation : CGPoint?
    var lastLocation : CGPoint?
    let alphaForDimming : CGFloat = 0.7
    let maxAnimationDuration : CGFloat = 0.25
    
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var subViewOutlet: UIView!
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    @IBOutlet weak var tableViewWidthOutlet: NSLayoutConstraint!
    
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
        menuLeadingConstraint.constant = -tableViewWidthOutlet.constant
    }
    
    func executeAfterTap(tap: UITapGestureRecognizer) {
        if isMenuShowing {
            hideMenu()
            isMenuShowing = false
        }
    }
    
    func executeForPanning(gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            startLocation = gesture.location(in: self.subViewOutlet)
            lastLocation = gesture.location(in: self.subViewOutlet)
        } else if gesture.state == UIGestureRecognizerState.ended {
            if menuLeadingConstraint.constant > -tableViewWidthOutlet.constant / 2 {
                self.showMenu()
                isMenuShowing = true
            }
            if menuLeadingConstraint.constant < -tableViewWidthOutlet.constant / 2 {
                self.hideMenu()
                isMenuShowing = false
            }
        } else if gesture.state == UIGestureRecognizerState.changed {
            
            let currentLocation = gesture.location(in: self.subViewOutlet)
            
            if isMenuShowing {
                moveTableView(moveDistance: 0 + (currentLocation.x - startLocation!.x), currentLocation: currentLocation)
            } else {
                moveTableView(moveDistance: -tableViewWidthOutlet.constant + (currentLocation.x - startLocation!.x), currentLocation: currentLocation)
            }
            
            lastLocation = currentLocation
        }
    }
    
    func moveTableView(moveDistance: CGFloat, currentLocation: CGPoint) {
        let gradientForChangingAlpha = tableViewWidthOutlet.constant / (1 - alphaForDimming)
        if currentLocation.x > lastLocation!.x && menuLeadingConstraint.constant < 0 {
            if startLocation!.x < 35 || menuLeadingConstraint.constant > -tableViewWidthOutlet.constant {
                if moveDistance <= 0 {
                    menuLeadingConstraint.constant = moveDistance
                    subViewOutlet.alpha = (-moveDistance / gradientForChangingAlpha) + alphaForDimming
                }
            } else {
                return
            }
        } else if currentLocation.x < lastLocation!.x && menuLeadingConstraint.constant > -tableViewWidthOutlet.constant {
            if moveDistance < 0 {
                menuLeadingConstraint.constant = moveDistance
                subViewOutlet.alpha = (-moveDistance / gradientForChangingAlpha) + alphaForDimming
            } else {
                return
            }
        }
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
        prepareToAnimateView(constant: -tableViewWidthOutlet.constant, compareConstant: 0, alpha: 1)
    }
    
    func showMenu() {
        prepareToAnimateView(constant: 0, compareConstant: -tableViewWidthOutlet.constant, alpha: alphaForDimming)
    }
    
    func prepareToAnimateView(constant: CGFloat, compareConstant: CGFloat, alpha: CGFloat) {
        let gradientForAnimationDuration = tableViewWidthOutlet.constant / maxAnimationDuration
        var duration: TimeInterval
        if isMenuShowing {
            duration = TimeInterval((tableViewWidthOutlet.constant + menuLeadingConstraint.constant + 100) / gradientForAnimationDuration)
            animateView(duration: duration, alpha: alpha, positionToMoveViewTo: constant)
        } else {
            duration = TimeInterval(-menuLeadingConstraint.constant / gradientForAnimationDuration)
            animateView(duration: duration, alpha: alpha, positionToMoveViewTo: constant)
        }
    }
    
    func animateView(duration: TimeInterval, alpha: CGFloat, positionToMoveViewTo: CGFloat) {
        menuLeadingConstraint.constant = positionToMoveViewTo
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
            self.subViewOutlet.alpha = alpha
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

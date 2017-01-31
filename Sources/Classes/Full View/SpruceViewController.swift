//
//  SpruceViewController.swift
//  Spruce
//
//  Created by Jackson Taylor on 11/15/16.
//  Copyright © 2016 WillowTree Apps, Inc. All rights reserved.
//

import UIKit

open class SpruceViewController: UIViewController {
    open var animations: [SpruceStandardAnimation] = []
    open var duration: TimeInterval = 0.3
    open var animationType: SpruceAnimation
    open var sortFunction: SortFunction
    
    open var animationView: UIView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        animationType = StandardAnimation(duration: duration)
        sortFunction = LinearSortFunction(direction: .topToBottom, interObjectDelay: 0.05)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        if animations.count > 0 {
            animationView?.hideAllSubviews()
            animationView?.sprucePrepare(withAnimations: animations)
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animationView?.spruceUp(withAnimations: animations, duration: duration, animationType: animationType, sortFunction: sortFunction, prepare: false)
    }
}

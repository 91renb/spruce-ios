//
//  DefaultFullViewAnimations.swift
//  Spruce
//
//  Created by Jackson Taylor on 11/14/16.
//  Copyright © 2016 WillowTree Apps, Inc. All rights reserved.
//

import UIKit

public enum SlideDirection {
    case up
    case down
    case left
    case right
}

public enum SpruceSize {
    case small
    case medium
    case large
}

public enum SpruceStandardAnimation {
    case slide(SlideDirection, SpruceSize)
    
    case fadeIn
    
    case spin(SpruceSize)
    
    case expand(SpruceSize)
    case contract(SpruceSize)
    
    func getClearFunction() -> SpruceChangeFunction {
        switch self {
        case .slide:
            let offset = getClearSlideOffset()
            return { view in
                let currentTransform = view.transform
                let offsetTransform = CGAffineTransform(translationX: offset.x, y: offset.y)
                view.transform = currentTransform.concatenating(offsetTransform)
            }
        case .fadeIn:
            return { view in
                view.alpha = 0.0
            }
        case .spin:
            let angle = getSpinAngle()
            return { view in
                let currentTransform = view.transform
                let spinTransform = CGAffineTransform(rotationAngle: angle)
                view.transform = currentTransform.concatenating(spinTransform)
            }
        case .expand, .contract:
            let scale = getScale()
            return { view in
                let currentTransform = view.transform
                let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
                view.transform = currentTransform.concatenating(scaleTransform)
            }
        }
    }
    
    func getAnimationFunction() -> SpruceChangeFunction {
        switch self {
        case .slide:
            return { view in
                view.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
            }
        case .fadeIn:
            return { view in
                view.alpha = 1.0
            }
        case .spin:
            return { view in
                view.transform = CGAffineTransform(rotationAngle: 0.0)
            }
        case .expand, .contract:
            return { view in
                view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
    }
    
    func getClearSlideOffset() -> CGPoint {
        
        switch self {
        case .slide(let direction, let size):
            switch (direction, size) {
            case (.up, .small):
                return CGPoint(x: 0.0, y: 10.0)
            case (.up, .medium):
                return CGPoint(x: 0.0, y: 30.0)
            case (.up, .large):
                return CGPoint(x: 0.0, y: 50.0)
            case (.down, .small):
                return CGPoint(x: 0.0, y: -10.0)
            case (.down, .medium):
                return CGPoint(x: 0.0, y: -30.0)
            case (.down, .large):
                return CGPoint(x: 0.0, y: -50.0)
            case (.left, .small):
                return CGPoint(x: 10.0, y: 0.0)
            case (.left, .medium):
                return CGPoint(x: 30.0, y: 0.0)
            case (.left, .large):
                return CGPoint(x: 50.0, y: 0.0)
            case (.right, .small):
                return CGPoint(x: -10.0, y: 0.0)
            case (.right, .medium):
                return CGPoint(x: -30.0, y: 0.0)
            case (.right, .large):
                return CGPoint(x: -50.0, y: 0.0)
            }
        default:
            return CGPoint.zero
        }
    }
    
    func getSpinAngle() -> CGFloat {
        switch self {
        case .spin(let size):
            switch size {
            case .small:
                return CGFloat(M_PI_4)
            case .medium:
                return CGFloat(M_PI_2)
            case .large:
                return CGFloat(M_PI)
            }
        default:
            return 0.0
        }
    }
    
    func getScale() -> CGFloat {
        switch self {
        case .contract(let size):
            switch size {
            case .small:
                return 1.1
            case .medium:
                return 1.3
            case .large:
                return 1.5
            }
        case .expand(let size):
            switch size {
            case .small:
                return 0.9
            case .medium:
                return 0.7
            case .large:
                return 0.5
            }
        default:
            return 0.0
        }
    }
}

public extension UIView {
    open func spruceUp(withAnimations animations: [SpruceStandardAnimation], duration: TimeInterval = 0.3) {
        let animation = StandardAnimation(duration: duration)
        self.spruceUp(withAnimations: animations, duration: duration, animationType: animation)
    }
    
    open func spruceUp(withAnimations animations: [SpruceStandardAnimation], duration: TimeInterval = 0.3, animationType: SpruceAnimation) {
        let sortFunction = LinearSortFunction(direction: .topToBottom, interObjectDelay: 0.05)
        self.spruceUp(withAnimations: animations, duration: duration, animationType: animationType, sortFunction: sortFunction)
    }
    
    open func spruceUp(withAnimations animations: [SpruceStandardAnimation], duration: TimeInterval = 0.3, animationType: SpruceAnimation, sortFunction: SortFunction, prepare: Bool = true) {
        
        if prepare {
            self.sprucePrepare(withAnimations: animations)
        }
        
        /* Create the animations */
        var animationType = animationType
        animationType.changeFunction = { view in
            for animation in animations {
                let animationFunc = animation.getAnimationFunction()
                animationFunc(view)
            }
        }
        self.spruceSubViews(withSortFunction: sortFunction, animation: animationType)
    }
    
    open func sprucePrepare(withAnimations animations: [SpruceStandardAnimation]) {
        /* Reset the views to prepare for the animations */
        let clearFunction: SpruceChangeFunction = { view in
            for animation in animations {
                let clearFunc = animation.getClearFunction()
                clearFunc(view)
            }
        }
        
        let isFading = animations.contains(where: { value in
            switch value {
            case .fadeIn:
                return true
            default:
                return false
            }
        })
        
        UIView.performWithoutAnimation {
            for subView in subviews {
                clearFunction(subView)
                if isFading {
                    subView.isHidden = false
                }
            }
        }
    }
    
    open func hideAllSubviews() {
        UIView.performWithoutAnimation {
            for subView in subviews {
                subView.isHidden = true
            }
        }
    }
}

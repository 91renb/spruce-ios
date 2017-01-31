//
//  SortFunctionTestViewController.swift
//  Spruce
//
//  Created by Matt Kauper on 12/22/16.
//  Copyright (c) 2017 WillowTree, Inc.

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit
import Spruce

class SortFunctionTestViewController: UIViewController {

    // Control containers
    @IBOutlet var controlViews: [UIView]!

    @IBOutlet weak var functionControlView: UIView!
    @IBOutlet weak var durationControlView: UIView!
    @IBOutlet weak var delayControlView: UIView!
    @IBOutlet weak var positionControlView: UIView!
    @IBOutlet weak var cornerControlView: UIView!
    @IBOutlet weak var reverseControlView: UIView!
    @IBOutlet weak var directionControlView: UIView!

    // Controls
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var delaySlider: UISlider!
    @IBOutlet weak var positionPicker: UISegmentedControl!
    @IBOutlet weak var directionPicker: UISegmentedControl!
    @IBOutlet weak var cornerPicker: UISegmentedControl!
    @IBOutlet weak var reverseSwitch: UISwitch!
    @IBOutlet weak var functionTextField: UITextField!

    // Preview
    @IBOutlet weak var sortView: UIView!

    // Settings
    let availableFunctions = ["Default", "Linear", "Cornered", "Radial", "Inline", "Continuous", "Weighted continuous", "Random"]
    var settings = SortFunctionTestSettings()
    var animationController = CustomAnimationViewController()

    // Lifecycle
    override func viewDidLoad() {
        let functionPicker = UIPickerView()
        functionPicker.dataSource = self
        functionPicker.delegate = self
        functionTextField.inputView = functionPicker
        let reloadGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(reloadSortView))
        sortView.addGestureRecognizer(reloadGestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        reloadSortView()
    }

    func reloadSortView() {
        for subview in sortView.subviews {
            subview.removeFromSuperview()
        }
        let testController = self.animationControllerForCurrentSettings()
        self.addChildViewController(testController)
        self.sortView.addSubview(testController.view)
        testController.view.frame = sortView.bounds
        testController.setup()

        let activeControlViews = controlViewsForCurrentSettings()
        for view in controlViews {
            view.isHidden = !activeControlViews.contains(view)
        }
    }

    func sortFunctionForCurrentSettings() -> SortFunction {
        var sortFunction: SortFunction
        switch settings.function {
        case "Default":
            sortFunction = DefaultSortFunction(interObjectDelay: settings.delay)
        case "Linear":
            sortFunction = LinearSortFunction(direction: settings.direction, interObjectDelay: settings.delay)
        case "Cornered":
            sortFunction = CorneredSortFunction(corner: settings.corner, interObjectDelay: settings.delay)
        case "Radial":
            sortFunction = RadialSortFunction(position: settings.position, interObjectDelay: settings.delay)
        case "Inline":
            sortFunction = InlineSortFunction(corner: settings.corner, interObjectDelay: settings.delay)
        case "Continuous":
            sortFunction = ContinuousSortFunction(position: settings.position, duration: settings.duration)
        case "Weighted continuous":
            sortFunction = ContinuousWeightedSortFunction(position: settings.position, duration: settings.duration, horizontalWeight: .light, verticalWeight: .heavy)
        case "Random":
            sortFunction = RandomSortFunction(interObjectDelay: settings.delay)
        default:
            sortFunction = DefaultSortFunction(interObjectDelay: settings.delay)
        }

        if let sortFunction = sortFunction as? BaseDistancedSortFunction {
            sortFunction.reversed = settings.reverse
        }
        return sortFunction
    }

    func controlViewsForCurrentSettings() -> [UIView] {
        switch settings.function {
        case "Default":
            return [functionControlView, delayControlView]
        case "Linear":
            return [functionControlView, delayControlView, directionControlView, reverseControlView]
        case "Cornered":
            return [functionControlView, delayControlView, cornerControlView]
        case "Radial":
            return [functionControlView, delayControlView, positionControlView, reverseControlView]
        case "Inline":
            return [functionControlView, delayControlView, cornerControlView]
        case "Continuous":
            return [functionControlView, durationControlView, positionControlView]
        case "Weighted continuous":
            return [functionControlView, durationControlView, positionControlView]
        case "Random":
            return [functionControlView, delayControlView]
        default:
            return controlViews
        }
    }

    // Actions
    @IBAction func durationDidChange(_ sender: UISlider) {
        settings.duration = Double(sender.value)
        reloadSortView()
    }

    @IBAction func delayDidChange(_ sender: UISlider) {
        settings.delay = Double(sender.value)
        reloadSortView()
    }

    @IBAction func positionDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            settings.position = .topLeft
        case 1:
            settings.position = .topMiddle
        case 2:
            settings.position = .topRight
        case 3:
            settings.position = .right
        case 4:
            settings.position = .middle
        case 5:
            settings.position = .left
        case 6:
            settings.position = .bottomLeft
        case 7:
            settings.position = .bottomMiddle
        case 8:
            settings.position = .bottomRight
        default:
            settings.position = .topLeft
        }
        reloadSortView()
    }

    @IBAction func directionDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            settings.direction = .topToBottom
        case 1:
            settings.direction = .bottomToTop
        case 2:
            settings.direction = .leftToRight
        case 3:
            settings.direction = .rightToLeft
        default:
            settings.direction = .topToBottom
        }
        reloadSortView()
    }

    @IBAction func cornerDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            settings.corner = .topLeft
        case 1:
            settings.corner = .topRight
        case 2:
            settings.corner = .bottomLeft
        case 3:
            settings.corner = .bottomRight
        default:
            settings.corner = .topLeft
        }
        reloadSortView()
    }

    @IBAction func reverseDidChange(_ sender: UISwitch) {
        settings.reverse = sender.isOn
        reloadSortView()
    }
}

extension SortFunctionTestViewController {

    func animationControllerForCurrentSettings() -> CustomAnimationViewController {

        let testController = CustomAnimationViewController(nibName: nil, bundle: nil)

        let animations = { [unowned self] in
            let animation = SpringAnimation(duration: 0.5) { view in
            view.alpha = 1.0
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            let sortFunction = self.sortFunctionForCurrentSettings()
            testController.containerView?.spruceSubViews(withSortFunction: sortFunction, animation: animation, completion: nil, exclude: nil)
        }
        testController.customAnimation = animations
        return testController
    }

}

extension SortFunctionTestViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableFunctions[row]
    }
}

extension SortFunctionTestViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableFunctions.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.functionTextField.endEditing(true)
        self.functionTextField.text = availableFunctions[row]
        settings.function = availableFunctions[row]
        reloadSortView()
    }

}

struct SortFunctionTestSettings {

    var context: String = "Squares"
    var function: String = "Default"
    var duration: Double = 1.0
    var delay: Double = 0.025
    var position: SprucePosition = .topLeft
    var direction: SpruceDirection = .topToBottom
    var corner: SpruceCorner = .topLeft
    var reverse: Bool = false

}

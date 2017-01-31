//
//  TestViewController2.swift
//  Spruce
//
//  Created by Jackson Taylor on 11/15/16.
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

import UIKit
import Spruce

class TestViewController2: UIViewController {

    var squaresPerRow: Int = 11

    var containerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setup()
        
        containerView?.hideAllSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        containerView?.spruceUp(withAnimations: [.fadeIn, .expand(.medium), .spin(.large), .slide(.up,.medium)])
    }
}

extension TestViewController2 {
    func setup() {
        let spacing: CGFloat = 3.0
        let frameWidth = view.bounds.size.width - (spacing * CGFloat(squaresPerRow + 1))
        let viewSize = (frameWidth / CGFloat(squaresPerRow))

        self.containerView = UIView(frame: CGRect(x: spacing, y: 67.0,
                                                  width: view.bounds.size.width - (spacing * 2.0),
                                                  height: viewSize * CGFloat(squaresPerRow)))
        self.view.addSubview(self.containerView!)
        for row in 0..<squaresPerRow {
            for col in 0..<squaresPerRow {
                let view = UIView(frame: CGRect(x: CGFloat(col) * (viewSize + spacing), y: CGFloat(row) * (viewSize + spacing), width: viewSize, height: viewSize))
                view.backgroundColor = UIColor.spruceGreen
                view.layer.cornerRadius = 2.0
                view.clipsToBounds = true
                containerView?.addSubview(view)
            }
        }
    }
}

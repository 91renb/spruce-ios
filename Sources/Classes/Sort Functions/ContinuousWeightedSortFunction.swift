//
//  WeightedContinuousSortFunction.swift
//  Spruce
//
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

public struct ContinuousWeightedSortFunction: PositionSortFunction, WeightSortFunction {
    
    public var interObjectDelay: TimeInterval = 0.0
    public var position: SprucePosition
    public var reversed: Bool = false
    public var duration: TimeInterval

    public var horizontalWeight: SpruceWeight
    public var verticalWeight: SpruceWeight

    public init(position: SprucePosition, duration: TimeInterval, horizontalWeight: SpruceWeight = .medium, verticalWeight: SpruceWeight = .medium) {
        self.horizontalWeight = horizontalWeight
        self.verticalWeight = verticalWeight
        self.position = position
        self.duration = duration
    }

    public func timeOffsets(view: UIView, recursiveDepth: Int) -> [SpruceTimedView] {
        let subviews = view.subviews(withRecursiveDepth: recursiveDepth)
        let comparisonPoint = distancePoint(view: view, subviews: subviews)

        let distancedViews = subviews.map {
            return (view: $0, horizontalDistance: comparisonPoint.horizontalDistance(to: $0.referencePoint) * horizontalWeight.coefficient, verticalDistance: comparisonPoint.verticalDistance(to: $0.referencePoint) * verticalWeight.coefficient)
        }

        guard let maxHorizontalDistance = distancedViews.max(by: { $0.horizontalDistance < $1.horizontalDistance })?.horizontalDistance, let maxVerticalDistance = distancedViews.max(by: { $0.verticalDistance < $1.verticalDistance })?.verticalDistance, maxHorizontalDistance > 0.0, maxVerticalDistance > 0.0 else {
            return []
        }

        var timedViews: [SpruceTimedView] = []
        var maxTimeOffset: TimeInterval = 0.0
        for view in distancedViews {
            let normalizedHorizontalDistance = view.horizontalDistance / maxHorizontalDistance
            let normalizedVerticalDistance = view.verticalDistance / maxVerticalDistance
            let offset = duration * (normalizedHorizontalDistance * horizontalWeight.coefficient + normalizedVerticalDistance * verticalWeight.coefficient)
            if offset > maxTimeOffset {
                maxTimeOffset = offset
            }
            let timedView = SpruceTimedView(spruceView: view.view, timeOffset: offset)
            timedViews.append(timedView)
        }
        
        for index in 0..<timedViews.count {
            let timeOffset = timedViews[index].timeOffset
            let normalizedTimeOffset = (timeOffset / maxTimeOffset) * duration
            timedViews[index].timeOffset = normalizedTimeOffset
            if reversed {
                timedViews[index].timeOffset = duration - normalizedTimeOffset
            }
        }
        
        return timedViews
    }
}

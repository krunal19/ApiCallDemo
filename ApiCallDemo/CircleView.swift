//
//  CircleView.swift
//  ApiCallDemo
//
//  Created by Krunal on 28/09/20.
//  Copyright © 2020 Krunal. All rights reserved.
//

import Foundation
import UIKit

class CircleView: UIView {

        let circleLayer: CAShapeLayer = {
            // Setup the CAShapeLayer with the path, colors, and line width
            let circle = CAShapeLayer()
            circle.fillColor = UIColor.clear.cgColor
            circle.strokeColor = UIColor.red.cgColor
            circle.lineWidth = 5.0

            // Don't draw the circle initially
            circle.strokeEnd = 0.0
            return circle
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }

        func setup(){
            backgroundColor = UIColor.clear

            // Add the circleLayer to the view's layer's sublayers
            layer.addSublayer(circleLayer)
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            // Use UIBezierPath as an easy way to create the CGPath for the layer.
            // The path should be the entire circle.
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2.0), clockwise: true)

            circleLayer.path = circlePath.cgPath
        }

        func animateCircle(duration t: TimeInterval) {
            // We want to animate the strokeEnd property of the circleLayer
            let animation = CABasicAnimation(keyPath: "strokeEnd")

            // Set the animation duration appropriately
            animation.duration = t

            // Animate from 0 (no circle) to 1 (full circle)
            animation.fromValue = 0
            animation.toValue = 1

            // Do a linear animation (i.e. the speed of the animation stays the same)
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

            // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
            // right value when the animation ends.
            circleLayer.strokeEnd = 1.0

            // Do the actual animation
            circleLayer.add(animation, forKey: "animateCircle")
        }
    }
class CircularProgressView: UIView {
    // First create two layer properties
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 80, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 20.0
        circleLayer.strokeColor = UIColor.clear.cgColor
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.green.cgColor
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }
    func progressAnimation(duration: TimeInterval) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}

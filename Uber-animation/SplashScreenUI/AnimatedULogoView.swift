//
//  AnimatedULogoView.swift
//  Uber-animation
//
//  Created by SL on 04/06/2017.
//  Copyright © 2017 SL. All rights reserved.
//

import UIKit
import QuartzCore
import Commons

class AnimatedULogoView: UIView {
    /*
     swift 3.0 新增加的的fileprivate显式表明，这个元素的访问权限为文件内私有，离开了这个类或者结构体的作用域外面就无法访问
     */
    fileprivate let strokeEndTimingFunction    = CAMediaTimingFunction(controlPoints: 1.00, 0.0, 0.35, 1.0)
    fileprivate let squareLayerTimingFunction  = CAMediaTimingFunction(controlPoints: 0.25, 0.0, 0.20, 1.0)
    fileprivate let circleLayerTimingFunction  = CAMediaTimingFunction(controlPoints: 0.65, 0.0, 0.40, 1.0)
    fileprivate let fadeInSquareTimingFunction = CAMediaTimingFunction(controlPoints: 0.15, 0, 0.85, 1.0)
    
    fileprivate let radius: CGFloat = 37.5
    fileprivate let squareLayerLength = 21.0
    fileprivate let startTimeOffset = 0.7 * kAnimationDuration
    
    
    fileprivate var circleLayer: CAShapeLayer!
    fileprivate var squareLayer: CAShapeLayer!
    fileprivate var lineLayer: CAShapeLayer!
    fileprivate var maskLayer: CAShapeLayer!
    
    var beginTime: CFTimeInterval = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        circleLayer = generateCircleLayer()
        lineLayer = generateLineLayer()
        squareLayer = generateSquareLayer()
        maskLayer = generateMaskLayer()
        
        layer.mask = maskLayer
        layer.addSublayer(circleLayer)
        layer.addSublayer(lineLayer)
        layer.addSublayer(squareLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func startAnimating() {
        /*
            CACurrentMediaTime获取的时间，是手机从开机到当前所经过的秒数
         */
        beginTime = CACurrentMediaTime()
        layer.anchorPoint = CGPoint.zero
        
        animateMaskLayer()
        animateCircleLayer()
        animateLineLayer()
        animateSquareLayer()
    }
}

extension AnimatedULogoView {
    fileprivate func generateMaskLayer()->CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: -radius, y: -radius, width: radius * 2.0, height: radius * 2.0)
        layer.allowsGroupOpacity = true
        layer.backgroundColor = UIColor.white.cgColor
        return layer
    }
    fileprivate func generateCircleLayer()->CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = radius
        layer.path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius / 2, startAngle: -CGFloat(Double.pi/2), endAngle: CGFloat(3*Double.pi/2), clockwise: true).cgPath
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }
    fileprivate func generateLineLayer()->CAShapeLayer {
        let layer = CAShapeLayer()
        layer.position = CGPoint.zero
        layer.frame = CGRect.zero
        layer.allowsGroupOpacity = true
        layer.lineWidth = 5.0
        layer.strokeColor = UIColor.fuberBlue().cgColor
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint.zero)
        bezierPath.addLine(to: CGPoint(x: 0.0, y: -radius))
        
        layer.path = bezierPath.cgPath
        return layer
    }
    fileprivate func generateSquareLayer()->CAShapeLayer {
        let layer = CAShapeLayer()
        layer.position = CGPoint.zero
        layer.frame = CGRect(x: -squareLayerLength/2.0, y: -squareLayerLength/2.0, width: squareLayerLength, height: squareLayerLength)
        layer.cornerRadius = 1.5
        layer.allowsGroupOpacity = true
        layer.backgroundColor = UIColor.fuberBlue().cgColor
        return layer
    }
}

extension AnimatedULogoView {
    fileprivate func animateMaskLayer() {
        //bounds
        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.fromValue = NSValue(cgRect: CGRect(x: 0.0, y: 0.0, width: radius*2.0, height: radius*2.0))
        boundsAnimation.toValue = NSValue(cgRect: CGRect(x: 0.0, y: 0.0, width: 2.0/3.0*squareLayerLength, height: 2.0/3.0*squareLayerLength))
        boundsAnimation.duration = kAnimationDurationDelay
        boundsAnimation.beginTime = kAnimationDuration-kAnimationDurationDelay
        boundsAnimation.timingFunction = circleLayerTimingFunction
        
        //cornerRadius
        let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimation.beginTime = kAnimationDuration - kAnimationDurationDelay
        cornerRadiusAnimation.duration = kAnimationDurationDelay
        cornerRadiusAnimation.fromValue = radius
        cornerRadiusAnimation.toValue = 2
        cornerRadiusAnimation.timingFunction = circleLayerTimingFunction
        
        //Group
        let groupAnimation = CAAnimationGroup()
        groupAnimation.isRemovedOnCompletion = false
        //决定当前对象在非active时间段的行为
        groupAnimation.fillMode = kCAFillModeBoth
        groupAnimation.beginTime = beginTime
        groupAnimation.repeatCount = Float.infinity
        groupAnimation.duration = kAnimationDuration
        groupAnimation.animations = [boundsAnimation, cornerRadiusAnimation]
        groupAnimation.timeOffset = startTimeOffset
        maskLayer.add(groupAnimation, forKey: "looping")
    }
    
    fileprivate func animateCircleLayer() {
        //strokeEnd
        let strokeEndAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.timingFunction = strokeEndTimingFunction
        strokeEndAnimation.duration = kAnimationDuration - kAnimationDurationDelay
        strokeEndAnimation.values = [0.0, 1.0]
        strokeEndAnimation.keyTimes = [0.0, 1.0]
        
        //transform
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.timingFunction = strokeEndTimingFunction
        transformAnimation.duration = kAnimationDuration - kAnimationDurationDelay
        
        var startingTransform = CATransform3DMakeRotation(-CGFloat(Double.pi/4), 0, 0, 1)
        startingTransform = CATransform3DScale(startingTransform, 0.25, 0.25, 1)
        transformAnimation.fromValue = NSValue(caTransform3D:startingTransform)
        transformAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))
        
        //group
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [strokeEndAnimation, transformAnimation]
        groupAnimation.repeatCount = Float.infinity
        groupAnimation.duration = kAnimationDuration
        groupAnimation.beginTime = beginTime
        groupAnimation.timeOffset = startTimeOffset
        
        circleLayer.add(groupAnimation, forKey: "looping")
    }
    
    fileprivate func animateLineLayer() {
        //lineWidth
        let lineWidthAnimation = CAKeyframeAnimation(keyPath: "lineWidth")
        lineWidthAnimation.values = [0.0, 5.0, 0.0]
        lineWidthAnimation.timingFunctions = [strokeEndTimingFunction, circleLayerTimingFunction]
        lineWidthAnimation.duration = kAnimationDuration
        lineWidthAnimation.keyTimes = [0.0, ((kAnimationDuration-kAnimationDurationDelay)/kAnimationDuration) as NSNumber, 1.0]
        
        //transform
        let transformAnimation = CAKeyframeAnimation(keyPath: "transform")
        transformAnimation.timingFunctions = [strokeEndTimingFunction, circleLayerTimingFunction]
        transformAnimation.duration = kAnimationDuration
        transformAnimation.keyTimes = [0.0, ((kAnimationDuration-kAnimationDurationDelay)/kAnimationDuration) as NSNumber, 1.0]
        
        var transform = CATransform3DMakeRotation(CGFloat(7.0*Double.pi/4), 0.0, 0.0, 1.0)
        transform = CATransform3DScale(transform, 0.25, 0.25, 1.0)
        transformAnimation.values = [NSValue(caTransform3D: transform),
                                     NSValue(caTransform3D: CATransform3DIdentity),
                                     NSValue(caTransform3D: CATransform3DMakeScale(0.15, 0.15, 1.0))]
        
        //group
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [lineWidthAnimation, transformAnimation]
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.repeatCount = Float.infinity
        groupAnimation.duration = kAnimationDuration
        groupAnimation.beginTime = beginTime
        groupAnimation.timeOffset = startTimeOffset
        
        lineLayer.add(groupAnimation, forKey: "looping")
    }
    
    fileprivate func animateSquareLayer() {
        //bounds
        let b1 = NSValue(cgRect: CGRect(x: 0.0, y: 0.0, width: 2.0/3.0*squareLayerLength, height: 2.0/3.0*squareLayerLength))
        let b2 = NSValue(cgRect: CGRect(x: 0.0, y: 0.0, width: squareLayerLength, height: squareLayerLength))
        let b3 = NSValue(cgRect: CGRect.zero)
        
        let boundsAnimation = CAKeyframeAnimation(keyPath: "bounds")
        boundsAnimation.values = [b1,b2,b3]
        boundsAnimation.timingFunctions = [fadeInSquareTimingFunction, squareLayerTimingFunction]
        boundsAnimation.duration = kAnimationDuration
        boundsAnimation.keyTimes = [0, ((kAnimationDuration-kAnimationDurationDelay)/kAnimationDuration) as NSNumber,1]
        
        //backgroundColor
        let backgroundColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        backgroundColorAnimation.fromValue = UIColor.white.cgColor
        backgroundColorAnimation.toValue = UIColor.fuberBlue().cgColor
        backgroundColorAnimation.timingFunction = squareLayerTimingFunction
        backgroundColorAnimation.fillMode = kCAFillModeBoth
        backgroundColorAnimation.beginTime = kAnimationDuration*2.0/kAnimationDuration
        backgroundColorAnimation.duration = kAnimationDuration/(kAnimationDuration-kAnimationDurationDelay)
        
        //group
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [boundsAnimation, backgroundColorAnimation]
        groupAnimation.repeatCount = Float.infinity
        groupAnimation.duration = kAnimationDuration
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.beginTime = beginTime
        groupAnimation.timeOffset = startTimeOffset
        
        squareLayer.add(groupAnimation, forKey: "looping")
    }
}

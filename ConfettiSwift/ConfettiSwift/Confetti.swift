//
//  Confetti.swift
//  ConfettiSwift
//
//  Created by LarrySue on 2017/8/24.
//  Copyright © 2017年 personal. All rights reserved.
//

import UIKit

private struct ConfettiDoubleRange {
    public var lower: Double
    public var upper: Double
    
    public init(from lower: Double, to upper: Double) {
        self.lower = lower
        self.upper = upper
    }
}
public struct ConfettiPointRange {
    fileprivate var rangeX: ConfettiDoubleRange
    fileprivate var rangeY: ConfettiDoubleRange
    
    public init(rect: CGRect) {
        self.rangeX = ConfettiDoubleRange(from: Double(rect.origin.x), to: Double(rect.origin.x + rect.size.width))
        self.rangeY = ConfettiDoubleRange(from: Double(rect.origin.y), to: Double(rect.origin.y + rect.size.height))
    }
}

private func random(from lower: Double, to upper: Double, decimal precision: UInt) -> Double {
    let offset = pow(10, Double(precision))
    
    return (Double(arc4random_uniform(UInt32(upper * offset - lower * offset))) + lower * offset) / offset
}

class Confetti: NSObject {
    
    // MARK: *** 属性 ***
    
    ///displayLink
    private var displayLink: CADisplayLink?
    ///基准视图
    private var view: UIView
    
    ///色彩
    public var colors: [UIColor] = [.red, .green, .blue]
    ///起点范围
    public var startPointRange: ConfettiPointRange
    ///终点范围
    public var endPointRange: ConfettiPointRange
    ///密度
    public var density: Int = 20 {
        didSet {
            if #available(iOS 10.0, *) {
                displayLink?.preferredFramesPerSecond = density
            } else {
                displayLink?.frameInterval = 60 / density
            }
        }
    }
    
    // MARK: *** 构造 ***
    
    init(on view: UIView, from startRange: ConfettiPointRange, to endRange: ConfettiPointRange) {
        self.view = view
        self.startPointRange = startRange
        self.endPointRange = endRange
        
        super.init()
        
        displayLink = CADisplayLink(target: self, selector: #selector(throwConfetti))
        displayLink?.add(to: RunLoop.main, forMode: .commonModes)
        displayLink?.isPaused = true
        
        if #available(iOS 10.0, *) {
            displayLink?.preferredFramesPerSecond = density
        } else {
            displayLink?.frameInterval = 60 / density
        }
    }
    
    // MARK: *** 析构 ***
    
    deinit {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    // MARK: *** 逻辑 ***
    
    ///开始撒花
    public func start() {
        displayLink?.isPaused = false
    }
    ///结束撒花
    public func end() {
        displayLink?.isPaused = true
    }
    
    // MARK: *** 回调 ***
    
    ///撒纸屑
    @objc private func throwConfetti() {
        
        let startLowerX = startPointRange.rangeX.lower
        let startUpperX = startPointRange.rangeX.upper
        let startLowerY = startPointRange.rangeY.lower
        let startUpperY = startPointRange.rangeY.upper
        
        let endLowerX = endPointRange.rangeX.lower
        let endUpperX = endPointRange.rangeX.upper
        let endLowerY = endPointRange.rangeY.lower
        let endUpperY = endPointRange.rangeY.upper
        
        let confetti = UIView(frame: CGRect(x: random(from: startLowerX, to: startUpperX, decimal: 1), y: random(from: startLowerY, to: startUpperY, decimal: 1), width: 15.0, height: 15.0))
        let colorView = UIView(frame: CGRect(x: 3, y: 3, width: random(from: 5.0, to: 8.0, decimal: 1), height: random(from: 5.0, to: 8.0, decimal: 1)))
        
        confetti.backgroundColor = .clear
        
        colorView.backgroundColor = colors[Int(random(from: 0, to: Double(colors.count), decimal: 0))]
        colorView.layer.transform = CATransform3DMakeRotation(CGFloat(random(from: 0, to: Double.pi * 2, decimal: 1)), CGFloat(random(from: -1, to: 1, decimal: 2)), CGFloat(random(from: -1, to: 1, decimal: 2)), CGFloat(random(from: -1, to: 1, decimal: 2)))
        
        view.addSubview(confetti)
        confetti.addSubview(colorView)
        
        UIView.animate(withDuration: TimeInterval(random(from: 6.0, to: 8.0, decimal: 1)), animations: {
            confetti.layer.transform = CATransform3DMakeTranslation(CGFloat(random(from: endLowerX, to: endUpperX, decimal: 1)), CGFloat(random(from: endLowerY, to: endUpperY, decimal: 1)), 0)
        }) { (finish) in
            if finish {
                confetti.removeFromSuperview()
            }
        }
    }
}

//
//  Confetti.swift
//  ConfettiSwift
//
//  Created by LarrySue on 2017/8/24.
//  Copyright © 2017年 personal. All rights reserved.
//

import UIKit

public protocol Randomable {
    associatedtype DataType
    func random(decimal precision: UInt) -> DataType
}

// MARK: -

public struct ConfettiFloatRange: Randomable {
    public typealias DataType = CGFloat
    
    public var lowerBound: CGFloat
    public var upperBound: CGFloat
    
    public init(from lowerBound: CGFloat, to upperBound: CGFloat) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
    }
    
    public func random(decimal precision: UInt) -> DataType {
        return CGFloat(ConfettiSwift.random(from: lowerBound, to: upperBound, decimal: precision))
    }
}
public struct ConfettiPointRange: Randomable {
    public typealias DataType = CGPoint
    
    fileprivate var rangeX: ConfettiFloatRange
    fileprivate var rangeY: ConfettiFloatRange
    
    public init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.rangeX = ConfettiFloatRange(from: x, to: x + width)
        self.rangeY = ConfettiFloatRange(from: y, to: y + height)
    }
    
    public func random(decimal precision: UInt) -> DataType {
        
        let x = ConfettiSwift.random(from: rangeX.lowerBound, to: rangeX.upperBound, decimal: precision)
        let y = ConfettiSwift.random(from: rangeY.lowerBound, to: rangeY.upperBound, decimal: precision)
        
        return CGPoint(x: x, y: y)
    }
}

private func random(from lowerBound: Double, to upperBound: Double, decimal precision: UInt) -> Double {
    let offset = pow(10, Double(precision))
    
    return (Double(arc4random_uniform(UInt32(upperBound * offset - lowerBound * offset))) + lowerBound * offset) / offset
}
private func random(from lowerBound: Int, to upperBound: Int, decimal precision: UInt) -> Double {
    return random(from: Double(lowerBound), to: Double(upperBound), decimal: precision)
}
private func random(from lowerBound: CGFloat, to upperBound: CGFloat, decimal precision: UInt) -> Double {
    return random(from: Double(lowerBound), to: Double(upperBound), decimal: precision)
}


// MARK: -

class Confetti: NSObject {
    
    // MARK: *** 属性 ***
    
    ///displayLink
    private var displayLink: CADisplayLink?
    ///基准视图
    private var view: UIView
    ///起点范围
    private var startRange: ConfettiPointRange
    ///终点范围
    private var endRange: ConfettiPointRange
    
    ///色彩组(默认R G B三种颜色)
    public var colors: [UIColor] = [.red, .green, .blue]
    ///密度(每秒生成数量 默认20)
    public var density: Int = 20 {
        didSet {
            if #available(iOS 10.0, *) {
                displayLink?.preferredFramesPerSecond = density
            } else {
                displayLink?.frameInterval = 60 / density
            }
        }
    }
    ///移动时间(从初始位置移动到结束位置的时间 默认5秒)
    public var durationRange: ConfettiFloatRange = ConfettiFloatRange(from: 5.0, to: 5.0)
    
    // MARK: *** 构造 ***
    
    init(from startRange: ConfettiPointRange, to endRange: ConfettiPointRange) {
        self.view = (UIApplication.shared.delegate?.window)!!
        self.startRange = startRange
        self.endRange = endRange
        
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
    public func start(on view: UIView) {
        self.view = view
        start()
    }
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
        
        let startPoint = startRange.random(decimal: 1)
        let endPoint = endRange.random(decimal: 1)
        
        let confetti = UIView(frame: CGRect(x: startPoint.x, y: startPoint.y, width: 15.0, height: 15.0))
        let colorView = UIView(frame: CGRect(x: 3, y: 3, width: random(from: 5.0, to: 8.0, decimal: 1), height: random(from: 5.0, to: 8.0, decimal: 1)))
        
        confetti.backgroundColor = .clear
        
        colorView.backgroundColor = colors[Int(random(from: 0, to: colors.count, decimal: 0))]
        colorView.layer.transform = CATransform3DMakeRotation(CGFloat(random(from: 0, to: Double.pi * 2, decimal: 1)), CGFloat(random(from: -1, to: 1, decimal: 2)), CGFloat(random(from: -1, to: 1, decimal: 2)), CGFloat(random(from: -1, to: 1, decimal: 2)))
        
        view.addSubview(confetti)
        confetti.addSubview(colorView)
        
        UIView.animate(withDuration: TimeInterval(durationRange.random(decimal: 1)), animations: {
            confetti.layer.transform = CATransform3DMakeTranslation(endPoint.x, endPoint.y, 0)
        }) { (finish) in
            if finish {
                confetti.removeFromSuperview()
            }
        }
    }
}

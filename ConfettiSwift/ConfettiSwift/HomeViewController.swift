//
//  HomeViewController.swift
//  ConfettiSwift
//
//  Created by LarrySue on 2017/8/24.
//  Copyright © 2017年 personal. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

func RGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
    return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
}

// MARK: -

class HomeViewController: UIViewController {
    
    // MARK: *** 属性 ***
    
    private var isGoing: Bool = false
    private var confetti: Confetti?
    
    // MARK: *** 周期 ***

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startRange = ConfettiPointRange(x: 0, y: 0, width: screenWidth, height: 0)
        let endRange = ConfettiPointRange(x: -screenWidth * 1.5, y: screenHeight * 1.5, width: screenWidth * 4.0, height: screenHeight * 0.5)
        confetti = Confetti(from: startRange, to: endRange)
        
        ///此属性若不定义 则采用默认红绿蓝三色
        confetti!.colors = [RGB(0, 255.0, 255.0),
                           RGB(0, 191.0, 255.0),
                           RGB(255.0, 255.0, 0),
                           RGB(238.0, 44.0, 44.0),
                           RGB(154.0, 205.0, 50.0)]
        ///此属性若不定义 则默认密度为每秒20个
        confetti!.density = 15
        ///此属性若不定义 则色块持续移动时间默认为5秒
        confetti!.durationRange = ConfettiFloatRange(from: 6.0, to: 8.0)
    }
    
    // MARK: *** 回调 ***
    
    ///点击按钮
    @IBAction func goButtonDidClick(_ button: UIButton) {
        if isGoing {
            isGoing = false
            button.setTitle("GO !", for: .normal)
            confetti?.end()
        } else {
            isGoing = true
            button.setTitle("STOP !", for: .normal)
            confetti?.start()
        }
    }
}

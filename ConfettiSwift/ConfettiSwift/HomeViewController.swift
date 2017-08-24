//
//  HomeViewController.swift
//  ConfettiSwift
//
//  Created by LarrySue on 2017/8/24.
//  Copyright © 2017年 personal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: *** 属性 ***
    
    private var isGoing: Bool = false
    private var confetti: Confetti?
    
    // MARK: *** 周期 ***

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        title = "Confetti"
        
        view.addSubview(goBtn)
        
        let startPointRange = ConfettiPointRange(rect: CGRect(x: 0, y: 0, width: screenWidth, height: 0))
        let endPointRange = ConfettiPointRange(rect: CGRect(x: -screenWidth * 1.5, y: screenHeight * 1.5, width: screenWidth * 3.0, height: screenHeight * 0.5))
        confetti = Confetti(on: view, from: startPointRange, to: endPointRange)
        
        ///此属性若不定义 则采用默认红绿蓝三色
        confetti!.colors = [UIColor(red: 0, green: 255.0, blue: 255.0),
                           UIColor(red: 0, green: 191.0, blue: 255.0),
                           UIColor(red: 255.0, green: 255.0, blue: 0),
                           UIColor(red: 238.0, green: 44.0, blue: 44.0),
                           UIColor(red: 154.0, green: 205.0, blue: 50.0)]
        ///此属性若不定义 则默认密度为每秒20个
        confetti!.density = 15
    }
    
    // MARK: *** 布局 ***
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        goBtn.frame = CGRect(x: 30.0, y: screenHeight - 74.0, width: screenWidth - 60.0, height: 44.0)
    }
    
    // MARK: *** 回调 ***
    
    ///点击按钮
    @objc private func goButtonDidClick() {
        if isGoing {
            isGoing = false
            goBtn.setTitle("GO !", for: .normal)
            confetti?.end()
        } else {
            isGoing = true
            goBtn.setTitle("STOP !", for: .normal)
            confetti?.start()
        }
    }
    
    // MARK: *** 懒加载 ***
    
    private lazy var goBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(red: 100.0, green: 149.0, blue: 237.0)
        button.layer.cornerRadius = 3.0
        button.layer.masksToBounds = true
        button.setTitle("GO !", for: .normal)
        button.addTarget(self, action: #selector(goButtonDidClick), for: .touchUpInside)
        
        return button
    }()
}

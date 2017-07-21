//
//  DoneAccessoryView.swift
//  GameNote
//
//  Created by 劉進泰 on 2017/7/1.
//  Copyright © 2017年 劉進泰. All rights reserved.
//

import UIKit

class DoneAccessoryView: UIView {
    
    var doneButton:UIButton = UIButton()
    var doneDelegate:DoneMethodDelegate?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        doneButton.frame = CGRect(x: 320.0, y: (rect.height - 25.0) / 2.0, width: 50.0, height: 25.0)
        doneButton.setTitle("完成", for: .normal)
        doneButton.setTitleColor(.blue, for: .normal)
        doneButton.setTitleColor(.white, for: .highlighted)
        doneButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        self.addSubview(doneButton)
    }
    
    @objc private func buttonPressed() {
        doneDelegate?.doneButtonPressed()
    }
}

protocol DoneMethodDelegate {
    func doneButtonPressed()
}

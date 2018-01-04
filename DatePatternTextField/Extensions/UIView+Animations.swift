//
//  UIView+Animations.swift
//  DatePatternTextField
//
//  Created by Jad  on 04/01/2018.
//  Copyright © 2018 Jad . All rights reserved.
//

import UIKit

extension UIView {
	func pulsate() {
		
		let flash = CABasicAnimation(keyPath: "opacity")
		flash.duration = 0.4
		flash.fromValue = 1
		flash.toValue = 0.1
		flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		flash.autoreverses = true
		flash.repeatCount = Float.infinity
		layer.add(flash, forKey: nil)
	}
}

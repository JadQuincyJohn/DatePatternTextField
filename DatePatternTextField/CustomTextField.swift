//
//  CustomTextField.swift
//  DatePatternTextField
//
//  Created by Jad  on 04/01/2018.
//  Copyright © 2018 Jad . All rights reserved.
//

import UIKit

protocol CustomTextFieldDelegate : class {
	func userDidTapBackSpace(textField: UITextField)
}

class CustomTextField: UITextField {
	
	weak var backDelegate: CustomTextFieldDelegate?
	
	lazy var focusView: UIView = {
		let focus = UIView()
		focus.backgroundColor = .sunFlower
		focus.frame =  CGRect(x: 0, y: bounds.size.height, width: bounds.width, height: 2)
		focus.layer.cornerRadius = 4
		focus.layer.masksToBounds = true
		return focus
	}()
	
	override func deleteBackward() {
		backDelegate?.userDidTapBackSpace(textField: self)
	}
	
	func setOn() {
		text = nil
		startAnimating()
		becomeFirstResponder()
	}
	
	func setOff() {
		stopAnimating()
		resignFirstResponder()
	}
	
	private func startAnimating() {
		addSubview(focusView)
		focusView.pulsate()
	}
	
	private func stopAnimating() {
		focusView.removeFromSuperview()
	}
}

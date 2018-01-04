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
	
	override func deleteBackward() {
		backDelegate?.userDidTapBackSpace(textField: self)
	}

}

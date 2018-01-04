//
//  ViewController.swift
//  DatePatternTextField
//
//  Created by Jad  on 03/01/2018.
//  Copyright © 2018 Jad . All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {
	
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var cursorView: UIView!
	
	let viewModel = ViewModel()
	
	lazy var fields : [CustomTextField] = {
		return viewModel.inputsOnly.map({
			createField(char: $0)
		})
	}()
	
	var inputs = [Int]() {
		didSet {
			DispatchQueue.main.async { [unowned self] in
				
				guard self.fields.count != self.inputs.count else {
					return
				}
				
				let textField = self.fields[self.inputs.count]
				self.setFocus(on: textField)
				textField.becomeFirstResponder()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Save the date !"
		configureNavBar()
		configureView()
		configureTextFields()
		inputs = [Int]()
	}
	
	@objc func reset(button: UIButton) {
		fields.forEach { $0.text = nil }
		inputs.removeAll()
	}
	
	fileprivate func configureNavBar() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createResetButton())
	}
	
	fileprivate func configureView() {
		view.backgroundColor = .greenSea
	}
	
	fileprivate func configureTextFields() {
		
		fields.forEach {
			stackView.addArrangedSubview($0)
		}
		
		viewModel.indexesOfSeparators.forEach {
			stackView.insertArrangedSubview(createSeparator(), at: $0)
		}
	}
}

extension ExampleViewController : UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		let currentCharacterCount = textField.text?.characters.count ?? 0
		if (range.length + range.location > currentCharacterCount){
			return false
		}
		let newLength = currentCharacterCount + string.characters.count - range.length
		
		let shouldChangeCharactersIn = newLength <= 1
		return shouldChangeCharactersIn
		
	}

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		
		let indexOfTextField = fields.index(of: textField as! CustomTextField)
		return indexOfTextField == inputs.count
	}
	
	@objc func textFieldDidChange(textField: UITextField) {
		
		guard
			let index = fields.index(of: textField as! CustomTextField),
			let input = textField.text
			else {
				return
		}
		
		inputs.append(Int(input)!)
		
		guard index < fields.count - 1 else {
			textField.resignFirstResponder()
			setFocusOff()
			return
		}
	}
}

fileprivate extension ExampleViewController {
	
	// Creates a Custom TextField
	func createField(char : Character) -> CustomTextField {
		let textField = CustomTextField.init()
		textField.placeholder = String.init(char)
		textField.keyboardType = .numberPad
		textField.tintColor = .clear
		textField.textColor = .white
		textField.font = viewModel.font
		textField.textAlignment = .center
		textField.delegate = self
		textField.backDelegate = self
		textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
		return textField
	}
	
	// Creates a Separator Label
	func createSeparator() -> UILabel {
		let label = UILabel()
		label.text = String.init(viewModel.separator)
		label.textAlignment = .center
		label.font = viewModel.font
		return label
	}
	
	// Create a BarButton Item 'Reset'
	func createResetButton() -> UIButton {
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
		button.setTitle("Reset", for: .normal)
		button.addTarget(self, action: #selector(reset(button:)), for: .touchUpInside)
		button.setTitleColor(.greenSea, for: .normal)
		return button
	}
	
	// TODO change to use only one view
	func setFocus(on textField: CustomTextField) {
		
		textField.text = nil
		cursorView.subviews.forEach {
			$0.removeFromSuperview()
		}
		
		let focusRect = CGRect(x: textField.frame.origin.x,
		                       y: 0,
		                       width: textField.bounds.width,
		                       height: 2)
		
		let focus = UIView()
		focus.backgroundColor = .sunFlower
		focus.frame = focusRect
		focus.layer.cornerRadius = 4
		focus.layer.masksToBounds = true
		cursorView.addSubview(focus)
		focus.pulsate()
	}
	
	func setFocusOff() {
		cursorView.subviews.forEach {
			$0.removeFromSuperview()
		}
	}
}

extension ExampleViewController : CustomTextFieldDelegate {
	func userDidTapBackSpace(textField: UITextField) {
		guard inputs.count > 0 else {
			return
		}
		inputs.removeLast()
	}
}


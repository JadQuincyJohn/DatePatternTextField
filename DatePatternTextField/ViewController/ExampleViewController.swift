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
	
	let viewModel = ViewModel()
	
	lazy var fields : [CustomTextField] = {
		return viewModel.inputsOnly.map({
			createField(char: $0)
		})
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Save the date !"
		setupNavBar()
		setupView()
		setupTextFields()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setInitialFocus()
	}
	
	fileprivate func setInitialFocus() {
		fields.first?.setOn()
	}
	
	fileprivate func setupNavBar() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createResetButton())
	}
	
	fileprivate func setupView() {
		view.backgroundColor = .greenSea
	}
	
	fileprivate func setupTextFields() {
		
		fields.forEach {
			stackView.addArrangedSubview($0)
		}
		
		viewModel.indexesOfSeparators.forEach {
			stackView.insertArrangedSubview(createSeparator(), at: $0)
		}
	}
	
	//MARK:- Actions
	@objc func reset(button: UIButton) {
		viewModel.removeAllInputs()
		setInitialFocus()
		fields.forEach { $0.text = nil }
	}
	
	@objc func textFieldDidChange(textField: UITextField) {
		
		let currentField = textField as! CustomTextField
		
		guard
			let index = fields.index(of: currentField),
			let textInput = currentField.text,
			let input = Int(textInput)
		else {
			return
		}
		
		viewModel.addInput(input)
		
		guard index < viewModel.maximumNumberOfInputs - 1 else {
			currentField.setOff()
			return
		}
		
		let nextField = fields[viewModel.currentNumberOfInputs]
		nextField.setOn()
	}
}

extension ExampleViewController : UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		let currentCharacterCount = textField.text?.count ?? 0
		if (range.length + range.location > currentCharacterCount){
			return false
		}
		let newLength = currentCharacterCount + string.count - range.length
		
		let shouldChangeCharactersIn = newLength <= 1
		return shouldChangeCharactersIn
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return fields.index(of: textField as! CustomTextField) == viewModel.currentNumberOfInputs
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		(textField as! CustomTextField).setOff()
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
}

extension ExampleViewController : CustomTextFieldDelegate {
	func userDidTapBackSpace(textField: UITextField) {
		viewModel.removeLastInput()
		let field = fields[viewModel.currentNumberOfInputs]
		field.setOn()
	}
}

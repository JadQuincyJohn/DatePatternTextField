//
//  ViewController.swift
//  DatePatternTextField
//
//  Created by Jad  on 03/01/2018.
//  Copyright © 2018 Jad . All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ExampleViewController: UIViewController {
	
	@IBOutlet weak var stackView: UIStackView!
	
	let viewModel = ViewModel()
	let disposeBag = DisposeBag()
	
	lazy var fields : [CustomTextField] = {
		viewModel.inputsOnly.enumerated().map { (index, element) in
			let field = createField()
			field.bind(with: viewModel.fieldModels[index])
			return field
		}
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
	
	// TODO : Drive with viewModel instead of calling directly
	fileprivate func setInitialFocus() {
		fields.first?.setOn()
	}
	
	fileprivate func setupNavBar() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: resetButton)
	}
	
	fileprivate func setupView() {
		view.backgroundColor = .greenSea
	}
	
	fileprivate func setupTextFields() {
		
		let lowerCasedFormat = viewModel.dateFormat.lowercased()
		
		var index = 0
		lowerCasedFormat.forEach { char in
			if viewModel.units.contains(String(char)) {
				stackView.addArrangedSubview(fields[index])
				index = index + 1
			}
			else {
				stackView.addArrangedSubview(createSeparator(char))
			}
		}
	}
}

extension ExampleViewController : UITextFieldDelegate {
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return fields.index(of: textField as! CustomTextField) == viewModel.currentNumberOfInputs
	}
}

fileprivate extension ExampleViewController {
	
	// Creates a Custom TextField
	func createField() -> CustomTextField {
		let textField = CustomTextField.init()
		textField.keyboardType = .numberPad
		textField.tintColor = .clear
		textField.textColor = .white
		textField.textAlignment = .center
		textField.font = viewModel.font
		textField.delegate = self
		textField.backDelegate = self
		
		textField.rx.controlEvent(.editingChanged)
			.subscribe(onNext: { [unowned self] in
				
				guard let input = textField.text, let index = self.fields.index(of: textField) else {
						return
				}
				
				// Update current input
				self.viewModel.setInput(input: input, at: index)
				
				// If the last input was set => end editing fields
				guard index < self.viewModel.maximumNumberOfInputs - 1 else {
					self.view.endEditing(true)
					return
				}
				
				let nextField = self.fields[self.viewModel.currentNumberOfInputs]
				nextField.setOn()
				
			})
			.disposed(by: disposeBag)
		
		textField.rx.controlEvent(.editingDidEnd)
			.subscribe(onNext: {
				textField.setOff()
			})
			.disposed(by: disposeBag)
		
		return textField
	}
	
	// Creates a Separator Label
	func createSeparator(_ char: Character) -> UILabel {
		let label = UILabel()
		label.text = String.init(char)
		label.textAlignment = .center
		label.font = viewModel.font
		return label
	}
	
	// Reset Button
	var resetButton: UIButton {
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
		button.setTitle("Reset", for: .normal)
		button.setTitleColor(.greenSea, for: .normal)
		button.rx.tap
			.subscribe(onNext: { [unowned self] in
				self.viewModel.removeAllInputs()
				self.setInitialFocus()
			})
			.disposed(by: disposeBag)
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

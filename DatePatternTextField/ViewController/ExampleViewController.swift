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
		
		fields.forEach {
			stackView.addArrangedSubview($0)
		}
		
		viewModel.indexesOfSeparators.forEach {
			stackView.insertArrangedSubview(createSeparator(), at: $0)
		}
	}
}

// TODO make RXCompatible
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
				
				self.viewModel.setInput(input: input, at: index)
				
				guard index < self.viewModel.maximumNumberOfInputs - 1 else {
					textField.setOff()
					return
				}
				
				let nextField = self.fields[self.viewModel.currentNumberOfInputs]
				nextField.setOn()
				
			})
			.disposed(by: disposeBag)
		
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

//
//  ViewModel.swift
//  DatePatternTextField
//
//  Created by Jad  on 04/01/2018.
//  Copyright © 2018 Jad . All rights reserved.
//

import UIKit
import RxSwift


class ViewModel {
	
	var dateFormat = "dd-MM-yyyy"
	let font = UIFont.init(name: "Helvetica-Bold", size: 28)
	
	var units = ["d","m","y"]

	var separator : Character {
		let sep = dateFormat.first { !units.contains(String($0)) }
		return sep!
	}

	lazy var fieldModels: [FieldViewModel] = {
		inputsOnly.enumerated().map({ (index, character) in
			var fieldViewModel = DigitViewModel()
			fieldViewModel.placeHolder = String(character)
			return fieldViewModel
		})
	}()
	
	var currentNumberOfInputs: Int {
		let numberOfInputs = fieldModels.filter {
			$0.value.value != ""
		}
		return numberOfInputs.count
	}
	
	func setInput(input: String, at index: Int) {
		fieldModels[index].value.value = input
	}
	
	func removeLastInput() {
		let field = fieldModels.reversed().first {
			$0.value.value != ""
		}
		field?.value.value = ""
		
	}
	
	func removeAllInputs() {
		fieldModels.forEach {
			$0.value.value = ""
		}
	}
	
	var maximumNumberOfInputs: Int {
		return inputsOnly.count
	}
	
	var inputsOnly: String {
		return dateFormat.replacingOccurrences(of: String(separator), with: "")
	}
}

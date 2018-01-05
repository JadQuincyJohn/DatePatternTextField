//
//  ViewModel.swift
//  DatePatternTextField
//
//  Created by Jad  on 04/01/2018.
//  Copyright © 2018 Jad . All rights reserved.
//

import UIKit


class ViewModel {
	
	var dateFormat = "dd/MM/yyyy"
	var separator : Character = "/"
	let font = UIFont.init(name: "Helvetica-Bold", size: 28)
	
	private var inputs = [Int]()
	
	var currentNumberOfInputs: Int {
		return inputs.count
	}
	
	func addInput(_ input: Int) {
		guard currentNumberOfInputs != maximumNumberOfInputs else {
			return
		}
		inputs.append(input)
	}
	
	func removeLastInput() {
		guard !inputs.isEmpty else {
			return
		}
		inputs.removeLast()
	}
	
	func removeAllInputs() {
		inputs.removeAll()
	}
	
	var maximumNumberOfInputs: Int {
		return inputsOnly.count
	}
	
	var indexesOfSeparators: [Int] {
		// TODO
		return [2,5]
	}
	
	var inputsOnly: String {
		return dateFormat.replacingOccurrences(of: String(separator), with: "")
	}
}

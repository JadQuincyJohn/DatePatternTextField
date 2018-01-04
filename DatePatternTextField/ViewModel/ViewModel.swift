//
//  ViewModel.swift
//  DatePatternTextField
//
//  Created by Jad  on 04/01/2018.
//  Copyright © 2018 Jad . All rights reserved.
//

import UIKit


class ViewModel {
	
	let dateFormat = "dd/MM/yyyy"
	let separator : Character = "/"
	let font = UIFont.init(name: "Helvetica-Bold", size: 28)
	
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

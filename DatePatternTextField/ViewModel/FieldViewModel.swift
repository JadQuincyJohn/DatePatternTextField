//
//  FieldViewModel.swift
//  DatePatternTextField
//
//  Created by Jad  on 05/01/2018.
//  Copyright © 2018 Jad . All rights reserved.
//

import Foundation
import RxSwift

struct DigitViewModel: FieldViewModel {
	var value: Variable<String> = Variable("")
	var placeHolder: String = ""
}

protocol FieldViewModel {
	var value: Variable<String> { get set }
	var placeHolder: String { get }
}




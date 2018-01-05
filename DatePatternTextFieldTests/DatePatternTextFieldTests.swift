//
//  DatePatternTextFieldTests.swift
//  DatePatternTextFieldTests
//
//  Created by Jad  on 03/01/2018.
//  Copyright © 2018 Jad . All rights reserved.
//

import XCTest
@testable import DatePatternTextField

class DatePatternTextFieldTests: XCTestCase {
	
	var viewModel = ViewModel()
	
    override func setUp() {
        super.setUp()
	}
    
    override func tearDown() {
        super.tearDown()
		viewModel.removeAllInputs()
    }
	
	func test_maximumNumberOfInputs() {
		// Given
		// When
		viewModel.dateFormat = "DD/mm"
		// Then
		XCTAssertEqual(viewModel.maximumNumberOfInputs, 4)
	}
	
	func test_addInput() {
		// Given
		viewModel.dateFormat = "DD/MM/yyyy"		
		// When
		viewModel.addInput(1)
		viewModel.addInput(3)
		viewModel.addInput(0)
		viewModel.addInput(1)
		viewModel.addInput(2)
		viewModel.addInput(0)
		viewModel.addInput(1)
		viewModel.addInput(8)
		// Then
		XCTAssertEqual(viewModel.currentNumberOfInputs, 8)
	}
	
	func test_addInput_outOfBounds() {
		// Given
		let viewModel = ViewModel()
		viewModel.dateFormat = "DD/MM/YYYY"
		// When
		viewModel.addInput(1)
		viewModel.addInput(3)
		viewModel.addInput(0)
		viewModel.addInput(1)
		viewModel.addInput(2)
		viewModel.addInput(0)
		viewModel.addInput(1)
		viewModel.addInput(8)
		viewModel.addInput(9)
		viewModel.addInput(9)
		// Then
		XCTAssertEqual(viewModel.currentNumberOfInputs, 8)
	}
	
	func test_removeInput() {
		// Given
		let viewModel = ViewModel()
		viewModel.dateFormat = "DD/MM/YYYY"
		// When
		viewModel.addInput(1)
		viewModel.addInput(3)
		viewModel.addInput(0)
		viewModel.addInput(1)
		viewModel.addInput(2)
		viewModel.addInput(0)
		viewModel.addInput(1)
		viewModel.addInput(8)
		viewModel.removeLastInput()
		viewModel.removeLastInput()
		// Then
		XCTAssertEqual(viewModel.currentNumberOfInputs, 6)
	}
	
	func test_removeAllInputs() {
		// Given
		let viewModel = ViewModel()
		viewModel.dateFormat = "DD/MM/YYYY"
		// When
		viewModel.addInput(1)
		viewModel.addInput(3)
		viewModel.addInput(0)
		viewModel.addInput(1)
		viewModel.removeAllInputs()
		// Then
		XCTAssertEqual(viewModel.currentNumberOfInputs, 0)
	}
	
}

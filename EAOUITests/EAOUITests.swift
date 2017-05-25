//
//  EAOUITests.swift
//  EAOUITests
//
//  Created by Micha Volin on 2017-05-16.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import XCTest

class EAOUITests: XCTestCase {
	
	let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
		app.launchArguments = ["UITests"]
        app.launch()
		XCUIDevice.shared().orientation = .faceUp
    }
    
    override func tearDown() {
        super.tearDown()
		
    }
    
    func testExample() {
		app.scrollViews.otherElements.textFields["Username"].tap()
		app.scrollViews.otherElements.textFields["Username"].typeText("Emma")
		app.scrollViews.otherElements.secureTextFields["Password"].tap()
		app.scrollViews.otherElements.secureTextFields["Password"].typeText("emma")
		app.buttons["LOGIN"].tap()
		
		app.buttons["   Add New Inspection   "].tap()
		
		app.scrollViews.buttons["Link Project"].tap()
 
		app.tables.staticTexts["29694 Marshall Road Extension"].tap()
		
		
		
//
//		app.buttons["   Add New Inspection   "].tap()
//		
//		let scrollViewsQuery = app.scrollViews
//	 
//		elementsQuery.buttons["link project"].tap()
//		
//		let tablesQuery = app2.tables
//		tablesQuery.staticTexts["29694 Marshall Road Extension"].tap()
//		
//		let titleTextField = elementsQuery.textFields["Title..."]
//		titleTextField.tap()
//		titleTextField.typeText("d")
//		
//		let subtitleTextField = elementsQuery.textFields["Subtitle..."]
//		subtitleTextField.tap()
//		subtitleTextField.typeText("f")
//		
//		let subtextTextField = elementsQuery.textFields["Subtext..."]
//		subtextTextField.tap()
//		subtextTextField.typeText("f")
//		
//		let inspectionNumberTextField = elementsQuery.textFields["Inspection number..."]
//		inspectionNumberTextField.tap()
//		inspectionNumberTextField.typeText(";")
//		app2.buttons["Return"].tap()
//		
//		elementsQuery.buttons["Inspection Start Date"].tap()
//		
//		let selectButton = app.buttons["Select"]
//		selectButton.tap()
//		
//		let inspectionEndDateButton = elementsQuery.buttons["Inspection End Date"]
//		inspectionEndDateButton.tap()
//
//		
//		let datePickersQuery = app.datePickers
//		datePickersQuery.pickerWheels["16"].tap()
//		datePickersQuery.pickerWheels["May"].tap()
//		datePickersQuery.pickerWheels["2017"].swipeUp()
//		selectButton.tap()
//		app2.buttons["Create Inspection"].tap()
//		app.buttons["icon add grey"].tap()
//		elementsQuery.buttons["Add Voice"].tap()
//		
//		let titleTextField2 = elementsQuery.textFields["Title"]
//		titleTextField2.tap()
//		titleTextField2.typeText("f")
//		
//		let requirementTextField = elementsQuery.textFields["Requirement"]
//		requirementTextField.tap()
//		requirementTextField.typeText("g")
		
	 
		
		
    }
    
}










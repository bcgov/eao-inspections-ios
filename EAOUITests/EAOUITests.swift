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
	

	
    func testAddingData() {
		XCUIDevice.shared().orientation = .faceUp
		XCUIDevice.shared().orientation = .faceUp
		
		let app = XCUIApplication()
		app.buttons["LOGIN"].tap()
		
		for i in 1...2{
			
			app.buttons["   Add New Inspection   "].tap()
			
			let elementsQuery = app.scrollViews.otherElements
			elementsQuery.buttons["Link Project"].tap()
			app.navigationBars["EAO.ProjectList"].buttons["Custom"].tap()
		 
			let projectNameAlert = app.alerts["Project name"]
			projectNameAlert.collectionViews.textFields["Start Typing..."].typeText("\(i)")
			projectNameAlert.buttons["Select"].tap()
			
			
			let titleTextField = elementsQuery.textFields["Title..."]
			titleTextField.tap()
			titleTextField.typeText("\(i)")
			
			let returnButton = app.buttons["Return"]
			returnButton.tap()
			
			
			let subtitleTextField = elementsQuery.textFields["Subtitle..."]
			subtitleTextField.tap()
			subtitleTextField.typeText("q")
			returnButton.tap()
			
			
			let subtextTextField = elementsQuery.textFields["Subtext..."]
			subtextTextField.tap()
			subtextTextField.typeText("q")
			returnButton.tap()
			
			
			let inspectionNumberTextField = elementsQuery.textFields["Inspection number..."]
			inspectionNumberTextField.tap()
			inspectionNumberTextField.typeText("1")
			returnButton.tap()
			
			
			elementsQuery.buttons["Inspection Start Date"].tap()
			app.datePickers.pickerWheels["1"].adjust(toPickerWheelValue: "\(i)")
			app.buttons["Select"].tap()
			
			
			elementsQuery.buttons["Inspection End Date"].tap()
			app.datePickers.pickerWheels["1"].adjust(toPickerWheelValue: "\(i)")
			app.buttons["Select"].tap()
			
			app.buttons["Create Inspection"].tap()
			
			for _ in 0...2{
				app.buttons["icon add grey"].tap()
				
				let titleTextField2 = elementsQuery.textFields["Title"]
				titleTextField2.tap()
				titleTextField2.typeText("q")
				returnButton.tap()
				
				let requirementTextField = elementsQuery.textFields["Requirement"]
				requirementTextField.tap()
				requirementTextField.typeText("q")
				returnButton.tap()
				
				app.buttons["Tap to enter description"].tap()
				app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element.typeText(descriptionText)
				 
				app.navigationBars["Element Description"].buttons["Done"].tap()
				
				for _ in 0...2{
					//add photos
					app.collectionViews.buttons["icon add photo"].tap()
					app.buttons["icon camera"].tap()
					app.sheets.buttons["Photo Library"].tap()
					app.tables.buttons["Moments"].tap()
					app.collectionViews["PhotosGridView"].children(matching: .cell).matching(identifier: "Photo, Portrait, May 30, 8:18 PM").element(boundBy: 2).tap()
					
					let textView = app.scrollViews.children(matching: .textView).element
					textView.tap()
					textView.typeText("Captioin")
					
					app.navigationBars["EAO.UploadPhoto"].buttons["Save"].tap()
				}
				
				app.navigationBars["EAO.NewObservation"].buttons["Save"].tap()
			}
			
			app.navigationBars["EAO.InspectionForm"].buttons["Save"].tap()
			app.alerts["Tip"].buttons["Okay"].tap()
			
		}
    }
    
}






let descriptionText = "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled "



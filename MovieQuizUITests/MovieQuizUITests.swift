//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by SERGEY SHLYAKHIN on 02.12.2022.
//

import XCTest

class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        let firstPoster = app.images["POSTER"]
        let indexLabel = app.staticTexts["INDEX"]
        XCTAssertEqual(indexLabel.label, "1/10")
        
        app.buttons["YES"].tap()
        
        sleep(3)
        
        let secondPoster = app.images["POSTER"]
        
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        let firstPoster = app.images["POSTER"]
        let indexLabel = app.staticTexts["INDEX"]
        XCTAssertEqual(indexLabel.label, "1/10")
        
        let noButton = app.buttons["NO"]
        noButton.tap()
        sleep(3)
        
        let secondPoster = app.images["POSTER"]
        
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertEqual(indexLabel.label, "2/10")
        
        noButton.tap()
        sleep(3)
        
        XCTAssertEqual(indexLabel.label, "3/10")
    }
    
    func testAlert() {
        let noButton = app.buttons["NO"]
        let indexLabel = app.staticTexts["INDEX"]
        
        sleep(3)
        for _ in 1...10 {
            noButton.tap()
            sleep(3)
        }
        XCTAssertTrue(indexLabel.label == "10/10")
        
        sleep(5)
        let alert = app.alerts["ALERT"] // как вариант: let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label,"Этот раунд окончен!")

        let button = alert.buttons.firstMatch
        XCTAssertEqual(button.label, "Сыграть ещё раз")

        button.tap()
        sleep(3)
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}

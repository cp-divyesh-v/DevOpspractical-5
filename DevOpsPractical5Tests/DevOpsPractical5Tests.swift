//
//  DevOpsPractical5Tests.swift
//  DevOpsPractical5Tests
//
//  Created by Divyesh Vekariya on 23/03/24.
//

import XCTest

final class DevOpsPractical5Tests: XCTestCase {
    
    var viewModel: TimerViewModel!
    
    override func setUpWithError() throws {
        viewModel = TimerViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testStartTimer() throws {
        viewModel.startTimer()
        XCTAssertTrue(viewModel.isTimerRunning, "Timer should be running after calling startTimer")
    }
    
    func testStopTimer() throws {
        viewModel.startTimer()
        viewModel.stopTimer()
        XCTAssertFalse(viewModel.isTimerRunning, "Timer should not be running after calling stopTimer")
    }
    
    func testResetTimer() throws {
        viewModel.startTimer()
        viewModel.resetTimer()
        XCTAssertFalse(viewModel.isTimerRunning, "Timer should not be running after calling resetTimer")
        XCTAssertEqual(viewModel.hours, 0, "Hours should be reset to 0 after calling resetTimer")
        XCTAssertEqual(viewModel.minutes, 0, "Minutes should be reset to 0 after calling resetTimer")
        XCTAssertEqual(viewModel.seconds, 0, "Seconds should be reset to 0 after calling resetTimer")
        XCTAssertEqual(viewModel.remainingTime, 0, "Remaining time should be reset to 0 after calling resetTimer")
        XCTAssertEqual(viewModel.elapsedTime, 0, "Elapsed time should be reset to 0 after calling resetTimer")
    }
    
    func testShowNotification() throws {
        viewModel.showNotification()
    }
}

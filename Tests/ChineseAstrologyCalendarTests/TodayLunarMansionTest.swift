import XCTest
@testable import ChineseAstrologyCalendar

final class TodayLunarMansionTest: XCTestCase {
    
    func testTodayLunarMansion() {
        let today = Date()
        let mansion = LunarMansion.lunarMansion(date: today)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        formatter.timeZone = TimeZone.current
        
        print("Current time: \(formatter.string(from: today))")
        print("Current lunar mansion: \(mansion.rawValue)")
        print("Four Symbol: \(mansion.fourSymbol.rawValue)")
        
        // Test at different times today to ensure consistency
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: today)
        let noon = calendar.date(byAdding: .hour, value: 12, to: startOfDay)!
        let endOfDay = calendar.date(byAdding: .hour, value: 23, to: startOfDay)!
        
        let mansionStartOfDay = LunarMansion.lunarMansion(date: startOfDay)
        let mansionNoon = LunarMansion.lunarMansion(date: noon)
        let mansionEndOfDay = LunarMansion.lunarMansion(date: endOfDay)
        
        print("\nSame-day verification:")
        print("Start of day (00:00): \(mansionStartOfDay.rawValue)")
        print("Noon (12:00): \(mansionNoon.rawValue)")
        print("End of day (23:00): \(mansionEndOfDay.rawValue)")
        
        // All times on the same day should show the same mansion
        XCTAssertEqual(mansionStartOfDay, mansionNoon, "Mansion should be same at start of day and noon")
        XCTAssertEqual(mansionNoon, mansionEndOfDay, "Mansion should be same at noon and end of day")
        
        // Log expected mansion for July 28, 2025 based on our test results
        let july28_2025 = Calendar.current.date(from: DateComponents(
            timeZone: TimeZone(identifier: "UTC")!,
            year: 2025,
            month: 7,
            day: 28,
            hour: 12
        ))!
        
        let expectedMansion = LunarMansion.lunarMansion(date: july28_2025)
        print("\nExpected for July 28, 2025 UTC: \(expectedMansion.rawValue)")
        
        // Verify that today's mansion is a valid one
        XCTAssertTrue(LunarMansion.allCases.contains(mansion), "Should return a valid lunar mansion")
    }
    
    func testSpecificDateMansions() {
        // Test some specific dates to verify our calculation
        let testCases = [
            (2025, 7, 28, "张宿"), // Based on our previous test results
            (2025, 7, 29, "翼宿"),
            (2025, 7, 30, "轸宿"),
            (2025, 7, 31, "奎宿"),
            (2025, 8, 1, "娄宿"),
            (2025, 8, 2, "昴宿"),
            (2025, 8, 3, "毕宿")
        ]
        
        print("\nVerifying specific dates:")
        for (year, month, day, expectedMansionName) in testCases {
            let calendar = Calendar(identifier: .gregorian)
            let components = DateComponents(
                calendar: calendar,
                timeZone: TimeZone(identifier: "UTC")!,
                year: year,
                month: month,
                day: day,
                hour: 12
            )
            
            guard let date = calendar.date(from: components) else { continue }
            
            let mansion = LunarMansion.lunarMansion(date: date)
            print("\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day)): \(mansion.rawValue) (expected: \(expectedMansionName))")
            
            XCTAssertEqual(mansion.rawValue, expectedMansionName, 
                          "Date \(year)-\(month)-\(day) should have mansion \(expectedMansionName)")
        }
    }
}
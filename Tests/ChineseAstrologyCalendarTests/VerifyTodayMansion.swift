import XCTest
@testable import ChineseAstrologyCalendar

final class VerifyTodayMansion: XCTestCase {
    
    func testTodayMansion() {
        let today = Date()
        let mansion = LunarMansion.lunarMansion(date: today)
        
        print("Today's lunar mansion: \(mansion.rawValue)")
        print("User expected: 女宿")
        
        // Test specifically for July 28, 2025 at noon UTC
        let calendar = Calendar(identifier: .gregorian)
        let july28_2025_noon = calendar.date(from: DateComponents(
            timeZone: TimeZone(identifier: "UTC")!,
            year: 2025,
            month: 7,
            day: 28,
            hour: 12
        ))!
        
        let mansionJuly28 = LunarMansion.lunarMansion(date: july28_2025_noon)
        print("July 28, 2025 noon UTC: \(mansionJuly28.rawValue)")
        
        XCTAssertEqual(mansionJuly28, .nuXiu, "July 28, 2025 should be 女宿")
    }
}
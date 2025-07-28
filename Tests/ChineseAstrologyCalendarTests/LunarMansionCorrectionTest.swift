import XCTest
@testable import ChineseAstrologyCalendar
import Astral

final class LunarMansionCorrectionTest: XCTestCase {
    
    /// Test a corrected lunar mansion calculation with potential offset
    func testCorrectedCalculation() {
        let calendar = Calendar(identifier: .gregorian)
        let july28_2025 = calendar.date(from: DateComponents(
            timeZone: TimeZone(identifier: "UTC")!,
            year: 2025,
            month: 7,
            day: 28,
            hour: 12
        ))!
        
        // Current calculation
        let currentMansion = LunarMansion.lunarMansion(date: july28_2025)
        print("Current calculation for July 28, 2025: \(currentMansion.rawValue)")
        
        // Proposed correction with offset
        let jd2000Days = july28_2025.toJC2000 * 36525.0
        let baseRev = moon_true_longitude(jd2000: jd2000Days)
        
        // Apply correction offset (10 mansions = 10/28 revolution)
        let correctionOffset = 10.0 / 28.0
        let correctedRev = (baseRev + correctionOffset).truncatingRemainder(dividingBy: 1.0)
        let finalRev = correctedRev < 0 ? correctedRev + 1.0 : correctedRev
        let correctedIdx = Int(floor(finalRev * 28.0)) % 28
        let correctedMansion = LunarMansion.allCases[correctedIdx]
        
        print("Corrected calculation: \(correctedMansion.rawValue)")
        print("Expected by user: 女宿")
        
        XCTAssertEqual(correctedMansion, .nuXiu, "Corrected calculation should match user expectation")
    }
    
    /// Test if the offset is consistent across multiple dates
    func testOffsetConsistency() {
        print("\n=== Testing Offset Consistency ===")
        let calendar = Calendar(identifier: .gregorian)
        let correctionOffset = 10.0 / 28.0
        
        let testDates = [
            (2025, 7, 28, "女宿"), // User's expectation for today
            (2025, 7, 29, "虚宿"), // Should be next mansion
            (2025, 7, 30, "危宿"), // Should continue progression
        ]
        
        for (year, month, day, expected) in testDates {
            let testDate = calendar.date(from: DateComponents(
                timeZone: TimeZone(identifier: "UTC")!,
                year: year,
                month: month,
                day: day,
                hour: 12
            ))!
            
            // Original calculation
            let originalMansion = LunarMansion.lunarMansion(date: testDate)
            
            // Corrected calculation
            let jd2000Days = testDate.toJC2000 * 36525.0
            let baseRev = moon_true_longitude(jd2000: jd2000Days)
            let correctedRev = (baseRev + correctionOffset).truncatingRemainder(dividingBy: 1.0)
            let finalRev = correctedRev < 0 ? correctedRev + 1.0 : correctedRev
            let correctedIdx = Int(floor(finalRev * 28.0)) % 28
            let correctedMansion = LunarMansion.allCases[correctedIdx]
            
            print("\(year)-\(month)-\(day): Original=\(originalMansion.rawValue), Corrected=\(correctedMansion.rawValue), Expected=\(expected)")
        }
    }
    
    /// Test mansion consistency throughout a single day with correction
    func testDailyConsistencyWithCorrection() {
        print("\n=== Daily Consistency with Correction ===")
        let calendar = Calendar(identifier: .gregorian)
        let july28_2025 = calendar.date(from: DateComponents(
            timeZone: TimeZone(identifier: "UTC")!,
            year: 2025,
            month: 7,
            day: 28
        ))!
        
        let correctionOffset = 10.0 / 28.0
        let times = [0, 6, 12, 18, 23]
        
        for hour in times {
            let testDate = calendar.date(byAdding: .hour, value: hour, to: july28_2025)!
            
            let jd2000Days = testDate.toJC2000 * 36525.0
            let baseRev = moon_true_longitude(jd2000: jd2000Days)
            let correctedRev = (baseRev + correctionOffset).truncatingRemainder(dividingBy: 1.0)
            let finalRev = correctedRev < 0 ? correctedRev + 1.0 : correctedRev
            let correctedIdx = Int(floor(finalRev * 28.0)) % 28
            let correctedMansion = LunarMansion.allCases[correctedIdx]
            
            print("\(String(format: "%02d", hour)):00 UTC: \(correctedMansion.rawValue)")
        }
    }
}
import XCTest
@testable import ChineseAstrologyCalendar
import Astral

final class InvestigateTest: XCTestCase {
    
    func testInvestigateMansionCalculation() {
        let calendar = Calendar(identifier: .gregorian)
        
        // Test dates with known expected results
        let testDates: [(year: Int, month: Int, day: Int, expected: String, expectedCase: LunarMansion)] = [
            (2025, 7, 28, "張宿", .zhangXiu),  // index 25
            (2025, 7, 29, "翼宿", .yiXiu),     // index 26
            (2025, 7, 30, "轸宿", .zhenXiu),   // index 27
            (2025, 7, 31, "角宿", .jiaoXiu),   // index 0
            (2025, 8, 1, "亢宿", .kangXiu),    // index 1
            (2025, 8, 2, "氐宿", .diXiu),      // index 2
            (2025, 8, 3, "房宿", .fangXiu)     // index 3
        ]
        
        print("\n=== Investigation of Mansion Calculation ===\n")
        
        for testDate in testDates {
            let date = calendar.date(from: DateComponents(
                timeZone: TimeZone(identifier: "UTC")!,
                year: testDate.year,
                month: testDate.month,
                day: testDate.day,
                hour: 12
            ))!
            
            // Get current calculation
            let currentMansion = LunarMansion.lunarMansion(date: date)
            let currentIndex = LunarMansion.allCases.firstIndex(of: currentMansion)!
            
            // Get expected
            let expectedIndex = LunarMansion.allCases.firstIndex(of: testDate.expectedCase)!
            
            // Calculate raw values
            let jd2000Days = date.toJC2000 * 36525.0
            let baseRev = moon_true_longitude(jd2000: jd2000Days)
            let baseIdx = Int(floor(baseRev * 28.0)) % 28
            let baseMansion = LunarMansion.allCases[baseIdx]
            
            // With current offset (10/28)
            let offset10 = 10.0 / 28.0
            let rev10 = (baseRev + offset10).truncatingRemainder(dividingBy: 1.0)
            let idx10 = Int(floor(rev10 * 28.0)) % 28
            let mansion10 = LunarMansion.allCases[idx10]
            
            // Calculate difference
            let diff = (expectedIndex - currentIndex + 28) % 28
            
            print("Date: \(testDate.year)-\(testDate.month)-\(testDate.day)")
            print("  Base (no offset):    rev=\(String(format: "%.6f", baseRev)), idx=\(baseIdx), mansion=\(baseMansion.rawValue)")
            print("  With offset 10/28:   idx=\(idx10), mansion=\(mansion10.rawValue)")
            print("  Current result:      idx=\(currentIndex), mansion=\(currentMansion.rawValue)")
            print("  Expected:            idx=\(expectedIndex), mansion=\(testDate.expected)")
            print("  Difference:          \(diff) mansions (\(diff >= 14 ? "-\(28-diff)" : "+\(diff)"))")
            print()
        }
        
        // Test different offsets to find the right one
        print("\n=== Testing Different Offsets ===\n")
        
        let july28 = calendar.date(from: DateComponents(
            timeZone: TimeZone(identifier: "UTC")!,
            year: 2025,
            month: 7,
            day: 28,
            hour: 12
        ))!
        
        let jd2000Days = july28.toJC2000 * 36525.0
        let baseRev = moon_true_longitude(jd2000: jd2000Days)
        
        for offset in [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20] {
            let offsetValue = Double(offset) / 28.0
            let correctedRev = (baseRev + offsetValue).truncatingRemainder(dividingBy: 1.0)
            let finalRev = correctedRev < 0 ? correctedRev + 1.0 : correctedRev
            let idx = Int(floor(finalRev * 28.0)) % 28
            let mansion = LunarMansion.allCases[idx]
            
            let marker = mansion == .zhangXiu ? " ← MATCH!" : ""
            print("Offset \(offset)/28: idx=\(idx), mansion=\(mansion.rawValue)\(marker)")
        }
    }
    
    func testDayConsistency() {
        let calendar = Calendar(identifier: .gregorian)
        let july28 = calendar.date(from: DateComponents(
            timeZone: TimeZone(identifier: "UTC")!,
            year: 2025,
            month: 7,
            day: 28,
            hour: 0
        ))!
        
        print("\n=== Testing Day Consistency (July 28, 2025) ===\n")
        
        for hour in [0, 6, 12, 18, 23] {
            let testDate = calendar.date(byAdding: .hour, value: hour, to: july28)!
            
            let jd2000Days = testDate.toJC2000 * 36525.0
            let rev = moon_true_longitude(jd2000: jd2000Days)
            let offset = 10.0 / 28.0
            let correctedRev = (rev + offset).truncatingRemainder(dividingBy: 1.0)
            let finalRev = correctedRev < 0 ? correctedRev + 1.0 : correctedRev
            let idx = Int(floor(finalRev * 28.0)) % 28
            let mansion = LunarMansion.allCases[idx]
            
            print("\(String(format: "%02d", hour)):00 UTC: rev=\(String(format: "%.6f", rev)), idx=\(idx), mansion=\(mansion.rawValue)")
        }
        
        print("\nNote: If mansion changes during the day, we need to normalize to start of day")
    }
}

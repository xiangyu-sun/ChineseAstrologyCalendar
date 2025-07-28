import XCTest
@testable import ChineseAstrologyCalendar
import Astral

final class DebugLunarMansionTest: XCTestCase {
    
    func testDebugMoonLongitudeForToday() {
        let calendar = Calendar(identifier: .gregorian)
        let july28_2025 = calendar.date(from: DateComponents(
            timeZone: TimeZone(identifier: "UTC")!,
            year: 2025,
            month: 7,
            day: 28
        ))!
        
        print("\n=== Debug Moon Longitude for July 28, 2025 ===")
        
        // Test at different times of day
        let times = [0, 6, 12, 18, 23] // Hours in UTC
        
        for hour in times {
            let testDate = calendar.date(byAdding: .hour, value: hour, to: july28_2025)!
            
            // Get raw values from calculation
            let jd2000Days = testDate.toJC2000 * 36525.0
            let rev = moon_true_longitude(jd2000: jd2000Days)
            let idx = Int(floor(rev * 28.0)) % 28
            let mansion = LunarMansion.allCases[idx]
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = TimeZone(identifier: "UTC")!
            
            print("\(formatter.string(from: testDate)) UTC: rev=\(String(format: "%.6f", rev)), idx=\(idx), mansion=\(mansion.rawValue)")
        }
        
        // Check what user thinks it should be
        print("\nUser expectation: 女宿")
        if let nuXiuIndex = LunarMansion.allCases.firstIndex(of: .nuXiu) {
            print("女宿 would require index: \(nuXiuIndex)")
            let expectedRev = Double(nuXiuIndex) / 28.0
            print("女宿 would require revolution: \(String(format: "%.6f", expectedRev)) to \(String(format: "%.6f", (Double(nuXiuIndex) + 1) / 28.0))")
        }
    }
    
    func testMansionProgression() {
        print("\n=== Mansion Order and Index ===")
        for (index, mansion) in LunarMansion.allCases.enumerated() {
            print("\(index): \(mansion.rawValue)")
        }
    }
}
import XCTest
@testable import ChineseAstrologyCalendar
import Astral

final class LunarMansionOffsetTest: XCTestCase {
    
    func testDifferentStartingPoints() {
        let calendar = Calendar(identifier: .gregorian)
        let july28_2025 = calendar.date(from: DateComponents(
            timeZone: TimeZone(identifier: "UTC")!,
            year: 2025,
            month: 7,
            day: 28,
            hour: 12
        ))!
        
        let jd2000Days = july28_2025.toJC2000 * 36525.0
        let baseRev = moon_true_longitude(jd2000: jd2000Days)
        
        print("\n=== Testing Different Starting Point Offsets ===")
        print("Base calculation: rev=\(String(format: "%.6f", baseRev)), mansion=\(LunarMansion.allCases[Int(floor(baseRev * 28.0)) % 28].rawValue)")
        
        // Test different offsets to see if we can match 女宿 (index 23)
        let targetIndex = 23 // 女宿
        let currentIndex = Int(floor(baseRev * 28.0)) % 28
        let offsetNeeded = targetIndex - currentIndex
        
        print("Current index: \(currentIndex), Target index: \(targetIndex)")
        print("Offset needed: \(offsetNeeded)")
        
        // Test common astronomical offsets
        let testOffsets = [
            0.0,                    // No offset (current)
            Double(offsetNeeded) / 28.0,  // Direct offset to match
            1.0/28.0,              // 1 mansion offset
            7.0/28.0,              // Quarter offset (7 mansions)
            14.0/28.0,             // Half offset (14 mansions)
            21.0/28.0,             // Three-quarter offset
            -1.0/28.0,             // Negative 1 mansion offset
        ]
        
        for offset in testOffsets {
            let adjustedRev = (baseRev + offset).truncatingRemainder(dividingBy: 1.0)
            let finalRev = adjustedRev < 0 ? adjustedRev + 1.0 : adjustedRev
            let idx = Int(floor(finalRev * 28.0)) % 28
            let mansion = LunarMansion.allCases[idx]
            
            print("Offset +\(String(format: "%.6f", offset)): rev=\(String(format: "%.6f", finalRev)), idx=\(idx), mansion=\(mansion.rawValue)")
            
            if mansion == .nuXiu {
                print("*** MATCH FOUND with offset \(offset) ***")
            }
        }
    }
    
    func testTraditionalChineseReference() {
        print("\n=== Traditional Chinese Lunar Mansion System ===")
        print("The 28 lunar mansions traditionally start with 角宿 (Horn) in the Azure Dragon constellation")
        print("Our current order:")
        
        let groups = [
            ("Azure Dragon (青龍)", 0..<7),
            ("Vermillion Bird (朱雀)", 7..<14), 
            ("White Tiger (白虎)", 14..<21),
            ("Black Tortoise (玄武)", 21..<28)
        ]
        
        for (groupName, range) in groups {
            print("\n\(groupName):")
            for i in range {
                print("  \(i): \(LunarMansion.allCases[i].rawValue)")
            }
        }
        
        print("\n女宿 (nuXiu/Girl) is in Black Tortoise group at index 23")
        print("Current calculation places today at index 13 (翼宿/Wings in Vermillion Bird)")
    }
}
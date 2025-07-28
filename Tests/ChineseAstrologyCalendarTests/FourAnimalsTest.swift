import XCTest
@testable import ChineseAstrologyCalendar

final class FourAnimalsTest: XCTestCase {
    
    func testTodayFourAnimal() {
        let today = Date()
        let mansion = LunarMansion.lunarMansion(date: today)
        let fourSymbol = mansion.fourSymbol
        
        print("Today's mansion: \(mansion.rawValue)")
        print("Today's Four Symbol: \(fourSymbol.rawValue)")
        
        // Test specifically for July 28, 2025 - should be 女宿
        let calendar = Calendar(identifier: .gregorian)
        let july28_2025 = calendar.date(from: DateComponents(
            timeZone: TimeZone(identifier: "UTC")!,
            year: 2025,
            month: 7,
            day: 28,
            hour: 12
        ))!
        
        let mansionJuly28 = LunarMansion.lunarMansion(date: july28_2025)
        let fourSymbolJuly28 = mansionJuly28.fourSymbol
        
        print("\nJuly 28, 2025:")
        print("Mansion: \(mansionJuly28.rawValue)")
        print("Four Symbol: \(fourSymbolJuly28.rawValue)")
        
        // Check if 女宿 correctly maps to Black Tortoise
        XCTAssertEqual(mansionJuly28, .nuXiu, "Should be 女宿")
        print("Expected Four Symbol for 女宿: 玄武 (Black Tortoise)")
        print("Actual Four Symbol: \(fourSymbolJuly28.rawValue)")
    }
    
    func testFourSymbolMapping() {
        print("\n=== Four Symbol Mapping ===")
        
        let expectedMapping = [
            ("Azure Dragon (青龙)", [LunarMansion.jiaoXiu, .kangXiu, .diXiu, .fangXiu, .xinXiu, .tailXiu, .jiXiu]),
            ("Vermillion Bird (朱雀)", [LunarMansion.jingXiu, .guiXiu, .liuXiu, .xingXiu, .zhangXiu, .yiXiu, .zhenXiu]),
            ("White Tiger (白虎)", [LunarMansion.kuiXiu, .louXiu, .wei4Xiu, .maoXiu, .biXiu, .ziXiu, .shenXiu]),
            ("Black Tortoise (玄武)", [LunarMansion.douXiu, .niuXiu, .nuXiu, .xuXiu, .wei1Xiu, .shiXiu, .wallXiu])
        ]
        
        for (groupName, mansions) in expectedMapping {
            print("\n\(groupName):")
            for mansion in mansions {
                let fourSymbol = mansion.fourSymbol
                print("  \(mansion.rawValue) → \(fourSymbol.rawValue)")
            }
        }
        
        // Verify 女宿 specifically
        let nuXiuSymbol = LunarMansion.nuXiu.fourSymbol
        print("\n*** 女宿 (Girl) maps to: \(nuXiuSymbol.rawValue) ***")
        XCTAssertEqual(nuXiuSymbol, .blackTortoise, "女宿 should map to Black Tortoise (玄武)")
    }
}
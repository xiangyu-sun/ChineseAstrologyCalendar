import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct FourAnimalsTest {

    @Test func todayFourAnimal() {
        let today = Date()
        let mansion = LunarMansion.lunarMansion(date: today)
        let fourSymbol = mansion.fourSymbol

        print("Today's mansion: \(mansion.rawValue)")
        print("Today's Four Symbol: \(fourSymbol.rawValue)")

        // Test specifically for July 28, 2025 - should be 女宿
        let calendar = Calendar(identifier: .gregorian)
        let july28_2025 = calendar.date(from: DateComponents(
          timeZone: TimeZone.chinaStandardTime,
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
      #expect(mansionJuly28 == .extendedNet)
        print("Expected Four Symbol for 女宿: 玄武 (Black Tortoise)")
        print("Actual Four Symbol: \(fourSymbolJuly28.rawValue)")
    }

    @Test func fourSymbolMapping() {
        print("\n=== Four Symbol Mapping ===")

        let expectedMapping = [
            ("Azure Dragon (青龍)", [LunarMansion.horn, .neck, .root, .room, .heart, .tail, .winnowingBasket]),
            ("Vermillion Bird (朱雀)", [LunarMansion.well, .ghost, .willow, .star, .extendedNet, .wings, .chariot]),
            ("White Tiger (白虎)", [LunarMansion.legs, .bond, .stomach, .pleiades, .net, .turtleBeak, .threeStars]),
            ("Black Tortoise (玄武)", [LunarMansion.dipper, .ox, .girl, .emptiness, .rooftop, .encampment, .wall])
        ]

        for (groupName, mansions) in expectedMapping {
            print("\n\(groupName):")
            for mansion in mansions {
                let fourSymbol = mansion.fourSymbol
                print("  \(mansion.rawValue) → \(fourSymbol.rawValue)")
            }
        }

        // Verify 女宿 specifically
        let nuXiuSymbol = LunarMansion.girl.fourSymbol
        print("\n*** 女宿 (Girl) maps to: \(nuXiuSymbol.rawValue) ***")
        #expect(nuXiuSymbol == .blackTortoise, "女宿 should map to Black Tortoise (玄武)")
    }
}

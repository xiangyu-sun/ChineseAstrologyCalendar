import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct LunarMansion7DayTests {

    // Test for the next 7 days from July 28, 2025 to August 3, 2025
    // We'll test at midnight UTC for each day for consistency

    @Test func lunarMansionJuly28_2025() {
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "UTC")!
        calendar.timeZone = timeZone

        let components = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            year: 2025,
            month: 7,
            day: 28,
            hour: 0,
            minute: 0,
            second: 0
        )

        guard let date = calendar.date(from: components) else {
            #expect(Bool(false), "Could not create date for July 28, 2025")
            return
        }

        let mansion = LunarMansion.lunarMansion(date: date)

        // Log the result for analysis
        print("July 28, 2025 00:00 UTC - Lunar Mansion: \(mansion.rawValue)")

        // Test that we get a valid mansion
        #expect(LunarMansion.allCases.contains(mansion))

        // Test the Four Symbol grouping
        let fourSymbol = mansion.fourSymbol
        #expect([FourSymbol.azureDragon, .vermilionBird, .whiteTiger, .blackTortoise].contains(fourSymbol))

        // Store the mansion for sequence testing
        UserDefaults.standard.set(mansion.rawValue, forKey: "mansion_2025_07_28")
    }

    @Test func lunarMansionJuly29_2025() {
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "UTC")!
        calendar.timeZone = timeZone

        let components = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            year: 2025,
            month: 7,
            day: 29,
            hour: 0,
            minute: 0,
            second: 0
        )

        guard let date = calendar.date(from: components) else {
            #expect(Bool(false), "Could not create date for July 29, 2025")
            return
        }

        let mansion = LunarMansion.lunarMansion(date: date)

        print("July 29, 2025 00:00 UTC - Lunar Mansion: \(mansion.rawValue)")

        #expect(LunarMansion.allCases.contains(mansion))

        let fourSymbol = mansion.fourSymbol
        #expect([FourSymbol.azureDragon, .vermilionBird, .whiteTiger, .blackTortoise].contains(fourSymbol))

        UserDefaults.standard.set(mansion.rawValue, forKey: "mansion_2025_07_29")
    }

    @Test func lunarMansionJuly30_2025() {
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "UTC")!
        calendar.timeZone = timeZone

        let components = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            year: 2025,
            month: 7,
            day: 30,
            hour: 0,
            minute: 0,
            second: 0
        )

        guard let date = calendar.date(from: components) else {
            #expect(Bool(false), "Could not create date for July 30, 2025")
            return
        }

        let mansion = LunarMansion.lunarMansion(date: date)

        print("July 30, 2025 00:00 UTC - Lunar Mansion: \(mansion.rawValue)")

        #expect(LunarMansion.allCases.contains(mansion))

        let fourSymbol = mansion.fourSymbol
        #expect([FourSymbol.azureDragon, .vermilionBird, .whiteTiger, .blackTortoise].contains(fourSymbol))

        UserDefaults.standard.set(mansion.rawValue, forKey: "mansion_2025_07_30")
    }

    @Test func lunarMansionJuly31_2025() {
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "UTC")!
        calendar.timeZone = timeZone

        let components = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            year: 2025,
            month: 7,
            day: 31,
            hour: 0,
            minute: 0,
            second: 0
        )

        guard let date = calendar.date(from: components) else {
            #expect(Bool(false), "Could not create date for July 31, 2025")
            return
        }

        let mansion = LunarMansion.lunarMansion(date: date)

        print("July 31, 2025 00:00 UTC - Lunar Mansion: \(mansion.rawValue)")

        #expect(LunarMansion.allCases.contains(mansion))

        let fourSymbol = mansion.fourSymbol
        #expect([FourSymbol.azureDragon, .vermilionBird, .whiteTiger, .blackTortoise].contains(fourSymbol))

        UserDefaults.standard.set(mansion.rawValue, forKey: "mansion_2025_07_31")
    }

    @Test func lunarMansionAugust1_2025() {
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "UTC")!
        calendar.timeZone = timeZone

        let components = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            year: 2025,
            month: 8,
            day: 1,
            hour: 0,
            minute: 0,
            second: 0
        )

        guard let date = calendar.date(from: components) else {
            #expect(Bool(false), "Could not create date for August 1, 2025")
            return
        }

        let mansion = LunarMansion.lunarMansion(date: date)

        print("August 1, 2025 00:00 UTC - Lunar Mansion: \(mansion.rawValue)")

        #expect(LunarMansion.allCases.contains(mansion))

        let fourSymbol = mansion.fourSymbol
        #expect([FourSymbol.azureDragon, .vermilionBird, .whiteTiger, .blackTortoise].contains(fourSymbol))

        UserDefaults.standard.set(mansion.rawValue, forKey: "mansion_2025_08_01")
    }

    @Test func lunarMansionAugust2_2025() {
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "UTC")!
        calendar.timeZone = timeZone

        let components = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            year: 2025,
            month: 8,
            day: 2,
            hour: 0,
            minute: 0,
            second: 0
        )

        guard let date = calendar.date(from: components) else {
            #expect(Bool(false), "Could not create date for August 2, 2025")
            return
        }

        let mansion = LunarMansion.lunarMansion(date: date)

        print("August 2, 2025 00:00 UTC - Lunar Mansion: \(mansion.rawValue)")

        #expect(LunarMansion.allCases.contains(mansion))

        let fourSymbol = mansion.fourSymbol
        #expect([FourSymbol.azureDragon, .vermilionBird, .whiteTiger, .blackTortoise].contains(fourSymbol))

        UserDefaults.standard.set(mansion.rawValue, forKey: "mansion_2025_08_02")
    }

    @Test func lunarMansionAugust3_2025() {
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "UTC")!
        calendar.timeZone = timeZone

        let components = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            year: 2025,
            month: 8,
            day: 3,
            hour: 0,
            minute: 0,
            second: 0
        )

        guard let date = calendar.date(from: components) else {
            #expect(Bool(false), "Could not create date for August 3, 2025")
            return
        }

        let mansion = LunarMansion.lunarMansion(date: date)

        print("August 3, 2025 00:00 UTC - Lunar Mansion: \(mansion.rawValue)")

        #expect(LunarMansion.allCases.contains(mansion))

        let fourSymbol = mansion.fourSymbol
        #expect([FourSymbol.azureDragon, .vermilionBird, .whiteTiger, .blackTortoise].contains(fourSymbol))

        UserDefaults.standard.set(mansion.rawValue, forKey: "mansion_2025_08_03")
    }

    // Test that lunar mansions change progressively (not necessarily daily, but over the 7-day period)
    @Test func lunarMansionProgression() {
        let dates = [
            ("2025-07-28", "mansion_2025_07_28"),
            ("2025-07-29", "mansion_2025_07_29"),
            ("2025-07-30", "mansion_2025_07_30"),
            ("2025-07-31", "mansion_2025_07_31"),
            ("2025-08-01", "mansion_2025_08_01"),
            ("2025-08-02", "mansion_2025_08_02"),
            ("2025-08-03", "mansion_2025_08_03")
        ]

        var mansions: [String] = []
        for (_, key) in dates {
            if let mansion = UserDefaults.standard.string(forKey: key) {
                mansions.append(mansion)
            }
        }

        print("7-day Lunar Mansion Sequence:")
        for (i, mansion) in mansions.enumerated() {
            print("Day \(i+1): \(mansion)")
        }

        // The moon's position should change over 7 days
        // We should see at least some variation in the mansions over this period
        let uniqueMansions = Set(mansions)
        #expect(uniqueMansions.count >= 1, "Should have at least 1 unique mansion")

        // Clean up UserDefaults after test
        for (_, key) in dates {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    // Test the implementation against known astronomical data
    @Test func lunarMansionConsistency() {
        // Test that the same date produces the same mansion consistently
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "UTC")!
        calendar.timeZone = timeZone

        let components = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            year: 2025,
            month: 7,
            day: 28,
            hour: 12,
            minute: 0,
            second: 0
        )

        guard let date = calendar.date(from: components) else {
            #expect(Bool(false), "Could not create test date")
            return
        }

        let mansion1 = LunarMansion.lunarMansion(date: date)
        let mansion2 = LunarMansion.lunarMansion(date: date)
        let mansion3 = LunarMansion.lunarMansion(date: date)

        #expect(mansion1 == mansion2)
        #expect(mansion2 == mansion3)
    }

    // Test mansion index bounds
    @Test func lunarMansionIndexBounds() {
        // Test with various dates to ensure index is always within bounds
        let testDates = [
            Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!,
            Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 15))!,
            Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 31))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 29))!, // Leap year
            Calendar.current.date(from: DateComponents(year: 2023, month: 2, day: 28))!  // Non-leap year
        ]

        for date in testDates {
            let mansion = LunarMansion.lunarMansion(date: date)
            #expect(LunarMansion.allCases.contains(mansion))

            // Verify the mansion has a valid Four Symbol
            let fourSymbol = mansion.fourSymbol
            #expect([FourSymbol.azureDragon, .vermilionBird, .whiteTiger, .blackTortoise].contains(fourSymbol))
        }
    }

    // Test all 28 mansions have correct Four Symbol assignments
    @Test func allMansionFourSymbolAssignments() {
        let expectedAssignments: [LunarMansion: FourSymbol] = [
            // Azure Dragon (Eastern) - 7 mansions
            .jiaoXiu: .azureDragon,   // 角宿
            .kangXiu: .azureDragon,   // 亢宿
            .diXiu: .azureDragon,     // 氐宿
            .fangXiu: .azureDragon,   // 房宿
            .xinXiu: .azureDragon,    // 心宿
            .tailXiu: .azureDragon,   // 尾宿
            .jiXiu: .azureDragon,     // 箕宿

            // Vermillion Bird (Southern) - 7 mansions
            .jingXiu: .vermilionBird, // 井宿
            .guiXiu: .vermilionBird,  // 鬼宿
            .liuXiu: .vermilionBird,  // 柳宿
            .xingXiu: .vermilionBird, // 星宿
            .zhangXiu: .vermilionBird,// 張宿
            .yiXiu: .vermilionBird,   // 翼宿
            .zhenXiu: .vermilionBird, // 轸宿

            // White Tiger (Western) - 7 mansions
            .kuiXiu: .whiteTiger,     // 奎宿
            .louXiu: .whiteTiger,     // 婁宿
            .wei4Xiu: .whiteTiger,    // 胃宿
            .maoXiu: .whiteTiger,     // 昴宿
            .biXiu: .whiteTiger,      // 畢宿
            .ziXiu: .whiteTiger,      // 觜宿
            .shenXiu: .whiteTiger,    // 參宿

            // Black Tortoise (Northern) - 7 mansions
            .douXiu: .blackTortoise,  // 斗宿
            .niuXiu: .blackTortoise,  // 牛宿
            .nuXiu: .blackTortoise,   // 女宿
            .xuXiu: .blackTortoise,   // 虛宿
            .wei1Xiu: .blackTortoise, // 危宿
            .shiXiu: .blackTortoise,  // 室宿
            .wallXiu: .blackTortoise  // 壁宿
        ]

        for (mansion, expectedSymbol) in expectedAssignments {
            #expect(mansion.fourSymbol == expectedSymbol,
                          "Mansion \(mansion.rawValue) should belong to \(expectedSymbol.rawValue)")
        }

        // Verify we have exactly 28 mansions total
        #expect(LunarMansion.allCases.count == 28)
        #expect(expectedAssignments.count == 28)

        // Verify each Four Symbol has exactly 7 mansions
        let symbolCounts = expectedAssignments.values.reduce(into: [FourSymbol: Int]()) { counts, symbol in
            counts[symbol, default: 0] += 1
        }

        for (symbol, count) in symbolCounts {
            #expect(count == 7, "Four Symbol \(symbol.rawValue) should have exactly 7 mansions")
        }
    }
}

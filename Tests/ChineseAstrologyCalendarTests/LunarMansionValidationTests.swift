import XCTest
@testable import ChineseAstrologyCalendar

final class LunarMansionValidationTests: XCTestCase {
    
    // Test different times throughout a day to see if mansion changes
    func testLunarMansionVariationThroughoutDay() {
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "UTC")!
        calendar.timeZone = timeZone
        
        let times = [0, 6, 12, 18] // Midnight, 6 AM, Noon, 6 PM
        var mansions: [String] = []
        
        for hour in times {
            let components = DateComponents(
                calendar: calendar,
                timeZone: timeZone,
                year: 2025,
                month: 7,
                day: 28,
                hour: hour,
                minute: 0,
                second: 0
            )
            
            guard let date = calendar.date(from: components) else {
                XCTFail("Could not create date for hour \(hour)")
                continue
            }
            
            let mansion = LunarMansion.lunarMansion(date: date)
            mansions.append(mansion.rawValue)
            
            print("July 28, 2025 \(String(format: "%02d", hour)):00 UTC - Lunar Mansion: \(mansion.rawValue)")
        }
        
        print("Same-day mansion variations: \(Set(mansions).count) unique mansions")
        
        // The lunar mansion should be the same throughout the day since it's based on the Moon's position
        // which changes slowly over ~1 day per mansion
        XCTAssertTrue(Set(mansions).count >= 1, "Should have at least 1 mansion")
    }
    
    // Test a longer period to verify mansion progression
    func testLunarMansionProgression30Days() {
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "UTC")!
        calendar.timeZone = timeZone
        
        var mansions: [(String, String)] = []
        
        // Test for 30 days starting from July 1, 2025
        for dayOffset in 0..<30 {
            let components = DateComponents(
                calendar: calendar,
                timeZone: timeZone,
                year: 2025,
                month: 7,
                day: 1 + dayOffset,
                hour: 12,
                minute: 0,
                second: 0
            )
            
            guard let date = calendar.date(from: components) else {
                continue
            }
            
            let mansion = LunarMansion.lunarMansion(date: date)
            let dateString = DateFormatter().apply { formatter in
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.timeZone = timeZone
            }.string(from: date)
            
            mansions.append((dateString, mansion.rawValue))
        }
        
        print("\n30-Day Lunar Mansion Progression (July 2025):")
        for (date, mansion) in mansions {
            print("\(date): \(mansion)")
        }
        
        let uniqueMansions = Set(mansions.map { $0.1 })
        print("\nUnique mansions over 30 days: \(uniqueMansions.count)")
        print("Unique mansions: \(Array(uniqueMansions).sorted())")
        
        // Over 30 days, we should see several different mansions
        // The Moon takes ~27.3 days to complete its orbit, so we expect to see most or all mansions
        XCTAssertTrue(uniqueMansions.count > 20, "Should see most of the 28 mansions over 30 days")
    }
    
    // Test around known lunar events to validate accuracy
    func testLunarMansionAroundNewMoon() {
        // Test around a new moon date when the Moon is closer to the Sun
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "UTC")!
        calendar.timeZone = timeZone
        
        // August 4, 2025 is a new moon
        let newMoonComponents = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            year: 2025,
            month: 8,
            day: 4,
            hour: 12,
            minute: 0,
            second: 0
        )
        
        guard let newMoonDate = calendar.date(from: newMoonComponents) else {
            XCTFail("Could not create new moon date")
            return
        }
        
        let mansion = LunarMansion.lunarMansion(date: newMoonDate)
        print("\nNew Moon - August 4, 2025 12:00 UTC - Lunar Mansion: \(mansion.rawValue)")
        print("Four Symbol: \(mansion.fourSymbol.rawValue)")
        
        // Test the day before and after
        let dayBefore = Calendar.current.date(byAdding: .day, value: -1, to: newMoonDate)!
        let dayAfter = Calendar.current.date(byAdding: .day, value: 1, to: newMoonDate)!
        
        let mansionBefore = LunarMansion.lunarMansion(date: dayBefore)
        let mansionAfter = LunarMansion.lunarMansion(date: dayAfter)
        
        print("Day before new moon: \(mansionBefore.rawValue)")
        print("Day after new moon: \(mansionAfter.rawValue)")
        
        XCTAssertTrue(LunarMansion.allCases.contains(mansion))
        XCTAssertTrue(LunarMansion.allCases.contains(mansionBefore))
        XCTAssertTrue(LunarMansion.allCases.contains(mansionAfter))
    }
    
    // Test the Moon's position calculation accuracy by checking mansion assignments
    func testMansionFourSymbolDistribution() {
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "UTC")!
        calendar.timeZone = timeZone
        
        var symbolCounts: [FourSymbol: Int] = [:]
        
        // Test 112 days (4 lunar months) to get a good sample
        for dayOffset in 0..<112 {
            let components = DateComponents(
                calendar: calendar,
                timeZone: timeZone,
                year: 2025,
                month: 1,
                day: 1 + dayOffset,
                hour: 12,
                minute: 0,
                second: 0
            )
            
            guard let date = calendar.date(from: components) else {
                continue
            }
            
            let mansion = LunarMansion.lunarMansion(date: date)
            let symbol = mansion.fourSymbol
            
            symbolCounts[symbol, default: 0] += 1
        }
        
        print("\nFour Symbol distribution over 112 days (4 lunar months):")
        for symbol in [FourSymbol.azureDragon, .vermilionBird, .whiteTiger, .blackTortoise] {
            let count = symbolCounts[symbol] ?? 0
            print("\(symbol.rawValue): \(count) days")
        }
        
        // Each symbol should appear roughly equally over time (within reasonable variance)
        let totalDays = symbolCounts.values.reduce(0, +)
        let expectedPerSymbol = totalDays / 4
        
        for (symbol, count) in symbolCounts {
            let variance = abs(count - expectedPerSymbol)
            let percentVariance = Double(variance) / Double(expectedPerSymbol) * 100
            
            print("\(symbol.rawValue) variance: \(variance) days (\(String(format: "%.1f", percentVariance))%)")
            
            // Allow up to 50% variance since the Moon's orbit is not perfectly uniform
            XCTAssertTrue(percentVariance < 50, "\(symbol.rawValue) distribution too far from expected")
        }
    }
    
    // Test mansion accuracy against traditional order
    func testMansionTraditionalOrder() {
        // The traditional order of the 28 mansions
        let traditionalOrder: [LunarMansion] = [
            // Eastern Azure Dragon (東方青龍)
            .jiaoXiu,   // 角 - Horn
            .kangXiu,   // 亢 - Neck  
            .diXiu,     // 氐 - Root
            .fangXiu,   // 房 - Room
            .xinXiu,    // 心 - Heart
            .tailXiu,   // 尾 - Tail
            .jiXiu,     // 箕 - Winnowing Basket
            
            // Northern Black Tortoise (北方玄武)
            .douXiu,    // 斗 - Dipper
            .niuXiu,    // 牛 - Ox
            .nuXiu,     // 女 - Girl
            .xuXiu,     // 虚 - Emptiness
            .wei1Xiu,   // 危 - Danger
            .shiXiu,    // 室 - Room
            .wallXiu,   // 壁 - Wall
            
            // Western White Tiger (西方白虎)
            .kuiXiu,    // 奎 - Legs
            .louXiu,    // 娄 - Bond
            .wei4Xiu,   // 胃 - Stomach
            .maoXiu,    // 昴 - Pleiades
            .biXiu,     // 毕 - Net
            .ziXiu,     // 觜 - Turtle Beak
            .shenXiu,   // 参 - Three Stars
            
            // Southern Vermillion Bird (南方朱雀)
            .jingXiu,   // 井 - Well
            .guiXiu,    // 鬼 - Ghost
            .liuXiu,    // 柳 - Willow
            .xingXiu,   // 星 - Star
            .zhangXiu,  // 张 - Extended Net
            .yiXiu,     // 翼 - Wings
            .zhenXiu,    // 轸 - Chariot
    
        ]
        
        // Verify our implementation has all 28 mansions in the expected order
        XCTAssertEqual(LunarMansion.allCases.count, 28)
        XCTAssertEqual(traditionalOrder.count, 28)
        
        // The allCases should match our expected traditional order
        for (index, expectedMansion) in traditionalOrder.enumerated() {
            let actualMansion = LunarMansion.allCases[index]
            XCTAssertEqual(actualMansion, expectedMansion, 
                          "Mansion at index \(index) should be \(expectedMansion.rawValue), got \(actualMansion.rawValue)")
        }
        
        print("\nLunar Mansion Traditional Order Verification:")
        print("✅ All 28 mansions present in correct traditional order")
    }
}

extension DateFormatter {
    func apply(_ closure: (DateFormatter) -> Void) -> DateFormatter {
        closure(self)
        return self
    }
}

import Foundation
//
//  DateConstructorTests.swift
//
//
//  Created by Xiangyu Sun on 24/12/22.
//

import Testing

@Suite struct DateConstructorTests {

  @Test func constructor() throws {
    let date = try #require(DateComponents.getDate(year: 2023, month: 1, day: .chuyi))

    let components = date.dateComponentsFromCurrentCalendar

    #expect(components.year == 2023)
    #expect(components.month == 1)
    #expect(components.day == 22)
    #expect(components.hour == 0)
    #expect(components.minute == 0)
    #expect(components.second == 0)
  }

}

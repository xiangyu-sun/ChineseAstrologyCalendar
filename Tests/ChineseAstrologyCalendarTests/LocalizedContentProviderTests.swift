import Foundation
import Testing
@testable import ChineseAstrologyCalendar

/// Tests for the Russian and Spanish content providers used by
/// `FestivalSource` and `JieqiSource`.
@Suite struct LocalizedContentProviderTests {

  private var utcCalendar: Calendar {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(identifier: "UTC")!
    return cal
  }

  private func date(year: Int, month: Int, day: Int) -> Date {
    utcCalendar.date(from: DateComponents(year: year, month: month, day: day))!
  }

  // MARK: - Festival providers

  /// Every festival must have a non-empty, unique name and non-empty detail in each language.
  @Test func festivalProvidersCoverAllCasesUniquely() {
    let providers: [any ChineseFestivalContentProvider] = [
      RussianFestivalContentProvider(),
      SpanishFestivalContentProvider(),
    ]
    for provider in providers {
      #expect(!provider.category.isEmpty)
      var names = Set<String>()
      for festival in ChineseFestival.allCases {
        let name = provider.name(for: festival)
        let detail = provider.detail(for: festival)
        #expect(!name.isEmpty, "empty name for \(festival)")
        #expect(!detail.isEmpty, "empty detail for \(festival)")
        names.insert(name)
      }
      #expect(names.count == ChineseFestival.allCases.count, "duplicate festival names")
    }
  }

  // MARK: - Jieqi providers

  /// Every solar term must have a non-empty, unique name and non-empty detail in each language.
  @Test func jieqiProvidersCoverAllCasesUniquely() {
    let providers: [any JieqiContentProvider] = [
      RussianJieqiContentProvider(),
      SpanishJieqiContentProvider(),
    ]
    for provider in providers {
      #expect(!provider.category.isEmpty)
      var names = Set<String>()
      for jieqi in Jieqi.allCases {
        let name = provider.name(for: jieqi)
        let detail = provider.detail(for: jieqi)
        #expect(!name.isEmpty, "empty name for \(jieqi)")
        #expect(!detail.isEmpty, "empty detail for \(jieqi)")
        names.insert(name)
      }
      #expect(names.count == Jieqi.allCases.count, "duplicate jieqi names")
    }
  }

  // MARK: - Source integration

  /// A localized FestivalSource surfaces the translated name on the festival day.
  @Test func festivalSourceUsesRussianAndSpanishNames() {
    // Spring Festival 2025 = Jan 29 UTC
    let springFestival2025 = date(year: 2025, month: 1, day: 29)

    let ru = springFestival2025.specialDays(sources: [FestivalSource(contentProvider: RussianFestivalContentProvider())])
    #expect(ru.count == 1)
    #expect(ru.first?.name == "Праздник весны (Китайский Новый год)")
    #expect(ru.first?.category == "Праздник")
    #expect(ru.first?.detail.isEmpty == false)

    let es = springFestival2025.specialDays(sources: [FestivalSource(contentProvider: SpanishFestivalContentProvider())])
    #expect(es.count == 1)
    #expect(es.first?.name == "Fiesta de la Primavera (Año Nuevo Chino)")
    #expect(es.first?.category == "Festividad")
    #expect(es.first?.detail.isEmpty == false)
  }

  /// A localized JieqiSource surfaces the translated name on a solar-term day.
  @Test func jieqiSourceUsesRussianAndSpanishNames() {
    // Qingming 2025 = April 5 UTC (isJieqiDay == true)
    let qingming2025 = date(year: 2025, month: 4, day: 5)
    #expect(qingming2025.isJieqiDay)

    let ru = qingming2025.specialDays(sources: [JieqiSource(contentProvider: RussianJieqiContentProvider())])
    #expect(ru.count == 1)
    #expect(ru.first?.name == "Ясность и чистота (Цинмин)")
    #expect(ru.first?.detail.isEmpty == false)

    let es = qingming2025.specialDays(sources: [JieqiSource(contentProvider: SpanishJieqiContentProvider())])
    #expect(es.count == 1)
    #expect(es.first?.name == "Claro y luminoso (Qingming)")
    #expect(es.first?.detail.isEmpty == false)
  }
}

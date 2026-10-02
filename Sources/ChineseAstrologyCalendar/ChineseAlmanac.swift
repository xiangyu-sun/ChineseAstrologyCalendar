import Foundation

// MARK: - ChineseAlmanac

/// The single entry point for building a day view of the Chinese calendar.
///
/// Configure the time zone and display language once, then ask for any day:
/// ```swift
/// let almanac = ChineseAlmanac(language: DisplayLanguage(identifier: Bundle.main.preferredLocalizations.first ?? "en"))
/// let today = almanac.day(for: Date())
///
/// today.lunarDate?.formatted(.yearZodiacMonthDay, in: almanac.language)
/// today.festival           // ChineseFestival?
/// today.text.festival      // "Mid-Autumn Festival", already localized
/// ```
///
/// ``AlmanacDay`` is a plain value: cache it, compare it, or hand it to a
/// widget. The lower-level `Date` extensions remain available for anything
/// it does not cover.
public struct ChineseAlmanac: Sendable {

  /// The time zone whose calendar day defines "a day" for lunar dates,
  /// festivals, the Twelve Gods and the Shichen. Defaults to China Standard
  /// Time, the time zone the Chinese calendar is defined in, so results match
  /// printed almanacs wherever the device is.
  public var timeZone: TimeZone

  /// The language used by ``AlmanacDay/text``.
  public var language: DisplayLanguage

  public init(timeZone: TimeZone = .chinaStandardTime, language: DisplayLanguage = .current) {
    self.timeZone = timeZone
    self.language = language
  }

  /// Every almanac fact for the instant `date`.
  public func day(for date: Date) -> AlmanacDay {
    var chinese = Calendar(identifier: .chinese)
    chinese.timeZone = timeZone

    let lunarDate = LunarDate(date: date, calendar: chinese)
    let hour = chinese.component(.hour, from: date)

    return AlmanacDay(
      date: date,
      language: language,
      lunarDate: lunarDate,
      pillars: Bazi(date: date),
      jieqi: date.currentJieqi,
      festival: date.chineseFestival(timeZone: timeZone),
      twelveGod: date.twelveGod(timeZone: timeZone),
      lunarMansion: LunarMansion.lunarMansion(date: date),
      shichen: Shichen(dizhi: Dizhi(hourOfDay: hour), date: date, timeZone: timeZone))
  }

  /// One ``AlmanacDay`` per calendar day for `count` days starting on the day containing `start`.
  ///
  /// Each day is sampled at noon in ``timeZone``, so values that depend on the
  /// time of day (``AlmanacDay/shichen``, the hour pillar) are those of midday.
  public func days(from start: Date, count: Int) -> [AlmanacDay] {
    var gregorian = Calendar(identifier: .gregorian)
    gregorian.timeZone = timeZone
    let noon = gregorian.date(bySettingHour: 12, minute: 0, second: 0, of: start) ?? start
    return (0..<max(0, count)).compactMap { offset in
      gregorian.date(byAdding: .day, value: offset, to: noon).map(day(for:))
    }
  }
}

// MARK: - AlmanacDay

/// A snapshot of the Chinese calendar for one instant, produced by ``ChineseAlmanac``.
public struct AlmanacDay: Equatable, Sendable {

  /// The instant this snapshot describes.
  public let date: Date

  /// The language ``text`` renders in.
  public let language: DisplayLanguage

  /// The lunar year, month and day.
  public let lunarDate: LunarDate?

  /// The four pillars (八字). Always reckoned in China Standard Time.
  public let pillars: Bazi?

  /// The solar term in effect and the day it began. Always reckoned in China Standard Time.
  public let jieqi: JieqiOccurrence?

  /// The traditional festival falling on this day, if any.
  public let festival: ChineseFestival?

  /// The day's officer in the 建除十二神 cycle.
  public let twelveGod: TwelveGods?

  /// The lunar mansion (二十八宿) the Moon occupies.
  public let lunarMansion: LunarMansion

  /// The double-hour (時辰) containing ``date``.
  public let shichen: Shichen

  /// The zodiac animal of the lunar year.
  public var zodiac: Zodiac? { lunarDate?.zodiac }

  /// The Moon's phase, from the lunar day.
  public var moonPhase: ChineseMoonPhase? { lunarDate?.day.moonPhase }

  /// Whether ``date`` falls on the first day of a solar term.
  public var isJieqiDay: Bool {
    guard let jieqi else { return false }
    var gregorian = Calendar(identifier: .gregorian)
    gregorian.timeZone = .chinaStandardTime
    return gregorian.isDate(jieqi.startDate, inSameDayAs: date)
  }

  /// Every value above, rendered in ``language``.
  public var text: AlmanacText { AlmanacText(day: self) }

  public static func == (lhs: AlmanacDay, rhs: AlmanacDay) -> Bool {
    lhs.date == rhs.date
      && lhs.language == rhs.language
      && lhs.lunarDate == rhs.lunarDate
      && lhs.pillars == rhs.pillars
      && lhs.jieqi == rhs.jieqi
      && lhs.festival == rhs.festival
      && lhs.twelveGod == rhs.twelveGod
      && lhs.lunarMansion == rhs.lunarMansion
      && lhs.shichen.dizhi == rhs.shichen.dizhi
  }
}

// MARK: - AlmanacText

/// The display strings for an ``AlmanacDay`` in its ``AlmanacDay/language``.
///
/// Optional properties are `nil` when the underlying value is absent (for
/// example, ``festival`` on a day without one).
public struct AlmanacText: Equatable, Sendable {

  /// Year, zodiac, month and day, e.g. 甲辰龍年正月初一 or "1st Month 1st, Year of the Dragon (Jiǎchén)".
  public let lunarDate: String?
  /// The lunar month and day only, e.g. 正月初一 or "1st Month 1st".
  public let lunarMonthDay: String?
  public let zodiac: String?
  /// The four pillars with labels, e.g. 年:甲辰 月:丙寅 日:甲子 時:甲子.
  public let pillars: String?
  public let jieqi: String?
  public let festival: String?
  public let twelveGod: String?
  public let lunarMansion: String
  public let moonPhase: String?
  /// The double-hour, e.g. 子時 / 子时 / "Zǐ hour".
  public let shichen: String

  init(day: AlmanacDay) {
    let language = day.language
    lunarDate = day.lunarDate?.formatted(.yearZodiacMonthDay, in: language)
    lunarMonthDay = day.lunarDate?.formatted(.monthDay, in: language)
    zodiac = day.zodiac?.localizedName(in: language)
    pillars = day.pillars?.localizedFormattedDescription(in: language)
    jieqi = day.jieqi?.jieqi.localizedName(in: language)
    festival = day.festival?.localizedName(in: language)
    twelveGod = day.twelveGod?.localizedName(in: language)
    lunarMansion = day.lunarMansion.localizedName(in: language)
    moonPhase = day.moonPhase?.localizedName(in: language)
    shichen = day.shichen.dizhi.localizedHourName(in: language)
  }
}

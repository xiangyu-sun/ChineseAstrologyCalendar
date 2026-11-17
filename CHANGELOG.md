# Changelog

All notable changes to this package. Releases follow [Semantic Versioning](https://semver.org).

## 4.3.0

### Added
- Exact solar-term instants. `Date.solarLongitude`, `Date.nextJieqiTransit` and `Date.previousJieqiTransit` return a
  `JieqiTransit` (the term and the instant the sun reaches its longitude, found to the second). `JieqiTransit.day(in:)`
  and `dayComponents(in:)` give the civil day in any time zone, and `JieqiTransit.transits(inYear:timeZone:)` lists a
  year's 24 transits. `Jieqi.transit(after:)`, `transit(before:)` and `transit(inYear:timeZone:)` do the same for one
  term. Instants agree with the Hong Kong Observatory to about ±12 minutes.
- The 72 pentads (七十二候). `Jieqi.pentads` gives a term's three phenology texts. `Pentad` (term + index 0–2) has
  `init(longitude:)`, `ordinal`, `startLongitude`, `text`, `next`, `previous`, `start(after:)` and `start(before:)`.
  `PentadBoundary.boundaries(from:to:)` and `boundaries(inYear:timeZone:)` list pentad starts, and `Date.pentad`,
  `pentadIndex`, `currentPentadBoundary` and `nextPentadBoundary` place a date.
- Seasonal day counts: 數九 (the nine nines from 冬至), 三伏 (dog days: 初伏 on the third 庚 day from 夏至, 末伏 on the first 庚 day
  from 立秋) and 入梅/出梅 (plum rains: the first 丙 day from 芒種 to the first 未 day from 小暑). Counts include the
  term day itself; the source comments note where almanacs differ. `SeasonalCount.active(on:timeZone:)`,
  `nines(on:)`, `dogDays(on:)` and `plumRains(on:)` return the period and the day within it;
  `dogDays(inYear:)` and `plumRains(inYear:)` return the year's dates. Kinds and periods have
  `localizedName(in:)`. Days are reckoned in China Standard Time unless you pass a time zone.
- `Date.startOfDay(in:)` and `Date.nextMidnights(count:in:)`: midnights in a given time zone, correct across
  daylight-saving changes. Useful for widget timelines that must turn over at another zone's midnight.
- `Jieqi.monthBranch`: the earthly branch of the solar month (月建) a term falls in. Each 節 opens a month and the following 中氣 belongs to it: 立春/雨水 → 寅, 驚蟄/春分 → 卯, … 小寒/大寒 → 丑.
- `Jieqi.isMonthOpener` (true for the 12 節), `monthOpener` (the 節 that opens the term's month) and `isMajorTerm` (the 12 中氣, same as `qi`).
- `Jieqi.previous`, the counterpart of `next`.
- `Jieqi.traditionalOrder` (立春 = 1 … 大寒 = 24) and `Jieqi.traditionallyOrderedCases`.
- `Jieqi.pinyin` (tone-marked, lowercase, like `Tiangan.pinyin` and `Dizhi.pinyin`) and `Jieqi.slug`, an ASCII name for assets and URLs (立春 → "lichun").

### Deprecated
- `Jieqi.dizhi`. It maps most terms a month early (春分 and 清明 → 寅) and is unchanged for compatibility. Use `monthBranch`.

## 4.2.1

### Changed
- Requires Astral 1.3.0 or newer (was 1.2.0). Astral 1.3.0 builds in Swift 6 language mode with strict concurrency and
  no longer pulls `airbnb/swift` and `swift-argument-parser` into consumers' dependency graphs.
- `Package.swift` declares `swiftLanguageModes: [.v6]` explicitly. The package already built in Swift 6 mode; nothing
  changes for clients.
- The WeatherKit bridge (`ChineseMoonPhase.moonPhase`, `MoonPhase.moonPhase(day:)`) names `WeatherKit.MoonPhase`
  explicitly so it can't be confused with Astral 1.3.0's new `MoonPhase` type.

## 4.2.0

### Added
- `JieqiSource(timeZone:contentProvider:)` reckons solar-term days in any time zone (default China Standard Time, as before).
- `FestivalSource(converter:timeZone:contentProvider:)` matches lunar and solar-term festivals on the calendar day in one time zone. Without `timeZone` the behaviour is unchanged.
- `ChineseFestival.nextDate(from:converter:timeZone:)`.
- `Date.currentOrNextSpecialDay(sources:calendar:)`: today's event with `daysUntil == 0` on the day itself, otherwise the next one. `nextSpecialDay(sources:)` only ever looks after the date, so it can't drive a "today / next" display.
- `Date.upcomingSpecialDays(sources:within:calendar:)`: every event in the coming days, sorted, with same-name same-day duplicates (冬至) removed.
- `RecurringDay` and `RecurringDaySource`: user-defined yearly days on a lunar or Gregorian date (birthdays, anniversaries). Days missing from a short month fall on its last day.

### Fixed
- `Date.nextSpecialDay(sources:)` counts calendar days, so an event at midnight tomorrow is 1 day away instead of 0.

## 4.1.0

### Added
- Time-zone-aware solar terms: `Date.jieqi(in:)`, `isJieqiDay(in:)`, `currentJieqi(in:)`, `nextJieqi(in:)`, `Jieqi.startDate(in:timeZone:)` and `Jieqi.nextOccurrence(after:timeZone:)` reckon solar-term days on the calendar day of any time zone. The existing properties are unchanged and still use China Standard Time.

### Changed
- `ChineseAlmanac` reckons solar terms in its own `timeZone` (4.0.0 always used China Standard Time), and `AlmanacDay` exposes `timeZone`. With the default time zone, results are unchanged.
- `Date.chineseFestival(timeZone:)` matches solar-term festivals (清明, 冬至) in the given time zone. The `chineseFestival` property is unchanged.

## 4.0.0

Breaking release. See [MIGRATION.md](MIGRATION.md).

### Breaking
- `DisplayLanguage` is a struct instead of an enum; exhaustive `switch` statements need a `default:` branch. `allCases` now includes `.ru` and `.es`.
- Solar terms that begin in the afternoon (China time) are attributed to that day instead of the next. This affects `Date.jieqi`, `isJieqiDay`, `currentJieqi`, `nextJieqi`, `JieqiSource` and the 清明/冬至 festivals.

### Added
- `ChineseAlmanac`, `AlmanacDay` and `AlmanacText`: one call for the lunar date, pillars, solar term, festival, Twelve Gods, lunar mansion, moon phase and Shichen, already localized.
- `LunarDate` with `formatted(_:in:)` and `Date.lunarDate(_:)`.
- `DisplayLanguage.ru` / `.es`, `identifier`, `Codable`; Russian and Spanish festival and solar-term text through `localizedName(in:)` and the `Localized…ContentProvider`s.
- `TimeZone.chinaStandardTime` is public. `Date.chineseFestival(timeZone:)` and `Date.twelveGod(timeZone:)` are new.
- `Shichen` is `Sendable`.

### Deprecated
- `RussianFestivalContentProvider`, `SpanishFestivalContentProvider`, `RussianJieqiContentProvider` and `SpanishJieqiContentProvider`. Use `LocalizedFestivalContentProvider(language:)` / `LocalizedJieqiContentProvider(language:)`.
- `Date.chineseDate`, `chineseYearMonthDate`, `displayStringOfChineseYearMonthDateWithZodiac` and their `…GTM8` variants. Use `LunarDate`.

### Fixed
- `dateComponentsFromChineseCalendar(_:)` is safe to call concurrently.

## 3.2.0

### Added
- `Ganzhi`: public `gan`/`zhi`, `init?(_:_:)`, `init(jiaziIndex:)` and `jiaziIndex`.
- `LocalizedNaming` for Tiangan, Dizhi (plus `localizedHourName(in:)`), Ganzhi, Nayin, LunarMansion, FourSymbol and the `DizhiRelationship` kinds.
- `LunarMonth` and `Date.lunarMonth(_:)`.
- `DisplayLanguage(identifier:)`.

### Fixed
- `DisplayLanguage(locale:)` treated `zh-Hant-CN` as Simplified.
- Traditional-script names: 軫, 覆燈火, 子午沖.
- Astral is pinned by version, so this package can be depended on by version.

## 3.1.0
- Russian and Spanish content providers for festivals and solar terms.

## 3.0.0
- Solar terms reckoned by the China civil day. CI fixes.

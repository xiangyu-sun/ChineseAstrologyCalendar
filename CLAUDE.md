# CLAUDE.md

Swift package (library product `ChineseAstrologyCalendar`) for the traditional Chinese calendar:
lunar dates, 干支 pillars, 五行, 節氣 solar terms, festivals, 建除十二神, 二十八宿, 時辰, and a
localized `ChineseAlmanac` facade used by apps (TianganDizhi) and packages (Bagua, JingluoShuxueCore).
iOS 13+ / macOS 10.14+ / watchOS 6+, swift-tools-version 6.0. Default branch is `master`.

## Commands
```bash
swift build
swift test                      # ~20 s, ~385 Swift Testing tests (all files `import Testing`)
swift test --filter <Suite/test>
```
No lint/format plugins are wired up (CONTRIBUTING.md's `swift package format/lint` don't exist).
CI (`swift.yml`) builds and tests PRs on macOS only (Astral needs CoreLocation).

If `swift test` fails with `missing required module '_TestingInternals'` or "module compiled with Swift X
cannot be imported", a stale prebuilt module from an older toolchain is in `.build`:
`rm -f .build/*/debug/Modules/Testing.swiftmodule .build/*/debug/Modules/_TestingInternals.swiftmodule`.

## Layout (`Sources/ChineseAstrologyCalendar/`)
- `ChineseAlmanac.swift` — app entry point (`AlmanacDay`, `AlmanacText`)
- `Date/` — Gregorian→Chinese conversion, `LunarDate`, `DayConverter`, `Date+SpecialDay`
- `DizhiGanzhi/` Tiangan/Dizhi/Ganzhi/Jiazi/Nayin/Zodiac · `FiveElements/` Wuxing, FangWei, Season
- `Jieqi/` solar terms + health tips · `Moon/` · `Event/EventModel` · top-level Bazi, Day, Shichen, TwelveGods, LunarMansion, ChineseFestival
- `SpecialDaySources/` — `SpecialDaySource` protocol, `FestivalSource`, `JieqiSource`, `RecurringDaySource`, content providers
- `Localization/` — `DisplayLanguage`, `*+Localized.swift` (including es names); `Tables/` holds ru and es festival/節氣 text

Concepts, data flow and extension points: `docs/architecture.md` (read when new to the domain).

## Public API essentials
- `ChineseAlmanac(timeZone: = .chinaStandardTime, language: = .current)`: `day(for:)` → `AlmanacDay`, `days(from:count:)`.
  `AlmanacDay` is a `Sendable` snapshot; `.text` → localized `AlmanacText`.
  Add new almanac facts to `AlmanacDay` and `AlmanacText` together, with a test in `V4APITests.swift`.
- `LunarDate` (`Date/LunarDate.swift`): year `Ganzhi` + `LunarMonth` + `Day`, `formatted(_:in:)`; replaces deprecated `Date+Year` strings.
- Special days: `Date.specialDays(sources:)`, `nextSpecialDay(sources:)` (strictly after the date, counts calendar days),
  `currentOrNextSpecialDay(sources:calendar:)` (use for "today / next" UI), `upcomingSpecialDays(sources:within:calendar:)`,
  `nextChineseFestival(converter:)`, `chineseFestival` (exact day).
- `LocalizedFestivalContentProvider(language:)` / `LocalizedJieqiContentProvider(language:)` cover every language;
  `Default*` providers are the Traditional Chinese originals.

## Domain gotchas
- **Solar terms are reckoned per calendar day in a time zone**: China (UTC+8) for plain properties (`jieqi`, `isJieqiDay`,
  `currentJieqi`, `nextJieqi`), any zone via the `(in: TimeZone)` overloads. A term belongs to the day it begins, so
  `jieqi(in:)` samples the sun at the **last instant** of the day, never noon (noon put afternoon transitions a day late).
- Clients offering local vs China time (TianganDizhi's `useGTM8`) pass the zone to the `(in:)` overloads; don't re-implement end-of-day alignment app-side.
- `Bazi(date:)` always uses China Standard Time. Lunar dates, solar terms, festivals, Twelve Gods and Shichen take a
  time zone/calendar; `ChineseAlmanac` passes its own to all of them.
- `dateComponentsFromChineseCalendar` uses a shared `DateFormatter` guarded by `NSLock`; keep the lock.

## Localization rules
- `DisplayLanguage` is a **struct** (`zhHant`, `zhHans`, `en`, `ru`, `es`), not an enum, so adding a language isn't source-breaking. Never make it an enum.
- Switch exhaustively on internal `language.base` (zhHant/zhHans/en/es): every type needs all four; ru falls back to English.
  Types with their own ru text (`ChineseFestival`, `Jieqi`) check `language == .ru` first.
- Spanish writes stems, branches and 干支 in Pinyin, and uses "Día 9 del 5.º mes" for lunar dates.
  `LocalizationCoverageTests` rejects Spanish that equals the English or contains Han characters; add new types to its list.
- `.zhHant` is canonical and must equal `traditionalChineseName`/`chineseCharacter`; canonical strings are Traditional script.
- Long-form prose (Jieqi `healthTip`, TwelveGods almanac text) is intentionally not machine-translated.
- Every `localizedName(in:)` must be non-empty for all `DisplayLanguage.allCases` (`LocalizationCoverageTests`).

## Versioning and releases
- Breaking changes (incl. behaviour changes with unchanged signatures) only in a major version, listed in `CHANGELOG.md`
  with a `MIGRATION.md` section (before/after code). Every release gets a `CHANGELOG.md` entry.
- Deprecate before removing: keep a forwarding `@available(*, deprecated, message: "Use …")` API for one major version.
  To delete in 5.0: `Russian*`/`Spanish*` content providers (`DeprecatedContentProviders.swift`) and `Date+Year` string properties.
- Release = push a `v*` tag on a `master` commit (never an unmerged branch); `release.yml` builds, tests and publishes a GitHub release.
- Dependencies are pinned by version, never a branch (downstream packages depend on this one by version): Astral `from: "1.4.0"`
  (sun position for solar terms). swift-numerics is declared but no source imports it.
- Downstream Bagua and JingluoShuxueCore (same GitHub folder) must bump their minimum version when they need a new API.

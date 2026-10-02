# Migrating to ChineseAstrologyCalendar 4.0

4.0 makes localization extensible, adds a single entry point for apps, and corrects
the day on which solar terms begin. Most apps need only the changes in **§1** and
**§4**. Everything removed from the main API in 4.0 is still available but
deprecated, and will be deleted in 5.0.

| # | Change | Kind | Action needed |
|---|--------|------|---------------|
| 1 | `DisplayLanguage` is a struct, not an enum | Source-breaking | Add `default:` to `switch` statements |
| 2 | Russian and Spanish are `DisplayLanguage` values | Deprecation | Replace the four `Russian…`/`Spanish…` providers |
| 3 | `Date+Year` string properties replaced by `LunarDate` | Deprecation | Move to `lunarDate()?.formatted(_:in:)` |
| 4 | Solar terms that begin in the afternoon now belong to that day | Behaviour change | Check stored dates and hard-coded expectations |
| 5 | `ChineseAlmanac` / `AlmanacDay` | Addition | Optional: adopt as your entry point |

---

## 1. `DisplayLanguage` is now a struct

**Why:** adding a language to an enum breaks every exhaustive `switch` in client code,
so a new language would have needed a major release. As a struct, languages can be
added in minor releases.

**What breaks:** exhaustive `switch` statements over `DisplayLanguage`, typically in
your own `LocalizedNaming` conformances, no longer compile.

```swift
// 3.x
switch language {
case .zhHant: return "龍"
case .zhHans: return "龙"
case .en: return "Dragon"
}

// 4.0: the static members still work as patterns; add a default
switch language {
case .zhHant: return "龍"
case .zhHans: return "龙"
default: return "Dragon"   // .en, .ru, .es and any future language
}
```

Dictionary lookups keyed by `DisplayLanguage` keep working, but now see `.ru` and
`.es`: give them an English fallback (`table[language] ?? table[.en]`).

**Other changes**

- `DisplayLanguage.allCases` is now `[.zhHant, .zhHans, .en, .ru, .es]`. Code that
  iterates it to build UI or tests will see two more languages.
- `DisplayLanguage(locale:)` / `init(identifier:)` now resolve Russian and Spanish
  locales (`ru-RU`, `es-MX`, …) to `.ru` / `.es` instead of `.en`.
- New: `identifier` (`"zh-Hant"`, `"zh-Hans"`, `"en"`, `"ru"`, `"es"`), `Codable`
  (encodes as the identifier string) and `CustomStringConvertible`.
- For `.ru` and `.es`, every type renders in English except `ChineseFestival` and
  `Jieqi`, which have Russian and Spanish text.

## 2. Russian and Spanish providers folded into `DisplayLanguage`

| 3.x (deprecated) | 4.0 |
|---|---|
| `RussianFestivalContentProvider()` | `LocalizedFestivalContentProvider(language: .ru)` |
| `SpanishFestivalContentProvider()` | `LocalizedFestivalContentProvider(language: .es)` |
| `RussianJieqiContentProvider()` | `LocalizedJieqiContentProvider(language: .ru)` |
| `SpanishJieqiContentProvider()` | `LocalizedJieqiContentProvider(language: .es)` |

Output is identical. The same strings are also available directly:
`ChineseFestival.midAutumn.localizedName(in: .ru)`, `Jieqi.winterSolstice.localizedName(in: .es)`.

`LocalizedJieqiContentProvider.detail(for:)` returns the hand-written Russian or
Spanish health note for `.ru` / `.es`. For `.zhHans` and `.en` it still returns the
Traditional Chinese `healthTip`, as in 3.x.

## 3. `Date+Year` strings replaced by `LunarDate`

The 3.x properties cut fixed character offsets out of a `DateFormatter` string. That
broke whenever the OS changed its Chinese-calendar format and could only produce
Traditional Chinese. They now render a `LunarDate` (same output in Traditional
Chinese) and are deprecated.

| 3.x (deprecated) | 4.0 |
|---|---|
| `date.chineseDate` | `date.lunarDate()?.formatted(.day, in: language)` |
| `date.chineseYearMonthDate` | `date.lunarDate()?.formatted(.yearMonthDay, in: language)` |
| `date.displayStringOfChineseYearMonthDateWithZodiac` | `date.lunarDate()?.formatted(.yearZodiacMonthDay, in: language)` |
| `date.chineseDateGTM8` etc. (the `…GTM8` variants) | pass `.chineseCalendarGTM8`: `date.lunarDate(.chineseCalendarGTM8)?.formatted(…)` |

`LunarDate` also exposes the parts as values (`year: Ganzhi`, `month: LunarMonth`,
`day: Day`, `zodiac`), so you no longer need to parse the string.

## 4. Solar terms that begin in the afternoon now belong to that day

3.1 started reckoning solar terms by the China civil day (UTC+8) but sampled the
sun's position at **noon**. A term that began after noon was therefore reported on
the **next** day. For example, 清明 2025 began at 15:48 on 4 April, but 3.x reported
5 April. 4.0 samples at the end of the civil day, so a term belongs to the day it
begins, as in printed almanacs.

Affected APIs: `Date.jieqi`, `isJieqiDay`, `currentJieqi`, `nextJieqi`,
`Jieqi.startDate(in:)`, `Jieqi.nextOccurrence(after:)`, `JieqiSource`, and the
solar-term festivals (清明, 冬至) in `Date.chineseFestival` and `FestivalSource`.
Roughly half of all solar terms begin in the afternoon, so expect about half of
solar-term dates computed by 3.1–3.2 to move one day earlier. If you stored them,
recompute them.

## 5. New: `ChineseAlmanac`

This change is additive and optional, but it is the recommended entry point for apps:

```swift
let almanac = ChineseAlmanac(language: DisplayLanguage(identifier: Bundle.main.preferredLocalizations.first ?? "en"))
let day = almanac.day(for: Date())   // AlmanacDay
day.text.lunarDate                   // already localized
```

- The time zone is set once (default: China Standard Time) instead of choosing
  between `X` and `XGTM8` APIs.
- The language is set once, so you no longer call `localizedName(in:)` per value.
- `AlmanacDay` is an `Equatable`, `Sendable` value you can cache or pass to widgets.

Supporting additions: `TimeZone.chinaStandardTime` is public;
`Date.chineseFestival(timeZone:)` and `Date.twelveGod(timeZone:)` take a time zone
(the existing no-argument forms keep using the device's time zone); `Shichen` is
`Sendable`.

## Also fixed in 4.0

- `dateComponentsFromChineseCalendar(_:)` set the time zone on a shared
  `DateFormatter` without synchronization, so concurrent calls with different time
  zones could return each other's results. It is now thread-safe.

# Architecture and domain background

Background on the concepts and the main types. Read this when you are new to the
domain (干支, 五行, 節氣) or are adding a new kind of calendar fact.

## Ganzhi system (干支) — `DizhiGanzhi/`
- **Tiangan (天干)**: 10 Heavenly Stems (`jia` … `kui`)
- **Dizhi (地支)**: 12 Earthly Branches (`zi` … `hai`)
- **Ganzhi**: stem + branch; **Jiazi** is the 60-combination cycle used for years, months, days and hours
- Also here: `Nayin`, `Zodiac`, `DizhiRelationship`

## Five Elements (Wuxing 五行) — `FiveElements/`
- Wood, Fire, Earth, Metal, Water; generating (`sheng`) and controlling (`ke`) cycles
- Every Tiangan and Dizhi maps to an element; elements map to colours, flavours, directions (`FangWei`) and `Season`

## Calendar conversion — `Date/`
- `Date+DateComponents.swift`, `Date+Ganzhi.swift`: Gregorian → Chinese components via Foundation's Chinese calendar with explicit time zones
- `LunarDate`, `YearGanzhi`, `DateComponents+Day/Month/Hour`

## Lunar days and time — `Day.swift`, `Moon/`, `Shichen.swift`
- `Day`: 30 lunar days (`chuyi` … `sanshi`) with Chinese text; `MoonPhase` per day
- `Shichen`: 2-hour periods mapped to Dizhi, with start/end intervals

## Events and search — `Event/`, `Date/DayConverter.swift`
- `EventModel`: occurrences of a lunar day; `DayConverter` finds upcoming occurrences across months/years

## Other almanac facts
- `TwelveGods.swift` (建除十二神), `LunarMansion.swift` (二十八宿), `Bazi.swift` (四柱), `ChineseFestival.swift`, `Jieqi/` (incl. `Jieqi+Health.swift` health tips)

## Data flow
1. Gregorian `Date` → Chinese calendar components (Foundation `Calendar`)
2. Components → Ganzhi via traditional formulas
3. Lunar day search → `EventModel`s with formatted Chinese text
4. Solar terms → sun longitude from the Astral dependency

## Extension points
Element-based calculations (Wuxing), zodiac/branch associations, new date formatting,
astronomical events via Astral, new `SpecialDaySource`s, new facts on `AlmanacDay`.

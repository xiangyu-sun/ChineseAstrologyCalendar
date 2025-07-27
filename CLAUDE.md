# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands for Development

### Building and Testing
```bash
swift build                    # Build the package
swift test                     # Run all tests
swift test --filter <TestName> # Run specific test class or method
swift test list               # List all available tests
```

### Code Quality
The project uses SwiftLint and SwiftFormat for code quality, configured as package plugins:
```bash
swift package format          # Format code using SwiftFormat
swift package lint           # Lint code using SwiftLint
```

### Release Management
Create releases by pushing git tags that match the pattern `v*` (e.g., `v1.2.0`). This triggers an automated workflow that builds the package and creates a GitHub release with a ZIP archive.

## Project Architecture

### Core Concept: Chinese Astrology Calendar System
This Swift package provides utilities for working with traditional Chinese lunar calendar and astrology concepts, focusing on date conversions and astronomical calculations.

### Key Architectural Components

#### 1. Ganzhi System (干支)
The foundation of Chinese calendar calculations:
- **Tiangan (天干)**: 10 Heavenly Stems (`jia` through `kui`)
- **Dizhi (地支)**: 12 Earthly Branches (`zi` through `hai`) 
- **Ganzhi**: Combinations of stem + branch forming 60-cycle periods
- **Jiazi**: Complete 60-combination cycle used for years, months, days, and hours

#### 2. Five Elements Theory (Wuxing 五行)
Philosophical system integrating throughout the calendar:
- **Elements**: Wood(木), Fire(火), Earth(土), Metal(金), Water(水)
- **Relationships**: Generating cycle (`sheng`) and controlling cycle (`ke`)
- **Mappings**: Each Tiangan and Dizhi maps to specific Wuxing elements
- **Associations**: Colors, flavors, directions, and seasons

#### 3. Calendar Conversion Architecture
Date conversion between Gregorian and Chinese lunar calendar:
- **Date Extensions**: Core functionality in `Date+DateComponents.swift`, `Date+Ganzhi.swift`
- **DateComponents Extensions**: Chinese calendar component extraction
- **Calendar Bridge**: Uses Foundation's Chinese calendar with custom timezone handling

#### 4. Lunar Day and Time Systems
- **Day Enum**: 30 lunar days (`chuyi` to `sanshi`) with Chinese text representations
- **MoonPhase**: Associated lunar phases for each day of the month
- **Shichen**: Traditional 2-hour time periods mapped to Dizhi branches
- **Time Calculations**: Hour-to-Dizhi mapping with start/end time intervals

#### 5. Event and Search System
- **EventModel**: Represents occurrences of specific lunar days
- **DayConverter**: Searches for upcoming lunar day occurrences across months/years
- **Formatters**: Traditional Chinese text formatting for dates and components

### Dependencies and External Libraries
- **swift-numerics**: Mathematical calculations for astronomical computations
- **Astral**: Astronomical calculations for solar terms and celestial positioning
- **SwiftLint/SwiftFormat**: Code quality tools (as package plugins)

### Testing Strategy
Comprehensive test coverage organized by functional areas:
- **Integration Tests**: Full date conversion workflows
- **Component Tests**: Individual Ganzhi, Wuxing, and lunar day calculations  
- **Date Tests**: Specific date scenarios and edge cases
- **Formatting Tests**: Chinese text output validation

### Data Flow Patterns
1. **Gregorian Date Input** → Chinese calendar components via Foundation Calendar
2. **DateComponents** → Ganzhi calculations using traditional formulas
3. **Lunar Day Search** → Event models with formatted Chinese representations
4. **Astronomical Data** → Solar terms and moon phases via Astral dependency

### Platform Support
- iOS 13+, macOS 10.14+, watchOS 5+
- Swift 5.8+ toolchain required
- Cross-platform compatibility for all astronomical calculations

### Key Extension Points
When adding new features, consider these integration points:
- **Wuxing relationships**: New element-based calculations 
- **Zodiac mappings**: Additional animal/branch associations
- **Calendar conversions**: New date formatting options
- **Astronomical events**: Integration with Astral library for celestial calculations
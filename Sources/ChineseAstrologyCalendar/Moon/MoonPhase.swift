#if canImport(WeatherKit)
import WeatherKit

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
extension ChineseMoonPhase {
  public var moonPhase: MoonPhase {
    switch self {
    case .newMoon:
      return .new
    case .waxingCrescent:
      return .waxingCrescent
    case .firstQuarter:
      return .firstQuarter
    case .waxingGibbous:
      return .waxingGibbous
    case .fullMoon:
      return .full
    case .waningGibbous:
      return .waningGibbous
    case .lastQuarter:
      return .lastQuarter
    case .waningCrescent:
      return .waningCrescent
    case .darkMoon:
      return .new
    }
  }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
extension MoonPhase {

  public func moonPhase(day: Day) -> ChineseMoonPhase {
    switch self {
    case .new:
      if day == .day30 {
        return .darkMoon
      } else {
        return .newMoon
      }

    case .waxingCrescent:
      return .waxingCrescent

    case .firstQuarter:
      return .firstQuarter

    case .waxingGibbous:
      return .waxingGibbous

    case .full:
      return .fullMoon

    case .waningGibbous:
      return .waningGibbous

    case .lastQuarter:
      return .lastQuarter

    case .waningCrescent:
      return .waningCrescent
    }
  }

}

#endif

// MARK: - ChineseMoonPhase

/// Lunar phases expressed with traditional Chinese names.
public enum ChineseMoonPhase: String, CaseIterable, TraditionalChineseNaming {

  /// The disk is unlit where the moon is not visible.
  case newMoon        = "朔"

  /// The disk is partially lit as the moon is waxing.
  case waxingCrescent = "蛾眉月"

  /// The disk is half lit.
  case firstQuarter   = "上弦月"

  /// The disk is half lit as the moon is waxing.
  case waxingGibbous  = "漸盈凸月"

  /// The disk is fully lit where the moon is visible.
  case fullMoon       = "望"

  /// The disk is half lit as the moon is waning.
  case waningGibbous  = "漸虧凸月"

  /// The disk is half lit.
  case lastQuarter    = "下弦月"

  /// The disk is partially lit as the moon is waning.
  case waningCrescent = "殘月"

  /// The dark moon at the end of the lunar month.
  case darkMoon       = "晦"

  /// Traditional Chinese character(s) for this phase.
  /// This is identical to `rawValue` and is provided for consistent API access.
  public var traditionalChineseName: String { rawValue }

  /// Historical Chinese name for the phase.
  public func acientChineseName(_: Day) -> String {
    rawValue
  }

  /// Modern Chinese name for the phase.
  public func modernChineseName(_: Day) -> String {
    switch self {
    case .newMoon:
      return "新月"
    case .waxingCrescent:
      return "上蛾眉月"
    case .firstQuarter:
      return "上弦月"
    case .waxingGibbous:
      return "漸盈凸月"
    case .fullMoon:
      return "滿月"
    case .waningGibbous:
      return "漸虧凸月"
    case .lastQuarter:
      return "下弦月"
    case .waningCrescent:
      return "下蛾眉月"
    case .darkMoon:
      return "晦"
    }
  }

}

#if canImport(WeatherKit)
import WeatherKit

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
extension ChineseMoonPhase {
  public var moonPhase: MoonPhase {
    switch self {
    case .朔:
      return .new
    case .蛾眉月:
      return .waxingCrescent
    case .上弦月:
      return .firstQuarter
    case .漸盈凸月:
      return .waxingGibbous
    case .望:
      return .full
    case .漸虧凸月:
      return .waningGibbous
    case .下弦月:
      return .lastQuarter
    case .殘月:
      return .waningCrescent
    case .晦:
      return .new
    }
  }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
extension MoonPhase {

  public func moonPhase(day: Day) -> ChineseMoonPhase {
    switch self {
    case .new:
      if day == .sanshi {
        return .晦
      } else {
        return .朔
      }

    case .waxingCrescent:
      return .蛾眉月

    case .firstQuarter:
      return .上弦月

    case .waxingGibbous:
      return .漸盈凸月

    case .full:
      return .望

    case .waningGibbous:
      return .漸虧凸月

    case .lastQuarter:
      return .下弦月

    case .waningCrescent:
      return .殘月
    }
  }

}

#endif

// MARK: - ChineseMoonPhase

/// Lunar phases expressed with traditional Chinese names.
public enum ChineseMoonPhase: String, CaseIterable {

  /// The disk is unlit where the moon is not visible.
  case 朔

  /// The disk is partially lit as the moon is waxing.
  case 蛾眉月

  /// The disk is half lit.
  case 上弦月

  /// The disk is half lit as the moon is waxing.
  case 漸盈凸月

  /// The disk is fully lit where the moon is visible.
  case 望

  /// The disk is half lit as the moon is waning.
  case 漸虧凸月

  /// The disk is half lit.
  case 下弦月

  /// The disk is partially lit as the moon is waning.
  case 殘月

  case 晦

 

  /// Historical Chinese name for the phase.
  public func acientChineseName(_: Day) -> String {
    rawValue
  }

  /// Modern Chinese name for the phase.
  public func modernChineseName(_: Day) -> String {
    switch self {
    case .朔:
      return "新月"
    case .蛾眉月:
      return "上蛾眉月"
    case .上弦月:
      return "上弦月"
    case .漸盈凸月:
      return "漸盈凸月"
    case .望:
      return "滿月"
    case .漸虧凸月:
      return "漸虧凸月"
    case .下弦月:
      return "下弦月"
    case .殘月:
      return "下蛾眉月"
    case .晦:
      return "晦"
    }
  }

}

#if canImport(WeatherKit)
import Bagua
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
  public var gua: Trigram? {
    switch self {
    case .new:
      return .kun
    case .waxingCrescent:
      return .zhen
    case .firstQuarter:
      return .dui
    case .waxingGibbous:
      return nil
    case .full:
      return .qian
    case .waningGibbous:
      return nil
    case .lastQuarter:
      return .xun
    case .waningCrescent:
      return .gen
    }
  }
  
  public var gua64: HexagramSymbol? {
    switch self {
    case .new:
      return .坤
    case .waxingCrescent:
      return .臨
    case .firstQuarter:
      return .大壯
    case .waxingGibbous:
      return nil
    case .full:
      return .乾
    case .waningGibbous:
      return nil
    case .lastQuarter:
      return .遯
    case .waningCrescent:
      return .觀
    }
  }

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

  // MARK: Public

  public var gua: Trigram? {
    switch self {
    case .朔, .晦:
      return .kun
    case .蛾眉月:
      return .zhen
    case .上弦月:
      return .dui
    case .漸盈凸月:
      return nil
    case .望:
      return .qian
    case .漸虧凸月:
      return nil
    case .下弦月:
      return .xun
    case .殘月:
      return .gen
    }
  }

  public func acientChineseName(_: Day) -> String {
    rawValue
  }

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

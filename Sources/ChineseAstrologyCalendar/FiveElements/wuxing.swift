
import Foundation

/// The five elements used throughout Chinese philosophy.
public enum Wuxing: Int, CaseIterable {

  case mu
  case huo
  case tu
  case jin
  case shui

  // MARK: Public

  /// Heavenly stems associated with the element.
  public var tiangan: (Tiangan, Tiangan) {
    switch self {
    case .mu:
      return (.jia, .yi)
    case .huo:
      return (.bing, .ding)
    case .tu:
      return (.wu, .ji)
    case .jin:
      return (.geng, .xin)
    case .shui:
      return (.ren, .kui)
    }
  }

  /// Chinese character used for the element.
  public var chineseCharacter: String {
    switch self {
    case .jin:
      return "金"
    case .mu:
      return "木"
    case .shui:
      return "水"
    case .huo:
      return "火"
    case .tu:
      return "土"
    }
  }

  /// Traditional color linked to the element.
  public var colorDescription: String {
    switch self {
    case .jin:
      return "白"
    case .mu:
      return "青"
    case .shui:
      return "黑"
    case .huo:
      return "赤"
    case .tu:
      return "黃"
    }
  }

  /// Traditional flavor associated with the element.
  /// 凡酸屬木入肝，苦屬火入心，甘屬土入脾，辛屬金入肺，鹹屬水入腎，此五味之義也。
  public var fiveFlavor: String {
    switch self {
    case .mu:
      return "酸"
    case .huo:
      return "苦"
    case .tu:
      return "甘"
    case .jin:
      return "辛"
    case .shui:
      return "鹹"
    }
  }

  /// Element generated by this element in the generating cycle.
  public var sheng: Wuxing {
    Wuxing(rawValue: rawValue.advanced(by: 1) % Wuxing.allCases.count) ?? .jin
  }

  /// Element controlled by this element in the controlling cycle.
  public var ke: Wuxing {
    Wuxing(rawValue: rawValue.advanced(by: 2) % Wuxing.allCases.count) ?? .jin
  }

  /// Earthly branches corresponding to the element.
  public var dizhi: [Dizhi] {
    switch self {
    case .mu:
      return [.yin, .mao]
    case .huo:
      return [.si, .wu]
    case .tu:
      return [.chen, .xu, .chou, .wei]
    case .jin:
      return [.shen, .you]
    case .shui:
      return [.zi, .hai]
    }
  }

  /// Direction associated with the element.
  public var fangwei: FangWei {
    switch self {
    case .jin:
      return .xi
    case .tu:
      return .zhong
    case .huo:
      return .nan
    case .mu:
      return .dong
    case .shui:
      return .bei
    }
  }

}

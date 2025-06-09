
import Foundation

/// Seasons mapped to their corresponding five elements.
public enum Season: CaseIterable, WuxingConvertable {
  case spring
  case summer
  case fall
  case winter

  // MARK: Public

  /// Chinese character representation of the season.
  public var chineseDescription: String {
    switch self {
    case .spring:
      return "春"
    case .summer:
      return "夏"
    case .fall:
      return "秋"
    case .winter:
      return "冬"
    }
  }

  /// ``Wuxing`` element corresponding to the season.
  public var wuxing: Wuxing {
    switch self {
    case .spring:
      return .mu
    case .summer:
      return .huo
    case .fall:
      return .jin
    case .winter:
      return .shui
    }
  }

  /// Cardinal direction associated with the season.
  public var fangwei: FangWei {
    switch self {
    case .spring:
      return .dong
    case .summer:
      return .nan
    case .fall:
      return .xi
    case .winter:
      return .bei
    }
  }

  /// Earthly branches occurring during this season.
  public var dizhi: [Dizhi] {
    switch self {
    case .spring:
      return [.yin, .mao, .chen]
    case .summer:
      return [.si, .wu, .wei]
    case .fall:
      return [.shen, .chou, .wu]
    case .winter:
      return [.hai, .zi, .chou]
    }
  }
}


import Foundation

/// Seasons mapped to their corresponding five elements.
public enum Season: CaseIterable, WuxingConvertable, TraditionalChineseNaming, Sendable {
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

  /// Traditional Chinese character for this season.
  public var traditionalChineseName: String { chineseDescription }

  /// ``Wuxing`` element corresponding to the season.
  public var wuxing: Wuxing {
    switch self {
    case .spring:
      return .wood
    case .summer:
      return .fire
    case .fall:
      return .metal
    case .winter:
      return .water
    }
  }

  /// Cardinal direction associated with the season.
  public var fangwei: FangWei {
    switch self {
    case .spring:
      return .east
    case .summer:
      return .south
    case .fall:
      return .west
    case .winter:
      return .north
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
      return [.shen, .you, .xu]
    case .winter:
      return [.hai, .zi, .chou]
    }
  }
}

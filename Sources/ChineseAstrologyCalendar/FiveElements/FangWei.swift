
import Foundation

/// Cardinal directions used with the five elements.
public enum FangWei: CaseIterable, WuxingConvertable {

  case dong
  case nan
  case xi
  case bei
  case zhong

  // MARK: Public

  /// Chinese character representation of the direction.
  public var chineseCharactor: String {
    switch self {
    case .dong:
      return "東"
    case .nan:
      return "南"
    case .xi:
      return "西"
    case .bei:
      return "北"
    case .zhong:
      return "中"
    }
  }

  /// ``Wuxing`` element corresponding to the direction.
  public var wuxing: Wuxing {
    switch self {
    case .dong:
      return .mu
    case .nan:
      return .huo
    case .xi:
      return .jin
    case .bei:
      return .shui
    case .zhong:
      return .tu
    }
  }
}

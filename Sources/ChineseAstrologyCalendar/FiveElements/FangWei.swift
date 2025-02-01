
import Foundation

public enum FangWei: CaseIterable, WuxingConvertable {

  case dong
  case nan
  case xi
  case bei
  case zhong

  // MARK: Public

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

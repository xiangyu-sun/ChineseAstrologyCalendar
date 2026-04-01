
import Foundation

/// Cardinal directions used with the five elements.
public enum FangWei: CaseIterable, WuxingConvertable, TraditionalChineseNaming, Sendable {

  case east
  case south
  case west
  case north
  case center

  // MARK: Public

  /// Chinese character representation of the direction.
  public var chineseCharacter: String {
    switch self {
    case .east:
      return "東"
    case .south:
      return "南"
    case .west:
      return "西"
    case .north:
      return "北"
    case .center:
      return "中"
    }
  }

  /// Traditional Chinese character for this direction.
  public var traditionalChineseName: String { chineseCharacter }

  /// Chinese character representation of the direction.
  @available(*, deprecated, renamed: "chineseCharacter", message: "Use chineseCharacter instead (spelling corrected)")
  public var chineseCharactor: String {
    chineseCharacter
  }

  /// ``Wuxing`` element corresponding to the direction.
  public var wuxing: Wuxing {
    switch self {
    case .east:
      return .wood
    case .south:
      return .fire
    case .west:
      return .metal
    case .north:
      return .water
    case .center:
      return .earth
    }
  }

  /// The two ``Tiangan`` (Heavenly Stems) associated with this direction.
  public var tiangan: (Tiangan, Tiangan) { wuxing.tiangan }

  /// The ``Dizhi`` (Earthly Branches) associated with this direction.
  public var dizhi: [Dizhi] { wuxing.dizhi }
}

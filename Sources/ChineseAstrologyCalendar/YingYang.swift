
import Foundation

// MARK: - TraditionalChineseNaming

/// Types that expose a traditional Chinese character representation.
///
/// All enums in this package expose their canonical Chinese text through this
/// property, regardless of whether the enum case names are English or pinyin.
/// Clients should use this property instead of `rawValue` when they need the
/// Chinese text, which ensures the property keeps working after any future
/// case-name changes.
public protocol TraditionalChineseNaming {
  /// The traditional Chinese character(s) for this value.
  var traditionalChineseName: String { get }
}

// MARK: - YinYangIdentifiable

/// Types that can indicate whether they are Yin or Yang based on their raw value.
public protocol YinYangIdentifiable {
  /// Returns ``true`` if the value represents Yin.
  var yin: Bool { get }
}

extension YinYangIdentifiable where Self: RawRepresentable, RawValue == Int {
  public var yin: Bool {
    rawValue.isMultiple(of: 2)
  }
}

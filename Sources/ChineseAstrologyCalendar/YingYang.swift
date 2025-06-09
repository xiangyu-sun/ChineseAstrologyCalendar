
import Foundation

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

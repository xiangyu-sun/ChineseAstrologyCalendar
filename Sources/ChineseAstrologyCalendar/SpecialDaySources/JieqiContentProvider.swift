import Foundation

// MARK: - JieqiContentProvider

/// Supplies display content for each `Jieqi` case when building a `SpecialDay`.
///
/// Conform to this protocol to provide localised or style-specific names,
/// descriptions, and category labels without modifying the `Jieqi` enum.
/// Pass your implementation to `JieqiSource(contentProvider:)`.
///
/// ```swift
/// struct EnglishJieqiContent: JieqiContentProvider {
///     func name(for jieqi: Jieqi) -> String {
///         switch jieqi {
///         case .springEquinox:  return "Spring Equinox"
///         case .clearAndBright: return "Clear and Bright (Qingming)"
///         // ...
///         }
///     }
///     func detail(for jieqi: Jieqi) -> String {
///         // Return an English health tip or seasonal note
///     }
///     var category: String { "Solar Term" }
/// }
///
/// let source = JieqiSource(contentProvider: EnglishJieqiContent())
/// ```
public protocol JieqiContentProvider: Sendable {

  /// The display name to use for the given solar term in a `SpecialDay`.
  func name(for jieqi: Jieqi) -> String

  /// The detail/description string to use for the given solar term in a `SpecialDay`.
  func detail(for jieqi: Jieqi) -> String

  /// The category label applied to every `SpecialDay` produced by `JieqiSource`.
  var category: String { get }
}

// MARK: - DefaultJieqiContentProvider

/// The built-in content provider for `JieqiSource`.
///
/// Returns the Traditional Chinese values already present on `Jieqi`
/// (`.chineseName` and `.healthTip`), preserving the library's original behaviour.
public struct DefaultJieqiContentProvider: JieqiContentProvider {

  public init() {}

  public func name(for jieqi: Jieqi) -> String {
    jieqi.chineseName
  }

  public func detail(for jieqi: Jieqi) -> String {
    jieqi.healthTip
  }

  public var category: String {
    JieqiSource.categoryName
  }
}

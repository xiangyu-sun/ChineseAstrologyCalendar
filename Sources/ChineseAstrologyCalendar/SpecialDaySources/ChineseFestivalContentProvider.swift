import Foundation

// MARK: - ChineseFestivalContentProvider

/// Supplies display content for each `ChineseFestival` case when building a `SpecialDay`.
///
/// Conform to this protocol to provide localised or style-specific names,
/// descriptions, and category labels without modifying the `ChineseFestival`
/// enum. Pass your implementation to `FestivalSource(contentProvider:)`.
///
/// ```swift
/// struct EnglishFestivalContent: ChineseFestivalContentProvider {
///     func name(for festival: ChineseFestival) -> String {
///         switch festival {
///         case .springFestival: return "Spring Festival"
///         case .midAutumn:      return "Mid-Autumn Festival"
///         // ...
///         }
///     }
///     func detail(for festival: ChineseFestival) -> String {
///         // Return an English description
///     }
///     var category: String { "Festival" }
/// }
///
/// let source = FestivalSource(contentProvider: EnglishFestivalContent())
/// ```
public protocol ChineseFestivalContentProvider: Sendable {

  /// The display name to use for the given festival in a `SpecialDay`.
  func name(for festival: ChineseFestival) -> String

  /// The detail/description string to use for the given festival in a `SpecialDay`.
  func detail(for festival: ChineseFestival) -> String

  /// The category label applied to every `SpecialDay` produced by `FestivalSource`.
  var category: String { get }
}

// MARK: - DefaultFestivalContentProvider

/// The built-in content provider for `FestivalSource`.
///
/// Returns the Traditional Chinese values already present on `ChineseFestival`
/// (`.chineseName` and `.meaning`), preserving the library's original behaviour.
public struct DefaultFestivalContentProvider: ChineseFestivalContentProvider {

  public init() {}

  public func name(for festival: ChineseFestival) -> String {
    festival.chineseName
  }

  public func detail(for festival: ChineseFestival) -> String {
    festival.meaning
  }

  public var category: String {
    FestivalSource.categoryName
  }
}

import Foundation

// MARK: - LocalizedJieqiContentProvider

/// A `JieqiContentProvider` that supplies display strings for each ``Jieqi``
/// in any ``DisplayLanguage``.
///
/// `name(for:)` is translated for every language. `detail(for:)` is the
/// seasonal health note: Russian and Spanish have hand-written notes, while
/// Simplified Chinese and English return the library's Traditional Chinese
/// `healthTip`, because machine-translating dense TCM text risked introducing
/// inaccurate health claims. Inject your own ``JieqiContentProvider`` if you
/// need a different `detail`.
///
/// ```swift
/// let source = JieqiSource(contentProvider: LocalizedJieqiContentProvider(language: .en))
/// ```
public struct LocalizedJieqiContentProvider: JieqiContentProvider {

  public let language: DisplayLanguage

  public init(language: DisplayLanguage) {
    self.language = language
  }

  public func name(for jieqi: Jieqi) -> String {
    jieqi.localizedName(in: language)
  }

  public func detail(for jieqi: Jieqi) -> String {
    switch language {
    case .ru: return RussianJieqiContent().detail(for: jieqi)
    case .es: return SpanishJieqiContent().detail(for: jieqi)
    default: return jieqi.healthTip
    }
  }

  public var category: String {
    switch language {
    case .ru: return RussianJieqiContent().category
    case .es: return SpanishJieqiContent().category
    default: break
    }
    switch language.base {
    case .zhHant: return JieqiSource.categoryName
    case .zhHans: return "节气"
    case .en: return "Solar Term"
    }
  }
}

import Foundation

// MARK: - Deprecated language-specific providers
//
// Russian and Spanish are DisplayLanguage values as of 4.0.0, served by the
// same providers as every other language.

@available(*, deprecated, message: "Use LocalizedFestivalContentProvider(language: .ru)")
public struct RussianFestivalContentProvider: ChineseFestivalContentProvider {
  private let base = LocalizedFestivalContentProvider(language: .ru)

  public init() {}

  public func name(for festival: ChineseFestival) -> String { base.name(for: festival) }
  public func detail(for festival: ChineseFestival) -> String { base.detail(for: festival) }
  public var category: String { base.category }
}

@available(*, deprecated, message: "Use LocalizedJieqiContentProvider(language: .ru)")
public struct RussianJieqiContentProvider: JieqiContentProvider {
  private let base = LocalizedJieqiContentProvider(language: .ru)

  public init() {}

  public func name(for jieqi: Jieqi) -> String { base.name(for: jieqi) }
  public func detail(for jieqi: Jieqi) -> String { base.detail(for: jieqi) }
  public var category: String { base.category }
}

@available(*, deprecated, message: "Use LocalizedFestivalContentProvider(language: .es)")
public struct SpanishFestivalContentProvider: ChineseFestivalContentProvider {
  private let base = LocalizedFestivalContentProvider(language: .es)

  public init() {}

  public func name(for festival: ChineseFestival) -> String { base.name(for: festival) }
  public func detail(for festival: ChineseFestival) -> String { base.detail(for: festival) }
  public var category: String { base.category }
}

@available(*, deprecated, message: "Use LocalizedJieqiContentProvider(language: .es)")
public struct SpanishJieqiContentProvider: JieqiContentProvider {
  private let base = LocalizedJieqiContentProvider(language: .es)

  public init() {}

  public func name(for jieqi: Jieqi) -> String { base.name(for: jieqi) }
  public func detail(for jieqi: Jieqi) -> String { base.detail(for: jieqi) }
  public var category: String { base.category }
}

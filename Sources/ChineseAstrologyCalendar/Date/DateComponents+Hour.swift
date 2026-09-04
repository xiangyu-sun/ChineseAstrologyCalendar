import Foundation

extension DateComponents {
  /// Computes the hour’s Heavenly Stem (時干) per 五鼠遁, based on the day’s
  /// stem and the *hour's own* branch.
  ///
  /// Formula:
  ///   shiGan = ((riGan - 1) * 2 + (shiZhi - 1)) mod 10, then +1 to re-index to 1...10
  public var shiGan: Tiangan? {
    // Ensure that the day’s Heavenly Stem and the hour's Earthly Branch are available.
    guard let dayStem = riGan, let hourBranch = shiZhi else {
      return nil
    }

    // We assume that both dayStem.rawValue and hourBranch.rawValue are 1-indexed.
    let preliminaryValue = (dayStem.rawValue - 1) * 2 + (hourBranch.rawValue - 1)

    // Calculate the hour stem index in the range 1...10.
    let hourStemIndex = preliminaryValue % 10 + 1

    return Tiangan(rawValue: hourStemIndex)
  }

  /// Computes the hour’s Earthly Branch (時支) based on the hour of day.
  ///
  /// The custom initializer of `Dizhi` (i.e. `Dizhi(hourOfDay:)`) is expected
  /// to map the hour (0–23) to the corresponding Earthly Branch.
  public var shiZhi: Dizhi? {
    guard let hour else {
      return nil
    }
    // If the hour component is missing, assume 0.
    let hourValue = hour
    return Dizhi(hourOfDay: hourValue)
  }

  /// Combines the hour Heavenly Stem and Earthly Branch to form the hour pillar (時柱).
  public var shiZhu: Ganzhi? {
    guard let stem = shiGan, let shiZhi else { return nil }
    return Ganzhi(gan: stem, zhi: shiZhi)
  }
}

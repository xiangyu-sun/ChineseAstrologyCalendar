import Foundation

extension DateComponents {
  /// Computes the hour’s Heavenly Stem (时干) based on the day’s stem and branch.
  ///
  /// Formula:
  ///   shiGan = (riGan * 2 + riZhi - 2) mod 10
  ///
  /// Note: If the modulo operation results in 0, it is mapped to 10.
  public var shiGan: Tiangan? {
    // Ensure that the day’s Heavenly Stem and Earthly Branch are available.
    guard let dayStem = riGan, let dayBranch = riZhi else {
      return nil
    }
    
    // Calculate the preliminary value.
    // We assume that both dayStem.rawValue and dayBranch.rawValue are 1-indexed.
    let preliminaryValue = (dayStem.rawValue * 2) + dayBranch.rawValue - 2
    
    // Calculate the hour stem index in the range 1...10.
    // If preliminaryValue % 10 == 0, we consider it as 10.
    let hourStemIndex = preliminaryValue % 10 == 0 ? 10 : preliminaryValue % 10
    
    return Tiangan(rawValue: hourStemIndex)
  }

  /// Computes the hour’s Earthly Branch (时支) based on the hour of day.
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

  /// Combines the hour Heavenly Stem and Earthly Branch to form the hour pillar (时柱).
  public var shiZhu: Ganzhi? {
    guard let stem = shiGan, let shiZhi else { return nil }
    return Ganzhi(gan: stem, zhi: shiZhi)
  }
}

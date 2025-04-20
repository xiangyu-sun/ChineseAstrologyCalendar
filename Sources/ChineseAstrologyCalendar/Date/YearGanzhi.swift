import Foundation

extension DateComponents {
  /// Computes the Heavenly Stem (年干) for the Chinese year.
  ///
  /// The formula is:
  ///   nianGan = chineseYear % 10,
  /// with a remainder of 0 being adjusted to 10.
  var nianGan: Tiangan? {
    guard let chineseYear else {
      return nil
    }
    // Ensure that the underlying chineseYear is valid.
    let remainder = chineseYear % 10
    // Adjust a 0 remainder to 10.
    let adjusted = remainder == 0 ? 10 : remainder
    return Tiangan(rawValue: adjusted)
  }

  /// Computes the Earthly Branch (年支) for the Chinese year.
  ///
  /// The formula is:
  ///   nianZhi = chineseYear % 12,
  /// with a remainder of 0 being adjusted to 12.
  /// The Dizhi values are assumed to be stored in Dizhi.allCases in order (1-indexed).
  var nianZhi: Dizhi? {
    guard let chineseYear else {
      return nil
    }
    let remainder = chineseYear % 12
    // Adjust a 0 remainder to 12.
    let adjusted = remainder == 0 ? 12 : remainder
    // Since allCases is 0-indexed, subtract 1.
    return Dizhi.allCases[adjusted - 1]
  }
}

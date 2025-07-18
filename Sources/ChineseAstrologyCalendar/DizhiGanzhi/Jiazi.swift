
import Foundation

/// Generates the 60 combinations of Heavenly Stems and Earthly Branches.
public func getJiazhi() -> [Ganzhi] {
  let dizhiCount = Dizhi.allCases.count
  let tianganCount = Tiangan.allCases.count

  let lcm = findLCM(n1: dizhiCount, n2: tianganCount)

  let dizhiRepeat = lcm / dizhiCount
  let tianganRepeat = lcm / tianganCount

  let dizhiLoop = Array(repeating: Dizhi.allCases, count: dizhiRepeat).flatMap { $0 }
  let tianganLoop = Array(repeating: Tiangan.allCases, count: tianganRepeat).flatMap { $0 }

  return zip(tianganLoop, dizhiLoop).map { Ganzhi(gan: $0, zhi: $1) }
}

#if canImport(WeatherKit)
import WeatherKit

@available(iOS 16.0, *)
public extension MoonPhase {
  func acientChineseName(_ day: Day) -> String {
    switch self {
    case .new:
      if day == .sanshi {
        return "晦"
      } else {
        return "朔"
      }
      
    case .waxingCrescent:
      return "蛾眉月"
    case .firstQuarter:
      return "上弦月"
    case .waxingGibbous:
      return "渐盈凸月"
    case .full:
      return "望"
    case .waningGibbous:
      return "渐亏凸月"
    case .lastQuarter:
      return "下弦月"
    case .waningCrescent:
      return "残月"
    }
  }
  
  func modernChineseName(_: Day) -> String {
    switch self {
    case .new:
      return "新月"
    case .waxingCrescent:
      return "上蛾眉月"
    case .firstQuarter:
      return "上弦月"
    case .waxingGibbous:
      return "渐盈凸月"
    case .full:
      return "满月"
    case .waningGibbous:
      return "渐亏凸月"
    case .lastQuarter:
      return "下弦月"
    case .waningCrescent:
      return "下蛾眉月"
    }
  }
  
}

#endif


public enum ChineseMoonPhase : String, CaseIterable {
  
  /// The disk is unlit where the moon is not visible.
  case 朔
  
  /// The disk is partially lit as the moon is waxing.
  case 蛾眉月
  
  /// The disk is half lit.
  case 上弦月
  
  /// The disk is half lit as the moon is waxing.
  case 渐盈凸月
  
  /// The disk is fully lit where the moon is visible.
  case 望
  
  /// The disk is half lit as the moon is waning.
  case 渐亏凸月
  
  /// The disk is half lit.
  case 下弦月
  
  /// The disk is partially lit as the moon is waning.
  case 残月
  
  case 晦
  
  public func acientChineseName(_ day: Day) -> String {
    return self.rawValue
  }
  
  public func modernChineseName(_: Day) -> String {
    switch self {
    case .朔:
      return "新月"
    case .蛾眉月:
      return "上蛾眉月"
    case .上弦月:
      return "上弦月"
    case .渐盈凸月:
      return "渐盈凸月"
    case .望:
      return "满月"
    case .渐亏凸月:
      return "渐亏凸月"
    case .下弦月:
      return "下弦月"
    case .残月:
      return "下蛾眉月"
    case .晦:
      return "晦"
    }
  }
  
}

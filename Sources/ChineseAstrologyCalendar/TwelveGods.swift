import Foundation

/// 建、除、滿、平、定、執、破、危、成、收、開、閉
public enum TwelveGods: Int, CaseIterable {
  case jian = 0
  case chu
  case man
  case ping
  case ding
  case zhi
  case po
  case wei
  case cheng
  case shou
  case kai
  case bi
  
  public var chinese: String {
    switch self {
    case .jian: return "建"
    case .chu: return "除"
    case .man: return "滿"
    case .ping: return "平"
    case .ding: return "定"
    case .zhi: return "執"
    case .po: return "破"
    case .wei: return "危"
    case .cheng: return "成"
    case .shou: return "收"
    case .kai: return "開"
    case .bi: return "閉"
    }
  }

  /// 根据地支获取值日神
  public init(from branch: Dizhi) {
    switch branch {
    case .yin:  self = .jian
    case .mao:  self = .chu
    case .chen: self = .man
    case .si:   self = .ping
    case .wu:   self = .ding
    case .wei:  self = .zhi
    case .shen: self = .po
    case .you:  self = .wei
    case .xu:   self = .cheng
    case .hai:  self = .shou
    case .zi:   self = .kai
    case .chou: self = .bi
    }
  }
}

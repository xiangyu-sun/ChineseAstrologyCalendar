public enum Day: Int, CaseIterable, Identifiable, Codable, Comparable {
  case chuyi = 1
  case chuer
  case chusan
  case chusi
  case chuwu
  case chulliu
  case chuqi
  case chuba
  case chujiu
  case chushi
  case shiyi
  case shier
  case shisan
  case shisi
  case shiwu
  case shiliu
  case shiqi
  case shiba
  case shijiu
  case ershi
  case eryi
  case erer
  case ersan
  case ersi
  case erwu
  case erliu
  case erqi
  case erba
  case erjiu
  case sanshi

  // MARK: Public

  public var id: Int {
    rawValue
  }

  public var name: String {
    switch self {
    case .chuyi:
      return "初一"
    case .chuer:
      return "初二"
    case .chusan:
      return "初三"
    case .chusi:
      return "初四"
    case .chuwu:
      return "初五"
    case .chulliu:
      return "初六"
    case .chuqi:
      return "初七"
    case .chuba:
      return "初八"
    case .chujiu:
      return "初九"
    case .chushi:
      return "初十"
    case .shiyi:
      return "十一"
    case .shier:
      return "十二"
    case .shisan:
      return "十三"
    case .shisi:
      return "十四"
    case .shiwu:
      return "十五"
    case .shiliu:
      return "十六"
    case .shiqi:
      return "十七"
    case .shiba:
      return "十八"
    case .shijiu:
      return "十九"
    case .ershi:
      return "二十"
    case .eryi:
      return "廿一"
    case .erer:
      return "廿二"
    case .ersan:
      return "廿三"
    case .ersi:
      return "廿四"
    case .erwu:
      return "廿五"
    case .erliu:
      return "廿六"
    case .erqi:
      return "廿七"
    case .erba:
      return "廿八"
    case .erjiu:
      return "廿九"
    case .sanshi:
      return "三十"
    }
  }

  public static func < (lhs: Day, rhs: Day) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

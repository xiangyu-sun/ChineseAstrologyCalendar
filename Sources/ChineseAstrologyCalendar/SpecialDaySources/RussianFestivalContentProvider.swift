import Foundation

// MARK: - RussianFestivalContentProvider

/// Russian-language content for `FestivalSource`.
///
/// Supplies Russian names and descriptions for every `ChineseFestival` case.
///
/// ```swift
/// let source = FestivalSource(contentProvider: RussianFestivalContentProvider())
/// ```
public struct RussianFestivalContentProvider: ChineseFestivalContentProvider {

  public init() {}

  public func name(for festival: ChineseFestival) -> String {
    switch festival {
    case .springFestival:     return "Праздник весны (Китайский Новый год)"
    case .lanternFestival:    return "Праздник фонарей"
    case .dragonRaisesHead:   return "Дракон поднимает голову"
    case .qingming:           return "Праздник Цинмин"
    case .dragonBoat:         return "Праздник драконьих лодок"
    case .doubleSeventhNight: return "Праздник Циси"
    case .ghostFestival:      return "Праздник голодных духов"
    case .midAutumn:          return "Праздник середины осени"
    case .doubleNinth:        return "Праздник двойной девятки (Чунъян)"
    case .dongzhi:            return "Праздник зимнего солнцестояния"
    case .laba:               return "Праздник Лаба"
    case .littleNewYear:      return "Малый Новый год"
    }
  }

  public func detail(for festival: ChineseFestival) -> String {
    switch festival {
    case .springFestival:
      return "Китайский Новый год по лунному календарю — важнейший традиционный праздник, знаменующий начало нового года."
    case .lanternFestival:
      return "Пятнадцатый день первого лунного месяца: любуются фонарями и разгадывают загадки на них, что символизирует завершение новогодних празднеств."
    case .dragonRaisesHead:
      return "Второй день второго лунного месяца: по преданию Царь-дракон поднимает голову, знаменуя начало сельскохозяйственного сезона."
    case .qingming:
      return "День уборки могил и поминовения предков, а также праздник весенних прогулок на природе."
    case .dragonBoat:
      return "Пятый день пятого лунного месяца: гонки на драконьих лодках и цзунцзы в память о поэте-патриоте Цюй Юане."
    case .doubleSeventhNight:
      return "Седьмой день седьмого лунного месяца — день встречи Пастуха и Ткачихи, китайский День влюблённых."
    case .ghostFestival:
      return "Пятнадцатый день седьмого лунного месяца: поминовение душ усопших предков; в народе называется Праздником духов или Юланьпэнь."
    case .midAutumn:
      return "Пятнадцатый день восьмого лунного месяца: любуются луной и едят лунные пряники — символ воссоединения семьи."
    case .doubleNinth:
      return "Девятый день девятого лунного месяца: восхождение на возвышенности и ветви кизила; также День почитания пожилых."
    case .dongzhi:
      return "Зимнее солнцестояние — самая длинная ночь в году; семья собирается вместе, чтобы есть танъюань."
    case .laba:
      return "Восьмой день последнего лунного месяца: едят кашу Лаба, моля о богатом урожае и благополучии в новом году."
    case .littleNewYear:
      return "Двадцать третий день последнего лунного месяца: чествуют Бога очага, начиная подготовку к Новому году."
    }
  }

  public var category: String { "Праздник" }
}

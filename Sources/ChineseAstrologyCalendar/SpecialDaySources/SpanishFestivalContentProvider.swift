import Foundation

// MARK: - SpanishFestivalContentProvider

/// Spanish-language content for `FestivalSource`.
///
/// Supplies Spanish names and descriptions for every `ChineseFestival` case.
///
/// ```swift
/// let source = FestivalSource(contentProvider: SpanishFestivalContentProvider())
/// ```
public struct SpanishFestivalContentProvider: ChineseFestivalContentProvider {

  public init() {}

  public func name(for festival: ChineseFestival) -> String {
    switch festival {
    case .springFestival:     return "Fiesta de la Primavera (Año Nuevo Chino)"
    case .lanternFestival:    return "Fiesta de los Faroles"
    case .dragonRaisesHead:   return "El Dragón Levanta la Cabeza"
    case .qingming:           return "Festival de Qingming"
    case .dragonBoat:         return "Fiesta del Bote del Dragón"
    case .doubleSeventhNight: return "Noche del Doble Siete (Qixi)"
    case .ghostFestival:      return "Fiesta de los Fantasmas"
    case .midAutumn:          return "Fiesta del Medio Otoño"
    case .doubleNinth:        return "Festival del Doble Nueve (Chongyang)"
    case .dongzhi:            return "Festival del Solsticio de Invierno"
    case .laba:               return "Festival de Laba"
    case .littleNewYear:      return "Pequeño Año Nuevo"
    }
  }

  public func detail(for festival: ChineseFestival) -> String {
    switch festival {
    case .springFestival:
      return "El Año Nuevo del calendario lunar, la festividad tradicional más importante del año, que celebra el comienzo del nuevo año."
    case .lanternFestival:
      return "El día quince del primer mes lunar: se admiran los faroles y se resuelven acertijos, simbolizando el fin de las celebraciones del Año Nuevo."
    case .dragonRaisesHead:
      return "El segundo día del segundo mes lunar: según la leyenda, el Rey Dragón levanta la cabeza, marcando el inicio de la temporada agrícola."
    case .qingming:
      return "Día para limpiar las tumbas y honrar a los antepasados, y también para pasear por el campo en primavera."
    case .dragonBoat:
      return "El quinto día del quinto mes lunar: carreras de botes del dragón y se comen zongzi en memoria del poeta patriota Qu Yuan."
    case .doubleSeventhNight:
      return "El séptimo día del séptimo mes lunar, el día del encuentro del Pastor y la Tejedora; el Día de los Enamorados chino."
    case .ghostFestival:
      return "El día quince del séptimo mes lunar: se honra a las almas de los antepasados; popularmente llamado Fiesta de los Fantasmas o Yulanpen."
    case .midAutumn:
      return "El día quince del octavo mes lunar: se contempla la luna y se comen pasteles de luna, símbolo de la reunión familiar."
    case .doubleNinth:
      return "El noveno día del noveno mes lunar: se sube a las alturas y se lleva cornejo; también es el Día de los Mayores."
    case .dongzhi:
      return "El solsticio de invierno, la noche más larga del año; la familia se reúne para comer tangyuan."
    case .laba:
      return "El octavo día del último mes lunar: se toman las gachas de Laba, pidiendo una buena cosecha y paz para el nuevo año."
    case .littleNewYear:
      return "El día veintitrés del último mes lunar: se venera al Dios de la Cocina, dando comienzo a los preparativos del Año Nuevo."
    }
  }

  public var category: String { "Festividad" }
}

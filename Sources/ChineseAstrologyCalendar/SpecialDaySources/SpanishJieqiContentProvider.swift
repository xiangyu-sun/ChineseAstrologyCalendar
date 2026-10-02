import Foundation

// MARK: - SpanishJieqiContentProvider

/// Spanish-language content for `JieqiSource`.
///
/// Supplies Spanish names and seasonal health notes for every `Jieqi` case.
///
/// ```swift
/// let source = JieqiSource(contentProvider: SpanishJieqiContentProvider())
/// ```
public struct SpanishJieqiContentProvider: JieqiContentProvider {

  public init() {}

  public func name(for jieqi: Jieqi) -> String {
    switch jieqi {
    case .startOfSpring:      return "Comienzo de la primavera"
    case .rainWater:          return "Agua de lluvia"
    case .awakeningOfInsects: return "Despertar de los insectos"
    case .springEquinox:      return "Equinoccio de primavera"
    case .clearAndBright:     return "Claro y luminoso (Qingming)"
    case .grainRain:          return "Lluvia de grano"
    case .startOfSummer:      return "Comienzo del verano"
    case .grainBuds:          return "Pequeña plenitud"
    case .grainInEar:         return "Grano en espiga"
    case .summerSolstice:     return "Solsticio de verano"
    case .minorHeat:          return "Calor menor"
    case .majorHeat:          return "Calor mayor"
    case .startOfAutumn:      return "Comienzo del otoño"
    case .endOfHeat:          return "Fin del calor"
    case .whiteDew:           return "Rocío blanco"
    case .autumnEquinox:      return "Equinoccio de otoño"
    case .coldDew:            return "Rocío frío"
    case .frostDescent:       return "Descenso de la escarcha"
    case .startOfWinter:      return "Comienzo del invierno"
    case .minorSnow:          return "Nieve menor"
    case .majorSnow:          return "Nieve mayor"
    case .winterSolstice:     return "Solsticio de invierno"
    case .minorCold:          return "Frío menor"
    case .majorCold:          return "Frío mayor"
    }
  }

  public func detail(for jieqi: Jieqi) -> String {
    switch jieqi {
    case .startOfSpring:
      return "En el comienzo de la primavera, nutre el hígado y protege el yang: acuéstate y levántate temprano, estira el cuerpo para elevar el qi yang y mantén un ánimo alegre."
    case .rainWater:
      return "En la temporada de agua de lluvia aumenta la humedad: fortalece el bazo y elimina la humedad, come ligero, mantén el abdomen abrigado y evita el frío."
    case .awakeningOfInsects:
      return "En el despertar de los insectos asciende el yang: libera el estancamiento del hígado y regula el qi, mantén la calma y realiza actividad moderada al aire libre."
    case .springEquinox:
      return "En el equinoccio de primavera el yin y el yang se equilibran: armoniza el qi y la sangre, mantén horarios regulares y evita el agotamiento."
    case .clearAndBright:
      return "En Qingming el qi del hígado es abundante: alivia el estancamiento hepático, pasea por el campo para despejar el ánimo y evita las emociones extremas."
    case .grainRain:
      return "En la lluvia de grano la humedad es intensa: elimina la humedad y fortalece el bazo, masajea los puntos del bazo y el estómago, y toma alimentos templados y digeribles."
    case .startOfSummer:
      return "En el comienzo del verano el qi del corazón es fuerte: nutre el corazón y calma la mente, mantén la serenidad y descansa brevemente al mediodía."
    case .grainBuds:
      return "En la pequeña plenitud aumentan el calor y la humedad: aclara el calor y drena la humedad, come ligero evitando lo graso y mantén la piel limpia para prevenir eczemas."
    case .grainInEar:
      return "En el grano en espiga arrecia el calor: refresca el corazón y combate el bochorno, ejercítate con moderación evitando sudar en exceso."
    case .summerSolstice:
      return "En el solsticio de verano el yang alcanza su punto máximo: refresca el corazón y nutre el yin, evita el sol del mediodía y descansa a esa hora."
    case .minorHeat:
      return "En el calor menor el bochorno se intensifica: combate el calor y tonifica el qi, ventila el interior y no abuses del frío para no dañar el yang."
    case .majorHeat:
      return "El calor mayor es el momento más caluroso del año: aclara el calor y tonifica el qi, fortalece el bazo, hidrátate con moderación y cuídate del golpe de calor."
    case .startOfAutumn:
      return "En el comienzo del otoño nutre los pulmones y humedece la sequedad: acuéstate y levántate temprano, hidrátate y protege los pulmones de la sequedad otoñal."
    case .endOfHeat:
      return "Al fin del calor el bochorno remite: nutre los pulmones y protege el yin, atiende al contraste térmico entre mañana y noche y abrígate a tiempo."
    case .whiteDew:
      return "En el rocío blanco baja la temperatura: nutre el yin y humedece la sequedad, mantén los pies abrigados y evita pisar descalzo el suelo frío."
    case .autumnEquinox:
      return "En el equinoccio de otoño el yin y el yang vuelven a equilibrarse: nutre los pulmones y recoge el qi, mantén la calma y evita la tristeza excesiva."
    case .coldDew:
      return "En el rocío frío el clima es seco: humedece los pulmones y genera fluidos, abrígate en especial el cuello y los tobillos y previene la entrada del frío."
    case .frostDescent:
      return "En el descenso de la escarcha el yin se intensifica: tonifica el hígado y el riñón, abrígate y refuerza la alimentación con moderación para prepararte para el invierno."
    case .startOfWinter:
      return "En el comienzo del invierno nutre los riñones y conserva la energía: acuéstate temprano y levántate tarde, evita el frío y busca el calor para almacenar la esencia."
    case .minorSnow:
      return "En la nieve menor arrecia el frío: calienta los riñones y apoya el yang, mantén abrigadas la espalda y la zona lumbar y reduce la actividad intensa al aire libre."
    case .majorSnow:
      return "En la nieve mayor el frío congela la tierra: tonifica los riñones y refuerza la base del cuerpo; abrígate y date baños de pies para expulsar el frío."
    case .winterSolstice:
      return "En el solsticio de invierno el yin llega a su cúspide y nace el yang: tonifica los riñones y conserva la energía, acuéstate temprano y levántate tarde, y reposa."
    case .minorCold:
      return "El frío menor es la época más fría del año: calienta y tonifica el yang del riñón, protégete del viento y abrígate al salir, y evita el frío que daña los riñones."
    case .majorCold:
      return "En el frío mayor el frío llega a su extremo: tonifica el qi del riñón, mantén todo el cuerpo abrigado y realiza ejercicio suave en interior para entrar en calor."
    }
  }

  public var category: String { "Término solar" }
}

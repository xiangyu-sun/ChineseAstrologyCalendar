//  Created by 孙翔宇 on 03/07/2020.
//

import Foundation

/// 正月为寅，二月为卯，三月为辰，四月为巳，五月为午，六月为未，七月为申，八月为酉，九月为戌，十月为亥，十一月为子，十二月为丑
public extension DateComponents {
    var yueGan: Tiangan? {
        guard let tiangan = nianGan?.rawValue, let dizhi = yueZhi?.rawValue else { return nil }
        let yueGan = (tiangan * 2 + dizhi) % 10
        return Tiangan(rawValue: yueGan)
    }

    var yueZhi: Dizhi? {
        guard let month = month else { return nil }
        return Dizhi(rawValue: month)
    }
}

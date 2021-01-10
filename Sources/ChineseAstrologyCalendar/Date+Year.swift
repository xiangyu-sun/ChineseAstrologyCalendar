//  Created by 孙翔宇 on 03/07/2020.
//  Copyright © 2020 孙翔宇. All rights reserved.
//

import Foundation

public extension Date {
    var nianGan: Tiangan? {
        let dateComponents = Calendar.current.dateComponents([.year], from: self)
        guard let year = dateComponents.value(for: .year) else { return nil }
        let t = (year - 3) % 10
        return Tiangan(rawValue: t)
    }

    var nianZhi: Dizhi? {
        let dateComponents = Calendar.current.dateComponents([.year], from: self)
        guard let year = dateComponents.value(for: .year) else { return nil }
        let t = year  % 12

        return Dizhi(rawValue: t)
    }
}

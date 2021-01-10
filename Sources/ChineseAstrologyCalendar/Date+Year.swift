//  Created by 孙翔宇 on 03/07/2020.
//  Copyright © 2020 孙翔宇. All rights reserved.
//

import Foundation

public extension Date {
    var nianGan: Tiangan? {
        let t = chineseYear % 10
        return Tiangan(rawValue: t)
    }

    var nianZhi: Dizhi? {
        let t = chineseYear  % 12
        return Dizhi.orderedAllCases[t-1]
    }
    
    var chineseYear: Int {
        let g_adj_year = year + 2697

        let c_era = Int(g_adj_year/60)
        return  g_adj_year - c_era * 60
    }
    
    var chineseEra: Int {
        let g_adj_year = year + 2697
        return Int(g_adj_year/60)
    }

    
    var year: Int {
        let dateComponents = Calendar.current.dateComponents([.year], from: self)
        guard let year = dateComponents.value(for: .year) else { return 0 }
        return year
    }
}

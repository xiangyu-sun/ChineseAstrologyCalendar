import Testing
@testable import ChineseAstrologyCalendar

@Suite struct JieqiHealthTests {

    // MARK: - Season Mapping

    @Test func springSeasonMapping() {
        let springTerms: [Jieqi] = [.lichun, .yushui, .jingzhe, .chunfen, .qingming, .guyu]
        for term in springTerms {
            #expect(term.season == .spring, "\(term.stringValue) should be spring")
        }
    }

    @Test func summerSeasonMapping() {
        let summerTerms: [Jieqi] = [.lixia, .xiaoman, .mangzhong, .xiazhi, .xiaoshu, .dashu]
        for term in summerTerms {
            #expect(term.season == .summer, "\(term.stringValue) should be summer")
        }
    }

    @Test func fallSeasonMapping() {
        let fallTerms: [Jieqi] = [.liqiu, .chushu, .bailu, .qiufen, .hanlu, .shuangjiang]
        for term in fallTerms {
            #expect(term.season == .fall, "\(term.stringValue) should be fall")
        }
    }

    @Test func winterSeasonMapping() {
        let winterTerms: [Jieqi] = [.lidong, .xiaoxue, .daxue, .dongzhi, .xiaohan, .dahan]
        for term in winterTerms {
            #expect(term.season == .winter, "\(term.stringValue) should be winter")
        }
    }

    /// Each season should contain exactly 6 of the 24 solar terms.
    @Test func sixTermsPerSeason() {
        let grouped = Dictionary(grouping: Jieqi.allCases, by: \.season)
        for season in Season.allCases {
            #expect(grouped[season]?.count == 6, "\(season) should have exactly 6 solar terms")
        }
    }

    /// All 24 solar terms must be covered by a season (no missing cases).
    @Test func allCasesCoveredBySeason() {
        #expect(Jieqi.allCases.count == 24)
        let allSeasonTerms = Season.allCases.flatMap { season in
            Jieqi.allCases.filter { $0.season == season }
        }
        #expect(allSeasonTerms.count == 24)
    }

    // MARK: - Season–Wuxing Consistency

    /// Spring terms should chain to the wood element via season.
    @Test func springSeasonWuxing() {
        #expect(Jieqi.chunfen.season.wuxing == .mu)
        #expect(Jieqi.lichun.season.wuxing == .mu)
    }

    /// Summer terms should chain to the fire element via season.
    @Test func summerSeasonWuxing() {
        #expect(Jieqi.xiazhi.season.wuxing == .huo)
        #expect(Jieqi.lixia.season.wuxing == .huo)
    }

    /// Autumn terms should chain to the metal element via season.
    @Test func fallSeasonWuxing() {
        #expect(Jieqi.qiufen.season.wuxing == .jin)
        #expect(Jieqi.liqiu.season.wuxing == .jin)
    }

    /// Winter terms should chain to the water element via season.
    @Test func winterSeasonWuxing() {
        #expect(Jieqi.dongzhi.season.wuxing == .shui)
        #expect(Jieqi.lidong.season.wuxing == .shui)
    }

    // MARK: - Health Tip Completeness

    /// Every solar term must have a non-empty health tip.
    @Test func healthTipNonEmpty() {
        for jieqi in Jieqi.allCases {
            #expect(!jieqi.healthTip.isEmpty, "\(jieqi.stringValue) should have a non-empty healthTip")
        }
    }

    // MARK: - Seasonal Foods Completeness

    /// Every solar term must have non-empty seasonal food recommendations.
    @Test func seasonalFoodsNonEmpty() {
        for jieqi in Jieqi.allCases {
            #expect(!jieqi.seasonalFoods.isEmpty, "\(jieqi.stringValue) should have non-empty seasonalFoods")
        }
    }

    // MARK: - Spot-Checks (TCM content accuracy)

    /// 立春 (Start of Spring) tip should mention nourishing the liver (養肝).
    @Test func lichunHealthTipMentionsLiver() {
        #expect(Jieqi.lichun.healthTip.contains("養肝"))
    }

    /// 夏至 (Summer Solstice) tip should mention nourishing yin (養陰) – peak yang.
    @Test func xiazhinHealthTipMentionsYin() {
        #expect(Jieqi.xiazhi.healthTip.contains("養陰"))
    }

    /// 冬至 (Winter Solstice) tip should mention nourishing the kidney (補腎).
    @Test func dongzhiHealthTipMentionsKidney() {
        #expect(Jieqi.dongzhi.healthTip.contains("補腎"))
    }

    /// 立春 foods should include spring chives (春韭), the classic spring ingredient.
    @Test func lichunSeasonalFoodsIncludesChives() {
        #expect(Jieqi.lichun.seasonalFoods.contains("春韭"))
    }

    /// 冬至 foods should include lamb (羊肉), the classic winter warming food.
    @Test func dongzhiSeasonalFoodsIncludesLamb() {
        #expect(Jieqi.dongzhi.seasonalFoods.contains("羊肉"))
    }

    /// 立秋 foods should include pear (梨) for lung-moistening.
    @Test func liqiuSeasonalFoodsIncludesPear() {
        #expect(Jieqi.liqiu.seasonalFoods.contains("梨"))
    }
}

// Jieqi+Health.swift
// Seasonal health tips and food recommendations for each of the 24 solar terms,
// grounded in traditional Chinese medicine (TCM) seasonal wellness principles.

// MARK: - Season

extension Jieqi {

    /// The season this solar term belongs to, following the traditional Chinese calendar
    /// where each season begins at its "li" (立) term.
    public var season: Season {
        switch self {
        case .lichun, .yushui, .jingzhe, .chunfen, .qingming, .guyu:
            return .spring
        case .lixia, .xiaoman, .mangzhong, .xiazhi, .xiaoshu, .dashu:
            return .summer
        case .liqiu, .chushu, .bailu, .qiufen, .hanlu, .shuangjiang:
            return .fall
        case .lidong, .xiaoxue, .daxue, .dongzhi, .xiaohan, .dahan:
            return .winter
        }
    }

    // MARK: - Health Tips

    /// Brief traditional Chinese medicine (TCM) health suggestion for this solar term.
    /// Based on the principle of living in harmony with seasonal qi (氣).
    public var healthTip: String {
        switch self {
        // Spring – nourish liver (養肝), encourage yang qi to rise
        case .lichun:
            return "立春養肝護陽，宜早睡早起，舒展筋骨以助陽氣升發，保持心情舒暢。"
        case .yushui:
            return "雨水時節濕氣漸重，宜健脾祛濕，飲食清淡，注意腹部保暖，避免受涼。"
        case .jingzhe:
            return "驚蟄陽氣上升，宜疏肝理氣，保持情緒平和，可做適度戶外活動激發生機。"
        case .chunfen:
            return "春分陰陽平衡，宜調和氣血，保持規律作息，避免過勞以維持陰陽協調。"
        case .qingming:
            return "清明肝氣旺盛，宜疏肝解鬱，適當踏青以舒展情志，避免大喜大悲傷肝。"
        case .guyu:
            return "穀雨濕氣較重，宜祛濕健脾，可適當按摩脾胃穴位，飲食宜溫和易消化。"
        // Summer – nourish heart (養心), calm the spirit
        case .lixia:
            return "立夏心氣旺盛，宜養心安神，保持心情平靜，午間可小憩片刻以養心神。"
        case .xiaoman:
            return "小滿濕熱漸增，宜清熱利濕，飲食清淡避油膩，保持皮膚清潔防濕疹。"
        case .mangzhong:
            return "芒種暑氣漸盛，宜清心消暑，適當運動但避免大汗淋漓以免耗傷心氣。"
        case .xiazhi:
            return "夏至陽氣最盛，宜清心養陰，避免正午烈日暴曬，午間小憩以養心神。"
        case .xiaoshu:
            return "小暑暑氣蒸騰，宜消暑益氣，保持室內通風，避免貪涼過度傷及陽氣。"
        case .dashu:
            return "大暑為一年最熱，宜清暑益氣、健脾利濕，適量補充水分，謹防中暑。"
        // Autumn – nourish lung (養肺), prevent dryness
        case .liqiu:
            return "立秋養肺潤燥，宜早臥早起，注意補充水分，防止秋燥傷肺。"
        case .chushu:
            return "處暑暑熱漸退，宜養肺護陰，注意早晚溫差，適時增添衣物預防風寒。"
        case .bailu:
            return "白露氣溫下降，宜滋陰潤燥，注意足部保暖，避免赤腳踩涼地傷及腎氣。"
        case .qiufen:
            return "秋分陰陽再平衡，宜養肺收斂，保持情緒安定，避免悲憂過度傷肺。"
        case .hanlu:
            return "寒露氣候乾燥，宜潤肺生津，注意保暖特別是頸部和腳踝，預防寒邪入侵。"
        case .shuangjiang:
            return "霜降陰氣漸重，宜補益肝腎，注意保暖，可適當進補以備冬季所需。"
        // Winter – nourish kidney (養腎), store essence
        case .lidong:
            return "立冬養腎封藏，宜早臥晚起，避寒就溫，適當進補以儲存精氣越冬。"
        case .xiaoxue:
            return "小雪寒氣漸重，宜溫腎助陽，保持背部及腰部溫暖，減少戶外劇烈活動。"
        case .daxue:
            return "大雪天寒地凍，宜補腎固本，防寒保暖尤為重要，可泡腳驅寒暖身。"
        case .dongzhi:
            return "冬至陰氣最盛，陽氣始生，宜補腎養藏，早臥晚起，靜養精氣以迎陽氣回升。"
        case .xiaohan:
            return "小寒為一年最冷之際，宜溫補腎陽，出行注意防風保暖，避免受寒傷腎。"
        case .dahan:
            return "大寒寒氣達頂，宜補益腎氣，注意全身保暖，可適當做室內暖身運動。"
        }
    }

    // MARK: - Seasonal Foods

    /// Seasonal food and recipe recommendations based on traditional Chinese dietary wisdom
    /// (食療, shí liáo) for this solar term.
    public var seasonalFoods: String {
        switch self {
        // Spring – light, pungent foods to support liver and rising yang
        case .lichun:
            return "宜食春韭、豆芽、薺菜，少食辛辣，以養肝氣、助陽升發。"
        case .yushui:
            return "宜食山藥、薏仁、紅棗，健脾祛濕，可煮薏仁粥溫養脾胃。"
        case .jingzhe:
            return "宜食梨、蜂蜜、菠菜，疏肝清熱，梨汁或蜂蜜水可潤肺防春燥。"
        case .chunfen:
            return "宜食菠菜、春筍、枸杞，平補陰陽，春筍炒肉可補充體力迎接春季。"
        case .qingming:
            return "宜食青色蔬菜、桑葚、草莓，疏肝養血，避免過食燥熱之品傷肝。"
        case .guyu:
            return "宜食香椿、豆腐、茯苓，祛濕健脾，香椿芽拌豆腐是傳統時令菜。"
        // Summer – cooling, bitter foods to clear heat and calm the heart
        case .lixia:
            return "宜食苦瓜、蓮子、百合，養心安神，蓮子百合粥可清心除煩。"
        case .xiaoman:
            return "宜食綠豆、冬瓜、薏仁，清熱利濕，綠豆湯是傳統消暑佳品。"
        case .mangzhong:
            return "宜食西瓜、黃瓜、烏梅，清暑生津，烏梅湯可止渴解暑補充電解質。"
        case .xiazhi:
            return "宜食苦瓜、荷葉、綠豆，清心瀉火，荷葉粥可清熱解暑養護心氣。"
        case .xiaoshu:
            return "宜食絲瓜、蓮藕、薏仁，消暑利濕，蓮藕排骨湯可補氣養血。"
        case .dashu:
            return "宜食西瓜、綠豆、冬瓜，清暑益氣，宜多飲溫水或淡鹽水補充水分。"
        // Autumn – moistening, nourishing foods to combat dryness and support lung
        case .liqiu:
            return "宜食梨、百合、蜂蜜，潤肺止燥，冰糖燉梨是傳統潤肺食療方。"
        case .chushu:
            return "宜食鴨肉、蓮藕、山藥，滋陰養肺，鴨肉性涼可補虛清熱。"
        case .bailu:
            return "宜食銀耳、蜂蜜、芝麻，滋陰潤燥，銀耳紅棗湯補益氣血且潤肺。"
        case .qiufen:
            return "宜食栗子、蓮藕、山藥，補益肺腎，栗子粥可補腎氣迎接深秋。"
        case .hanlu:
            return "宜食菊花、核桃、芝麻，潤燥益腎，菊花枸杞茶可養肝明目。"
        case .shuangjiang:
            return "宜食柿子、蘋果、牛肉，補益氣血，柿子潤肺止咳但不可空腹食用。"
        // Winter – warm, nourishing foods to supplement kidney and store yang
        case .lidong:
            return "宜食羊肉、栗子、黑豆，溫補腎陽，羊肉湯加薑片可驅寒暖身。"
        case .xiaoxue:
            return "宜食核桃、腰果、黑芝麻，補腎益精，黑芝麻糊可溫養腎氣。"
        case .daxue:
            return "宜食羊肉、白蘿蔔、生薑，溫中散寒，羊肉蘿蔔湯暖身效果極佳。"
        case .dongzhi:
            return "宜食羊肉、核桃、黑芝麻，溫補腎陽，冬至傳統習俗宜食餃子或湯圓。"
        case .xiaohan:
            return "宜食韭菜、羊肉、桂圓，溫腎散寒，桂圓紅棗粥可溫補氣血禦寒。"
        case .dahan:
            return "宜食蓮子、山藥、黑米，補腎固精，八寶粥是大寒時節傳統進補食品。"
        }
    }
}

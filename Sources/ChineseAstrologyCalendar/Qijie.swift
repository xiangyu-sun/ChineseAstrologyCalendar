//
//  File.swift
//  
//
//  Created by 孙翔宇 on 10/8/21.
//

import Foundation

public enum Qijie: Int, CaseIterable {
    case lichun = 315
    case yushui = 330
    case jingzhe = 345
    
    case chunfen = 0
    case qingming = 15
    case guyu = 30
    
    case lixia = 45
    case xiaoman = 60
    case mangzhong = 75
    
    case xiazhi = 90
    case xiaoshu = 105
    case dashu = 120
    
    case liqiu = 135
    case chushu = 150
    case bailu = 165
    
    case qiufen = 180
    case hanlu = 195
    case shuangjiang = 210
    
    case lidong = 225
    case xiaoxue = 240
    case daxue = 255
    
    case dongzhi = 270
    case xiaohan = 285
    case dahan = 300
}

public extension Qijie {
    
    var chineseName: String {
        switch self {
        case .lichun:
            return "立春"
        case .yushui:
            return "雨水"
        case .jingzhe:
            return "驚蟄"
        case .chunfen:
            return "春分"
        case .qingming:
            return "清明"
        case .guyu:
            return "穀雨"
        case .lixia:
            return "立夏"
        case .xiaoman:
            return "小滿"
        case .mangzhong:
            return "芒種"
        
        case .xiazhi:
            return "夏至"
        case .xiaoshu:
            return "小暑"
        case .dashu:
            return "大暑"
        case .liqiu:
            return "立秋"
        case .chushu:
            return "處暑"
        case .bailu:
            return "白露"
        
        case .qiufen:
            return "秋分"
        case .hanlu:
            return "寒露"
        case .shuangjiang:
            return "霜降"
        
        case .lidong:
            return "立冬"
        case .xiaoxue:
            return "小雪"
        case .daxue:
            return "大雪"
        
        case .dongzhi:
            return "冬至"
        case .xiaohan:
            return "小寒"
        case .dahan:
            return "大寒"
        }
    }
    
    var qishierHou: String {
        switch self {
        case .lichun:
            return "立春之日東風解凍，又五日蟄蟲始振，又五日魚上冰（魚陟負冰)"
        case .yushui:
            return "雨水之日獺祭魚，又五日鴻雁來（候雁北），又五日草木萌動"
        case .jingzhe:
            return "驚蟄之日桃始華，又五日倉庚鳴，又五日鷹化為鳩"
        case .chunfen:
            return "春分之日玄鳥至，又五日雷乃發聲，又五日始電"
        case .qingming:
            return "清明之日桐始華，又五日田鼠化為鴽，又五日虹始見"
        case .guyu:
            return "谷雨之日萍始生，又五日鳴鳩拂其羽，又五日戴勝降于桑"
        case .lixia:
            return "立夏之日螻蟈鳴，又五日蚯蚓出，又五日王瓜生"
        case .xiaoman:
            return "小滿之日苦菜秀，又五日靡草死，又五日小暑至（麥秋生，麥秋至)"
        case .mangzhong:
            return "芒種之日螳螂生，又五日鵙始鳴，又五日反舌無聲"
        
        case .xiazhi:
            return "夏至之日鹿角解，又五日蜩始鳴，又五日半夏生"
        case .xiaoshu:
            return "小暑之日溫風至，又五日蟋蟀居壁，又五日鷹乃學習（鷹始擊）"
        case .dashu:
            return "大暑之日腐草为萤，又五日土潤溽暑，又五日大雨時行"
        case .liqiu:
            return "立秋之日涼風至，又五日白露降，又五日寒蟬鳴"
        case .chushu:
            return "處暑之日鷹乃祭鳥，又五日天地始肅，又五日禾乃登"
        case .bailu:
            return "白露之日鴻雁來，又五日玄鳥歸，又五日群鳥養羞"
        
        case .qiufen:
            return "秋分之日雷始收聲，又五日蟄蟲培坯戶，又五日水始涸"
        case .hanlu:
            return "寒露之日鴻雁來賓，又五日雀入大水為蛤，又五日菊有黃華"
        case .shuangjiang:
            return "霜降之日豺乃祭獸，又五日草木黃落，又五日蟄蟲咸俯"
        
        case .lidong:
            return "立冬之日水始冰，又五日地始凍，又五日雉入大水為蜃"
        case .xiaoxue:
            return "小雪之日虹藏不見，又五日天氣上騰地氣下降，又五日閉塞而成冬"
        case .daxue:
            return "大雪之日鶡旦不鳴，又五日虎始交，又五日荔挺生（荔挺出）"
        
        case .dongzhi:
            return "冬至之日蚯蚓結，又五日麋角解，又五日水泉動"
        case .xiaohan:
            return "小寒之日雁北鄉，又五日鵲始巢，又五日雉始鴝（雉始雊）"
        case .dahan:
            return "大寒之日雞始乳，又五日鷲鳥厲疾（征鳥厲疾），又五日水澤腹堅"
        }
    }
    
}

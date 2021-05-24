//
//  Model.swift
//  Arknights-Notes
//
//  Created by Kasumigaoka Utaha on 17.05.21.
//

import Foundation

struct RecruitCategory {
    static let trait = ["控场", "爆发", "治疗", "支援", "费用回复", "输出", "生存", "群攻", "防护", "减速", "削弱", "快速复活", "位移", "召唤", "支援机械"]
    static let seniority = ["新手", "资深干员", "高级资深干员"]
    static let position = ["远程位", "近战位"]
    static let profession = ["先锋干员", "狙击干员", "医疗干员", "术师干员", "近卫干员", "重装干员", "辅助干员", "特种干员"]
    
    static var all: [String] {
        trait + seniority + position + profession
    }
    
    static let rarityToTag = [
        1: "新手", 4: "资深干员", 5: "高级资深干员"
    ]
    
    static let positionToTag = [
        "MELEE": "近战位", "RANGED": "远程位"
    ]
    
    static let professionToTag = [
        "PIONEER": "先锋干员", "SNIPER": "狙击干员", "MEDIC": "医疗干员", "SPECIAL": "特种干员",
        "CASTER": "术师干员", "WARRIOR": "近卫干员", "TANK": "重装干员", "SUPPORT": "辅助干员"
    ]
}

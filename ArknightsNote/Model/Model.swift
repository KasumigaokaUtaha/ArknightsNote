//
//  Model.swift
//  Arknights-Notes
//
//  Created by Kasumigaoka Utaha on 17.05.21.
//

import Foundation

struct RecruitCategory {
    let trait = ["控场", "爆发", "治疗", "支援", "费用回复", "输出", "生存", "群攻", "防护", "减速", "削弱", "快速复活", "位移", "召唤", "支援机械"]
    let seniority = ["新手", "资深干员", "高级资深干员"]
    let position = ["远程位", "近战位"]
    let profession = ["先锋", "狙击", "医疗", "术师", "近卫", "重装"]
    
    var all: [String] {
        trait + seniority + position + profession
    }
}

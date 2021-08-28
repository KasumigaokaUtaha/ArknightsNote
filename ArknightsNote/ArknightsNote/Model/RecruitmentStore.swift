//
//  RecruitmentStore.swift
//  RecruitmentStore
//
//  Created by Kasumigaoka Utaha on 13.08.21.
//

import Foundation

struct RecruitmentStore {
    enum Category: Int, CaseIterable {
        case trait = 3
        case position = 1
        case seniority = 0
        case profession = 2
    }
    
    private let traitTags = ["控场", "爆发", "治疗", "支援", "费用回复", "输出", "生存", "群攻", "防护", "减速", "削弱", "快速复活", "位移", "召唤", "支援机械"]
    private let positionTags = ["远程位", "近战位"]
    private let seniorityTags = ["新手", "资深干员", "高级资深干员"]
    private let professionTags = ["先锋干员", "狙击干员", "医疗干员", "术师干员", "近卫干员", "重装干员", "辅助干员", "特种干员"]
    private let rarityToTag = ["1": "新手", "4": "资深干员", "5": "高级资深干员"]
    private let positionToTag = ["MELEE": "近战位", "RANGED": "远程位"]
    private let professionToTag = [
        "PIONEER": "先锋干员", "SNIPER": "狙击干员", "MEDIC": "医疗干员", "SPECIAL": "特种干员",
        "CASTER": "术师干员", "WARRIOR": "近卫干员", "TANK": "重装干员", "SUPPORT": "辅助干员"
    ]
    private let recruitmentCharacterNames: [String] = [
        "Lancet-2", "Castle-3", "THRM-EX",
        "夜刀", "黑角", "巡林者", "杜林", "12F",
        "安德切尔", "芬", "香草", "翎羽", "玫兰纱", "米格鲁", "克洛丝", "炎熔", "芙蓉", "安赛尔", "史都华德", "梓兰", "空爆", "月见夜", "泡普卡", "斑点",
        "艾丝黛尔", "清流", "夜烟", "远山", "杰西卡", "流星", "白雪", "清道夫", "红豆", "杜宾", "缠丸", "霜叶", "慕斯", "砾", "暗索", "末药", "调香师", "角峰", "蛇屠箱", "古米", "地灵", "阿消", "猎蜂", "格雷伊", "苏苏洛", "桃金娘", "红云", "梅",
        "因陀罗", "火神", "白面鸮", "凛冬", "德克萨斯", "幽灵鲨", "蓝毒", "白金", "陨星", "梅尔", "赫默", "华法琳", "临光", "红", "雷蛇", "可颂", "普罗旺斯", "守林人", "崖心", "初雪", "真理", "狮蝎", "食铁兽", "夜魔", "诗怀娅", "格劳克斯", "星极", "送葬人", "槐琥",
        "能天使", "推进之王", "伊芙利特", "闪灵", "夜莺", "星熊", "塞雷娅", "银灰", "斯卡蒂", "陈", "黑", "赫拉格", "麦哲伦", "莫斯提马"
    ]
    
    func allTags() -> [String] {
        return Category.allCases.flatMap { category in
            return tagsOfCategory(category)
        }
    }
    
    func numberOfCategoryCases() -> Int {
        return Category.allCases.count
    }
    
    func tagsOfCategory(_ category: Category) -> [String] {
        switch category {
        case .trait:
            return traitTags
        case .position:
            return positionTags
        case .seniority:
            return seniorityTags
        case .profession:
            return professionTags
        }
    }
    
    func tagOfCategory(_ category: Category, value: Any) -> String {
        let valueString = String(describing: value)
        
        var categoryValueToTag: [String:String]
        switch category {
        case .position:
            categoryValueToTag = positionToTag
        case .profession:
            categoryValueToTag = professionToTag
        case .seniority:
            categoryValueToTag = rarityToTag
        default:
            fatalError("Error cannot find tag with category: \(category) and value: \(valueString)")
        }

        if let tag = categoryValueToTag[valueString] {
            return tag
        } else {
            fatalError("Error cannot find tag with category: \(category) and value: \(valueString)")
        }
    }
    
    func getRecruitmentCharacterNames() -> [String] {
        return recruitmentCharacterNames
    }
}

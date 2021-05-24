//
//  CharacterStore.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 24.05.21.
//

import Foundation

struct CharacterStore {
    let recruitCharacterNames: [String] = [
        "Lancet-2", "Castle-3", "THRM-EX",
        "夜刀", "黑角", "巡林者", "杜林", "12F",
        "安德切尔", "芬", "香草", "翎羽", "玫兰纱", "米格鲁", "克洛丝", "炎熔", "芙蓉", "安赛尔", "史都华德", "梓兰", "空爆", "月见夜", "泡普卡", "斑点",
        "艾丝黛尔", "清流", "夜烟", "远山", "杰西卡", "流星", "白雪", "清道夫", "红豆", "杜宾", "缠丸", "霜叶", "慕斯", "砾", "暗索", "末药", "调香师", "角峰", "蛇屠箱", "古米", "地灵", "阿消", "猎蜂", "格雷伊", "苏苏洛", "桃金娘", "红云", "梅",
        "因陀罗", "火神", "白面鸮", "凛冬", "德克萨斯", "幽灵鲨", "蓝毒", "白金", "陨星", "梅尔", "赫默", "华法琳", "临光", "红", "雷蛇", "可颂", "普罗旺斯", "守林人", "崖心", "初雪", "真理", "狮蝎", "食铁兽", "夜魔", "诗怀娅", "格劳克斯", "星极", "送葬人", "槐琥",
        "能天使", "推进之王", "伊芙利特", "闪灵", "夜莺", "星熊", "塞雷娅", "银灰", "斯卡蒂", "陈", "黑", "赫拉格", "麦哲伦", "莫斯提马"
    ]
    var recruitNameToCharacter: [String:Character] {
        var nameToChar = [String:Character]()
        for char in recruitCharacters {
            nameToChar[char.name] = char
        }
        return nameToChar
    }
    
    var characters: [Character]
    var recruitCharacters: [Character] {
        characters.filter { character in
            return recruitCharacterNames.contains(character.name)
        }
    }
    
    init() {
        let url = Bundle.main.url(forResource: "character_table", withExtension: "json")
        guard let url = url else {
            fatalError("Could not find the resource file character_table.json")
        }
        
        characters = []
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: url) {
            if let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
                for value in dict.values {
                    guard let jsonValue = try? JSONSerialization.data(withJSONObject: value) else {
                        fatalError("Could not convert parsed data into JSON Object")
                    }
                    
                    let character = try? decoder.decode(Character.self, from: jsonValue)
                    if let character = character {
                        characters.append(character)
                    }
                }
            }
        }
    }
    
    func computeCharactersMatchedWith(tags: [String], maxTagCombCnt: Int = 4) -> [[String]:[Character]] {
        var result = [[String]:[Character]]()
        var tagsToChars = [[String]:[String]]()
        
        for char in recruitCharacters {
            if let rarityTag = RecruitCategory.rarityToTag[char.rarity], tags.contains(rarityTag) {
                let key = [rarityTag]
                if tagsToChars[key] == nil {
                    tagsToChars[key] = []
                }
                tagsToChars[key]!.append(char.name)
            }

            if let positionTag = RecruitCategory.positionToTag[char.position], tags.contains(positionTag) {
                let key = [positionTag]
                if tagsToChars[key] == nil {
                    tagsToChars[key] = []
                }
                tagsToChars[key]!.append(char.name)
            }

            if let professionTag = RecruitCategory.professionToTag[char.profession], tags.contains(professionTag) {
                let key = [professionTag]
                if tagsToChars[key] == nil {
                    tagsToChars[key] = []
                }
                tagsToChars[key]!.append(char.name)
            }
            
            for tag in char.tagList {
                if tags.contains(tag) {
                    let key = [tag]
                    if tagsToChars[key] == nil {
                        tagsToChars[key] = []
                    }
                    tagsToChars[key]!.append(char.name)
                }
            }
        }
        
        for count in 2...maxTagCombCnt {
            let temp = constructTagsToCharacters(tagCombCnt: count, tagsToChars: tagsToChars)
            tagsToChars.merge(temp, uniquingKeysWith: {
                return Array(Set($0 + $1))
            })
        }
        
        for (key, value) in tagsToChars {
            result[key] = value.map { name in
                guard let char = recruitNameToCharacter[name] else {
                    fatalError("Could not find recruit character with the given name \(name)")
                }
                return char
            }
        }
        
        return result
    }
    
    private func constructTagsToCharacters(tagCombCnt: Int, tagsToChars: [[String]:[String]]) -> [[String]:[String]] {
        var result = [[String]:[String]]()
        var tagsList: [[String]] = []
        
        for item in tagsToChars.keys {
            if item.count == tagCombCnt - 1 {
                tagsList.append(item)
            }
        }

        for i in 0..<tagsList.count {
            let iTags = tagsList[i]
            guard let iChars = tagsToChars[iTags] else {
                fatalError("Could not find matched characters for given tags \(iTags) in tagsToChars")
            }
            let iTagsChars = Set(iChars)

            for j in i+1..<tagsList.count {
                let jTags = tagsList[j]
                guard let jChars = tagsToChars[jTags] else {
                    fatalError("Could not find matched characters for given tags \(jTags) in tagsToChars")
                }
                let jTagsChars = Set(jChars)
                
                var checkTagsOverlap = true
                var key = Array(Set(iTags + jTags))
                
                if iTags.count == 1, jTags.count == 1 {
                    checkTagsOverlap = false
                    key = iTags + jTags
                }
                
                if checkTagsOverlap, Set(iTags).isDisjoint(with: Set(jTags)) {
                    continue
                }
                if key.count != tagCombCnt {
                    continue
                }
                
                let charsIntersection = iTagsChars.intersection(jTagsChars)
                if charsIntersection.count > 0 {
                    result[key] = Array(charsIntersection)
                }
            }
        }
        
        return result
    }
}

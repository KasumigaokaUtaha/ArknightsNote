//
//  Character.swift
//  Character
//
//  Created by Kasumigaoka Utaha on 13.08.21.
//

import Foundation

struct Character: Codable, Equatable, Hashable {
    // MARK: - Protocol implementation
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
    
    // MARK: - Property
    var name: String
    var description: String
    var canUseGeneralPotentialItem: Bool
    var potentialItemId: String
    var nationId: String?
    var groupId: String?
    var teamId: String?
    var displayNumber: String?
    var tokenKey: String?
    var appellation: String
    var position: String
    var tagList: [String]
    var itemUsage: String?
    var itemDesc: String?
    var itemObtainApproach: String?
    var isNotObtainable: Bool
    var isSpChar: Bool
    var maxPotentialLevel: Int
    var rarity: Int
    var profession: String
    var subProfessionId: String
    var trait: Trait?
    var phases: [Phase]
    var skills: [Skill]
    var talents: [Talent]?
//    var potentialRanks: []
//    var favorKeyFrames: []
//    var allSkillLvup: []
    
    struct Trait: Codable {
        var candidates: [Candidate]
        
        struct Candidate: Codable {
            var unlockCondition: UnlockCondition
            var requiredPotentialRank: Int
            var blackboard: [Blackboard]
            var overrideDescription: String?
            var prefabKey: String?
            var rangeId: String?

            struct UnlockCondition: Codable {
                var phase: Int
                var level: Int
            }
            
            struct Blackboard: Codable {
                var key: String
                var value: Double
            }
        }
    }
    
    struct Phase: Codable {
        var characterPrefabKey: String
        var rangeId: String
        var maxLevel: Int
        var attributesKeyFrames: [AttributesKeyFrames]

        struct AttributesKeyFrames: Codable {
            var level: Int
            var data: Data

            struct Data: Codable {
                var maxHp: Int
                var atk: Int
                var def: Int
                var magicResistance: Double
                var cost: Int
                var blockCnt: Int
                var moveSpeed: Double
                var attackSpeed: Double
                var baseAttackTime: Double
                var respawnTime: Int
                var hpRecoveryPerSec: Double
                var spRecoveryPerSec: Double
                var maxDeployCount: Int
                var maxDeckStackCnt: Int
                var tauntLevel: Int
                var massLevel: Int
                var baseForceLevel: Int
                var stunImmune: Bool
                var silenceImmune: Bool
                var sleepImmune: Bool
            }
        }
    }
    
    struct Skill: Codable {
        var skillId: String
        var overridePrefabKey: String?
        var overrideTokenKey: String?
        var levelUpCostCond: [LevelUpCostCond]
        
        struct LevelUpCostCond: Codable {
            var unlockCond: UnlockCond
            var lvlUpTime: Int
            var levelUpCost: [LevelUpCost]?
            
            struct UnlockCond: Codable {
                var phase: Int
                var level: Int
            }
            
            struct LevelUpCost: Codable {
                var id: String
                var count: Int
                var type: String
            }
        }
    }
    
    struct Talent: Codable {
        var candidates: [Candidate]
        
        struct Candidate: Codable {
            var unlockCondition: UnlockCondition
            var requiredPotentialRank: Int
            var prefabKey: String
            var name: String
            var description: String
            var rangeId: String?
            var blackboard: [Blackboard]

            struct UnlockCondition: Codable {
                var phase: Int
                var level: Int
            }
            
            struct Blackboard: Codable {
                var key: String
                var value: Double
            }
        }
    }
}

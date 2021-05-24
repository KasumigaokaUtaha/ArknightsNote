//
//  Character.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 24.05.21.
//

import Foundation

struct Character: Codable, Hashable {
    var name: String
    var description: String
//    var canUseGeneralPotentialItem: Bool
//    var potentialItemId: String
//    var nationId: String
//    var groupId: String
//    var teamId: String
//    var displayNumber: String
//    var tokenKey: String
//    var appellation: String
    var position: String
    var tagList: [String]
    var itemUsage: String
    var itemDesc: String
    var itemObtainApproach: String
    var isNotObtainable: Bool
//    var isSpChar: Bool
//    var maxPotentialLevel: Int
    var rarity: Int
    var profession: String
//    var trait: String
//    var phases: [Phase]
//    var skills: [Skill]
//    var talents: [Talent]
//    var potentialRanks: []
//    var favorKeyFrames: []
//    var allSkillLvup: []
    
//    struct Phase: Codable {
//        var characterPrefabKey: String
//        var rangeId: String
//        var maxLevel: Int
//        var attributesKeyFrames: [AttributesKeyFrames]
//
//        struct AttributesKeyFrames: Codable {
//            var level: Int
//            var data: Data
//
//            struct Data: Codable {
//                var maxHp: Int
//                var atk: Int
//                var def: Int
//                var magicResistance: Double
//                var cost: Int
//                var blockCnt: Int
//                var moveSpeed: Double
//                var attackSpeed: Double
//                var baseAttackTime: Double
//                var respawnTime: Int
//                var hpRecoveryPerSec: Double
//                var spRecoveryPerSec: Double
//                var maxDeployCount: Int
//                var maxDeckStackCnt: Int
//                var tauntLevel: Int
//                var massLevel: Int
//                var baseForceLevel: Int
//                var stunImmune: Bool
//                var silenceImmune: Bool
//                var sleepImmune: Bool
//            }
//        }
//    }
    
//    struct Skill: Codable {
//        var skillId: String
//        var overridePrefabKey: String
//        var overrideTokenKey: String
////        var levelUpCostCond: [String]
//        var unlockCond: UnlockCond
//
//        struct UnlockCond: Codable {
//            var phase: Int
//            var level: Int
//        }
//    }
}

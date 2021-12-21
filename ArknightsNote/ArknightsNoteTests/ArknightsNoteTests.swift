//
//  ArknightsNoteTests.swift
//  ArknightsNoteTests
//
//  Created by Kasumigaoka Utaha on 10.08.21.
//

import XCTest
@testable import ArknightsNote

class ArknightsNoteTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testExtractXMLElementRange() throws {
        let text = "攻击造成<@ba.kw>法术伤害</>，并对敌人造成短暂的<$ba.sluggish>停顿</>"

        XCTAssertNotNil(text.range(of: "<@ba.kw>法术伤害</>"))
        XCTAssertNotNil(text.range(of: "法术伤害"))
        XCTAssertNotNil(text.range(of: "<$ba.sluggish>停顿</>"))
        XCTAssertNotNil(text.range(of: "停顿"))

        let pattern = ArknightsNote.Defaults.Pattern.characterDescription
        let ranges = ArknightsNote.Util.extractXMLElementRange(from: text, with: pattern)
        let expectedRanges = [
            text.range(of: "<@ba.kw>法术伤害</>")! : text.range(of: "法术伤害")!,
            text.range(of: "<$ba.sluggish>停顿</>")! : text.range(of: "停顿")!
        ]

        XCTAssertEqual(ranges.count, 2)
        XCTAssertEqual(ranges, expectedRanges)
    }
    
    func testExtractXMLContent() throws {
        let text = "攻击造成<@ba.kw>法术伤害</>，\\n并对敌人造成短暂的<$ba.sluggish>停顿</>\\n"
        
        XCTAssertNotNil(text.range(of: "<@ba.kw>法术伤害</>"))
        XCTAssertNotNil(text.range(of: "法术伤害"))
        XCTAssertNotNil(text.range(of: "<$ba.sluggish>停顿</>"))
        XCTAssertNotNil(text.range(of: "停顿"))

        let pattern = ArknightsNote.Defaults.Pattern.characterDescription
        let (extractedText, contentRanges) = ArknightsNote.Util.extractXMLContent(from: text, with: pattern)
        let expectedText = "攻击造成法术伤害，\n并对敌人造成短暂的停顿\n"
        let expectedContentRanges = [expectedText.range(of: "法术伤害"), expectedText.range(of: "停顿")]
        
        XCTAssertEqual(extractedText, expectedText)
        XCTAssertEqual(contentRanges, expectedContentRanges)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

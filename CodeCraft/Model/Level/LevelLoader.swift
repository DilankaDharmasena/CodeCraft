//
//  LevelLoader.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 11/22/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import Foundation

class LevelLoader {
    
    struct LevelPList : Codable {
        let id: Int
        let status : Int
        let prompt : String
        let inputs : String
        let outputs : String
    }
    
    typealias LevelsPList = [LevelPList]
    
    let levelModelUtils = LevelModelUtils()
    
    init() {}
    
    func convertLevelPList(_ level: LevelPList) -> Level {
        let newLevel = Level(id: level.id, status: level.status, prompt: level.prompt, inputs: level.inputs, outputs: level.outputs, solution: [])
        return newLevel
    }
    
    func extractPList() -> LevelsPList {
        
        var levels : LevelsPList
        let levelList = Bundle.main.url(forResource: "levels", withExtension: "plist")
        
        do {
            let data = try Data(contentsOf: levelList!)
            levels = try PropertyListDecoder().decode(LevelsPList.self, from: data)
        } catch {
            //print(error)
            levels = []
        }
        
        return levels
    }
    
    func updateLevels() {
        
        let levels = extractPList()
        
        let levelsMO : [LevelMO] = levelModelUtils.allLevels()
        
        if levels.count <= levelsMO.count {
            return
        }
        
        let levelCount = levelsMO.count
        
        var newLevels : [Level] = []
        
        for level in levels {
            if(level.id > levelCount) {
                newLevels.append(convertLevelPList(level))
            }
        }
        
        levelModelUtils.createLevels(newLevels)
        
    }
    
    func resetLevels() {
        
        let levels = extractPList()
        
        levelModelUtils.clearLevels()
        
        var newLevels : [Level] = []
        
        for level in levels {
            newLevels.append(convertLevelPList(level))
        }
        
        levelModelUtils.createLevels(newLevels)
        
    }
    
}

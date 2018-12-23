//
//  LevelModelUtils.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 11/22/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import Foundation
import CoreData

class LevelModelUtils {
    
    let dataManager = DataManager.shared
    
    init() {}
    
    //* Queries
    
    func allLevels() -> [LevelMO] {
        
        var levelsMO : [LevelMO]
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LevelMO")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            levelsMO = try dataManager.persistentContainer.viewContext.fetch(request) as! [LevelMO]
        } catch {
            //print(error)
            levelsMO = []
        }
        
        return levelsMO
    }
    
    func level(id : Int) -> LevelMO {
        
        var levelMO : [LevelMO]
        
        let convertedID = Int32(id)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LevelMO")
        let predicate = NSPredicate(format: "id == \(convertedID)")
        request.predicate = predicate
        
        do {
            levelMO = try dataManager.persistentContainer.viewContext.fetch(request) as! [LevelMO]
        } catch {
            //print(error)
            levelMO = []
        }
        
        return levelMO[0]
        
    }
    
    //* Mutations
    
    // Creations
    
    func createLevels(_ levels : [Level]) {
        
        for level in levels {
            
            let newLevel = NSEntityDescription.insertNewObject(forEntityName: "LevelMO", into: dataManager.persistentContainer.viewContext) as! LevelMO
            
            newLevel.id = Int32(level.id)
            newLevel.status = Int32(level.status)
            newLevel.prompt = level.prompt
            newLevel.inputs = level.inputs
            newLevel.outputs = level.outputs
            
            let initCode : Code = []
            
            newLevel.solution = initCode as NSObject
            
        }
        
        dataManager.saveContext()
        
    }
    
    // Deletions
    
    func clearLevels() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LevelMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try dataManager.persistentContainer.viewContext.execute(deleteRequest)
        } catch {
            //print(error)
        }
        
        dataManager.saveContext()
    }
    
    func deleteLevels(_ levels: [LevelMO]) {
        
        for level in levels {
            dataManager.persistentContainer.viewContext.delete(level)
        }
        
        dataManager.saveContext()
        
    }
    
    // Modifications
    
    func startedLevel(id: Int) {
        let level : LevelMO = self.level(id: id)
        if(level.status < 1) {
            level.status = Int32(1)
            dataManager.saveContext()
        }
    }
    
    func finishedLevel(id: Int) {
        let level : LevelMO = self.level(id: id)
        if(level.status < 2) {
            level.status = Int32(2)
            dataManager.saveContext()
        }
    }
    
    func updatedSolution(id: Int, solution: Code) {
        let level : LevelMO = self.level(id: id)
        level.solution = solution as NSObject
        dataManager.saveContext()
    }
    
    
}

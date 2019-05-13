//
//  WJCoreDataManager.swift
//  PlayerPro
//
//  Created by William on 2019/5/8.
//  Copyright © 2019 William. All rights reserved.
//

import Foundation
import CoreData

class WJCoreDataManager: NSObject {
    
    /// 单例
    static let sharedInstance = WJCoreDataManager()
    
    private override init() {
        super.init()
        
        guard let url = Bundle.main.url(forResource: "Music", withExtension: "momd") else {
            print("没有获取资源路径")
            return
        }
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            return
        }
        
        let storeUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent("music.sqlite")
        
        let options = [NSMigratePersistentStoresAutomaticallyOption:true,
                       NSInferMappingModelAutomaticallyOption: true] /// 自动模型更新
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
    
        _ = try? coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: options)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: options)
        } catch {
            print("coordinator add presistent store")
        }
        
        
        /// 创建上下文
        
        /// 主线程
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        /// 子线程
        self.backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        /// 设置子线程的父线程
        self.backgroundContext?.parent = self.mainContext
        
        
        /// 关联上下文和持久化容器
        self.mainContext?.persistentStoreCoordinator = coordinator
        self.backgroundContext?.persistentStoreCoordinator = coordinator
    }
    
    open var backgroundContext: NSManagedObjectContext?
    
    open var mainContext: NSManagedObjectContext?
}

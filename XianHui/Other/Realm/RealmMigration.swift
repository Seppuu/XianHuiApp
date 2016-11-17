//
//  RealmMigration.swift
//  XianHui
//
//  Created by jidanyu on 2016/11/17.
//  Copyright © 2016年 mybook. All rights reserved.
//

import Foundation
import RealmSwift

let RealmConfig = Realm.Configuration(
    // 设置新的架构版本。这个版本号必须高于之前所用的版本号（如果您之前从未设置过架构版本，那么这个版本号设置为 0）
    schemaVersion: 1,
    
    // 设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
    migrationBlock: { migration, oldSchemaVersion in
        // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
        if (oldSchemaVersion < 1) {
            // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
        }
})

//
//  Record.swift
//  StopWatch
//
//  Created by 大平泰地 on 2022/07/01.
//

import Foundation
import RealmSwift

class Record: Object {
    @objc dynamic var createDay: Date = Date() //例：2022/01/31
    @objc dynamic var startTime: String = "" //例：10:21
    @objc dynamic var time: String = "" //秒数を保存
}

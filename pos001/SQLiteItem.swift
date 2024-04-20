//
//  File.swift
//  pos001
//
//  Created by 성재 on 2021/07/08.
//

import Foundation

public class SQLiteItem {
    let id:Int;
    let memo:Int;
    let image:String;
    let color:Int;
    let sort:Int;
    let feel:Int;
    
    init(id:Int, memo:Int, image:String, color:Int, sort:Int, feel:Int) {
        self.id = id
        self.memo = memo
        self.image = image
        self.color = color
        self.sort = sort
        self.feel = feel
    }
    
    func get_id() -> Int {
        return id
    }
    
    func get_image() -> String {
        return image
    }
    
    func get_color() -> Int {
        return color
    }
    
    func get_feel() -> Int {
        return feel
    }
}

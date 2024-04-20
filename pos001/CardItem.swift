//
//  CardItem.swift
//  pos001
//
//  Created by 성재 on 2021/07/13.
//

import Foundation

public class CardItem {
    let id1: Int
    let id2: Int
    let image1: String
    let image2: String
    let descrip: String
    let star: Int
    let color1: Int
    let color2: Int
    
    init(image1: String, image2: String, id1: Int, id2: Int, color1: Int, color2: Int, descrip: String, star: Int) {
        self.image1 = image1
        self.image2 = image2
        self.id1 = id1
        self.id2 = id2
        self.descrip = descrip
        self.star = star
        self.color1 = color1
        self.color2 = color2
    }
    
    func get_image1() -> String {
        return image1
    }
    
    func get_image2() -> String {
        return image2
    }
}

//
//  SetCard.swift
//  SetSara
//
//  Created by Sarah Mohamed on 6/25/21.
//

import Foundation

// color, number, shape, and shading // ▲●■
// data structure
struct SetCard:CustomStringConvertible , Hashable{
    var description: String{
        return "\(shape) \(number) \(color) \(shading)"
    }
    
    
    var shape : Shape
    var number : Number
    var color : Color
    var shading : Shading
    
    
    var isSelected:Bool = false
    var isMakeSet:Bool = false
    var isFaceUp:Bool = false
    
    enum Shape:String,CustomStringConvertible{
        var description: String{
            return rawValue
        }
        
        
        case square = "■"
        case circle = "●"
        case triangle = "▲"
        
        static var all = [Shape.square,.circle,.triangle]
    }
    enum Color:String,CustomStringConvertible{
        var description: String{
            return rawValue
        }
        case red
        case green
        case blue
        
        static var all = [Color.red,.green,.blue]
    }
    enum Shading:String,CustomStringConvertible{
        var description: String{
            return rawValue
        }
        case striped
        case filled
        case outline
        
        static var all = [Shading.striped,.filled,.outline]
    }
    enum Number:Int,CustomStringConvertible{
        var description: String{
            return "\(rawValue)"
        }
        case one = 1
        case two = 2
        case three = 3
        
        static var all = [Number.one,.two,.three]
    }
}

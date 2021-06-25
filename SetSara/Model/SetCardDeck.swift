//
//  SetCardDeck.swift
//  SetSara
//
//  Created by Sarah Mohamed on 6/25/21.
//

import Foundation


struct SetCardDeck {
    
    enum Score : Int{
        case match = 3
        case mismatch = -5
        case deselection = -1
    }
    var game_score : Score?
    
    private(set) var cards =  [SetCard]()
    private(set) var playing_cards =  [SetCard]()
    private(set) var number_of_playing_card_on_deck = 24
    private(set) var first_playing_card_on_deck = 12
    
    private(set) var selecting_cards =  [SetCard]()
    
    init() {
        
        for shape in SetCard.Shape.all{
            for number in SetCard.Number.all{
                for color in SetCard.Color.all{
                    for shading in SetCard.Shading.all{
                        cards.append(SetCard(shape: shape, number: number, color: color, shading: shading))
                    }
                }
            }
        }

        get_n_cards(number: first_playing_card_on_deck)
        
    }
    
    mutating func new_game(){
        if cards.count >= 12{
            playing_cards = []
            playing_cards = []
            get_n_cards(number: first_playing_card_on_deck)
        }
    }
    mutating func select_cards(index:Int){
        game_score = nil
        if selecting_cards.count < 2{ // select 2
            if let _index = selecting_cards.index(of:playing_cards[index]){
                
                
               // if let _index = playing_cards.index(of:selecting_cards[_index]){
                    playing_cards[index].isSelected = false
                //}
                selecting_cards.remove(at: _index)
                game_score = .deselection
            }else{
                
                playing_cards[index].isSelected = true
                selecting_cards.append(playing_cards[index])
            }
           
        }else{ // select 3
            // check matching //
            playing_cards[index].isSelected = true
            selecting_cards.append(playing_cards[index])
            check_matching_set()
        }
    }
    
    /**
     For example, these three cards form a set:

     One red striped diamond
     Two red solid diamonds
     Three red open diamonds
     */
    
    mutating func check_matching_set(){
       // selecting_cards //
        
        var ismatched = false
        var card1 = selecting_cards[0]
        var card2 = selecting_cards[1]
        var card3 = selecting_cards[2]
        
        print(selecting_cards)
        
        if is_matched_color(card1: card1, card2: card2, card3: card3) &&
            is_matched_shape(card1: card1, card2: card2, card3: card3) &&
            is_matched_shade(card1: card1, card2: card2, card3: card3) &&
            is_matched_number(card1: card1, card2: card2, card3: card3){
            ismatched = true
        }
      
        if ismatched == true{
//            card1.isMakeSet = true
//            card2.isMakeSet = true
//            card3.isMakeSet = true
            if let index = playing_cards.index(of:card1){
                playing_cards[index].isMakeSet = true
                
            }
            if let index = playing_cards.index(of:card2){
                playing_cards[index].isMakeSet = true
                
            }
            if let index = playing_cards.index(of:card3){
                playing_cards[index].isMakeSet = true
                
            }
            game_score = .match
        }else{
            if let index = playing_cards.index(of:card1){
                
                playing_cards[index].isSelected = false
            }
            if let index = playing_cards.index(of:card2){
               
                playing_cards[index].isSelected = false
            }
            if let index = playing_cards.index(of:card3){
                
                playing_cards[index].isSelected = false
            }
            game_score = .mismatch
        }
        
        selecting_cards = []
        
    }
    
    func is_matched_color(card1:SetCard,card2:SetCard,card3:SetCard)->Bool{
        var ismatched = false
        if ((card1.color.rawValue == card2.color.rawValue) && (card2.color.rawValue == card3.color.rawValue)) || ((card1.color.rawValue != card2.color.rawValue) && (card2.color.rawValue != card3.color.rawValue)){
            ismatched = true
        }else{
            ismatched = false
        }
        print("color ismatched ",ismatched)
        return ismatched
    }
    func is_matched_shape(card1:SetCard,card2:SetCard,card3:SetCard)->Bool{
        var ismatched = false
        if ((card1.shape.rawValue == card2.shape.rawValue) && (card2.shape.rawValue == card3.shape.rawValue)) || ((card1.shape.rawValue != card2.shape.rawValue) && (card2.shape.rawValue != card3.shape.rawValue)){
            ismatched = true
        }else{
            ismatched = false
        }
        print("shape ismatched ",ismatched)
        return ismatched
    }
    func is_matched_shade(card1:SetCard,card2:SetCard,card3:SetCard)->Bool{
        var ismatched = false
        if  ((card1.shading.rawValue == card2.shading.rawValue) && (card2.shading.rawValue == card3.shading.rawValue)) || ((card1.shading.rawValue != card2.shading.rawValue) && (card2.shading.rawValue != card3.shading.rawValue)){
            ismatched = true
        }else{
            ismatched = false
        }
        print("shading ismatched ",ismatched)
        return ismatched
    }
    func is_matched_number(card1:SetCard,card2:SetCard,card3:SetCard)->Bool{
        var ismatched = false
        if ((card1.number.rawValue == card2.number.rawValue) && (card2.number.rawValue == card3.number.rawValue)) || ((card1.number.rawValue != card2.number.rawValue) && (card2.number.rawValue != card3.number.rawValue)){
            ismatched = true
        }else{
            ismatched = false
        }
        print("number ismatched ",ismatched)
        return ismatched
    }
    
    mutating func get_n_cards (number : Int){
        
        for _ in 0..<number{
            if cards.count > 0 && (playing_cards.count <= number_of_playing_card_on_deck){
                playing_cards.append(cards.remove(at: cards.count.arc4Random))
            }
        }
        
    }
    
    mutating func deal_more_3_cards(){
       
        get_n_cards(number: 3)
    }
    
  
}



extension Int{
    var arc4Random:Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(self)))
        }else{
            return 0
        }
    }
}

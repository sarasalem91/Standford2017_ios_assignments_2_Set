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
    var hintCard = [Int]()
    
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
    
    mutating func hint() {
        hintCard.removeAll()
        for i in 0..<playing_cards.count {
            for j in (i + 1)..<playing_cards.count {
                for k in (j + 1)..<playing_cards.count {
                    let hints = [playing_cards[i], playing_cards[j], playing_cards[k]]
                    if is_matched_set_x(on: hints) {
                        hintCard += [i, j, k]
                    }
                }
            }
        }
    }
 
    mutating func select_cards(index:Int){
        
        if selecting_cards.count < 2{ // select 2
            if selecting_cards.contains(playing_cards[index]){
                selecting_cards.remove(at: selecting_cards.index(of: playing_cards[index])!)
                game_score = .deselection
                return
            }
            selecting_cards.append(playing_cards[index])
           
        }else{ // select 3
            // check matching //
            selecting_cards.append(playing_cards[index])
            check_matching_set()
        }
        
    }

    mutating func check_matching_set(){

        if is_matched_set_x(on: selecting_cards){
            for cards in selecting_cards {
                playing_cards.remove(at: playing_cards.index(of: cards)!)
            }
            get_n_cards(number: 3)
            game_score = .match
        }else{
            
            game_score = .mismatch
        }
        
        selecting_cards.removeAll()
        
    }
    
    mutating func is_matched_set_x(on selectedCard: [SetCard]) -> Bool {
      
        let color = Set(selectedCard.map{ $0.color }).count
        let shape = Set(selectedCard.map{ $0.shape }).count
        let number = Set(selectedCard.map{ $0.number }).count
        let fill = Set(selectedCard.map{ $0.shading }).count
        
        print("color ",color,"shape ",shape,"number ",number,"shading ",fill)
        return color != 2 && shape != 2 && number != 2 && fill != 2 // 1 or 3 to make set // 2 not make set
    }

    mutating func get_n_cards (number : Int){
        if cards.count > 0{
            for _ in 0..<number{
                
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

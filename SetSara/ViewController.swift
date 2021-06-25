//
//  ViewController.swift
//  SetSara
//
//  Created by Sarah Mohamed on 6/25/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var new_game_btn: UIButton!
    var new_game_btn_clck = false{
        didSet{
            if (deck.cards.count == 0){
                new_game_btn.isEnabled = false
            }
        }
    }
    var deal_3_more_cards = false{
        didSet{
            if (deck.playing_cards.count >= deck.number_of_playing_card_on_deck){
                deal_btn.isEnabled = false
            }
        }
    }
    @IBOutlet weak var score_lbl: UILabel!{
        didSet{
            score_lbl.text = "Score is : \(score )"
        }
    }
    var score = 0{
        didSet{
            score_lbl.text = "Score is : \(score )"
        }
    }
    @IBOutlet var buttonsArr: [UIButton]!
    
    var deck = SetCardDeck()

    @IBOutlet weak var deal_btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        show_n_cards()
        
    }
   
    @IBAction func New_Game(_ sender: UIButton) {
        score = 0
        new_game_btn_clck = true
        for index in buttonsArr.indices{
            buttonsArr[index].isHidden = true
            buttonsArr[index].alpha = 1
            buttonsArr[index].layer.borderWidth = 0
            buttonsArr[index].layer.borderColor = UIColor.clear.cgColor
        }
        deck.new_game()
        show_n_cards()
    }
    
    func show_n_cards(){
        if buttonsArr.count > 0{
            for index in deck.playing_cards.indices{
                
                var button = buttonsArr[index]
                var card = deck.playing_cards[index]
                
                button.isHidden = false
                draw_button(btn: button, card: card)
            }
        }
    }
    func draw_button(btn:UIButton,card:SetCard){
        var number = card.number
        var color = card.color
        var shade = card.shading
        var shape = card.shape
        
        var shape_on_btn = shape.rawValue
        print(number,color,shape,shade)
        
        if number.rawValue == 1{
            shape_on_btn = "\(shape_on_btn)"
        }else  if number.rawValue == 2{
            shape_on_btn = "\(shape_on_btn) \(shape_on_btn)"
        }else  if number.rawValue == 3{
            shape_on_btn = "\(shape_on_btn) \(shape_on_btn) \(shape_on_btn)"
        }
        var str : NSAttributedString?
        var color_btn : UIColor?
        switch color {
        case .red:
            color_btn = UIColor.red
        case .blue:
            color_btn = UIColor.blue
        case .green:
            color_btn = UIColor.green
        default:
            color_btn = UIColor.clear
        }
        
        switch shade {
        case .filled:
            var attributes : [NSAttributedString.Key:Any] = [.strokeWidth:-5,.foregroundColor:color_btn?.withAlphaComponent(1)]
             str = NSAttributedString(string: shape_on_btn, attributes: attributes)
        case .striped:
            var attributes : [NSAttributedString.Key:Any] = [.foregroundColor:color_btn?.withAlphaComponent(0.15)]
             str = NSAttributedString(string: shape_on_btn, attributes: attributes)
        case .outline:
            var attributes : [NSAttributedString.Key:Any] = [.strokeWidth:5,.strokeColor:color_btn]
             str = NSAttributedString(string: shape_on_btn, attributes: attributes)
        }
        
        btn.setAttributedTitle(str, for: .normal)
        btn.layer.cornerRadius = 8
    }
    
    @IBAction func chooseCard(_ sender: UIButton) {
        if let index = buttonsArr.index(of:sender){
            deck.select_cards(index:index )
            update_ui()
            
            var deck_score = deck.game_score?.rawValue ?? 0
            score += deck_score
            
        }
    }
    
    @IBAction func deal_3_more_cards(_ sender: UIButton) {
        
        deal_3_more_cards_on_ui()
    }
    
    func deal_3_more_cards_on_ui(){
        deck.deal_more_3_cards()
        update_ui()
        show_n_cards()
        deal_3_more_cards = true
    }

    func update_ui(){
        for index in deck.playing_cards.indices{
            var card = deck.playing_cards[index]
            if card.isSelected {
                if card.isMakeSet {
                    buttonsArr[index].alpha = 0
                }else{
                    buttonsArr[index].layer.borderWidth = 3
                    buttonsArr[index].layer.borderColor = UIColor.purple.cgColor
                }
                
            }else{
                buttonsArr[index].isHidden = false
                buttonsArr[index].layer.borderWidth = 0
                buttonsArr[index].layer.borderColor = UIColor.clear.cgColor
            }
        }
     
    }
}


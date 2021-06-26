//
//  ViewController.swift
//  SetSara
//
//  Created by Sarah Mohamed on 6/25/21.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = SetCardDeck()
    private var selectedButton = [UIButton]()
    private var hintedButton = [UIButton]()
    
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
    var score = 0{
        didSet{
            score_lbl.text = "Score is : \(score )"
        }
    }
    @IBOutlet weak var score_lbl: UILabel!{
        didSet{
            score_lbl.text = "Score is : \(score )"
        }
    }
   
    @IBOutlet var buttonsArr: [UIButton]!
    @IBOutlet weak var deal_btn: UIButton!
    @IBOutlet weak var new_game_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewFromModel()
        
    }
    
    
    @IBAction func press_hint(_ sender: UIButton) {
        deck.hint()
        if deck.hintCard.count > 0 {
            for hint in 0...2 {
                let index = deck.hintCard[hint]
                buttonsArr[index].layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                buttonsArr[index].layer.borderWidth = 3.0
                hintedButton.append(buttonsArr[index])
            }
            hintedButton.removeAll()
        }
    }
    
    @IBAction func New_Game(_ sender: UIButton) {
        score = 0
        deal_btn.isEnabled = true
        new_game_btn_clck = true
        deck = SetCardDeck()
        resetButton()

        selectedButton.removeAll()
        hintedButton.removeAll()
        updateViewFromModel()
    }
    private func resetButton() {
        for button in buttonsArr {
            let nsAttributedString = NSAttributedString(string: "")
            button.setAttributedTitle(nsAttributedString, for: .normal)
            button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        }
    }
    func updateViewFromModel(){
        for index in deck.playing_cards.indices{
            buttonsArr[index].titleLabel?.numberOfLines = 0
            buttonsArr[index].setAttributedTitle(setCardTitle(with: deck.playing_cards[index]), for: .normal)
            
        }
    }
    func setCardTitle(with card : SetCard)->NSAttributedString{
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: ModelToViewDataSource.colors[card.color]!,
            .strokeWidth: ModelToViewDataSource.strokeWidth[card.shading],
            .foregroundColor: ModelToViewDataSource.colors[card.color]!.withAlphaComponent(ModelToViewDataSource.alpha[card.shading]!),
            ]
        var cardTitle = ModelToViewDataSource.shapes[card.shape]!
        switch card.number {
        case .two: cardTitle = "\(cardTitle) \(cardTitle)"
        case .three: cardTitle = "\(cardTitle) \(cardTitle) \(cardTitle)"
        default:
            break
        }
        
        return NSAttributedString(string: cardTitle, attributes: attributes)
    }

    
    @IBAction func chooseCard(_ sender: UIButton) {
        if let index = buttonsArr.index(of:sender){
            deck.select_cards(index:index )
            chooseButton(at: sender)
            updateViewFromModel()
            
            var deck_score = deck.game_score?.rawValue ?? 0
            score += deck_score
            
        }
    }
    
    @IBAction func deal_3_more_cards(_ sender: UIButton) {
        
        deal_3_more_cards_on_ui()
    }
    
    func deal_3_more_cards_on_ui(){
        deck.deal_more_3_cards()
        updateViewFromModel()
        deal_3_more_cards = true
    }

    func chooseButton(at card: UIButton){
        
        if selectedButton.count < 2{
            if selectedButton.contains(card) {
                card.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                card.layer.borderWidth = 3.0
                selectedButton.remove(at: selectedButton.index(of: card)!)
                return
            }
            selectedButton += [card]
            card.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            card.layer.borderWidth = 3.0
        }else{
            selectedButton += [card]
            card.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            card.layer.borderWidth = 3.0
            
            buttonsArr.forEach() { $0.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0) }
            selectedButton.removeAll()
            updateScore()
        }
    }
      
    private func updateScore() {
        
        score_lbl.text = "Score is : \(deck.game_score?.rawValue )"
    }
    
}

struct ModelToViewDataSource {
    
    static let shapes: [SetCard.Shape: String] = [.circle: "●", .triangle: "▲", .square: "■"]
    static var colors: [SetCard.Color: UIColor] = [.red: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), .blue: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), .green: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)]
    static var alpha: [SetCard.Shading: CGFloat] = [.filled: 1.0, .outline: 0.40, .striped: 0.15]
    static var strokeWidth: [SetCard.Shading: CGFloat] = [.filled: -5, .outline: 5, .striped: -5]
}

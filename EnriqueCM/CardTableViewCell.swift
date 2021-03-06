//
//  CardTableViewCell.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 18/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

enum CardType: String {
    case Unknown, Detail = "detail", Project = "project"
}

class CardTableViewCell: UITableViewCell {

    var card: Card? = nil
    var cardType: CardType? = .Unknown
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var cardImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var aboutSummaryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.2
    }

    func initWithCart(_card : Card) {
        card = _card
        
        titleLabel.text         = _card.title
        subtitleLabel.text      = _card.subtitle
        aboutSummaryLabel.text  = _card.about
        if let type = _card.type {
            cardType = CardType.init(rawValue:type)
        }
        
        if let photoName = _card.imageName {
            if (!photoName.isEmpty) {
                cardImageView.image = UIImage(named: photoName)
            } else {
                cardImageView.image = nil
            }
        }
    }
}

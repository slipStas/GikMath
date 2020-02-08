//
//  HistoryTableViewCell.swift
//  GikMath
//
//  Created by Stanislav Slipchenko on 19.01.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var tapView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        historyLabel.text = nil
    }
    
    override func awakeFromNib() {
        
        tapView.isUserInteractionEnabled = true
        let tapOnIcon = UILongPressGestureRecognizer(target: self, action: #selector(tapOnIconView))
        tapOnIcon.minimumPressDuration = 1
        tapView.addGestureRecognizer(tapOnIcon)
    }
    
    @objc func tapOnIconView(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            UIView.animate(withDuration: 0.3,
                                   delay: 0,
                                   usingSpringWithDamping: 0.7,
                                   initialSpringVelocity: 0,
                                   options: [],
                                   animations: {
                                    self.historyLabel.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2)

            })
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.3,
                                   delay: 0,
                                   usingSpringWithDamping: 0.7,
                                   initialSpringVelocity: 0,
                                   options: [],
                                   animations: {
                                    self.historyLabel.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)

            })
        }
    }
}

//
//  EmptyTableView.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/20/21.
//

import Foundation
import UIKit

extension UITableView {

    func setEmptyMessage(_ message: String, view: UIView) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = view
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

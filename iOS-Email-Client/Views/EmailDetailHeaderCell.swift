//
//  EmailDetailHeaderCell.swift
//  iOS-Email-Client
//
//  Created by Pedro Aim on 3/19/18.
//  Copyright © 2018 Criptext Inc. All rights reserved.
//

import Foundation
import TagListView

class EmailDetailHeaderCell: UITableViewCell{
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var subjectHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelsListView: TagListView!
    @IBOutlet weak var starButton: UIButton!
    var onStarPressed: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelsListView.textFont = Font.regular.size(12.0)!
        labelsListView.marginX = 10.0
        labelsListView.marginY = 9.0
        labelsListView.paddingX = 10.0
        labelsListView.paddingY = 3.0
        labelsListView.cornerRadius = 8
    }
    
    func addLabels(_ labels: [Label]){
        labelsListView.removeAllTags()
        var starredColor = UIColor(red: 142/255, green: 143/255, blue: 149/255, alpha: 1.0)
        for label in labels {
            guard label.id != SystemLabel.starred.id else {
                starredColor = UIColor(hex: label.color)
                continue
            }
            let tag = labelsListView.addTag(label.text)
            tag.tagBackgroundColor = UIColor(hex: label.color)
        }
        labelsListView.invalidateIntrinsicContentSize()
        starButton.tintColor = starredColor
    }
    
    func setSubject(_ subject: String){
        subjectLabel.text = subject
        subjectLabel.numberOfLines = 0
        let myHeight = Utils.getLabelHeight(subject, width: subjectLabel.frame.width, fontSize: 21.0)
        subjectHeightConstraint.constant = myHeight
    }
    
    @IBAction func onStarButtonPressed(_ sender: Any) {
        self.onStarPressed?()
    }
}

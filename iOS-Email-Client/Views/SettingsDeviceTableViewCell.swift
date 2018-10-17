
//
//  SettingsDeviceTableViewCell.swift
//  iOS-Email-Client
//
//  Created by Pedro Aim on 5/22/18.
//  Copyright © 2018 Criptext Inc. All rights reserved.
//

import Foundation
import Material

protocol DeviceTableViewCellDelegate {
    func tableViewCellDidLongPress(_ cell: SettingsDeviceTableViewCell)
}

class SettingsDeviceTableViewCell: UITableViewCell {
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceLocationLabel: UILabel!
    @IBOutlet weak var currentDeviceLabel: UILabel!
    @IBOutlet weak var trashButton: UIButton!
    var delegate: DeviceTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trashButton.tintColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
    }
    
    func setContent(device: Device){
        deviceImageView.image = Device.Kind(rawValue: device.type)! != .pc ? #imageLiteral(resourceName: "device-mobile") : #imageLiteral(resourceName: "device-desktop")
        deviceNameLabel.text = device.friendlyName
        displayAsActive(device.active)
        guard !device.active else {
            return
        }
        let attrString = NSMutableAttributedString(string: "Last Activity", attributes: [NSAttributedStringKey.font: Font.bold.size(12.0)!])
        guard let date = device.lastActivity else {
            attrString.append(NSAttributedString(string: " - Over 2 month ago", attributes: [NSAttributedStringKey.font: Font.regular.size(12.0)!]))
            deviceLocationLabel.attributedText = attrString
            return
        }
        attrString.append(NSAttributedString(string: " - \(String(DateUtils.beautyDate(date)!).replacingOccurrences(of: "at ", with: ""))", attributes: [NSAttributedStringKey.font: Font.regular.size(12.0)!]))
        deviceLocationLabel.attributedText = attrString
    }
    
    func displayAsActive(_ active: Bool){
        deviceLocationLabel.isHidden = active
        currentDeviceLabel.isHidden = !active
        trashButton.isHidden = active
    }
    
    @IBAction func onTrashPress(_ sender: Any) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.tableViewCellDidLongPress(self)
    }
}

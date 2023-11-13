//
//  FriendMessageChatTableViewCell.swift
//  hw8
//
//  Created by 陈可轩 on 2023/11/12.
//

import UIKit

class FriendMessageChatTableViewCell: UITableViewCell {

    var wrapperCellView: UIView!
    var labelSenderName: UILabel!
    var labelMessage: UILabel!
    var labelTime: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelSenderName()
        setupLabelMessage()
        setupLabelTime()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UIView()
        wrapperCellView.backgroundColor = .green
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.4
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrapperCellView)
    }
    
    func setupLabelSenderName(){
        labelSenderName = UILabel()
        labelSenderName.font = UIFont.boldSystemFont(ofSize: 14)
        labelSenderName.textColor = .darkGray
        labelSenderName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelSenderName)
    }
    
    func setupLabelMessage(){
        labelMessage = UILabel()
        labelMessage.numberOfLines = 0
        labelMessage.font = UIFont.systemFont(ofSize: 16)
        labelMessage.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelMessage)
    }
    
    func setupLabelTime(){
        labelTime = UILabel()
        labelTime.font = UIFont.systemFont(ofSize: 12)
        labelTime.textColor = .gray
        labelTime.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTime)
    }
    
    func initConstraints() {
        // Set up your constraints here
        NSLayoutConstraint.activate([

            labelSenderName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            labelSenderName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            wrapperCellView.topAnchor.constraint(equalTo: labelSenderName.bottomAnchor, constant: 8),
            wrapperCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            wrapperCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            wrapperCellView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),

            labelMessage.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 4),
            labelMessage.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 8),
            labelMessage.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -8),

            labelTime.topAnchor.constraint(equalTo: labelMessage.bottomAnchor, constant: 4),
            labelTime.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 8),
            labelTime.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -8)
        ])
    }


}

//
//  ChatView.swift
//  hw8
//
//  Created by 陈可轩 on 2023/11/12.
//

import UIKit

class ChatView: UIView {

    // make tableView scrollable
    var scrollView: UIScrollView!
    
    //tableView for contacts...
    var tableViewMessages: UITableView!
    
    //bottom view for adding a Contact...
    var bottomAddView:UIView!
    var textViewMessage:UITextField!
    var buttonAdd:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupScrollView()
        
        setupTableViewMessages()
        
        setupBottomAddView()
        setupTextViewNote()
        setupButtonAdd()
        
        initConstraints()
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
    }
    
    //MARK: the table view to show the list of contacts...
    func setupTableViewMessages(){
        tableViewMessages = UITableView()
        tableViewMessages.register(MyMessageChatTableViewCell.self, forCellReuseIdentifier: "myMessage")
        tableViewMessages.register(FriendMessageChatTableViewCell.self, forCellReuseIdentifier: "friendMessage")
        tableViewMessages.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(tableViewMessages)
    }
    
    //MARK: the bottom add contact view....
    func setupBottomAddView(){
        bottomAddView = UIView()
        bottomAddView.backgroundColor = .white
        bottomAddView.layer.cornerRadius = 6
        bottomAddView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomAddView.layer.shadowOffset = .zero
        bottomAddView.layer.shadowRadius = 4.0
        bottomAddView.layer.shadowOpacity = 0.7
        bottomAddView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomAddView)
    }
    
    func setupTextViewNote() {
        textViewMessage = UITextField()
        textViewMessage.placeholder = "Send message here..."
        textViewMessage.borderStyle = .roundedRect
        textViewMessage.translatesAutoresizingMaskIntoConstraints = false
        bottomAddView.addSubview(textViewMessage)
    }

    
    func setupButtonAdd(){
        buttonAdd = UIButton(type: .system)
        buttonAdd.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonAdd.setTitle("Send", for: .normal)
        buttonAdd.translatesAutoresizingMaskIntoConstraints = false
        bottomAddView.addSubview(buttonAdd)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            // Constraints for scrollView
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: bottomAddView.topAnchor, constant: -8),

            // Constraints for tableViewContacts inside the scrollView
            tableViewMessages.topAnchor.constraint(equalTo: scrollView.topAnchor),
            tableViewMessages.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            tableViewMessages.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            tableViewMessages.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            tableViewMessages.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            //bottom add view...
            bottomAddView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -8),
            bottomAddView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            bottomAddView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            buttonAdd.bottomAnchor.constraint(equalTo: bottomAddView.bottomAnchor, constant: -8),
            buttonAdd.leadingAnchor.constraint(equalTo: bottomAddView.leadingAnchor, constant: 4),
            buttonAdd.trailingAnchor.constraint(equalTo: bottomAddView.trailingAnchor, constant: -4),
            
            textViewMessage.bottomAnchor.constraint(equalTo: buttonAdd.topAnchor, constant: -8),
            textViewMessage.leadingAnchor.constraint(equalTo: buttonAdd.leadingAnchor, constant: 4),
            textViewMessage.trailingAnchor.constraint(equalTo: buttonAdd.trailingAnchor, constant: -4),
            
            bottomAddView.topAnchor.constraint(equalTo: textViewMessage.topAnchor, constant: -8),
            //...
            
            tableViewMessages.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableViewMessages.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewMessages.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableViewMessages.bottomAnchor.constraint(equalTo: bottomAddView.topAnchor, constant: -8),
            
        ])
    }
    
    
    //MARK: initializing constraints...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



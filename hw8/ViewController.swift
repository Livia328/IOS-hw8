//
//  ViewController.swift
//  hw8
//
//  Created by 陈可轩 on 2023/11/9.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {

    let mainScreen = MainScreenView()
    let notificationCenter = NotificationCenter.default
    
    // use this listener to track whether any user is signed in
    var handleAuth: AuthStateDidChangeListenerHandle?
    // current signed-in Firebase user
    var currentUser:FirebaseAuth.User?
    
    var chatsList = [Chat]()
    
    // buttom search bar
    let searchSheetController = SearchBottomSheetController()
    var searchSheetNavController: UINavigationController!
    
    let db = Firestore.firestore()
    
    override func loadView() {
        view = mainScreen
    }
    
    // lifecycle method, handle the logic before the screen is loaded.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                //MARK: not signed in...
                self.currentUser = nil
                self.mainScreen.labelText.text = "Please sign in to see the chats!"
                self.mainScreen.floatingButtonAddContact.isEnabled = false
                self.mainScreen.floatingButtonAddContact.isHidden = true
                
                //MARK: Reset tableView...
                self.chatsList.removeAll()
                self.mainScreen.tableViewContacts.reloadData()
                
                // determine which button to show on the right corner
                self.setupRightBarButton(isLoggedin: false)
                
            }else{
                //MARK: the user is signed in...
                self.currentUser = user
                self.mainScreen.labelText.text = "Welcome \(user?.displayName ?? "Anonymous")!"
                self.mainScreen.floatingButtonAddContact.isEnabled = true
                self.mainScreen.floatingButtonAddContact.isHidden = false
                
                // determine which button to show on the right corner
                self.setupRightBarButton(isLoggedin: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Chats"
        
        //MARK: Make the titles look large...
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //MARK: Put the floating button above all the views...
        view.bringSubviewToFront(mainScreen.floatingButtonAddContact)
        
        //MARK: patching table view delegate and data source...
        mainScreen.tableViewContacts.delegate = self
        mainScreen.tableViewContacts.dataSource = self
        
        //MARK: removing the separator line...
        mainScreen.tableViewContacts.separatorStyle = .none
        
        // tapping the floatting add contact button
        mainScreen.floatingButtonAddContact.addTarget(self, action: #selector(onSearchContactButtonTapped), for: .touchUpInside)
        
        // select the name to start a new chat
        observeNameSelected()
    }
    
    func observeNameSelected(){
        notificationCenter.addObserver(
            self,
            selector: #selector(onNameSelected(notification:)),
            name: .startChatNameSelected,
            object: nil)
    }
    
    @objc func onNameSelected(notification: Notification){
//        let selectedName = notification.object{
//            print(selectedName)
//        }
        
        // if the selected user is current user, alert
        if let selectedEmail = notification.object as? String {
            if selectedEmail == currentUser?.email {
                showAlert(text: "Can't choosing yourself, please choose another user")
            }
            
            // if there is already the chat, open it
            startNewChat(emailToChat: selectedEmail)
            let chatViewController = ChatViewController()
            self.navigationController?.pushViewController(chatViewController, animated: true)
            // reload the chat list
            self.mainScreen.tableViewContacts.reloadData()
        }
        
        // otherwise start a new chat,
            // append it to the table view in the main screen
            // pop up the

        
    }
    
    // start a new chat between the current user with selected user
    func startNewChat(emailToChat: String) {
        guard let currentUserEmail = currentUser?.email else {
            showAlert(text: "Can't find current user")
            return
        }
        let participants = [emailToChat, currentUserEmail]
        let newChat = Chat(participants: participants)
        
        // append to chatsList
        chatsList.append(newChat)
        
        var key = ""
        if emailToChat < currentUserEmail {
            key = emailToChat + currentUserEmail
        } else {
            key = currentUserEmail + emailToChat
        }
        
        do {
            let chatRef = db.collection("chats").document(key)
            try chatRef.setData(from: newChat, completion: {(error) in
                if error == nil {
                    print("New chat created ")
                    // add the chat to the users document
                    for email in participants {
                        self.db
                            .collection("users")
                            .document(email)
                            .collection("chats")
                            .document(key)
                            .setData(["chatReference": chatRef])
                    }
                }
            })
        } catch {
            print("Error creating chat object: \(error.localizedDescription)")
            showAlert(text: "Failed to create a new chat")
        }
        
    }
    
    func showAlert(text:String){
        let alert = UIAlertController(
            title: "Error",
            message: "\(text)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
    // because is async, so we have to guarantee that the getAllUser function is complete
    // then move to the seach part
    @objc func onSearchContactButtonTapped(){
        self.searchSheetController.namesDatabase.removeAll()
        getAllUsersFromFireBase { [weak self] names in
            guard let self = self else { return }
            
            self.searchSheetController.namesDatabase.append(contentsOf: names)
            print(self.searchSheetController.namesDatabase)
            self.setupSearchBottomSheet()
            present(self.searchSheetNavController, animated: true)
        }
    }
    
    func setupSearchBottomSheet(){
        //MARK: setting up bottom search sheet...
        searchSheetNavController = UINavigationController(rootViewController: searchSheetController)
        // set the searchNames Listed
        // MARK: setting up modal style...
        searchSheetNavController.modalPresentationStyle = .pageSheet
        
        if let bottomSearchSheet = searchSheetNavController.sheetPresentationController{
            bottomSearchSheet.detents = [.medium(), .large()]
            bottomSearchSheet.prefersGrabberVisible = true
        }
    }
    
    // Important: have to user completion, or it will give back an empty array
    func getAllUsersFromFireBase(completion: @escaping ([String]) -> Void) {
        var tmp = [String]()
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")

        usersCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                       // Extracting user data
                       let userData = document.data()
                       if let userEmail = userData["email"] as? String {
                           tmp.append(userEmail)
                           print("in the for loop: \(userEmail)")
                       } else {
                           print("User data does not contain a name")
                       }
                   }
                }
                completion(tmp)

            }
        }
    }

    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handleAuth!)
    }
}

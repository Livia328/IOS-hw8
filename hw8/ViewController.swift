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
        getAllChats()
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
                self.getAllChats()
                
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
        print("current User in view Controller")
        print(currentUser)
        getAllChats()
        
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
        
        notificationCenter.addObserver(
            self,
            selector: #selector(updatedUserRegistered(_:)),
            name: .userRegistered,
            object: nil)
        
        notificationCenter.addObserver(
            self,
            selector: #selector(updatedUserLoggedIn(_:)),
            name: .userLoggedin,
            object: nil)
        
        notificationCenter.addObserver(
            self,
            selector: #selector(updatedUserLoggedout(_:)),
            name: .userLoggedout,
            object: nil)
        
        
    }
    
    @objc func updatedUserRegistered(_ notification: Notification) {
        print("Notification center triggered -- UserRegistered")
        // update the view
        loadView()
    }
    
    @objc func updatedUserLoggedIn(_ notification: Notification) {
        print("Notification center triggered -- UserLoggedIn")
        // update the view
        loadView()
    }
    
    @objc func updatedUserLoggedout(_ notification: Notification) {
        print("Notification center triggered -- UserLoggedOut")
        currentUser = nil
        self.chatsList.removeAll()
        self.mainScreen.tableViewContacts.reloadData()
        loadView()
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
            
            // 查找是否存在这个chat
            var key = ""
            guard let currentUserEmail = currentUser?.email else {
                return
            }
            if selectedEmail < currentUserEmail {
                key = selectedEmail + currentUserEmail
            } else {
                key = currentUserEmail + selectedEmail
            }
            let chatViewController = ChatViewController()
            
            getChatIfExists(key: key, currentUserEmail: currentUserEmail) { chat in
                if let chat = chat {
                    // The chat object exists
                    chatViewController.messagesList = chat.messages
                } else {
                    // The chat object doesn't exist
//                    self.startNewChat(emailToChat: selectedEmail)
                    self.startNewChat(emailToChat: selectedEmail) { result in
                        switch result {
                        case .success:
                            // reload the chat list
                            print("Chat created successfully")
                            self.getAllChats()
                            self.mainScreen.tableViewContacts.reloadData()
                        case .failure(let error):
                            print("Error creating chat: \(error.localizedDescription)")
                        }
                    }
                }
            }
            self.navigationController?.pushViewController(chatViewController, animated: true)
        }
        
        // otherwise start a new chat,
            // append it to the table view in the main screen
            // pop up the

    }
    
    func getAllChats() {
        guard let currentUserEmail = currentUser?.email else {
            return
        }
        print("Get All Chats executed")
        getAllChatsFromFireBase(forUserEmail: currentUserEmail) { chats in
            self.chatsList = chats
            self.mainScreen.tableViewContacts.reloadData()
        }
        print(chatsList)
    }
    
    func getAllChatsFromFireBase(forUserEmail userEmail: String, completion: @escaping ([Chat]) -> Void) {
        print("getAllChatsFromFireBase")
        db.collection("users")
            .document(userEmail)
            .collection("chats")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion([])
                } else {
                    var chats: [Chat] = []

                    for document in querySnapshot?.documents ?? [] {
                        do {
                            if let chatReference = document.get("chatReference") as? DocumentReference {
                                // Fetch the chat using the reference
                                chatReference.getDocument { (chatSnapshot, chatError) in
                                    if let chatError = chatError {
                                        print("Error getting chat document: \(chatError)")
                                    } else if let chatDocument = chatSnapshot, chatDocument.exists {
                                        // Parse the chat document into your Chat model
                                        if let chat = try? chatDocument.data(as: Chat.self) {
                                            chats.append(chat)
                                        }
                                    }
                                    completion(chats)
                                }
                            }
                        } catch {
                            print("Error parsing document: \(error)")
                            // Handle the error, e.g., log it or ignore the document
                        }
                    }

                    completion(chats)
                }
            }
    }



    
    // check whether this chatID exist in the firebase
    func getChatIfExists(key: String, currentUserEmail: String, completion: @escaping (Chat?) -> Void) {
        db.collection("users")
            .document(currentUserEmail)
            .collection("chats")
            .document(key)
            .getDocument { (document, error) in
                if let error = error {
                    print("Error getting document: \(error)")
                    completion(nil)
                } else if let document = document, document.exists {
                    do {
                        let chat = try document.data(as: Chat.self)
                        completion(chat)
                    } catch {
                        print("Error parsing document: \(error)")
                        completion(nil)
                    }
                } else {
                    // Document doesn't exist
                    completion(nil)
                }
            }
    }


    
    // start a new chat between the current user with selected user
//    func startNewChat(emailToChat: String) {
//        guard let currentUserEmail = currentUser?.email else {
//            showAlert(text: "Can't find current user")
//            return
//        }
//        let participants = [emailToChat, currentUserEmail]
//        let newChat = Chat(participants: participants)
//
//        // append to chatsList
//        chatsList.append(newChat)
//
//        var key = ""
//        if emailToChat < currentUserEmail {
//            key = emailToChat + currentUserEmail
//        } else {
//            key = currentUserEmail + emailToChat
//        }
//
//        do {
//            let chatRef = db.collection("chats").document(key)
//            try chatRef.setData(from: newChat, completion: {(error) in
//                if error == nil {
//                    print("New chat created ")
//                    // add the chat to the users document
//                    for email in participants {
//                        self.db
//                            .collection("users")
//                            .document(email)
//                            .collection("chats")
//                            .document(key)
//                            .setData(["chatReference": chatRef])
//                    }
//                }
//            })
//        } catch {
//            print("Error creating chat object: \(error.localizedDescription)")
//            showAlert(text: "Failed to create a new chat")
//        }
//    }
    
    func startNewChat(emailToChat: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUserEmail = currentUser?.email else {
            showAlert(text: "Can't find the current user")
            completion(.failure(NSError(domain: "YourDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Can't find the current user"])))
            return
        }

        let participants = [emailToChat, currentUserEmail]
        let newChat = Chat(participants: participants)

        // Append to chatsList
        chatsList.append(newChat)

        var key = ""
        if emailToChat < currentUserEmail {
            key = emailToChat + currentUserEmail
        } else {
            key = currentUserEmail + emailToChat
        }

        do {
            let chatRef = db.collection("chats").document(key)
            try chatRef.setData(from: newChat, completion: { error in
                if let error = error {
                    print("Error creating chat object: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("New chat created")
                    // Add the chat to the users' document
                    for email in participants {
                        self.db.collection("users").document(email).collection("chats").document(key).setData(["chatReference": chatRef])
                    }
                    completion(.success(()))
                }
            })
        } catch {
            print("Error creating chat object: \(error.localizedDescription)")
            showAlert(text: "Failed to create a new chat")
            completion(.failure(error))
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

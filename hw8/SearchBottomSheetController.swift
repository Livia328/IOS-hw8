//
//  SearchBottomSheetController.swift
//  hw8
//
//  Created by 陈可轩 on 2023/11/11.
//

import UIKit
import FirebaseFirestore

class SearchBottomSheetController: UIViewController {

    let searchSheet = SearchBottomSheetView()
    
    let notificationCenter = NotificationCenter.default
    
    //MARK: the list of names...
    //TODO: get all users name from firebase
    var namesDatabase = [String]()
    
    //MARK: the array to display the table view...
    var namesForTableView = [String]()
    
    override func loadView() {
        view = searchSheet
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        print(namesDatabase)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: sorting the names list...
        namesDatabase.sort()
        
        //MARK: setting up Table View data source and delegate...
        searchSheet.tableViewSearchResults.delegate = self
        searchSheet.tableViewSearchResults.dataSource = self
        
        //MARK: setting up Search Bar delegate...
        searchSheet.searchBar.delegate = self
        
        //MARK: initializing the array for the table view with all the names...
        namesForTableView = namesDatabase
    }
    
//    func getAllUsersFromFireBase(completion: @escaping ([String]) -> Void) {
//        var tmp = [String]()
//        let db = Firestore.firestore()
//        let usersCollection = db.collection("users")
//
//        usersCollection.getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                for document in querySnapshot!.documents {
//                    do {
//                       // Extracting user data
//                       let userData = document.data()
//                       if let userEmail = userData["email"] as? String {
//                           tmp.append(userEmail)
//                           print("in the for loop: \(userEmail)")
//                       } else {
//                           print("User data does not contain a name")
//                       }
//                   }
//                }
//                completion(tmp)
//            }
//        }
//    }
//
//    func updateSearchSheetContent() {
//        namesDatabase.removeAll()
//        getAllUsersFromFireBase { names in
//            self.namesDatabase.append(contentsOf: names)
//            print(self.namesDatabase)
//            self.searchSheet.tableViewSearchResults.reloadData()
//        }
//    }
}

//MARK: adopting Table View protocols...
extension SearchBottomSheetController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesForTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Configs.searchTableViewID, for: indexPath) as! SearchTableCell
        
        cell.labelTitle.text = namesForTableView[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK: name selected....
        notificationCenter.post(name: .startChatNameSelected, object: namesForTableView[indexPath.row])
        
        //MARK: dismiss the bottom search sheet...
        self.dismiss(animated: true)
    }
}

//MARK: adopting the search bar protocol...
extension SearchBottomSheetController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            print(namesDatabase)
            namesForTableView = namesDatabase
        }else{
            self.namesForTableView.removeAll()

            for name in namesDatabase{
                if name.contains(searchText){
                    self.namesForTableView.append(name)
                }
            }
        }
        self.searchSheet.tableViewSearchResults.reloadData()
    }
}

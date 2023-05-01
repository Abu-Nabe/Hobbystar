//
//  Search.swift
//  Zinging
//
//  Created by Abu Nabe on 5/1/21.
//

import UIKit
import FirebaseDatabase
import Firebase



class Search: UIViewController {
    
    var username: String!
    
    var filteredData = [String]()     //Added    : AnyObject
    var userdata : [UserData] = [UserData]()
    
    var inSearchMode = false
    
    var search: String!
    
    let cellId = "searchid"
    
    private let SearchList: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let Field: UITextField = {
        let field = UITextField()
        field.placeholder = "Search"
        field.backgroundColor = .green
        field.layer.cornerRadius = 16
        field.autocapitalizationType = .none
        field.text = field.text?.lowercased()
        
        var imageView = UIImageView();
        var image = UIImage(systemName: "magnifyingglass");
        imageView.image = image;
        imageView.tintColor = .black
        field.leftView = imageView
        field.leftViewMode = .always
        
        return field
    }()
    
    private let BlackLine: UIView =
        {
            let line = UIView()
            
            line.backgroundColor = .black
            
            return line
        }()
    
    private let SearchView: UIView =
        {
            let line = UIView()
            line.backgroundColor = .green
            
            
            
            return line
        }()
    
    let removeImage: UIImageView = {
        var imageview = UIImageView()
        imageview.image = UIImage(named: "Cancel")
        imageview.tintColor = .black
        
        return imageview
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(SearchList)
        view.addSubview(SearchView)
        
        configureTableView()
        configureSearch()
        
        userdata.removeAll()
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        
        Field.delegate = self
        Field.returnKeyType = UIReturnKeyType.done
        
        self.edgesForExtendedLayout = []
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = true
        
        SearchView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.height/13-10)
        
        SearchList.register(SearchCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if Field.text == ""
        {
            inSearchMode = false
            userdata.removeAll()
            self.SearchList.reloadData()
            self.BlackLine.backgroundColor = .black
        }else {
            let tap = UITapGestureRecognizer(target: self, action: #selector(EmptyText))
            tap.numberOfTapsRequired = 1
            Field.isUserInteractionEnabled = true
            Field.addGestureRecognizer(tap)
        }
    }
    
    func configureSearch()
    {
        SearchView.addSubview(Field)
        SearchView.addSubview(removeImage)
        SearchView.addSubview(BlackLine)
        Field.addTarget(self, action: #selector(Search.textFieldDidChange(_:)), for: .editingChanged)
        
        let height = view.height/13-15
        let width = height
        Field.anchor(top: SearchView.topAnchor, left: SearchView.leftAnchor, right: removeImage.leftAnchor, paddingLeft: 2, height: view.height/13-15)
                
        removeImage.anchor(top: SearchView.topAnchor, right: SearchView.rightAnchor, width: width, height: height)
        
        BlackLine.anchor(top: Field.bottomAnchor, left: SearchView.leftAnchor, right: removeImage.leftAnchor, paddingLeft: 2, height: 1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PreviousView))
        tap.numberOfTapsRequired = 1
        removeImage.isUserInteractionEnabled = true
        removeImage.addGestureRecognizer(tap)
        
    }
    
    @objc func EmptyText()
    {
        let text = Field.text
        if text == ""
        {
           
        }else {
            userdata.removeAll()
            SearchList.reloadData()
            Field.text = ""
        }
    }
    
    @objc func PreviousView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "Main") as! UITabBarController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    func configureTableView()
    {
        setTableViewDelegates()
        SearchList.rowHeight = 60
        SearchList.separatorStyle = .none
        
        SearchList.anchor(top: SearchView.bottomAnchor, width: view.width, height: view.height)
    }
    
    func setTableViewDelegates()
    {
        SearchList.dataSource = self
        SearchList.delegate = self
    }
}

extension Search: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            return userdata.count
        }
        return 0   // return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 30 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId,
                                                     for: indexPath) as! SearchCell
            
            var username: String!
            var hobby: String!
            //
            let items = userdata[indexPath.row]
            
            if inSearchMode {
                //                username = self.filteredData[indexPath.row]
                //                hobby = self.filteredData[indexPath.row]
                
                username = items.text
                hobby = items.Activity as! String
                let ref = Database.database().reference()
                
                ref.child("Users").child(items.id).observe(.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        cell.NameLabel.text = items.text
                        if(snapshot.hasChild("hobbyname"))
                        {
                            cell.HobbyLabel.text = items.Activity as! String
                            
                            hobby = cell.HobbyLabel.text
                        }else {
                            cell.HobbyLabel.text = ""
                        }
                        if snapshot.hasChild("profileimage")
                        {
                            
                            //                            let image = userObjects?["profileimage"]
                            let image = items.image
                            let url = URL(string: image)
                            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                
                                if let error = error {
                                    print("There was an error fetching the image from the url: \n", error)
                                }
                                
                                if let data = data, let profilePicture = UIImage(data: data) {
                                    DispatchQueue.main.async() {
                                        cell.profileImageView.image = profilePicture // Set the profile picture
                                    }
                                } else {
                                    print("Something is wrong with the image data")
                                }
                                
                            }).resume()
                        }else {
                            cell.profileImageView.image = UIImage.init(systemName: "person.fill")
                            cell.profileImageView.tintColor = .systemGreen
                        }
                    }
                }
            } else {
                
                username = ""          //don't want to get and place all usernames in cells
                
            }
            
            //            cell.configureCell(username: username, hobby: hobby)
            
            return cell
            
        } else {
            
            return UITableViewCell()
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let items = userdata[indexPath.row]
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        if items.id == Auth
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "ProfileView") as! ProfileView
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "AddProfile", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddProfile") as! AddProfile
            newViewController.NameLabel.text = items.text
            newViewController.Userid = items.id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
}

extension Search: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        inSearchMode = true
        let text = Field.text! + string
        print(text)
        
        userdata.removeAll()
        SearchList.reloadData()
        
        getData(String: text)
        
        
        
        return true
    }
    
    
    func getData(String: String)
    {
        let text = String
        let ref = Database.database().reference()
        self.BlackLine.backgroundColor = .white
        
        inSearchMode = true
        // previous was text + "\u{f8ff}" which gives exact value.
        ref.child("Users").queryOrdered(byChild: "username").queryStarting(atValue: text).queryEnding(atValue: text + "\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // cast to an array of DataSnapshots
            
            self.userdata.removeAll()   //remove irrelevant values
            
            guard let fetchedList = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            // iterate through array, cast value to dictionary
            
            for obj in fetchedList {
                
                
                let objDict = obj.value as! [String: AnyObject]
                
                
                let data = objDict["username"] as! String
                let hobby = objDict["hobbyname"] as? String ?? ""
                
                let image = objDict["profileimage"] as? String ?? ""
                
                
                
                
                let key = obj.key
                
                //                    let user = objDict[key]
                
                
                
                
                let SearchUsers = UserData(image: image, text: data , Activity: hobby, id: key)
                
                self.userdata.append(SearchUsers)
                self.SearchList.reloadData()
                
                //                self.inSearchMode = true
                //                    self.filteredData.append(data)
            }
        }) { (err) in
            print(err)
            
            self.SearchList.reloadData()
        }
    }
    
}

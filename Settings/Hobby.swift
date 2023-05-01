//
//  Hobby.swift
//  Zinging
//
//  Created by Abu Nabe on 25/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


struct HobbyCellModel{
    let title: String
    let handler: (() -> Void)
}

class Hobby: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    private var data = [[HobbyCellModel]]()
    
    var textview = UITextView()
    
    let label: UILabel =
    {
        let label = UILabel()
        label.text = "Select Your Hobby"
        return label
    }()
    
    let line: UIView = {
        let line = UIView()
        
        return line
    }()
    
    
    private let tableView: UITableView =
        {
            let tableView = UITableView(frame: .zero, style: .plain)
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            return tableView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        view.addSubview(line)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.anchor(top: view.topAnchor,paddingTop: 5)
        
        line.frame = CGRect(x: view.width/2-label.width/2, y: label.frame.origin.y+label.frame.size.height
                                    , width: label.width, height: 1)
        
        tableView.anchor(top: line.bottomAnchor,width: view.width, height: view.height)
        
        configureModels()
        
    }
    
    
    private func configureModels()
    {
        let section = [
            HobbyCellModel(title: "Artist")
            { [weak self] in
                self?.textview.text = "Artist"
                self?.updateData()
            }
        ]
        let section1 = [
            HobbyCellModel(title: "Athlete")
            { [weak self] in
                self?.textview.text = "Athlete"
                self?.updateData()
            }
        ]
        let section2 = [
            HobbyCellModel(title: "Comedian")
            { [weak self] in
                self?.textview.text = "Comedian"
                self?.updateData()
            }
        ]
        let section3 = [
            HobbyCellModel(title: "Cooking")
            { [weak self] in
                self?.textview.text = "Cooking"
                self?.updateData()
            }
        ]
        let section4 = [
            HobbyCellModel(title: "Dance")
            { [weak self] in
                self?.textview.text = "Dance"
                self?.updateData()
            }
        ]
        let section5 = [
            HobbyCellModel(title: "Editor")
            { [weak self] in
                self?.textview.text = "Editor"
                self?.updateData()
            }
        ]
        let section6 = [
            HobbyCellModel(title: "Gamer")
            { [weak self] in
                self?.textview.text = "Gamer"
                self?.updateData()
            }
        ]
        let section7 = [
            HobbyCellModel(title: "Model")
            { [weak self] in
                self?.textview.text = "Model"
                self?.updateData()
            }
        ]
        let section8 = [
            HobbyCellModel(title: "Photographer")
            { [weak self] in
                self?.textview.text = "Photographer"
                self?.updateData()
            }
        ]
        let section9 = [
            HobbyCellModel(title: "Sports")
            { [weak self] in
                self?.textview.text = "Sports"
                self?.updateData()
            }
        ]
        let section10 = [
            HobbyCellModel(title: "Speaker")
            { [weak self] in
                self?.textview.text = "Speaker"
                self?.updateData()
            }
        ]
        let section11 = [
            HobbyCellModel(title: "Regular")
            { [weak self] in
                self?.textview.text = "Regular"
                self?.updateData()
            }
        ]
        data.append(section)
        data.append(section1)
        data.append(section2)
        data.append(section3)
        data.append(section4)
        data.append(section5)
        data.append(section6)
        data.append(section7)
        data.append(section8)
        data.append(section9)
        data.append(section10)
        data.append(section11)
        
    }
    
    func updateData()
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser?.uid
        
        let hobby = textview.text
        
        let data = ["hobbyname": hobby]
        ref.child("Users").child(Auth!).setValue(data)
       
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:  IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
    
}

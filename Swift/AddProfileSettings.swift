//
//  SettingsView.swift
//  Zinging
//
//  Created by Abu Nabe on 12/4/21.
//

import UIKit
import FirebaseAuth

struct SettingCellModel1{
    let title: String
    let handler: (() -> Void)
}

final class AddProfileSettings: UIViewController{
    
    private let tableView: UITableView =
        {
            let tableView = UITableView(frame: .zero, style: .plain)
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            return tableView
        }()
    
    private var data = [[SettingCellModel1]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        
        self.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func configureModels()
    {
        let section = [
            SettingCellModel1(title: "Videos")
            { [weak self] in
                self?.Videos()
            }
        ]
        let section1 = [
            SettingCellModel1(title: "Report")
            { [weak self] in
                self?.Report()
            }
        ]
        let section2 = [
            SettingCellModel1(title: "Block")
            { [weak self] in
                self?.Block()
            }
        ]

       
        data.append(section)
        data.append(section1)
        data.append(section2)
        
    }
    
    func Videos()
    {
        let popupVC = ManageUser()
        
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        present(popupVC, animated: true, completion: nil)
    }
    
    func Report()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "PersonalLinks", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PersonalLinks") as! PersonalLinks
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func Block()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Premium", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Premium") as! Premium
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    private func Unfriend()
    {
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: {_ in
            Authentication.shared.logOut(completion: {success in
                DispatchQueue.main.async {
                    if success{
                       
                    }else{
                        
                    }
                }
            })
        }))
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
    }
}

extension AddProfileSettings: UITableViewDelegate, UITableViewDataSource
{
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

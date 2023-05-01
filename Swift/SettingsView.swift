//
//  SettingsView.swift
//  Zinging
//
//  Created by Abu Nabe on 4/1/21.
//

import UIKit
import FirebaseAuth

struct SettingCellModel{
    let title: String
    let handler: (() -> Void)
}

final class SettingsView: UIViewController{
    
    private let tableView: UITableView =
        {
            let tableView = UITableView(frame: .zero, style: .plain)
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            return tableView
        }()
    
    private var data = [[SettingCellModel]]()
    
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
        let section2 = [
            SettingCellModel(title: "Log Out")
            { [weak self] in
                self?.didTapLogOut()
            }
        ]
        let section = [
            SettingCellModel(title: "Manage")
            { [weak self] in
                self?.Manage()
            }
        ]
        let section1 = [
            SettingCellModel(title: "Hobby")
            { [weak self] in
                self?.Hobby()
            }
        ]
        let section3 = [
            SettingCellModel(title: "Gathers")
            { [weak self] in
                self?.Gathers()
            }
        ]
        let section4 = [
            SettingCellModel(title: "Gather Edit")
            { [weak self] in
                self?.GatherEdit()
            }
        ]
        let section5 = [
            SettingCellModel(title: "Premium")
            { [weak self] in
                self?.Premium()
            }
        ]
        let section6 = [
            SettingCellModel(title: "Suggestions")
            { [weak self] in
                self?.Suggestions()
            }
        ]
        let section7 = [
            SettingCellModel(title: "BlockList")
            { [weak self] in
                self?.BlockList()
            }
        ]
        let section8 = [
            SettingCellModel(title: "Report A Bug")
            { [weak self] in
                self?.ReportABug()
            }
        ]
        let section9 = [
            SettingCellModel(title: "Personal Links")
            { [weak self] in
                self?.PersonalLinks()
            }
        ]
        let section10 = [
            SettingCellModel(title: "Instructions")
            { [weak self] in
//                self?.Manage()
            }
        ]
        let section11 = [
            SettingCellModel(title: "Videos")
            { [weak self] in
                self?.Videos()
            }
        ]
        data.append(section)
        data.append(section3)
        data.append(section4)
        data.append(section1)
        data.append(section5)
        data.append(section6)
        data.append(section11)
        data.append(section7)
        data.append(section8)
        data.append(section9)
        data.append(section10)
        data.append(section2)
        
    }
    
    func Manage()
    {
        let popupVC = ManageUser()
        
        popupVC.modalPresentationStyle = .formSheet
        popupVC.modalTransitionStyle = .crossDissolve
        
        present(popupVC, animated: true, completion: nil)

    }
    
    func PersonalLinks()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "PersonalLinks", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PersonalLinks") as! PersonalLinks
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func Premium()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Premium", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Premium") as! Premium
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func BlockList()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "BlockList", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "BlockList") as! BlockList
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func Videos()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "PersonalVideos", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PersonalVideos") as! PersonalVideos
        newViewController.videoUserID = FirebaseAuth.Auth.auth().currentUser!.uid
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func ReportABug()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ReportABug", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ReportABug") as! ReportABug
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func Suggestions()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Suggestions", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Suggestions") as! Suggestions
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func Hobby()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "HobbyPicker", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HobbyPicker") as! HobbyPicker
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func Gathers()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Gathers", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Gathers") as! Gathers
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func GatherEdit()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "GatherEdit", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "GatherEdit") as! GatherEdit
        self.present(newViewController, animated: true)
    }
    
    private func didTapLogOut()
    {
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: {_ in
            Authentication.shared.logOut(completion: {success in
                DispatchQueue.main.async {
                    if success{
                        
                        self.dismiss(animated: true, completion: nil)
                        let storyboard = UIStoryboard(name: "Login", bundle: nil)
                        let secondViewController = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
                        self.navigationController?.pushViewController(secondViewController, animated: true)
                    }else{
                        fatalError("Could Not Log User Out")
                    }
                }
            })
        }))
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
    }
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource
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

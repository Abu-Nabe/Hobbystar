//
//  CountryPicker.swift
//  Zinging
//
//  Created by Abu Nabe on 1/2/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CountryPicker: UIViewController
{
    let countries = ["Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bhutan", "Bolivia", "Bosnia and Herzegovinia", "Botswana", "Brazil", "Brunei", "Bulgaria", "Burkina Faso", "Cabo Verde", "Cambodia", "Cameroon", "Canada", "Central African Republic", "Chad", "Chile", "China", "Colombia", "Comoros", "Congo", "Cote D'Ivoire", "Cyprus", "CzechRepublic", "Democratic Republic Of Congo", "Denmark", "Djibouti", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Eswatini", "Ethiopia", "Fiji", "Finland", "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Guatemala", "Guinea", "Guinea Bissau", "Guyana", "Haiti", "Honduras", "HongKong", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Mauritania", "Mexico", "Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "New Zealand", "Niger", "Nigeria", "North Korea", "North Macedonia", "Norway", "Oman", "Pakistan", "Palau", "Palestine", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Qatar", "Romania", "Russia", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Korea", "South Sudan", "Spain", "Sri Lanka", "St Vincent Grenadines", "Sudan", "Suriname", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzia", "Thailand", "Timor Leste", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "Yemen", "Zambia", "Zimbabwe"]
    
    var pickerView = UIPickerView()
    
    var countryText = UITextView()
    
    private let Button: UIButton = {
        let LoginButton = UIButton()
        LoginButton.backgroundColor = .systemGreen
        LoginButton.setTitleColor(.white, for: .normal)
        LoginButton.layer.cornerRadius = 24;
        LoginButton.setTitle("Done", for: .normal)
        
        return LoginButton
    }()
    
    
    private let imageview: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = UIView.ContentMode.scaleAspectFit
        
        return imageview
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pickerView)
        view.addSubview(Button)
        view.addSubview(imageview)
        
        
        pickerView.delegate = self as UIPickerViewDelegate
        pickerView.dataSource = self as UIPickerViewDataSource
        pickerView.center = self.view.center
        
        imageview.anchor(bottom: pickerView.topAnchor, width: 100, height: 70)
        imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        Button.anchor(top: pickerView.bottomAnchor, paddingTop: 30, width: 200, height: 40)
        
        Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Button.addTarget(self, action: #selector(ChangeCountry), for: .touchUpInside)
    }
    @objc func ChangeCountry()
    {
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let country = countryText.text
        if country == ""
        {
            self.dismiss(animated: true, completion: nil)
        }else if country == "Afghanistan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Afghanistan"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Albania"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Albania"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else if country == "Algeria"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Algeria"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Andorra"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Andorra"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Angola"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Angola"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }

        else if country == "Antigua and Barbuda"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Antigua and Barbuda"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Argentina"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Argentina"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Armenia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Armenia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Australia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Australia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Austria"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Austria"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Azerbaijan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Azerbaijan"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Bahamas"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Bahamas"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Bahrain"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Bahrain"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Bangladesh"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Bangladesh"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Barbados"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Barbados"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Belarus"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Belarus"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else if country == "Belgium"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Belgium"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else if country == "Belize"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Belize"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else if country == "Benin"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Benin"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else if country == "Belarus"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Belarus"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else if country == "Bhutan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Bhutan"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else if country == "Bolivia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Bolivia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else if country == "Bosnia and Herzegovinia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Bosnia and Herzegovinia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else if country == "Botswana"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Botswana"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else if country == "Brazil"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Brazil"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else if country == "Brunei"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Brunei"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else if country == "Bulgaria"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Bulgaria"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Burkina Faso"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Burkina faso"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else if country == "Cabo Verde"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Cabo Verde"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Cambodia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Cambodia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Cameroon"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Cameroon"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Canada"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Canada"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Central African Republic"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Central African Republic"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Chad"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Chad"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Chile"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Chile"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "China"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["China"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Colombia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Colombia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Comoros"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Comoros"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Congo"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Congo"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Cote D'Ivoire"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Cote D'Ivoire"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Cyprus"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Cyprus"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "CzechRepublic"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["CzechRepublic"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Democratic Republic of the Congo"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Democratic Republic of the Congo"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Denmark"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Denmark"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Djibouti"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Djibouti"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Dominica"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Dominica"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Dominican Republic"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Dominican Republic"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Ecuador"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Ecuador"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Egypt"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Egypt"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "El Salvador"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["El Salvador"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Equatorial Guinea"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Equatorial Guinea"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Eritrea"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Eritrea"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Estonia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Estonia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Eswatini"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Eswatini"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Ethiopia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Ethiopia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Fiji"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Fiji"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Finland"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Finland"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "France"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["France"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Gabon"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Gabon"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Gambia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Gambia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Georgia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Georgia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Germany"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Germany"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Ghana"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Ghana"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Greece"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Greece"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Guatemala"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Guatemala"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Guinea"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Guinea"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Guinea Bissau"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Guinea Bissau "] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Guyana"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Guyana"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Haiti"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Haiti"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Honduras"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Honduras"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Hongkong"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Hongkong"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Hungary"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Hungary"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Iceland"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Iceland"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "India"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["India"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Indonesia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Indonesia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Iran"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Iran"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Iraq"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Iraq"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Ireland"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Ireland"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Italy"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Italy"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Jamaican"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Jamaican"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Japan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Japan"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Jordan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Jordan"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Kazakhstan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Kazakhstan"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Kyrgyzstan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Kyrgyzstan"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Laos"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Laos"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Latvia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Latvia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Latvia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Latvia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Lebanon"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Lebanon"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Lesotho"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Lesotho"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Liberia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Liberia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Libya"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Libya"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Liechtenstein"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Liechtenstein"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Lithuania"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Lithuania"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Luxembourg"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Luxembourg"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Madagascar"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Madagascar"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Malawi"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Malawi"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Malaysia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Malaysia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Maldives"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Maldives"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Mali"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Mali"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Malta"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Malta"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Marshall Islands"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Marshall Islands"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Mauritania"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Mauritania"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Mauritius"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Mauritius"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Mexico"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Mexico"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Micronesia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Micronesia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Moldova"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Moldova"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Monaco"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Monaco"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Mongolia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Mongolia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Montenegro"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Montenegro"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Morocco"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Morocco"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Mozambique"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Mozambique"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Namibia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Namibia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Nauru"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Nauru"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Nepal"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Nepal"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Netherlands"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Netherlands"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "New Zealand"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["New Zealand"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Nicaragua"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Nicaragua"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Niger"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Niger"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Nigeria"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Nigeria"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "North Korea"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["North Korea"] as! String
                ref.child("Users").child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "North Macedonia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["North Macedonia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Norway"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Norway"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Oman"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Oman"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Pakistan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Pakistan"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Palau"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Palau"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Panama"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Panama"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Papua New Guinea"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Papua New Guinea"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Paraguay"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Paraguay"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Peru"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Peru"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Philippines"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["philippines"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Poland"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Poland"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Portugal"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Portugal"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Qatar"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Qatar"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Romania"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Romania"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Russia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Russia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Saint Kitts and Nevis"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Saint Kitts and Nevis"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Saint Lucia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Saint Lucia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Samoa"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Samoa"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "San Marino"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["San Marino"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Sao Tome and Principe"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Sao Tome and Principe"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Saudi Arabia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Saudi Arabia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Serbia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Serbia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Seychelles"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Seychelles"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Sierra Leone"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Sierra Leone"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Singapore"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Singapore"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Slovakia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Slovakia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Slovenia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Slovenia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Solomon Islands"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Solomon Islands"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Somalia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Somalia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "South Africa"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["South Africa"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "South Korea"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["South Korea"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "South Sudan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["South Sudan"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Spain"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Spain"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Sri Lanka"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Sri Lanka"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "St Vincent Grenadines"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["St Vincent Grenadines"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Sudan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Sudan"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Suriname"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Suriname"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Sweden"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Sweden"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Switzerland"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Switzerland"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Syria"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Syria"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Taiwan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Taiwan"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Tajikistan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Tajikistan"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Tanzania"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Tanzania"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Thailand"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Thailand"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Timor Leste"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Timor Leste"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Togo"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Togo"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Tonga"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Tonga"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Trinidad and Tobago"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Trinidad and Tobago"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Tunisia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Tunisia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Turkey"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Turkey"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Turkmenistan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Turkmenistan"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Tuvalu"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Tuvalu"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Uganda"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Uganda"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Ukraine"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Ukraine"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "United Arab Emirates"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["United Arab Emirates"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "United Kingdom"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["United Kingdom"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "United States"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["United States"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Uruguay"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Uruguay"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Uzbekistan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Uzbekistan"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Vanuatu"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Vanuatu"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Vatican City"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Vatican City"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Venezuela"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Venezuela"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Vietnam"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Vietnam"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Yemen"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Yemen"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Zambia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Zambia"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if country == "Zimbabwe"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let afghanistan = data?["Zimbabwe"] as! String
                ref.child("Users").child(Auth).child("hobby").setValue(afghanistan)
                self.dismiss(animated: true, completion: nil)
            }
        }

    }
}

extension CountryPicker: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row < countries.count else {
                return
            }

        let countrySelected = countries[row]
        
        countryText.text = countrySelected
        
        ChangeCountryImage(String: countrySelected)
    }
    func ChangeCountryImage(String: String)
    {
        let country = String
        let ref = Database.database().reference()
        if country == "Afghanistan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Afghanistan"] as! String
                let url = URL(string: image )
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Albania"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Albania"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Algeria"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Algeria"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Andorra"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Andorra"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Antigua and Barbuda"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Antigua and Barbuda"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Argentina"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Argentina"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Armenia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Armenia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Australia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Australia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Azerbaijan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Azerbaijan"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Bahamas"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Bahamas"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Bahrain"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Bahrain"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Bangladesh"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Bangladesh"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Barbados"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Barbados"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Belarus"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Belarus"] as! String
                let url = URL(string: image )
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
            
        }
        else if country == "Belgium"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Belgium"] as! String
                let url = URL(string: image )
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Belize"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Belize"] as! String
                let url = URL(string: image )
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Benin"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Benin"] as! String
                let url = URL(string: image )
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Belarus"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Belarus"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Bhutan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Bhutan"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Bolivia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Bolivia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Bosnia and Herzegovinia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Bosnia and Herzegovinia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Botswana"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Botswana"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Brazil"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Brazil"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Brunei"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Brunei"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Bulgaria"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Bulgaria"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Burkina Faso"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Burkina Faso"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Cabo Verde"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Cabo Verde"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Cambodia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Cambodia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Cameroon"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Cameroon"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }        }
        else if country == "Canada"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Canada"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Central African Republic"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Central African Republic"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Chad"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Chad"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Chile"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Chile"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "China"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["China"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Colombia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Colombia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Comoros"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Comoros"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Congo"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Congo"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Cote D'Ivoire"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Cote D'Ivoire"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Cyprus"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Cyprus"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "CzechRepublic"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["CzechRepublic"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Democratic Republic of the Congo"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Democratic Republic of the Congo"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Denmark"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Denmark"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Djibouti"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Djibouti"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Dominica"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Dominica"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Dominican Republic"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Demonican Republic"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Ecuador"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Ecuador"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Egypt"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Egypt"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "El Salvador"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["El Salvador"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Equatorial Guinea"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Equatorial Guinea"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Eritrea"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Eritrea"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Estonia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Estonia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Eswatini"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Eswatini"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Ethiopia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Ethiopia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Fiji"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Fiji"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Finland"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Finland"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "France"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["France"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Gabon"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Gabon"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Gambia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Gambia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Georgia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Georgia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Germany"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Germany"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Ghana"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Ghana"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Greece"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Greece"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Guatemala"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Guatemala"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Guinea"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Guinea"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }        }
        else if country == "Guinea Bissau"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Guinea Bissau"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Guyana"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Guyana"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Haiti"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Haiti"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Honduras"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Honduras"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Hongkong"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Hongkong"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Hungary"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Hungary"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Iceland"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Iceland"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "India"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["India"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Indonesia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Indonesia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Iran"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Iran"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Iraq"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Iraq"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Ireland"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Ireland"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Italy"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Italy"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Jamaican"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Jamaican"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Japan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Japan"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Jordan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Jordan"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Kazakhstan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Kazakhstan"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Kyrgyzstan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Kyrgyzstan"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Laos"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Laos"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Latvia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Latvia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Latvia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Latvia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Lebanon"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Lebanon"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Lesotho"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Lesotho"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Liberia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Liberia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Libya"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Libya"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Liechtenstein"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Liechtenstein"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Lithuania"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Lithuania"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Luxembourg"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Luxembourg"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Madagascar"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Madagascar"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Malawi"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Malawi"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Malaysia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Malaysia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Maldives"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Maldives"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Mali"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Mali"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Malta"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Malta"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Marshall Islands"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Marshall Islands"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Mauritania"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Mauritania"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Mauritius"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Mauritius"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Mexico"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Mexico"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }        }
        else if country == "Micronesia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Micronesia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Moldova"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Moldova"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Monaco"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Monaco"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Mongolia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Mongolia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Montenegro"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Montenegro"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Morocco"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Morocco"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Mozambique"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Mozambique"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Namibia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Namibia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Nauru"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Nauru"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Nepal"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Nepal"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Netherlands"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Netherlands"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }        }
        else if country == "New Zealand"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["New Zealand"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Nicaragua"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Nicaragua"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Niger"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Niger"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Nigeria"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Nigeria"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "North Korea"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["North Korea"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "North Macedonia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["North Macedonia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Norway"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Norway"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Oman"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Oman"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Pakistan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Pakistan"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Palau"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Palau"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Panama"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Panama"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Papua New Guinea"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Papua New Guinea"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Paraguay"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Paraguay"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Peru"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Peru"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Philippines"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Philippines"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Poland"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Poland"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Portugal"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Portugal"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Qatar"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Qatar"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Romania"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Romania"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Russia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Russia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Saint Kitts and Nevis"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Saint Kitts and Nevis"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Saint Lucia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Saint Lucia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Samoa"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Samoa"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "San Marino"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["San Marino"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Sao Tome and Principe"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Sao Tome and Principe"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Saudi Arabia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Saudi Arabia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Serbia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Serbia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Seychelles"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Seychelles"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Sierra Leone"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Sierra Leone"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Singapore"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Singapore"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Slovakia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Slovakia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Slovenia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Slovenia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Solomon Islands"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Solomon Islands"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Somalia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Somalia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "South Africa"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["South Africa"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "South Korea"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["South Korea"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "South Sudan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["South Sudan"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Spain"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Spain"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Sri Lanka"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Sri Lanka"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "St Vincent Grenadines"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["St Vincent Grenadines"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Sudan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Sudan"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Suriname"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Suriname"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Sweden"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Sweden"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Switzerland"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Switzerland"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Syria"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Syria"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Taiwan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Taiwan"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Tajikistan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Tajikistan"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Tanzania"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Tanzania"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Thailand"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Thailand"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Timor Leste"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Timor Leste"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Togo"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Togo"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Tonga"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Tonga"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Trinidad and Tobago"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Trinidad and Tobago"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Tunisia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Tunisia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Turkey"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Turkey"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Turkmenistan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Turkmenistan"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Tuvalu"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Tuvalu"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Uganda"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Uganda"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Ukraine"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Ukraine"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "United Arab Emirates"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["United Arab Emirates"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "United Kingdom"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["United Kingdom"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "United States"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["United States"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Uruguay"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Uruguay"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Uzbekistan"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Uzbekistan"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Vanuatu"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Vanuatu"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Vatican City"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Vatican City"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }        }
        else if country == "Venezuela"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Venezuela"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Vietnam"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Vietnam"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Yemen"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Yemen"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Zambia"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Zambia"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
        else if country == "Zimbabwe"{
            ref.child("Countries").observe(.value) { (snapshot) in
                let data = snapshot.value as? [String: AnyObject]
                
                let image = data?["Zimbabwe"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let countryPicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                           self.imageview.image = countryPicture // Set the profile picture
                                       }
                                   } else {
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
            }
        }
    }

}

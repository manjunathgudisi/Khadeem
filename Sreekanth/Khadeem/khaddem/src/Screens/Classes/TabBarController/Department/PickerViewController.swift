//
//  PickerViewController.swift
//  khaddem
//
//  Created by I0006 on 20/08/19.
//  Copyright © 2019 I0006. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var donebutton: UIButton!
    @IBOutlet weak var cancelbutton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationitem: UINavigationItem!
    
    //MARK:- GlobalVariables
    var rowString = String()
    var imagesArray = ["moc_icon", "mof_icon", "mofa_icon", "moh_icon", "mohl_icon"]
    var offices = ["Ministry of Culture & Innovation", "Ministry of Finance", "Ministry of Foreign Affairs", "Ministry of Housing", "Ministry of Health"]
    var departmentViewController : DepartmentViewController? = nil
    var homeViewController : HomeViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.dataSource = self
        pickerView.delegate = self
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Lato-Black", size: 17)!]

        navigationitem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Lato-Black", size: 15)!], for: .normal)
        navigationitem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Lato-Black", size: 15)!], for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        Utilities.instance().isSelectedDoneButton = true
        if Utilities.instance().isSelectedDoneButton == true {
            let row = pickerView.selectedRow(inComponent: 0);
            print("pickervieww value: \(row)")
            self.homeViewController?.departmentViewController?.nameLabel.text = offices[row]
            self.homeViewController?.departmentViewController?.imageHolder.image = UIImage(named: imagesArray[row])
            self.homeViewController?.pickerViewControllerToUIView.isHidden = true
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.homeViewController?.pickerViewControllerToUIView.isHidden = true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return offices.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return offices[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = offices[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [.font:UIFont(name: "Lato-Black", size: 15.0)!, .foregroundColor: UIColor.black])
        return myTitle
    }
}

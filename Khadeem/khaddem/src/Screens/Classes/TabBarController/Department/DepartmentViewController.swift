//
//  DepartmentViewController.swift
//  khaddem
//
//  Created by I0006 on 13/08/19.
//  Copyright © 2019 I0006. All rights reserved.
//

import UIKit


class DepartmentViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var imageHolder: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK:- GlobalVariables
    var isPopUpViewSelecetd : Bool?
    var popViewControllerUIView : UIView? = nil
    private var gradientView : UIView? = nil
    var newImage: UIImage!
    var nameString: String!
    var selcetdPcikerViewRowString: String!
    var namesArray = ["High" , "Medium", "Low"]
    var defaultImagesArray = ["high-priority-default", "medium-priority-default", "low-priority-default"]
    var selectedImagesArray = ["icons8-high-priority", "icons8-medium-priority", "icons8-low-priority"]
    var homeViewController : HomeViewController? = nil
    var pickerViewController : PickerViewController? = nil
    
    @IBOutlet weak var complimentButton: UIButton!
    @IBOutlet weak var complaintButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        
        if Utilities.instance().isSelectedDoneButton == true {
            
        }
        
        if Utilities.instance().isPopUpViewButtonSelected == true {
            
            self.homeViewController?.hideUIView.isHidden = false
            self.homeViewController?.pickerViewControllerToUIView.isHidden = false
        }else {
            
            self.homeViewController?.hideUIView.isHidden = true
            self.homeViewController?.pickerViewControllerToUIView.isHidden = true
        }
    }

    //MARK:- IBActions
    @IBAction func proceedButtonTappped(_ sender: Any) {
        
        if nameString == "Video Message" {
            let vc = UIStoryboard(name: "FaceTracking", bundle: Bundle.main).instantiateInitialViewController() as? FaceDetectionViewController
            vc?.detectFaces = false
            homeViewController?.navigationController!.pushViewController(vc!, animated: true)
        } else if nameString == "Avatar Message" {
            let vc = UIStoryboard(name: "FaceTracking", bundle: Bundle.main).instantiateInitialViewController() as? FaceDetectionViewController
            vc?.detectFaces = true
            homeViewController?.navigationController!.pushViewController(vc!, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Utilities", bundle: Bundle.main)
            let vc = storyboard.instantiateInitialViewController() as? UtilitiesViewController
            homeViewController?.navigationController!.pushViewController(vc!, animated: true)
        }
    }
    
    @IBAction func dropDownButtonTappped(_ sender: UIButton) {

        Utilities.instance().isPopUpViewButtonSelected = true
        if Utilities.instance().isPopUpViewButtonSelected == true {
            
            self.homeViewController?.hideUIView.isHidden = false
            self.homeViewController?.pickerViewControllerToUIView.isHidden = false
        }else {
            
            self.homeViewController?.hideUIView.isHidden = true
            self.homeViewController?.hideUIView.isHidden = true
        }
    }
    
    @IBAction func complimentButtonTapped(_ sender: Any) {
        complimentButton.isSelected = true
        complaintButton.isSelected = false
    }
    
    @IBAction func complaintButtonTapped(_ sender: Any) {
        complimentButton.isSelected = false
        complaintButton.isSelected = true
    }
}

//MARK:- UICollectionView
extension DepartmentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90.0, height: 90.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return namesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DepartmentCollectionViewCell", for: indexPath as IndexPath) as! DepartmentCollectionViewCell
        myCell.button.setBackgroundImage(UIImage(named: defaultImagesArray[indexPath.row]), for: .normal)
        myCell.button.setBackgroundImage(UIImage(named: selectedImagesArray[indexPath.row]), for: .selected)
        myCell.namesLabel.text = namesArray[indexPath.row]
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DepartmentCollectionViewCell
        cell.button.isSelected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DepartmentCollectionViewCell
        cell.button.isSelected = false
    }
}

extension DepartmentViewController {
    
    func roundImageView(image : UIImageView) {
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.clear.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
}


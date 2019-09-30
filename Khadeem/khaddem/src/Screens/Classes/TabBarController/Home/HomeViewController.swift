//
//  HomeViewController.swift
//  khaddem
//
//  Created by I0006 on 13/08/19.
//  Copyright © 2019 I0006. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    private static var homeViewController : HomeViewController? = nil
    
    //MARK:- IBOutlets
    @IBOutlet weak var gradientUIView: UIView!
    @IBOutlet weak var collectionView: UIView!
    @IBOutlet weak var hideUIView: UIView!
    @IBOutlet weak var showViewControllerContainerUIvVew: UIView!
    @IBOutlet weak var pickerViewControllerToUIView: UIView!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var voiceLabel: UILabel!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var avatarLabel: UILabel!

    
    //MARK:- GlobalVariables
    var departmentViewController: DepartmentViewController? = nil
    var pickerViewController: PickerViewController? = nil
    private var gradientView : UIView? = nil
    var isPopUpViewSelecetd = false
    var newImage: UIImage!
    var nameString: String!
    var imagesArray = ["moc_icon", "mof_icon", "mofa_icon", "moh_icon", "mohl_icon"]
    var namesArray = ["Ministry of Culture & Innovation", "Ministry of Finance", "Ministry of Foreign Affairs", "Ministry of Housing", "Ministry of Health"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hideUIView.isHidden = true
        showPickerViewController()
        pickerViewControllerToUIView.addShadow(with: .black)
    }
    
    @IBAction func textMessageButtonTappped(_ sender: UIButton) {

        newImage = nil
        nameString = ""
        newImage = UIImage(named: "icons8-page")
        nameString = "Text Message"
        showDeapartmentViewController()
        self.hideUIView.isHidden = false
        self.pickerViewControllerToUIView.isHidden = true
    }
    
    @IBAction func audioMessageButtonTappped(_ sender: Any) {
        
        newImage = nil
        nameString = ""
        newImage = UIImage(named: "icons8-microphone")
        nameString = "Audio Message"
        showDeapartmentViewController()
        self.hideUIView.isHidden = false
        self.pickerViewControllerToUIView.isHidden = true
    }
    
    @IBAction func videoMessageButtonTappped(_ sender: Any) {
        
        newImage = nil
        nameString = ""
        newImage = UIImage(named: "icons8-video-call")
        nameString = "Video Message"
        showDeapartmentViewController()
        self.hideUIView.isHidden = false
        self.pickerViewControllerToUIView.isHidden = true
    }
    
    @IBAction func vatarMessageButtonTappped(_ sender: Any) {
        
        newImage = nil
        nameString = ""
        newImage = UIImage(named: "icons8-user")
        nameString = "Avatar Message"
        showDeapartmentViewController()
        self.hideUIView.isHidden = false
        self.pickerViewControllerToUIView.isHidden = true
    }
    
    @IBAction func tapGestureButtonTapped(_ sender: Any) {
        hideUIView.isHidden = true
        pickerViewControllerToUIView.isHidden = true
    }
}

//MARK:- Functions
extension HomeViewController {
    
    func showDeapartmentViewController() {

        hideUIView.isHidden = false
        if Utilities.instance().isPopUpViewButtonSelected == true {
            
            if (self.departmentViewController == nil) {
                let vc = UIStoryboard(name: "Department", bundle: nil).instantiateViewController(withIdentifier: "DepartmentViewController") as! DepartmentViewController
                vc.newImage = newImage
                vc.nameString = nameString
                vc.homeViewController = self
                self.departmentViewController = vc
            }
            departmentViewController?.nameString = nameString
            var frame = self.showViewControllerContainerUIvVew.frame
            frame.origin.x = 0
            frame.origin.y = 0
            self.showViewControllerContainerUIvVew.clipsToBounds = true
            departmentViewController?.view.frame = frame
            self.showViewControllerContainerUIvVew.addSubview(departmentViewController!.view)
            
        } else {
            
            if (self.departmentViewController == nil) {
                let vc = UIStoryboard(name: "Department", bundle: nil).instantiateViewController(withIdentifier: "DepartmentViewController") as! DepartmentViewController
                vc.newImage = newImage
                vc.nameString = nameString
                vc.homeViewController = self
                self.departmentViewController = vc
            }
            departmentViewController?.nameString = nameString
            var frame = self.showViewControllerContainerUIvVew.frame
            frame.origin.x = 0
            frame.origin.y = 0
            self.showViewControllerContainerUIvVew.clipsToBounds = true
            departmentViewController?.view.frame = frame
            self.showViewControllerContainerUIvVew.addSubview(departmentViewController!.view)
        }
    }
    
    func showPickerViewController() {
        
        if (self.pickerViewController == nil) {
            let vc = UIStoryboard(name: "Department", bundle: nil).instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
            vc.homeViewController = self
            Utilities.instance().isSelectedDoneButton = true
            self.pickerViewController = vc
        }
        var frame = self.pickerViewControllerToUIView.frame
        frame.origin.x = 0
        frame.origin.y = 0
        pickerViewController?.view.frame = frame
        self.pickerViewControllerToUIView.addSubview(pickerViewController!.view)
    }
}

//MARK:- UICollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 100.0, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath as IndexPath) as! HomeCollectionViewCell
        let myCellImage = UIImage(named: imagesArray[indexPath.row])
        myCell.logoImageView.image = myCellImage
        myCell.nameLabel.text = namesArray[indexPath.row]
        //nameString = namesArray[indexPath.row]
        //newImage = myCell.imagesImageView.image
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        hideUIView.isHidden = false
        if let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell {
            
        }
    }
}

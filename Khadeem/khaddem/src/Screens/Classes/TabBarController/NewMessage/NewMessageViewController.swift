//
//  NewMessageViewController.swift
//  khaddem
//
//  Created by I0006 on 13/08/19.
//  Copyright © 2019 I0006. All rights reserved.
//

import UIKit

class NewMessageViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var gradientUIView: UIView!
    @IBOutlet weak var imageHolder: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var complimentIamgeView: UIImageView!
    @IBOutlet weak var complaintsIamgeView: UIImageView!
    
    //MARK:- GlobalVariables
    private var gradientView : UIView? = nil
    var newImage: UIImage!
    var nameString: String!
    var namesArray = ["High" , "Medium", "Low"]
    var imagesArray = ["icons8-high-priority", "icons8-medium-priority", "icons8-low-priority"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:- IBActions
    @IBAction func proceedButtonTappped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Utilities", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "UtilitiesViewController") as? UtilitiesViewController
        vc!.newImage = newImage
        vc!.nameString = nameString
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

//MARK:- UICollectionView
extension NewMessageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 90.0, height: 90.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return namesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewMessageCollectionViewCell", for: indexPath as IndexPath) as! NewMessageCollectionViewCell
        
        let myCellImage = UIImage(named: imagesArray[indexPath.row])
        roundImageView(image: myCell.imagesImageView)
        myCell.imagesImageView.image = myCellImage
        myCell.namesLabel.text = namesArray[indexPath.row]
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DepartmentCollectionViewCell {
           
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DepartmentCollectionViewCell {
            
        }
    }
}

extension NewMessageViewController {
    
    func roundImageView(image : UIImageView) {
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.clear.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
}





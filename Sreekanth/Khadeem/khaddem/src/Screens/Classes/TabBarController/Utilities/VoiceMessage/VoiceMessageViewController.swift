//
//  VoiceMessageViewController.swift
//  khaddem
//
//  Created by I0006 on 14/08/19.
//  Copyright © 2019 I0006. All rights reserved.
//

import UIKit

class VoiceMessageViewController: UIViewController {
    
    public var homeViewController : UIViewController? = nil

    //MARK:- IBOutlest
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    
    //MARK:- GolbalVariables
    var newImage: UIImage!
    var nameString: String!
    var imagesArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        textView.resignFirstResponder()
        let alert = UIAlertController(title: "Voice message sent", message: "Your voice message has been sent successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.homeViewController?.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK:- UICollectionView
extension VoiceMessageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 90.0, height: 56.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VoiceMessageCollectionViewCell", for: indexPath as IndexPath) as! VoiceMessageCollectionViewCell

        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! VoiceMessageCollectionViewCell
        if indexPath.row == 0 {
            nameString = ""
            newImage = cell.imagesImageView.image
        }
    }
}

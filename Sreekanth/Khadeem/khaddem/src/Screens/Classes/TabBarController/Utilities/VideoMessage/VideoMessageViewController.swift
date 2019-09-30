//
//  VideoMessageViewController.swift
//  khaddem
//
//  Created by I0006 on 14/08/19.
//  Copyright © 2019 I0006. All rights reserved.
//

import UIKit

class VideoMessageViewController: UIViewController {

    public var homeViewController : UIViewController? = nil
    
    //MARK:- IBOutlest
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    
    //MARK:- GolbalVariables
    var newImage: UIImage!
    var nameString: String!
    var imagesArray: [String] = [
        "Appeal3.png", "Appeal3.png", "Appeal3.png", "Appeal3.png", "Appeal3.png", "Appeal3.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        textView.resignFirstResponder()
        let alert = UIAlertController(title: "Video message sent", message: "Your video message has been sent successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.homeViewController?.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK:- UICollectionView
extension VideoMessageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 90.0, height: 56.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VoiceMessageCollectionViewCell", for: indexPath as IndexPath) as! VoiceMessageCollectionViewCell
        
        let myCellImage = UIImage(named: imagesArray[indexPath.row])
        myCell.imagesImageView.image = myCellImage
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


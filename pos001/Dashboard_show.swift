//
//  Dashboard_show.swift
//  pos001
//
//  Created by 성재 on 2021/08/13.
//

import UIKit

class Dashboard_show: UIViewController {

    @IBOutlet weak var collectionview_all: UICollectionView!
    
    var allailist : [CardItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionview_all.delegate = self
        collectionview_all.dataSource = self
        // Do any additional setup after loading the view.
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

extension Dashboard_show: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allailist!.count
    }
    
    // CollectionView Cell의 Object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allGridCell", for: indexPath) as! allGridCell
                
//        cell.image.image = UIImage(named: arrimage[indexPath.row]) ?? UIImage()
        let url1 = URL(string: allailist![indexPath.row].get_image1())
        cell.allimgup.kf.setImage(with: url1)
        let url2 = URL(string: allailist![indexPath.row].get_image2())
        cell.allimgdown.kf.setImage(with: url2)
        cell.all_descrip.text = allailist![indexPath.row].descrip
        
        return cell
    }
    
    // CollectionView Cell의 Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        let width: CGFloat = collectionView.frame.width / 2 - 1.0
            
        return CGSize(width: width, height: width*2)
    }
        
    // CollectionView Cell의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1.0
    }
        
    // CollectionView Cell의 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1.0
    }
}

class allGridCell: UICollectionViewCell {
    
    @IBOutlet weak var all_descrip: UILabel!
    @IBOutlet weak var allimgup: UIImageView!
    @IBOutlet weak var allimgdown: UIImageView!
}

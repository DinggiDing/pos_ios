//
//  ViewController.swift
//  pos001
//
//  Created by 성재 on 2021/07/06.
//

import UIKit
import Kingfisher

class ViewController: UIViewController, UIGestureRecognizerDelegate {

   // @IBOutlet var stackview: UIStackView!
    @IBOutlet var lblMain: UILabel!
    @IBOutlet weak var collectionview: UICollectionView!
    var items : [SQLiteItem] = []
    var sqlite = SQLite()
    private var refreshControl = UIRefreshControl()
    private var MainTextInt: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.tabBarController?.tabBar.isHidden = false
        items = []
        lblMain.text = "UP"
        MainTextInt = 0
        items = sqlite.fetchToDo_UP()
       
        collectionview.reloadData()
        print("\n appear")
    }
    
    override func prepare (for seque: UIStoryboardSegue, sender: Any?) {        // Detail View Controller한테 data를 준다.
        if seque.identifier == "main_detail" {
            if let indexPaths = collectionview.indexPathsForSelectedItems {
                let destinationController = seque.destination as! Main_detail
                destinationController.sqlitedetail = items[indexPaths[0].row]
                //collectionview.deselectItem(at: indexPaths, animated: false)
            }
        }
    }
    
    // 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       // self.view.backgroundColor = UIColor(red: 0, green: 51/256, blue: 106/256, alpha: 1)
        //collectionview.backgroundColor = UIColor(red: 0, green: 51/256, blue: 106/256, alpha: 1)
        lblMain.text = "UP"
        MainTextInt = 0
        items = sqlite.fetchToDo_UP()
        print("viewDidLoad")
        print(items.first?.color)
        collectionview.reloadData()
        
        setupLongGestureRecognizerOnCollection()
        
        collectionview.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        if self.MainTextInt == 0 {
            self.items = self.sqlite.fetchToDo_UP()
        } else {
            self.items = self.sqlite.fetchToDo_DOWN()
        }
        self.collectionview.reloadData()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (refreshControl.isRefreshing) {
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func changeMain(_ sender: UIButton) {
        if MainTextInt==0 {
            lblMain.text = "DOWN"
            items = sqlite.fetchToDo_DOWN()
            collectionview.reloadData()
            MainTextInt = 1
        } else {
            lblMain.text = "UP"
            items = sqlite.fetchToDo_UP()
            collectionview.reloadData()
            MainTextInt = 0
        }
    }
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionview?.addGestureRecognizer(longPressedGesture)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state != .began {
            return
        }
        let p = gesture.location(in: collectionview)
        if let indexPath = collectionview.indexPathForItem(at: p) {
            print("Long Press at item: \(indexPath.row)")
            let alert = UIAlertController(title: "REMOVE", message: "Are you sure?", preferredStyle: .alert)
            
            let alertDelete = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                print("[SUC] dialog cancel")
            }
            let alertSuccess = UIAlertAction(title: "OK", style: .default) { (action) in
                print("[SUC] dialog success")
                self.sqlite.deleteToDo(id: self.items[indexPath.row].id)
                if self.MainTextInt == 0 {
                    self.items = self.sqlite.fetchToDo_UP()
                } else {
                    self.items = self.sqlite.fetchToDo_DOWN()
                }
                
                self.collectionview.reloadData()
            }
            
            alert.addAction(alertDelete)
            alert.addAction(alertSuccess)
            self.present(alert, animated: true, completion: nil)
        } else {
            print("indexpath error")
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // CollectionView Cell의 Object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridViewCell", for: indexPath) as! GridViewCell
                
//        cell.image.image = UIImage(named: arrimage[indexPath.row]) ?? UIImage()
        let url = URL(string: items[indexPath.row].get_image())
        cell.image.kf.setImage(with: url)

        return cell
    }
    
    // CollectionView Cell의 Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        let width: CGFloat = collectionView.frame.width / 3 - 1.0
            
        return CGSize(width: width, height: width)
    }
        
    // CollectionView Cell의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1.0
    }
        
    // CollectionView Cell의 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1.0
    }
    
    // collectionveiw touch event
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "main_detail", sender: nil)
    }
}

class GridViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
}

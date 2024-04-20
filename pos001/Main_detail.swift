//
//  Main_detail.swift
//  pos001
//
//  Created by 성재 on 2021/07/18.
//

import UIKit
import Kingfisher

class Main_detail: UIViewController {

    @IBOutlet weak var main_detail_image: UIImageView!
    @IBOutlet weak var main_detail_view: UIView!
    @IBOutlet weak var main_detail_txt: UILabel!
    @IBOutlet weak var main_detail_imagematch: UIImageView!
    
    var sqlitedetail: SQLiteItem?
    let arrfeel: [String] = ["#해맑은", "#밝은", "#기본", "#검은", "#연한", "#부드러운", "#칙칙한", "#어두운", "#아주연한", "#연한회","#회","#어두운회","#무채 흰","#무채 연한회","#무채 회","#무채 어두운 회","#무채 검"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        main_detail_view.layer.cornerRadius = 50
        main_detail_view.layer.shadowOpacity = 0.5
        main_detail_view.layer.shadowRadius = 7
        main_detail_txt.text = arrfeel[sqlitedetail?.feel ?? 0]
        let imagestring: String = sqlitedetail?.image ?? ""
        let url = URL(string: imagestring)
        main_detail_image.kf.setImage(with: url)
        let imagecolor: UIColor = UIColor.init(rgb: sqlitedetail?.color ?? 0)
        main_detail_view.backgroundColor = imagecolor
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

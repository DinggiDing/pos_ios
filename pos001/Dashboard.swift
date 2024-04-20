//
//  Dashboard.swift
//  pos001
//
//  Created by 성재 on 2021/07/08.
//

import UIKit
import CoreLocation
import Kingfisher

class Dashboard: UIViewController, CLLocationManagerDelegate {
    private var arr = [[Int]](repeating: Array(repeating: 0, count: 18), count: 18)

    @IBOutlet weak var lbl_descrip: UILabel!
    @IBOutlet weak var lbl_temp: UILabel!
    
    @IBOutlet weak var img_ran_up: UIImageView!
    @IBOutlet weak var img_ran_down: UIImageView!
    
    // main ava
    @IBOutlet weak var img_main: UIImageView!
    @IBOutlet weak var img_main_up: UIImageView!
    @IBOutlet weak var img_main_down: UIImageView!
    
    
    var locationManager: CLLocationManager!
    var loc_lat: Double = 37.57
    var loc_long: Double = 126.98
    
    var weather: Weather?
    var main: Main?
    var name: String?
    
    var items_UP : [SQLiteItem] = []
    var items_DOWN : [SQLiteItem] = []
    var sqlite = SQLite()
    var ailist_a : [CardItem] = []
    var ailist_b : [CardItem] = []
    var ailist_c : [CardItem] = []
    var ailist_random : [CardItem] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Do any additional setup after loading the view.
        
        items_UP = []
        items_DOWN = []
        ailist_a = []
        ailist_b = []
        ailist_c = []
        ailist_random = []
        
        print("-----")
        items_UP = sqlite.fetchToDo_UP()
        items_DOWN = sqlite.fetchToDo_DOWN()
        //CollectionView_Good!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "RecGridViewCell")
        //CollectionView_So!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "RecGridViewCell")
        
        img_ran_up.layer.borderColor = UIColor.orange.cgColor
        img_ran_up.layer.borderWidth = 2
        img_ran_down.layer.borderColor = UIColor.orange.cgColor
        img_ran_down.layer.borderWidth = 2

        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let coor = locationManager.location?.coordinate
        loc_lat = coor?.latitude ?? 37.57
        loc_long = coor?.longitude ?? 126.98

        print("위도 경도 : \(loc_lat), \(loc_long)")
        
        img_ran_up.layer.zPosition = .greatestFiniteMagnitude
        img_ran_down.layer.zPosition = .greatestFiniteMagnitude
        
        img_main.image = UIImage(named: "main.png")
        img_main_up.image = UIImage(named: "mainup.png")
        img_main_down.image = UIImage(named: "maindown.png")
        
        WeatherService().getWeather(lati: Float(loc_lat), longi: Float(loc_long)) { result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    self.weather = weatherResponse.weather.first
                    self.main = weatherResponse.main
                    self.name = weatherResponse.name
                    self.lbl_temp.text = "\(round((weatherResponse.main.temp-273.15)*100)/100)"+"°"
                    self.lbl_descrip.text = "| "+"\(String(describing: weatherResponse.weather.first!.main))"
                }
            case .failure(_ ):
                print("error")
            }
        }
        
        check()
        if items_UP.count != 0 && items_DOWN.count != 0 {
            // 등급 알고리즘
            for a in 0..<items_UP.count {
                for b in 0..<items_DOWN.count {
                    let acolor = UIColor.init(rgb: items_UP[a].get_color())
                    let bcolor = UIColor.init(rgb: items_DOWN[b].get_color())
                    let distinguish = tone_distinguish(acolor: acolor, bcolor: bcolor)
                    
                    // 톤온톤 코디
                    if distinguish==1 {
                        print("톤온톤코디")
                        let grade = tone_on(acolor: acolor, bcolor: bcolor)
                        if grade == 0 {
                            ailist_a.append(CardItem(image1: items_UP[a].get_image(), image2: items_DOWN[b].get_image(), id1: items_UP[a].get_id(), id2: items_DOWN[b].get_id(), color1: items_UP[a].get_color(), color2: items_DOWN[b].get_color(), descrip: "ToneONTone", star: 1))
                        }
                        if grade == 1 {
                            ailist_a.append(CardItem(image1: items_UP[a].get_image(), image2: items_DOWN[b].get_image(), id1: items_UP[a].get_id(), id2: items_DOWN[b].get_id(), color1: items_UP[a].get_color(), color2: items_DOWN[b].get_color(), descrip: "ToneONTone", star: 2))
                        }
                        if grade == 2 {
                            ailist_a.append(CardItem(image1: items_UP[a].get_image(), image2: items_DOWN[b].get_image(), id1: items_UP[a].get_id(), id2: items_DOWN[b].get_id(), color1: items_UP[a].get_color(), color2: items_DOWN[b].get_color(), descrip: "ToneONTone", star: 3))
                        }
                    }
                    
                    // 톤인톤 코디
                    if distinguish==2 {
                        print("톤인톤코디")
                        let m = items_UP[a].get_feel()+1
                        let n = items_DOWN[b].get_feel()+1
                        let grade = bfs(a: m, b: n)
                        //print(grade)
                        if grade == 0 {
                            ailist_a.append(CardItem(image1: items_UP[a].get_image(), image2: items_DOWN[b].get_image(), id1: items_UP[a].get_id(), id2: items_DOWN[b].get_id(), color1: items_UP[a].get_color(), color2: items_DOWN[b].get_color(), descrip: "ToneINTone", star: 1))
                        }
                        if grade == 1 {
                            ailist_a.append(CardItem(image1: items_UP[a].get_image(), image2: items_DOWN[b].get_image(), id1: items_UP[a].get_id(), id2: items_DOWN[b].get_id(), color1: items_UP[a].get_color(), color2: items_DOWN[b].get_color(), descrip: "ToneINTone", star: 2))
                        }
                        if grade == 2 {
                            ailist_a.append(CardItem(image1: items_UP[a].get_image(), image2: items_DOWN[b].get_image(), id1: items_UP[a].get_id(), id2: items_DOWN[b].get_id(), color1: items_UP[a].get_color(), color2: items_DOWN[b].get_color(), descrip: "ToneINTone", star: 3))
                        }
                    }
                }
            }
            
        } else {
            myAlert("RECOMMEND", message: "상하의 사진이 없어요")
        }
        if ailist_a.isEmpty {
            print("존재x")
            let path1 = Bundle.main.path(forResource: "dislike", ofType: "png")
            let url1 = URL(fileURLWithPath: path1!)
            ailist_a.append(CardItem(image1: url1.absoluteString, image2: url1.absoluteString, id1: 1, id2: 1, color1: 0, color2: 0, descrip: "sss", star: 1))
            ailist_a.append(CardItem(image1: url1.absoluteString, image2: url1.absoluteString, id1: 1, id2: 1, color1: 0, color2: 0, descrip: "sss", star: 1))
        }
        print(ailist_a.count)
        
        // 랜덤 추천
        if ailist_a.count != 0 {
            let ran = Int.random(in: 0...ailist_a.count-1)
            ailist_random.append(CardItem(image1: ailist_a[ran].image1, image2: ailist_a[ran].image2, id1: ailist_a[ran].id1, id2: ailist_a[ran].id2, color1: ailist_a[ran].color1, color2: ailist_a[ran].color2, descrip: ailist_a[ran].descrip, star: ailist_a[ran].star))
            let ranurl1: URL = URL(string: ailist_a[ran].image1)!
            img_ran_up.kf.setImage(with: ranurl1)
            let ranurl2: URL = URL(string: ailist_a[ran].image2)!
            img_ran_down.kf.setImage(with: ranurl2)
            print("tint---------")
            img_main_up.image = img_main_up.image?.withRenderingMode(.alwaysTemplate)
            img_main_up.tintColor = UIColor.init(rgb: ailist_random[0].color1)
            img_main_down.image = img_main_down.image?.withRenderingMode(.alwaysTemplate)
            img_main_down.tintColor = UIColor.init(rgb: ailist_random[0].color2)
        } else {
            print("else")
//            img_ran_up.image = UIImage(named: "dislike.png")
//            img_ran_down.image = UIImage(named: "dislike.png")
            
            // 예시
            let ran = 0
            let path1 = Bundle.main.path(forResource: "dislike", ofType: "png")
            let url1 = URL(fileURLWithPath: path1!)
            ailist_random.append(CardItem(image1: url1.absoluteString, image2: url1.absoluteString, id1: 1, id2: 1, color1: 0, color2: 0, descrip: "sss", star: 1))
            img_ran_up.kf.setImage(with: url1)
            img_ran_down.kf.setImage(with: url1)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().tintColor = .orange
        
        view.setGradient(color1: UIColor.init(displayP3Red: 255/255, green: 224/255, blue: 178/255, alpha: 1), color2: UIColor.init(displayP3Red: 225/255, green: 190/255, blue: 231/255, alpha: 1), color3: UIColor.init(displayP3Red: 209/255, green: 196/255, blue: 233/255, alpha: 1))
    }
    
    override func prepare (for seque: UIStoryboardSegue, sender: Any?) {        // Detail View Controller한테 data를 준다.
        if seque.identifier == "dash_detail" {
                
            let vc = seque.destination as? Dashboard_show
            vc?.allailist = self.ailist_a

        }
    }
    
    @IBAction func btnmore(_ sender: UIButton) {
        performSegue(withIdentifier: "dash_detail", sender: nil)
    }
    
        
    func tone_distinguish(acolor: UIColor, bcolor: UIColor) -> Int? {
        var fHue: CGFloat = 0
        var fSatur : CGFloat = 0
        var fBright : CGFloat = 0
        var fAlpha: CGFloat = 0
        var gHue: CGFloat = 0
        var gSatur : CGFloat = 0
        var gBright : CGFloat = 0
        var gAlpha: CGFloat = 0
        var aHue: Float = 0
        var bHue: Float = 0
        if acolor.getHue(&fHue, saturation: &fSatur, brightness: &fBright, alpha: &fAlpha) {
            aHue = Float(fHue*360.0)
        } else {
            aHue = 0
        }
        if bcolor.getHue(&gHue, saturation: &gSatur, brightness: &gBright, alpha: &gAlpha) {
            bHue = Float(gHue*360.0)
        } else {
            bHue = 0
        }
        let minu = (aHue-bHue).magnitude
        if minu < 5 {
            return 1
        } else {
            return 2
        }
        
    }
    
    func tone_on(acolor: UIColor, bcolor: UIColor) -> Int? {
        var fHue: CGFloat = 0
        var fSatur : CGFloat = 0
        var fBright : CGFloat = 0
        var fAlpha: CGFloat = 0
        var gHue: CGFloat = 0
        var gSatur : CGFloat = 0
        var gBright : CGFloat = 0
        var gAlpha: CGFloat = 0
        var aHue: Float = 0
        var bHue: Float = 0
        var aBright: Float = 0
        var bBright: Float = 0
        var grade: Float = 0
        if acolor.getHue(&fHue, saturation: &fSatur, brightness: &fBright, alpha: &fAlpha) {
            aHue = Float(fHue*360.0)
            aBright = Float(fBright*100.0)
        } else {
            aHue = 0
            aBright = 0
        }
        if bcolor.getHue(&gHue, saturation: &gSatur, brightness: &gBright, alpha: &gAlpha) {
            bHue = Float(gHue*360.0)
            bBright = Float(gBright*100.0)
        } else {
            bHue = 0
            bBright = 0
        }
        let minu = (aHue-bHue).magnitude
        if minu < 3 {
            grade = (aBright/20-bBright/20).magnitude
        }
        if 4-grade == -1 {
            grade = 4
        }
        return 4-(Int)(grade)
    }
    
    private func bfs(a: Int, b: Int) -> Int {
        var count = 0
        var nn = a
        
        var q = Queue<Int>()
        q.enqueue(nn)
        q.enqueue(0)
        
        var visited = [Bool](repeating: false, count: 18)
        visited[nn] = true
        
        while(!q.isEmpty && nn != b) {
            nn = q.dequeue()!
            count = q.dequeue()!
            for i in 1...17 {
                if arr[nn][i] == 1 && visited[i] == false {
                    q.enqueue(i)
                    q.enqueue(count+1)
                    visited[nn] = true
                }
            }
        }
        return count
    }
    
    private func check() {
        arr[1][2] = 1
        arr[1][3] = 1
        arr[1][4] = 1
        arr[2][1] = 1
        arr[2][3] = 1
        arr[2][5] = 1
        arr[2][6] = 1
        arr[3][1] = 1
        arr[3][2] = 1
        arr[3][4] = 1
        arr[3][6] = 1
        arr[3][7] = 1
        arr[4][1] = 1
        arr[4][3] = 1
        arr[4][7] = 1
        arr[4][8] = 1
        arr[5][2] = 1
        arr[5][6] = 1
        arr[5][9] = 1
        arr[5][10] = 1
        arr[6][2] = 1
        arr[6][3] = 1
        arr[6][5] = 1
        arr[6][7] = 1
        arr[6][9] = 1
        arr[6][10] = 1
        arr[6][11] = 1
        arr[7][3] = 1
        arr[7][4] = 1
        arr[7][6] = 1
        arr[7][8] = 1
        arr[7][10] = 1
        arr[7][11] = 1
        arr[7][12] = 1
        arr[8][4] = 1
        arr[8][7] = 1
        arr[8][11] = 1
        arr[8][12] = 1
        arr[9][5] = 1
        arr[9][6] = 1
        arr[9][10] = 1
        arr[9][13] = 1
        arr[9][14] = 1
        arr[10][5] = 1
        arr[10][6] = 1
        arr[10][7] = 1
        arr[10][9] = 1
        arr[10][11] = 1
        arr[10][14] = 1
        arr[10][15] = 1
        arr[11][6] = 1
        arr[11][7] = 1
        arr[11][8] = 1
        arr[11][10] = 1
        arr[11][12] = 1
        arr[11][15] = 1
        arr[11][16] = 1
        arr[12][7] = 1
        arr[12][8] = 1
        arr[12][11] = 1
        arr[12][16] = 1
        arr[12][17] = 1
        arr[13][9] = 1
        arr[13][14] = 1
        arr[14][9] = 1
        arr[14][10] = 1
        arr[14][13] = 1
        arr[14][15] = 1
        arr[15][10] = 1
        arr[15][11] = 1
        arr[15][14] = 1
        arr[15][16] = 1
        arr[16][11] = 1
        arr[16][12] = 1
        arr[16][15] = 1
        arr[16][17] = 1
        arr[17][12] = 1
        arr[17][16] = 1
    }
    
    func myAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let actiong = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(actiong)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func setGradient(color1: UIColor, color2: UIColor, color3: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor, color3.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
//        layer.addSublayer(gradient)
        layer.insertSublayer(gradient, at: 0)
    }
}

extension UIColor {
    convenience init(rgb: Int) {
        let iBlue = rgb & 0xFF
        let iGreen =  (rgb >> 8) & 0xFF
        let iRed =  (rgb >> 16) & 0xFF
        self.init(red: CGFloat(iRed)/255, green: CGFloat(iGreen)/255,
                  blue: CGFloat(iBlue)/255, alpha: 1)
    }
}



struct Queue<T> {
    private var queue: [T] = []
    
    public var count: Int {
        return queue.count
    }
    
    public var isEmpty: Bool {
        return queue.isEmpty
    }
    
    public mutating func enqueue(_ element: T) {
        queue.append(element)
    }
    
    public mutating func dequeue() -> T? {
        return isEmpty ? nil : queue.removeFirst()
    }
}


class RecGridViewCell: UICollectionViewCell {
    @IBOutlet weak var imgUp: UIImageView!
    @IBOutlet weak var imgDown: UIImageView!
}

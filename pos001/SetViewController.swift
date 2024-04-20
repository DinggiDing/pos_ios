//
//  SetViewController.swift
//  pos001
//
//  Created by 성재 on 2021/07/06.
//

import UIKit
import MobileCoreServices
import TensorFlowLite
import Photos
import PhotosUI

class SetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var colorview: UIView!
    @IBOutlet var setimage: UIImageView!
    @IBOutlet var btnsave: UIButton!
    @IBOutlet weak var btn_type_up: UIButton!
    @IBOutlet weak var btn_type_down: UIButton!
    
    @IBOutlet weak var btn_spring: UIButton!
    @IBOutlet weak var btn_summer: UIButton!
    @IBOutlet weak var btn_autumn: UIButton!
    @IBOutlet weak var btn_winter: UIButton!
    
    var arrpicker = ["상의", "하의"]
    
//    private var result: Result?
//    private var modelDataHandler: ModelDataHandler? = ModelDataHandler()
    
    var fetchResult: PHFetchResult<PHAsset>?
    var canAccessImages: [UIImage] = []
    
    let imagepicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var url: String = ""
    var sqlite = SQLite()
    var sortStr: Int = 0            // sortStr은 picker 요소, memo +1 해줘야함
    var check_spring:Int = 0
    var check_summer:Int = 0
    var check_autumn: Int = 0
    var check_winter: Int = 0
    var point: CGPoint!
    var image: UIImage!
    var rgbcolor: Int = 0              // color
    var maxIdx: Int = 0             // feel
        
    let myStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let setcolor = UITapGestureRecognizer(target: self, action: #selector(touchimg(sender:)))
//        setimage.addGestureRecognizer(setcolor)
//        setimage.isUserInteractionEnabled = true
    
        colorview.layer.cornerRadius = 30
        colorview.layer.shadowOpacity = 0.5
        colorview.layer.shadowRadius = 7
        
        btn_type_up.isSelected = true
        btn_type_up.backgroundColor = UIColor.orange
        btn_type_up.addTarget(self, action: #selector(type1), for: .touchUpInside)
        btn_type_down.addTarget(self, action: #selector(type2), for: .touchUpInside)
        
        btnsave.addTarget(self, action: #selector(btnLoad), for: .touchUpInside)
        btnload_access()
        
        btn_spring.addTarget(self, action: #selector(season1(sender:)), for: .touchUpInside)
        btn_summer.addTarget(self, action: #selector(season1(sender:)), for: .touchUpInside)
        btn_autumn.addTarget(self, action: #selector(season1(sender:)), for: .touchUpInside)
        btn_winter.addTarget(self, action: #selector(season1(sender:)), for: .touchUpInside)
    }
    
    func btnload_access() {
        if url != "" && rgbcolor != 0 && check_spring*1000+check_summer*100+check_autumn*10+check_winter != 0 {
            btnsave.isUserInteractionEnabled = true
            btnsave.backgroundColor = UIColor.orange
            
        } else {
            btnsave.isUserInteractionEnabled = false
            btnsave.backgroundColor = UIColor.gray
        }
    }
    

    @objc func type1() {
        print("type1 버튼")
        btn_type_up.isSelected = true
        btn_type_up.backgroundColor = UIColor.orange
        btn_type_down.isSelected = false
        btn_type_down.backgroundColor = UIColor.gray
        sortStr = 0
        btnload_access()
    }
    @objc func type2() {
        btn_type_down.isSelected = true
        btn_type_down.backgroundColor = UIColor.orange
        btn_type_up.isSelected = false
        btn_type_up.backgroundColor = UIColor.gray
        sortStr = 1
        btnload_access()
    }
    
    @objc func season1(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.backgroundColor = UIColor.gray
            if sender == btn_spring {
                check_spring = 0
            }
            if sender == btn_summer {
                check_summer = 0
            }
            if sender == btn_autumn {
                check_autumn = 0
            }
            if sender == btn_winter {
                check_autumn = 0
            }
        } else {
            sender.isSelected = true
            sender.backgroundColor = UIColor.orange
            if sender == btn_spring {
                check_spring = 1
            }
            if sender == btn_summer {
                check_summer = 1
            }
            if sender == btn_autumn {
                check_autumn = 1
            }
            if sender == btn_winter {
                check_autumn = 1
            }
        }
        btnload_access()
    }
    
    
    @IBAction func picker(_ sender: UIButton) {
        let picker = UIColorPickerViewController()
        picker.selectedColor = self.view.backgroundColor!
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func btnopen(_ sender: UIButton) {
        print("----------------")
        print("open")
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            imagepicker.delegate = self
            imagepicker.sourceType = .photoLibrary
            imagepicker.mediaTypes = [kUTTypeImage as String]
            imagepicker.allowsEditing = true

            present(imagepicker, animated: true, completion: nil)
        } else {
            myAlert("Photo", message: "Application cannot access the photo album.")
        }
        
    }
   
    
//    @objc
//    func touchimg(sender: UITapGestureRecognizer) {
//        if(sender.state == UITapGestureRecognizer.State.recognized) {
//            point = sender.location(in: self.setimage)                    // 확실시 않음
//            if setimage.image == nil {
//                print("never")
//            } else {
//                image = setimage.image
//                let color: UIColor = image.getPixelColor(pos: point)
//                print(color)
//                rgbcolor = color.rgb()
//                colorview.layer.backgroundColor = color.cgColor
//                result = modelDataHandler?.runModel(onFrame: color)
//                for i in 0...16 {
//                    let a = result?.arrtf[i] ?? 0
//                    let b = result?.arrtf[maxIdx] ?? 0
//                    if a > b {
//                        maxIdx = i
//                    }
//                    print(a,b)
//                }
//            }
//        }
//    }
    
    // alert 만들기
    func myAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let actiong = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(actiong)
        self.present(alert, animated: true, completion: nil)
    }
    // toast 만들기
    func showTaost(message: String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {toastLabel.alpha = 0.0}, completion: {(isCompleted) in toastLabel.removeFromSuperview()
        })
    }
    // init
    func initSet() {
        colorview.backgroundColor = UIColor.white
        setimage.image = UIImage(named: "dislike.png")
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString

        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            setimage.image = captureImage
            let lblset_edit = info[UIImagePickerController.InfoKey.imageURL]
            url = "\(lblset_edit!)"
        }
        print(url)
        btnload_access()
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func btnLoad() {
        print("save 버튼")
        if url != "" {
            let sortint = check_spring*1000+check_summer*100+check_autumn*10+check_winter
            _ = sqlite.insertToDo(memo: sortStr+1, image: url, color: rgbcolor, sort: sortint, feel: maxIdx)

//            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//            let tabController: UITabBarController = UITabBarController(rootViewController: viewController)
 //           viewController.modalPresentationStyle = .fullScreen
//
//            present(viewController, animated: true, completion: nil)
//            self.presentingViewController?.dismiss(animated:true)
//            presentingViewController?.viewDidAppear(true)
            //self.tabBarController?.tabBar.isHidden = false
//
            self.showTaost(message: "Save")

            initSet()

        } else {
            myAlert("Photo", message: "Application cannot access the photo album.")
        }
    }
    
}

extension SetViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController){
        print(viewController.selectedColor)
//        colorview.backgroundColor = viewController.selectedColor
//        let color: UIColor = viewController.selectedColor
//        rgbcolor = color.rgb()
//        colorview.layer.backgroundColor = color.cgColor
//        result = modelDataHandler?.runModel(onFrame: color)
//        for i in 0...16 {
//            let a = result?.arrtf[i] ?? 0
//            let b = result?.arrtf[maxIdx] ?? 0
//            if a > b {
//                maxIdx = i
//            }
//        }
    }
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController){
        print(viewController.selectedColor)
        let result: Result?
        let modelDataHandler: ModelDataHandler? = ModelDataHandler()
        guard modelDataHandler != nil else {
              fatalError("Model set up failed")
        }
        colorview.backgroundColor = viewController.selectedColor
        let color: UIColor = viewController.selectedColor
        rgbcolor = color.rgb()!
        colorview.layer.backgroundColor = color.cgColor
        print(color)
        result = modelDataHandler?.runModel(onFrame: color)
        print(color.cgColor)
        for i in 0...16 {
            let a = result?.arrtf[i] ?? 0
            let b = result?.arrtf[maxIdx] ?? 0
            if a > b {
                maxIdx = i
            }
            print(a,b)
        }
        btnload_access()
    }
}

extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        let provider = self.cgImage!.dataProvider
        let providerData = provider!.data
        let data = CFDataGetBytePtr(providerData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4

        let r = CGFloat(data![pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data![pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data![pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data![pixelInfo+3]) / CGFloat(255.0)

        return UIColor(red: r, green: g, blue: b, alpha: a)

    }
}

extension UIColor {

    func rgb() -> Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)

            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}

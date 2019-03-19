//
//  Instagram Hashtag Generator
//
//  Created by Amey Dhamgunde on 2019-03-17.
//  Copyright © 2019 Amey Dhamgunde. All rights reserved.
//
//  Description:
//

import PlaygroundSupport
import UIKit
import CoreGraphics


//  Used to resize images that are not the required size that GoogLeNetPlaces can handle. Knowing that the image size required is 224x224,
//  this function is designed to extend the UIImage class and resize it to the specified dimensions.
//  This inadvertently can
extension UIImage {
    func resize() -> UIImage {
        let targetSize = CGSize.init(width: 224, height: 224)
        
        let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

class viewController : UIViewController {
    
    //  The machine learning model used in this project is the GoogLeNetPlaces model, featured on Apple's developer page.
    let model = GoogLeNetPlaces()
    
    var margin = CGFloat()
    var allScenes : [String] = []
    var finalHashtags = String()
    
    var image1 = UIImageView()
    var image2 = UIImageView()
    var image3 = UIImageView()
    var image4 = UIImageView()
    var image5 = UIImageView()
    var image6 = UIImageView()
    
    var label1 = UILabel()
    var label2 = UILabel()
    var label3 = UILabel()
    var label4 = UILabel()
    var label5 = UILabel()
    var label6 = UILabel()
    
    var labels : [UILabel] = []
    
    var numberOfHashtags : Int = 1
    
    
    override func viewDidLoad() {
        
        //  Setting up the view that will be used to interact with the application. The dimensions have been set to half of the iPad Pro,
        //  since I am using a Macbook Air - the view would not fit within the screen dimensions. The app should be easily scalable.
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 417, height:556))
        self.view = view
        
        let standardSize = CGSize(width: (view.frame.width/417)*100, height: (view.frame.width/417)*100)
        margin = standardSize.width/2   //  This is used to keep all the margins the same, based off the standard size for the images. This is thus dependent on the size of the view, allowing the app to be easily scaled up.
        
        // By making the rows dependent on the screen size, it makes the app adaptable.
        let row1 = CGFloat(standardSize.width*1.75)
        let row2 = CGFloat(standardSize.width*3)
        let row3 = CGFloat(standardSize.width*0.85) //  Row for the buttons
        
        view.backgroundColor = .white
        
        
        //  Image 1 and gestureRecognizers
        
        let imageGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        
        image1 = UIImageView(frame: CGRect(origin: CGPoint(x: margin, y: row1), size: standardSize))
        
        if let sample = Bundle.main.path(forResource: "img1", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image1.image = image
        }
        
        image1.layer.borderColor = UIColor.black.cgColor
        image1.layer.borderWidth = 2.5*(view.frame.width/417)
        image1.isUserInteractionEnabled = true
        image1.addGestureRecognizer(imageGestureRecognizer1)
        
        
        //  Image 2
        
        let imageGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        
        image2 = UIImageView(frame: CGRect(origin: CGPoint(x: (view.frame.width/2)-margin, y: row1), size: standardSize))
        
        if let sample = Bundle.main.path(forResource: "img2", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image2.image = image
        }
        
        image2.layer.borderColor = UIColor.black.cgColor
        image2.layer.borderWidth = 2.5*(view.frame.width/417)
        image2.isUserInteractionEnabled = true
        image2.addGestureRecognizer(imageGestureRecognizer2)
        
        
        //  Image 3
        
        let imageGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        
        image3 = UIImageView(frame: CGRect(origin: CGPoint(x: view.frame.width-(view.frame.width/417)*50-2*margin, y: row1), size: standardSize))
        
        if let sample = Bundle.main.path(forResource: "img3", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image3.image = image
        }
        
        image3.layer.borderColor = UIColor.black.cgColor
        image3.layer.borderWidth = 2.5*(view.frame.width/417)
        image3.isUserInteractionEnabled = true
        image3.addGestureRecognizer(imageGestureRecognizer3)
        
        
        //  Image 4
        
        let imageGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        
        image4 = UIImageView(frame: CGRect(origin: CGPoint(x: margin, y: row2), size: standardSize))
        
        if let sample = Bundle.main.path(forResource: "img4", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image4.image = image
        }
        
        image4.layer.borderColor = UIColor.black.cgColor
        image4.layer.borderWidth = 2.5*(view.frame.width/417)
        image4.isUserInteractionEnabled = true
        image4.addGestureRecognizer(imageGestureRecognizer4)
        
        
        //  Image 5
        
        let imageGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        
        image5 = UIImageView(frame: CGRect(origin: CGPoint(x: (view.frame.width/2)-margin, y: row2), size: standardSize))
        
        if let sample = Bundle.main.path(forResource: "img5", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image5.image = image
        }
        
        image5.layer.borderColor = UIColor.black.cgColor
        image5.layer.borderWidth = 2.5*(view.frame.width/417)
        image5.isUserInteractionEnabled = true
        image5.addGestureRecognizer(imageGestureRecognizer5)
        
        
        //  Image 6
        
        let imageGestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        
        image6 = UIImageView(frame: CGRect(origin: CGPoint(x: view.frame.width-(view.frame.width/417)*50-margin*2, y: row2), size: standardSize))
        
        if let sample = Bundle.main.path(forResource: "img6", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image6.image = image
        }
        
        image6.layer.borderColor = UIColor.black.cgColor
        image6.layer.borderWidth = 2.5*(view.frame.width/417)
        image6.isUserInteractionEnabled = true
        image6.addGestureRecognizer(imageGestureRecognizer6)
        
        view.addSubview(image1)
        view.addSubview(image2)
        view.addSubview(image3)
        view.addSubview(image4)
        view.addSubview(image5)
        view.addSubview(image6)
        
        
        //  Buttons for how many hashtags to generate.
        
        let buttonWidth = (view.bounds.width-margin*2)/6
        
        
        label1 = UILabel(frame: CGRect(x: margin, y: row3, width: buttonWidth, height: 20))
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        label1.text = "1"
        label1.textAlignment = .center
        label1.isUserInteractionEnabled = true
        label1.addGestureRecognizer(gestureRecognizer)
        
        label2 = UILabel(frame: CGRect(x: margin+buttonWidth, y: row3, width: buttonWidth, height: 20))
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        label2.text = "2"
        label2.textAlignment = .center
        label2.isUserInteractionEnabled = true
        label2.addGestureRecognizer(gestureRecognizer2)

        
        label3 = UILabel(frame: CGRect(x: margin+2*buttonWidth, y: row3, width: buttonWidth, height: 20))
        let gestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        label3.text = "3"
        label3.textAlignment = .center
        label3.isUserInteractionEnabled = true
        label3.addGestureRecognizer(gestureRecognizer3)

        label4 = UILabel(frame: CGRect(x: margin+3*buttonWidth, y: row3, width: buttonWidth, height: 20))
        let gestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        label4.text = "4"
        label4.textAlignment = .center
        label4.isUserInteractionEnabled = true
        label4.addGestureRecognizer(gestureRecognizer4)

        label5 = UILabel(frame: CGRect(x: margin+4*buttonWidth, y: row3, width: buttonWidth, height: 20))
        let gestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        label5.text = "5"
        label5.textAlignment = .center
        label5.isUserInteractionEnabled = true
        label5.addGestureRecognizer(gestureRecognizer5)

        label6 = UILabel(frame: CGRect(x: margin+5*buttonWidth, y: row3, width: buttonWidth, height: 20))
        let gestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        label6.text = "6"
        label6.textAlignment = .center
        label6.isUserInteractionEnabled = true
        label6.addGestureRecognizer(gestureRecognizer6)

        labels = [label1, label2, label3, label4, label5, label6]
        
        //  Initialize starting 1
        label1.textColor = .blue
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        view.addSubview(label6)
        
    }
    
    func switching (label : UILabel) {
        for u in labels {
            if u == label {
                u.textColor = .blue
                numberOfHashtags = Int(u.text!)!
                print(numberOfHashtags)
            } else {
                u.textColor = .black
            }
        }
    }
    
    @objc internal func selectLabel(_ sender : UITapGestureRecognizer) {
        
        let labelToChange = sender.view as! UILabel
        switching(label: labelToChange)
        
    }
    
    @objc internal func callMLModel(_ sender : UITapGestureRecognizer) {
        
        let imageView = sender.view as! UIImageView
        finalHashtags = ""
        allScenes = []
        
        if let imageToAnalyse = imageView.image {
            if var sceneLabels = scenes(image : imageToAnalyse) {
                while allScenes.count < 7 {
                    let removal = maximum(scenery: sceneLabels)
                    var processingString = ""
                    for u : Character in removal {
                        if u == "/" {
                            if !(allScenes.contains(processingString)) {
                                allScenes.append(hashtagCreator(stringToCreate: processingString))
                            }
                            processingString = ""
                        } else {
                            processingString += String(u)
                        }
                    }
                    allScenes.append(hashtagCreator(stringToCreate: processingString))
                    processingString = ""
                    sceneLabels.removeValue(forKey: removal)
                    
                }
                for i in 0...numberOfHashtags-1 {
                    finalHashtags += allScenes[i] + " "
                }
            }
        }
        
        print(finalHashtags)
    }
    
    func hashtagCreator (stringToCreate : String) -> String {
        return "#" + stringToCreate
    }
    
    func scenes (image : UIImage) -> Dictionary<String, Double>? {
        print("running")
        let resizedImage = image.resize()
        
        if let bufferedImage = imageProcessor.pixelBuffer(forImage: resizedImage.cgImage!) {
            guard let scene = try? model.prediction(sceneImage: bufferedImage) else {fatalError("Unexpected Runtime Error")}
            
            return scene.sceneLabelProbs
        }
        
        return nil
        
    }
    
    func maximum (scenery: Dictionary<String, Double>) -> String {
        var probability = 0.0;
        var returnvalue = ""
        for u in scenery {
            if u.value > probability {
                probability = u.value
                returnvalue = u.key
            }
        }
        return returnvalue
    }
    
}

let vc = viewController()
vc.view.frame.size = CGSize(width: 417, height: 556)






PlaygroundPage.current.liveView = vc.view

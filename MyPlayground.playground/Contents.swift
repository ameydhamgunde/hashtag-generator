//
//  Instagram Hashtag Generator
//
//  Created by Amey Dhamgunde on 2019-03-17.
//  Copyright © 2019 Amey Dhamgunde. All rights reserved.
//
//  Description: For content creators, a large part of their job is gaining recognition on
//

import PlaygroundSupport
import UIKit
import CoreGraphics

//  Used to resize images that are not the required size that GoogLeNetPlaces can handle. Knowing that the image size required is 224x224,
//  this function is designed to extend the UIImage class and resize it to the specified dimensions.
//  This inadvertently can stretch the image, but this is a better alternative compared to

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
    
    func darkened() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
            return nil
        }
        
        // flip the image, or result appears flipped
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.translateBy(x: 0, y: -size.height)
        
        let rect = CGRect(origin: .zero, size: size)
        ctx.draw(cgImage, in: rect)
        UIColor(white: 0.05, alpha: 0.90).setFill()
        ctx.fill(rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
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
    var images : [UIImageView] = []
    
    var label1 = UILabel()
    var label2 = UILabel()
    var label3 = UILabel()
    var label4 = UILabel()
    var label5 = UILabel()
    var label6 = UILabel()
    
    var titleLabel = UILabel()
    
    var instruction1 = UILabel()
    var instruction2 = UILabel()
    var instruction3 = UILabel()
    
    var labels : [UILabel] = []
    var resultsLabel = UILabel()
    var copiedLabel = UILabel()
    
    var numberOfHashtags : Int = 1
    
    
    override func viewDidLoad() {
        
        let fontURL = Bundle.main.url(forResource: "FreightSansMedium", withExtension: "otf")
        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
        
        
        //  Setting up the view that will be used to interact with the application. The dimensions have been set to half of the iPad Pro,
        //  since I am using a Macbook Air - the view would not fit within the screen dimensions. The app should be easily scalable.
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 417, height:556))
        self.view = view
        
        let standardSize = CGSize(width: (view.frame.width/417)*100, height: (view.frame.width/417)*100)
        margin = standardSize.width/2   //  This is used to keep all the margins the same, based off the standard size for the images. This is thus dependent on the size of the view, allowing the app to be easily scaled up.
        
        // By making the rows dependent on the screen size, it makes the app adaptable.
        let row1 = CGFloat(standardSize.width*1.85)
        let row2 = CGFloat(standardSize.width*3)
        let row3 = CGFloat(standardSize.width*1.05) //  Row for the buttons
        
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 417, height: 556))
        if let sample = Bundle.main.path(forResource: "background", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            backgroundImage.image = image?.darkened()
        }
        view.addSubview(backgroundImage)
        view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.10, alpha: 1.0)
        
        titleLabel = UILabel(frame: CGRect(x: margin/2, y: margin/2, width: view.frame.width-margin, height: 40))
        titleLabel.text = "Instagram Hashtag Generator"
        titleLabel.font = UIFont(name: "Freight-SansMedium", size: 25)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        //  Image 1 and gestureRecognizers
        
        let imageGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        
        image1 = UIImageView(frame: CGRect(origin: CGPoint(x: margin, y: row1), size: standardSize))
        
        if let sample = Bundle.main.path(forResource: "img1", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image1.image = image
        }
        
        image1.layer.borderColor = UIColor.white.cgColor
        image1.layer.borderWidth = 2.5*(view.frame.width/417)
        image1.isUserInteractionEnabled = true
        image1.contentMode = .scaleAspectFill
        image1.clipsToBounds = true
        image1.addGestureRecognizer(imageGestureRecognizer1)
        
        
        //  Image 2
        
        let imageGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        
        image2 = UIImageView(frame: CGRect(origin: CGPoint(x: (view.frame.width/2)-margin, y: row1), size: standardSize))
        
        if let sample = Bundle.main.path(forResource: "img2", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image2.image = image
        }
        
        image2.layer.borderColor = UIColor.white.cgColor
        image2.layer.borderWidth = 2.5*(view.frame.width/417)
        image2.isUserInteractionEnabled = true
        image2.contentMode = .scaleAspectFill
        image2.clipsToBounds = true
        image2.addGestureRecognizer(imageGestureRecognizer2)
        
        
        //  Image 3
        
        let imageGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        
        image3 = UIImageView(frame: CGRect(origin: CGPoint(x: view.frame.width-(view.frame.width/417)*50-2*margin, y: row1), size: standardSize))
        
        if let sample = Bundle.main.path(forResource: "img3", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image3.image = image
        }
        
        image3.layer.borderColor = UIColor.white.cgColor
        image3.layer.borderWidth = 2.5*(view.frame.width/417)
        image3.isUserInteractionEnabled = true
        image3.contentMode = .scaleAspectFill
        image3.clipsToBounds = true
        image3.addGestureRecognizer(imageGestureRecognizer3)
        
        
        //  Image 4
        
        let imageGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        
        image4 = UIImageView(frame: CGRect(origin: CGPoint(x: margin, y: row2), size: standardSize))
        
        if let sample = Bundle.main.path(forResource: "img4", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image4.image = image
        }
        
        image4.layer.borderColor = UIColor.white.cgColor
        image4.layer.borderWidth = 2.5*(view.frame.width/417)
        image4.isUserInteractionEnabled = true
        image4.contentMode = .scaleAspectFill
        image4.clipsToBounds = true
        image4.addGestureRecognizer(imageGestureRecognizer4)
        
        
        //  Image 5
        
        let imageGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        
        image5 = UIImageView(frame: CGRect(origin: CGPoint(x: (view.frame.width/2)-margin, y: row2), size: standardSize))
        
        if let sample = Bundle.main.path(forResource: "img5", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image5.image = image
        }
        
        image5.layer.borderColor = UIColor.white.cgColor
        image5.layer.borderWidth = 2.5*(view.frame.width/417)
        image5.isUserInteractionEnabled = true
        image5.contentMode = .scaleAspectFill
        image5.clipsToBounds = true
        image5.addGestureRecognizer(imageGestureRecognizer5)
        
        
        //  Image 6
        
        let imageGestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        
        image6 = UIImageView(frame: CGRect(origin: CGPoint(x: view.frame.width-(view.frame.width/417)*50-margin*2, y: row2), size: standardSize))
        
        if let sample = Bundle.main.path(forResource: "img6", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image6.image = image
        }
        
        image6.layer.borderColor = UIColor.white.cgColor
        image6.layer.borderWidth = 2.5*(view.frame.width/417)
        image6.isUserInteractionEnabled = true
        image6.contentMode = .scaleAspectFill
        image6.clipsToBounds = true
        image6.addGestureRecognizer(imageGestureRecognizer6)
        
        view.addSubview(image1)
        view.addSubview(image2)
        view.addSubview(image3)
        view.addSubview(image4)
        view.addSubview(image5)
        view.addSubview(image6)
        images = [image1, image2, image3, image4, image5, image6]
        
        
        //  Buttons for how many hashtags to generate.
        
        let buttonWidth = (view.bounds.width-margin*2)/6
        
        
        label1 = UILabel(frame: CGRect(x: margin, y: row3, width: buttonWidth, height: 20))
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        label1.text = "1"
        label1.textAlignment = .center
        label1.isUserInteractionEnabled = true
        label1.textColor = .white
        label1.addGestureRecognizer(gestureRecognizer)
        
        label2 = UILabel(frame: CGRect(x: margin+buttonWidth, y: row3, width: buttonWidth, height: 20))
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        label2.text = "2"
        label2.textAlignment = .center
        label2.isUserInteractionEnabled = true
        label2.textColor = .white
        label2.addGestureRecognizer(gestureRecognizer2)

        
        label3 = UILabel(frame: CGRect(x: margin+2*buttonWidth, y: row3, width: buttonWidth, height: 20))
        let gestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        label3.text = "3"
        label3.textAlignment = .center
        label3.isUserInteractionEnabled = true
        label3.textColor = .white
        label3.addGestureRecognizer(gestureRecognizer3)

        label4 = UILabel(frame: CGRect(x: margin+3*buttonWidth, y: row3, width: buttonWidth, height: 20))
        let gestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        label4.text = "4"
        label4.textAlignment = .center
        label4.isUserInteractionEnabled = true
        label4.textColor = .white
        label4.addGestureRecognizer(gestureRecognizer4)

        label5 = UILabel(frame: CGRect(x: margin+4*buttonWidth, y: row3, width: buttonWidth, height: 20))
        let gestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        label5.text = "5"
        label5.textAlignment = .center
        label5.isUserInteractionEnabled = true
        label5.textColor = .white
        label5.addGestureRecognizer(gestureRecognizer5)

        label6 = UILabel(frame: CGRect(x: margin+5*buttonWidth, y: row3, width: buttonWidth, height: 20))
        let gestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        label6.text = "6"
        label6.textAlignment = .center
        label6.isUserInteractionEnabled = true
        label6.textColor = .white
        label6.addGestureRecognizer(gestureRecognizer6)

        labels = [label1, label2, label3, label4, label5, label6]
        
        //  Initialize starting 1
        label1.textColor = .purple
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        view.addSubview(label6)
        
        
        //  Adding results
        resultsLabel = UILabel(frame: CGRect(x: margin/2, y: 9.1*margin, width: view.frame.width-margin, height: 50))
        let copyRecognizer = UITapGestureRecognizer(target: self, action: #selector(copyIt))
        resultsLabel.font = UIFont(name: "Helvetica", size: 20)
        resultsLabel.textAlignment = .center
        resultsLabel.lineBreakMode = .byWordWrapping
        resultsLabel.numberOfLines = 0
        resultsLabel.isUserInteractionEnabled = true
        resultsLabel.textColor = .white
        resultsLabel.addGestureRecognizer(copyRecognizer)
        
        view.addSubview(resultsLabel)
        
        copiedLabel = UILabel(frame: CGRect(x: (view.bounds.width/2)-50, y: margin*10.2, width: 100, height: 20))
        let copyRecognizerLabel = UITapGestureRecognizer(target: self, action: #selector(copyIt))
        copiedLabel.font = UIFont(name: "Helvetica", size: 14)
        copiedLabel.textAlignment = .center
        copiedLabel.isHidden = true
        copiedLabel.text = "Tap to copy!"
        copiedLabel.addGestureRecognizer(copyRecognizerLabel)
        copiedLabel.isUserInteractionEnabled = true
        copiedLabel.textColor = .white
        view.addSubview(copiedLabel)
        
        
        // Setting up the instructions
        
        instruction1 = UILabel(frame: CGRect(x: margin/2, y: margin*1.25, width: view.frame.width-margin, height: 30))
        instruction1.text = "1. How many hashtags do you need?"
        instruction1.font = UIFont(name: "San Francisco", size: 17)
        instruction1.textColor = .white
        view.addSubview(instruction1)
        
        instruction2 = UILabel(frame: CGRect(x: margin/2, y: margin*2.75, width: view.frame.width-margin, height: 30))
        instruction2.text = "2. Which image do you need analyzed?"
        instruction2.font = UIFont(name: "Montserrat", size: 17)
        instruction2.textColor = .white
        view.addSubview(instruction2)
        
        instruction3 = UILabel(frame: CGRect(x: margin/2, y: margin*8.5, width: view.frame.width-margin, height: 30))
        instruction3.text = "3. Done!"
        instruction3.font = UIFont(name: "Open Sans", size: 17)
        instruction3.textColor = .white
        view.addSubview(instruction3)
        
    }
    
    @objc internal func copyIt(_ sender : UITapGestureRecognizer) {
        let hashtags = sender.view as! UILabel
        UIPasteboard.general.string = hashtags.text
        copiedLabel.text = "Copied!"
        
        
    }
    
    func switching (label : UILabel) {
        for u in labels {
            if u == label {
                let pulse = pulseAnimation(numberOfPulses: 1, radius: 50, position: label.center)
                pulse.animationDuration = 0.8
                pulse.backgroundColor = UIColor.purple.cgColor
                
                view.layer.insertSublayer(pulse, below: label.layer)
//                u.textColor = .purple
                
                UIView.transition(with: u, duration: 0.25, options: .transitionCrossDissolve, animations: { u.textColor = .purple }, completion: nil)
                
                numberOfHashtags = Int(u.text!)!
            } else if u.textColor == .purple {
                UIView.transition(with: u, duration: 0.25, options: .transitionCrossDissolve, animations: { u.textColor = .white }, completion: nil)
            }
        }
    }
    
    @objc internal func selectLabel(_ sender : UITapGestureRecognizer) {
        
        let labelToChange = sender.view as! UILabel
        switching(label: labelToChange)
        
    }
    
    @objc internal func callMLModel(_ sender : UITapGestureRecognizer) {
        
        copiedLabel.isHidden = false
        copiedLabel.text = "Tap to copy!"
        let imageView = sender.view as! UIImageView
        
        let pulse = pulseAnimation(numberOfPulses: 1, radius: 110, position: imageView.center)
        pulse.animationDuration = 0.8
        pulse.backgroundColor = UIColor.purple.cgColor
        
        view.layer.insertSublayer(pulse, below: imageView.layer)
        
        finalHashtags = ""
        allScenes = []
        
        for u in images {
            if u == imageView {
                
                let colorChange = CABasicAnimation(keyPath: "borderColor")
                colorChange.fromValue = UIColor.white.cgColor
                colorChange.toValue = UIColor.purple.cgColor
                colorChange.duration = 1
                colorChange.repeatCount = 1
                imageView.layer.borderWidth = 2
                imageView.layer.borderColor = UIColor.purple.cgColor
                imageView.layer.add(colorChange, forKey: "borderColor")

            } else if u.layer.borderColor == UIColor.purple.cgColor {
                
                let colorChange = CABasicAnimation(keyPath: "borderColor")
                colorChange.fromValue = UIColor.purple.cgColor
                colorChange.toValue = UIColor.white.cgColor
                colorChange.duration = 1
                colorChange.repeatCount = 1
                u.layer.borderWidth = 2
                u.layer.borderColor = UIColor.white.cgColor
                u.layer.add(colorChange, forKey: "borderColor")
                
            }
        }
        
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
        
        resultsLabel.text = finalHashtags
    }
    
    func hashtagCreator (stringToCreate : String) -> String {
        return "#" + stringToCreate
    }
    
    func scenes (image : UIImage) -> Dictionary<String, Double>? {
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

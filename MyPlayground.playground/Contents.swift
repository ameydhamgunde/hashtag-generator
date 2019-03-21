//
//  Hashtag Generator
//
//  Created by Amey Dhamgunde on 2019-03-17.
//  Copyright © 2019 Amey Dhamgunde. All rights reserved.
//
//  Description: For content creators, a large part of their job is gaining recognition on various social media platforms such as Instagram, Facebook, and Twitter. One of the most effective ways to increase your outreach is through the use of hashtags, as it has the benefit that people can find your posts without relying on search and recommendation algorithms on the social media platforms or through mutual followers.
//
//  This app aims to help content creators, whether they be influencial figures or photographers. When they are stuck thinking about possible hashtags that people commonly search up, that pertain to their image, this algorithm comes in handy.
//
//  The first step is to select the number of hashtags you want to generate: an integer between 1 and 6. This is made convenient for the user through the use of UILabels arranged neatly in a row, made interactive through the use of UITapGestureRecognizers. It is animated using the UIView.animate function and the CoreAnimation library. When one of the numbers are pressed, the logic is written to set the numberOfHashtags integer to the appropriate number selected by the user, and animate both the current and previous selection.
//
//  The second step is to the select the image to be analyzed. In practice, this would rely on prompting the user to open their photo library and select an image that would be processed. However, for the nature of this submission, given that this app will be run offline and there is no guarantee that there will be images saved on the testing platform to be used for the app, there have been some example pictures provided. However, the results are not hard coded. Instead, through the use of machine learning from the CoreML library, this app processes these testing images using the GoogLeNetPlaces model.
//
//  When the image is selected, the callMLModel function is called. In this function, there is an animation created, changing the border color and adding a pulse effect to the image to let the user know that the selection has been successful. The image is then passed into the scenes function in the GoogLeNetPlaces.swift file, which returns a dictionary [String: Double], representing the name of the scene and the probability of the scene. The top 6 most probable scenes are then stored in an array - the amount specified by the user later formatted as a string. At the end, the results are displayed on a UILabel using an NSMutableAttributedString for formatting.
//
//

import PlaygroundSupport
import UIKit

extension UIImage {
    
    /**
        Resizes the image to the required 224x224 dimension required by GoogLeNetPlaces.
        - returns: the same image, resized to 224x224 pixels.
     */
    
    func resize() -> UIImage {
        let targetSize = CGSize.init(width: 224, height: 224)
        
        let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /**
        Changes the brightness of the specified image and returns it.
        - parameters:
            - white: brightness of the image as CGFloat
            - alpha: transparency of the image as CGFloat
        - returns: the image with the changed brightness as UIImage?
     */
    
    func changeBrightness (white: CGFloat, alpha: CGFloat) -> UIImage? {
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
        UIColor(white: white, alpha: alpha).setFill()
        ctx.fill(rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UILabel {
    
    /**
        Animation for the fading out and in of a label, with purple hashtags (#).
        - parameters:
            - textGiven: text to replace the given label with as String
     */
    
    func fadeOutIn (textGiven: String) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: { () -> Void in
            let myMutableString = NSMutableAttributedString(string: textGiven, attributes: [NSAttributedString.Key.font : UIFont(name: "OpenSans-Regular", size: 18)!])
            var count : Int = 0
            for u : Character in textGiven {
                if u == "#" {
                    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(location:count,length:1))
                }
                count += 1
                
            }
            self.attributedText = myMutableString
            UIView.animate(withDuration: 0.6, animations: {
                self.alpha = 1.0
            })
        })
    }
    
    /**
        Animation for fading out and in of a label, while changing text color.
        - parameters:
            - textGiven: text to replace the given label with as String
            - colorChange: color the text change to
     */
    
    func fadeOutInColor (textGiven: String, colorChange: UIColor) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: { () -> Void in
            self.text = textGiven
            self.textColor = colorChange
            UIView.animate(withDuration: 0.6, animations: {
                self.alpha = 1.0
            })
        })
    }
}

class viewController : UIViewController {
    
    //  The machine learning model used in this project is the GoogLeNetPlaces model, featured on Apple's developer page.
    let model = GoogLeNetPlaces()
    
    var margin = CGFloat()
    
    var titleLabel = UILabel()
    
    var instruction1 = UILabel()
    var instruction2 = UILabel()
    var instruction3 = UILabel()
    
    var image1 = UIImageView()
    var image2 = UIImageView()
    var image3 = UIImageView()
    var image4 = UIImageView()
    var image5 = UIImageView()
    var image6 = UIImageView()
    var images : [UIImageView] = []
    
    var button1 = UILabel()
    var button2 = UILabel()
    var button3 = UILabel()
    var button4 = UILabel()
    var button5 = UILabel()
    var button6 = UILabel()
    var labels : [UILabel] = []
    
    var allScenes : [String] = []
    var finalHashtags = String()
    var resultsLabel = UILabel()
    var copiedLabel = UILabel()
    var copied = false
    
    var numberOfHashtags : Int = 1
    
    
    override func viewDidLoad() {
        
        let fontURL = Bundle.main.url(forResource: "FreightSansMedium", withExtension: "otf")
        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
        let fontURL2 = Bundle.main.url(forResource: "OpenSans-Regular", withExtension: "ttf")
        CTFontManagerRegisterFontsForURL(fontURL2! as CFURL, CTFontManagerScope.process, nil)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 417, height:556))
        self.view = view
        
        let standardSize = CGSize(width: (view.frame.width/417)*100, height: (view.frame.width/417)*100)
        
        
        margin = standardSize.width/2
        //  This is used to keep all the margins the same, based off the standard size for the images. This is thus dependent on the size of the view, allowing the app to be easily scaled up.
        
        let imageRow1 = CGFloat(standardSize.width*1.85)
        let imageRow2 = CGFloat(standardSize.width*3)
        let buttonRow = CGFloat(standardSize.width*1.05)
        
        
        //  The background image was sourced from https://www.fircroft.com/blogs/londons-newest-tallest-tower-the-tulip-83231914163
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        if let sample = Bundle.main.path(forResource: "background", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            backgroundImage.image = image?.changeBrightness(white: 0.05, alpha: 0.9)
        }
        view.addSubview(backgroundImage)

        
        titleLabel = UILabel(frame: CGRect(x: margin/2, y: margin/3, width: view.frame.width-margin, height: 40))
        titleLabel.text = "Hashtag Generator"
        titleLabel.font = UIFont(name: "Freight-SansMedium", size: 25)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        
        // Setting up the instructions
        
        instruction1 = UILabel(frame: CGRect(x: margin/2, y: margin*1.25, width: view.frame.width-margin, height: 30))
        instruction1.textColor = .white
        let mutableString1 = NSMutableAttributedString(string: "1. How many hashtags do you need?", attributes: [NSAttributedString.Key.font :UIFont(name: "OpenSans-Regular", size: 17)!])
        mutableString1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(location:0,length:2))
        instruction1.attributedText = mutableString1
        view.addSubview(instruction1)
        
        
        instruction2 = UILabel(frame: CGRect(x: margin/2, y: margin*2.75, width: view.frame.width-margin, height: 30))
        instruction2.textColor = .white
        let mutableString2 = NSMutableAttributedString(string: "2. Which image do you need analyzed?", attributes: [NSAttributedString.Key.font :UIFont(name: "OpenSans-Regular", size: 17)!])
        mutableString2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(location:0,length:2))
        instruction2.attributedText = mutableString2
        view.addSubview(instruction2)
        
        instruction3 = UILabel(frame: CGRect(x: margin/2, y: margin*8.4, width: view.frame.width-margin, height: 30))
        instruction3.textColor = .white
        let mutableString3 = NSMutableAttributedString(string: "3. Done!", attributes: [NSAttributedString.Key.font :UIFont(name: "OpenSans-Regular", size: 17)!])
        mutableString3.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(location:0,length:2))
        instruction3.attributedText = mutableString3
        view.addSubview(instruction3)
        
        
        //  Buttons for number of hashtags to generate
        
        let buttonWidth = (view.bounds.width-margin*2)/6
        
        button1 = UILabel(frame: CGRect(x: margin, y: buttonRow, width: buttonWidth, height: 20))
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        button1.text = "1"
        button1.textAlignment = .center
        button1.isUserInteractionEnabled = true
        button1.textColor = .white
        button1.addGestureRecognizer(gestureRecognizer)
        
        button2 = UILabel(frame: CGRect(x: margin+buttonWidth, y: buttonRow, width: buttonWidth, height: 20))
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        button2.text = "2"
        button2.textAlignment = .center
        button2.isUserInteractionEnabled = true
        button2.textColor = .white
        button2.addGestureRecognizer(gestureRecognizer2)
        
        
        button3 = UILabel(frame: CGRect(x: margin+2*buttonWidth, y: buttonRow, width: buttonWidth, height: 20))
        let gestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        button3.text = "3"
        button3.textAlignment = .center
        button3.isUserInteractionEnabled = true
        button3.textColor = .white
        button3.addGestureRecognizer(gestureRecognizer3)
        
        button4 = UILabel(frame: CGRect(x: margin+3*buttonWidth, y: buttonRow, width: buttonWidth, height: 20))
        let gestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        button4.text = "4"
        button4.textAlignment = .center
        button4.isUserInteractionEnabled = true
        button4.textColor = .white
        button4.addGestureRecognizer(gestureRecognizer4)
        
        button5 = UILabel(frame: CGRect(x: margin+4*buttonWidth, y: buttonRow, width: buttonWidth, height: 20))
        let gestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        button5.text = "5"
        button5.textAlignment = .center
        button5.isUserInteractionEnabled = true
        button5.textColor = .white
        button5.addGestureRecognizer(gestureRecognizer5)
        
        button6 = UILabel(frame: CGRect(x: margin+5*buttonWidth, y: buttonRow, width: buttonWidth, height: 20))
        let gestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        button6.text = "6"
        button6.textAlignment = .center
        button6.isUserInteractionEnabled = true
        button6.textColor = .white
        button6.addGestureRecognizer(gestureRecognizer6)
        
        labels = [button1, button2, button3, button4, button5, button6]
        
        
        button1.textColor = .purple //  Initialize as 1 hashtag to generate
        
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        view.addSubview(button4)
        view.addSubview(button5)
        view.addSubview(button6)
        
        
        
        //  Images
        
        //  The first example image was sourced from https://en.wikipedia.org/wiki/Jade_Belt_Bridge#/media/File:Gaoliang_Bridge.JPG
        image1 = UIImageView(frame: CGRect(origin: CGPoint(x: margin, y: imageRow1), size: standardSize))
        let imageGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        if let sample = Bundle.main.path(forResource: "img1", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image1.image = image
        }
        image1.layer.borderColor = UIColor.white.cgColor
        image1.layer.borderWidth = 3*(view.frame.width/417)
        image1.isUserInteractionEnabled = true
        image1.contentMode = .scaleAspectFill
        image1.clipsToBounds = true
        image1.addGestureRecognizer(imageGestureRecognizer1)
        
        
        //  The second example image was sourced from https://s3-media1.fl.yelpcdn.com/bphoto/53W4ATaHudIsoLQVE4TTug/o.jpg
        image2 = UIImageView(frame: CGRect(origin: CGPoint(x: (view.frame.width/2)-margin, y: imageRow1), size: standardSize))
        let imageGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        if let sample = Bundle.main.path(forResource: "img2", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image2.image = image
        }
        image2.layer.borderColor = UIColor.white.cgColor
        image2.layer.borderWidth = 3*(view.frame.width/417)
        image2.isUserInteractionEnabled = true
        image2.contentMode = .scaleAspectFill
        image2.clipsToBounds = true
        image2.addGestureRecognizer(imageGestureRecognizer2)
        
        
        //  The third example image was sourced from https://www.visitnsw.com/sites/visitnsw/files/styles/gallery_full_width/public/2017-05/Charlotte_Pass_Ski_Resort%2C_Kosciuszko_National_Park._Photo_by_S_Pawsey_and_Charlotte_Pass_Village_Pty_Ltd.jpg?itok=JH3vpdTc
        image3 = UIImageView(frame: CGRect(origin: CGPoint(x: view.frame.width-(view.frame.width/417)*50-2*margin, y: imageRow1), size: standardSize))
        let imageGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        if let sample = Bundle.main.path(forResource: "img3", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image3.image = image
        }
        image3.layer.borderColor = UIColor.white.cgColor
        image3.layer.borderWidth = 3*(view.frame.width/417)
        image3.isUserInteractionEnabled = true
        image3.contentMode = .scaleAspectFill
        image3.clipsToBounds = true
        image3.addGestureRecognizer(imageGestureRecognizer3)

        
        //  The fourth example image was sourced from https://www.canyontours.com/wp-content/uploads/2014/10/grand-canyon-west-rim-colorado-river-500x500.jpg
        image4 = UIImageView(frame: CGRect(origin: CGPoint(x: margin, y: imageRow2), size: standardSize))
        let imageGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        if let sample = Bundle.main.path(forResource: "img4", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image4.image = image
        }
        image4.layer.borderColor = UIColor.white.cgColor
        image4.layer.borderWidth = 3*(view.frame.width/417)
        image4.isUserInteractionEnabled = true
        image4.contentMode = .scaleAspectFill
        image4.clipsToBounds = true
        image4.addGestureRecognizer(imageGestureRecognizer4)
        
        
        //  The fifth example image was sourced from http://www.tunisiesoir.com/wp-content/uploads/2019/02/190218153155_1_540x360.jpg
        image5 = UIImageView(frame: CGRect(origin: CGPoint(x: (view.frame.width/2)-margin, y: imageRow2), size: standardSize))
        let imageGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        if let sample = Bundle.main.path(forResource: "img5", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image5.image = image
        }
        image5.layer.borderColor = UIColor.white.cgColor
        image5.layer.borderWidth = 3*(view.frame.width/417)
        image5.isUserInteractionEnabled = true
        image5.contentMode = .scaleAspectFill
        image5.clipsToBounds = true
        image5.addGestureRecognizer(imageGestureRecognizer5)
        
        //  The sixth example image was sourced from https://i2.wp.com/www.alabamanewscenter.com/wp-content/uploads/2018/04/alabama-power-smart-house00029.jpg?ssl=1
        image6 = UIImageView(frame: CGRect(origin: CGPoint(x: view.frame.width-(view.frame.width/417)*50-margin*2, y: imageRow2), size: standardSize))
        let imageGestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(callMLModel))
        if let sample = Bundle.main.path(forResource: "img6", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            image6.image = image
        }
        image6.layer.borderColor = UIColor.white.cgColor
        image6.layer.borderWidth = 3*(view.frame.width/417)
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
        
        
        
        //  Results of machine learning assisted hashtag generation
        
        resultsLabel = UILabel(frame: CGRect(x: margin/2, y: 8.95*margin, width: view.frame.width-margin, height: 60))
        let copyRecognizer = UITapGestureRecognizer(target: self, action: #selector(copyIt))
        resultsLabel.font = UIFont(name: "OpenSans-Regular", size: 18)
        resultsLabel.textAlignment = .center
        resultsLabel.lineBreakMode = .byWordWrapping
        resultsLabel.numberOfLines = 0
        resultsLabel.isUserInteractionEnabled = true
        resultsLabel.textColor = .white
        resultsLabel.alpha = 0
        resultsLabel.addGestureRecognizer(copyRecognizer)
        
        view.addSubview(resultsLabel)
        
        
        copiedLabel = UILabel(frame: CGRect(x: (view.bounds.width/2)-50, y: margin*10.2, width: 100, height: 20))
        let copyRecognizerLabel = UITapGestureRecognizer(target: self, action: #selector(copyIt))
        copiedLabel.font = UIFont(name: "OpenSans-Regular", size: 14)
        copiedLabel.textAlignment = .center
        copiedLabel.text = "Tap to copy!"
        copiedLabel.addGestureRecognizer(copyRecognizerLabel)
        copiedLabel.isUserInteractionEnabled = true
        copiedLabel.textColor = .white
        copiedLabel.alpha = 0
        
        view.addSubview(copiedLabel)
    }
    
    @objc internal func copyIt(_ sender : UITapGestureRecognizer) {
        UIPasteboard.general.string = resultsLabel.text
        if !copied {
            copiedLabel.fadeOutInColor(textGiven: "Copied!", colorChange: UIColor.purple)
            copied = true
        }
    }
    
    /**
        Changes the label selected by the user to have purple text and undergo a circular pulse animation.
        - parameters:
            - sender: the gesture recognizer that called the function as UITapGestureRecognizer
     */
    
    @objc internal func selectLabel(_ sender : UITapGestureRecognizer) {
        
        let labelToChange = sender.view as! UILabel
        
        for u in labels {
            if u == labelToChange {
                let pulse = pulseAnimation(numberOfPulses: 1, radius: 50, position: labelToChange.center, duration: 0.8)
                
                view.layer.insertSublayer(pulse, below: labelToChange.layer)
                
                UIView.transition(with: u, duration: 0.25, options: .transitionCrossDissolve, animations: { u.textColor = .purple }, completion: nil)
                
                numberOfHashtags = Int(u.text!)!
            } else if u.textColor == .purple {
                UIView.transition(with: u, duration: 0.25, options: .transitionCrossDissolve, animations: { u.textColor = .white }, completion: nil)
            }
        }
    }
    
    /**
        Calls the machine learning model used for the program: in this case, GoogLeNetPlaces. Based on the results and the number of hashtags requested, the resultsLabel undergoes animations and is changed to fulfill these requirements
        - parameters:
            - sender: the gesture recognizer that called the function as UITapGestureRecognizer
     */
    
    @objc internal func callMLModel(_ sender : UITapGestureRecognizer) {
        
        let imageView = sender.view as! UIImageView
        
        let pulse = pulseAnimation(numberOfPulses: 1, radius: 110, position: imageView.center, duration: 0.8)
        
        view.layer.insertSublayer(pulse, below: imageView.layer)
        
        finalHashtags = ""
        allScenes = []
        
        for u in images {
            if u == imageView && u.layer.borderColor != UIColor.purple.cgColor {
                
                let colorChange = CABasicAnimation(keyPath: "borderColor")
                colorChange.fromValue = UIColor.white.cgColor
                colorChange.toValue = UIColor.purple.cgColor
                colorChange.duration = 1
                colorChange.repeatCount = 1
                imageView.layer.borderWidth = 3
                imageView.layer.borderColor = UIColor.purple.cgColor
                imageView.layer.add(colorChange, forKey: "borderColor")

            } else if u.layer.borderColor == UIColor.purple.cgColor && u != imageView {
                
                let colorChange = CABasicAnimation(keyPath: "borderColor")
                colorChange.fromValue = UIColor.purple.cgColor
                colorChange.toValue = UIColor.white.cgColor
                colorChange.duration = 1
                colorChange.repeatCount = 1
                u.layer.borderWidth = 3
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
                                allScenes.append("#" + processingString)
                            }
                            processingString = ""
                        } else {
                            processingString += String(u)
                        }
                    }
                    
                    allScenes.append("#" + processingString)
                    processingString = ""
                    sceneLabels.removeValue(forKey: removal)
                    
                }
                
                for i in 0...numberOfHashtags-1 {
                    finalHashtags += allScenes[i] + " "
                }
            }
        }
        
        if resultsLabel.text != finalHashtags {
            let pulse2 = pulseAnimation(numberOfPulses: 1, radius: 500, position: CGPoint(x: view.bounds.width/2, y: view.bounds.height+300), duration: 1.2)
            
            view.layer.insertSublayer(pulse2, above: resultsLabel.layer)
            
            copiedLabel.fadeOutInColor(textGiven: "Tap to copy!", colorChange: UIColor.white)
            resultsLabel.fadeOutIn(textGiven: finalHashtags)
            
            copied = false
        }
    }
    
    /**
        Uses the machine learning model on the image specified,
        - parameters:
            - image: the image required for analysis by the model as UIImage
        - returns: the scenes and the probability of each scene as Dictionary<String, Double>?
     */

    func scenes (image : UIImage) -> Dictionary<String, Double>? {
        let resizedImage = image.resize()
        
        if let bufferedImage = imageProcessor.pixelBuffer(image: resizedImage.cgImage!) {
            guard let scene = try? model.prediction(sceneImage: bufferedImage) else {fatalError("Unexpected Runtime Error")}
            
            return scene.sceneLabelProbs
        }
        
        return nil
    }
    
    /**
        Finds the most probable scene
        - parameters:
            - scenery: a dictionary containing each scene and its respective probability as Dictionary<String, Double>
        - returns: the scene with the highest probability as String
     */
    
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

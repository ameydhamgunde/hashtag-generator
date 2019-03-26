//
//  Hashtag Generator
//
//  Created by Amey Dhamgunde on 2019-03-17.
//  Copyright © 2019 Amey Dhamgunde. All rights reserved.
//
//  Description: For content creators, a large part of their job is gaining recognition on various social media platforms such as Instagram, Facebook, and Twitter. One of the most effective ways to increase your outreach is through the use of hashtags, as it has the benefit that people can find your posts without relying on search and recommendation algorithms on the social media platforms or through mutual followers.
//
//  This playground, created using Xcode 10.2 on the iOS profile for the invaluable UIKit framework, aims to help content creators do just that, whether they are vloggers or photographers. When they are stuck thinking about possible and popular hashtags to add to their image, this algorithm is the solution.
//
//  The first step is to select the number of hashtags to generate, an integer between 1 and 6. The user-friendly presentation comes from the use of UILabels arranged in a row, made interactive through the use of UITapGestureRecognizers. Since IBActions are not supported in Swift playgrounds, I decided to use these gesture recognizers in a UIViewController to call a function with the @objc keyword to create pseudo-buttons. These buttons are then animated using the UIView.animate function and the CoreAnimation library to provide user feedback indicating that the button has been pressed. When one of the numbers is pressed, the logic is written to set the numberOfHashtags integer to the number selected, and animate both the current and previous selection.
//
//  The second step is to the select the image to be analyzed. In practice, this would rely on prompting the user to open their photo library and select an image that would be processed. However, given that this app will be run offline and there is no guarantee that there will be images saved on the testing platform, there have been some example pictures provided. However, the results are not hard coded. Instead, through the use of machine learning from the CoreML library, this app processes these testing images using the GoogLeNetPlaces model.
//
//  When the image is selected, the callMLModel function is called. In this function, an animation changes the border color and adds a pulse effect to the image to let the user know that the selection has been successful. The image is then passed into the scenes function in the GoogLeNetPlaces.swift file, which returns a dictionary [String: Double], representing the name of the scene and the probability of the scene. The top 6 most probable scenes are then stored in an array, the amount specified by the user later formatted as a string. At the end, the results are displayed on a UILabel using an NSMutableAttributedString for formatting.

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
    
    func fadeOutIn (textGiven: String, multiplier: CGFloat) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: { () -> Void in
            let myMutableString = NSMutableAttributedString(string: textGiven, attributes: [NSAttributedString.Key.font : UIFont(name: "OpenSans-Regular", size: 18*multiplier)!])
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

class buttonClass : UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, font: UIFont, text: String, alignment: NSTextAlignment, userinteraction: Bool, color: UIColor) {
        super.init(frame: frame)
        self.font = font
        self.text = text
        self.textAlignment = alignment
        self.isUserInteractionEnabled = userinteraction
        self.textColor = color
    }
    
    
}

class imageClass : UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    init(frame: CGRect, resource: String, borderwidth: CGFloat) {
        super.init(frame: frame)
        if let sample = Bundle.main.path(forResource: resource, ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            self.image = image
        }
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = borderwidth
        self.isUserInteractionEnabled = true
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
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
    
    var image1 = imageClass(image: UIImage(contentsOfFile: Bundle.main.path(forResource: "img1", ofType: "jpg")!))
    var image2 = imageClass(image: UIImage(contentsOfFile: Bundle.main.path(forResource: "img2", ofType: "jpg")!))
    var image3 = imageClass(image: UIImage(contentsOfFile: Bundle.main.path(forResource: "img3", ofType: "jpg")!))
    var image4 = imageClass(image: UIImage(contentsOfFile: Bundle.main.path(forResource: "img4", ofType: "jpg")!))
    var image5 = imageClass(image: UIImage(contentsOfFile: Bundle.main.path(forResource: "img5", ofType: "jpg")!))
    var image6 = imageClass(image: UIImage(contentsOfFile: Bundle.main.path(forResource: "img6", ofType: "jpg")!))
    var images : [imageClass] = []
    
    var button1 = buttonClass()
    var button2 = buttonClass()
    var button3 = buttonClass()
    var button4 = buttonClass()
    var button5 = buttonClass()
    var button6 = buttonClass()
    var labels : [buttonClass] = []
    
    var allScenes : [String] = []
    var finalHashtags = String()
    var resultsLabel = UILabel()
    var copiedLabel = UILabel()
    var copied = false
    
    var numberOfHashtags : Int = 1
    
    
    override func viewDidLoad() {
        
        self.view.frame.size = CGSize(width: 570, height: 760)  //  Chosen to fit on Macbook Air, the hardware it was created on
        
        let fontURL = Bundle.main.url(forResource: "FreightSansMedium", withExtension: "otf")
        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
        let fontURL2 = Bundle.main.url(forResource: "OpenSans-Regular", withExtension: "ttf")
        CTFontManagerRegisterFontsForURL(fontURL2! as CFURL, CTFontManagerScope.process, nil)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
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

        
        titleLabel = UILabel(frame: CGRect(x: margin/2, y: margin/3, width: view.frame.width-margin, height: 40*(self.view.frame.width/417)))
        titleLabel.text = "Hashtag Generator"
        titleLabel.font = UIFont(name: "Freight-SansMedium", size: 25*(self.view.frame.width/417))
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        
        // Setting up the instructions
        
        instruction1 = UILabel(frame: CGRect(x: margin/2, y: margin*1.25, width: view.frame.width-margin, height: 30*(self.view.frame.width/417)))
        instruction1.textColor = .white
        let mutableString1 = NSMutableAttributedString(string: "1. How many hashtags do you need?", attributes: [NSAttributedString.Key.font :UIFont(name: "OpenSans-Regular", size: 17*(self.view.frame.width/417))!])
        mutableString1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(location:0,length:2))
        instruction1.attributedText = mutableString1
        view.addSubview(instruction1)
        
        
        instruction2 = UILabel(frame: CGRect(x: margin/2, y: margin*2.75, width: view.frame.width-margin, height: 30*(self.view.frame.width/417)))
        instruction2.textColor = .white
        let mutableString2 = NSMutableAttributedString(string: "2. Which image do you need analyzed?", attributes: [NSAttributedString.Key.font :UIFont(name: "OpenSans-Regular", size: 17*(self.view.frame.width/417))!])
        mutableString2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(location:0,length:2))
        instruction2.attributedText = mutableString2
        view.addSubview(instruction2)
        
        instruction3 = UILabel(frame: CGRect(x: margin/2, y: margin*8.4, width: view.frame.width-margin, height: 30*(self.view.frame.width/417)))
        instruction3.textColor = .white
        let mutableString3 = NSMutableAttributedString(string: "3. Done!", attributes: [NSAttributedString.Key.font :UIFont(name: "OpenSans-Regular", size: 17*(self.view.frame.width/417))!])
        mutableString3.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(location:0,length:2))
        instruction3.attributedText = mutableString3
        view.addSubview(instruction3)
        
        
        //  Buttons for number of hashtags to generate
        
        let buttonWidth = (view.bounds.width-margin*2)/6
        
        button1 = buttonClass(frame: CGRect(x: margin, y: buttonRow, width: buttonWidth, height: 20*(self.view.frame.width/417)), font: UIFont(name: "OpenSans-Regular", size: 15*(self.view.frame.width/417))!, text: "1", alignment: .center, userinteraction: true, color: .purple)
        button1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectLabel)))
        
        
        button2 = buttonClass(frame: CGRect(x: margin+buttonWidth, y: buttonRow, width: buttonWidth, height: 20*(self.view.frame.width/417)), font: UIFont(name: "OpenSans-Regular", size: 15*(self.view.frame.width/417))!, text: "2", alignment: .center, userinteraction: true, color: .white)
        button2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectLabel)))
        
        
        button3 = buttonClass(frame: CGRect(x: 2*margin+buttonWidth, y: buttonRow, width: buttonWidth, height: 20*(self.view.frame.width/417)), font: UIFont(name: "OpenSans-Regular", size: 15*(self.view.frame.width/417))!, text: "3", alignment: .center, userinteraction: true, color: .white)
        button3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectLabel)))
        
        button4 = buttonClass(frame: CGRect(x: 3*margin+buttonWidth, y: buttonRow, width: buttonWidth, height: 20*(self.view.frame.width/417)), font: UIFont(name: "OpenSans-Regular", size: 15*(self.view.frame.width/417))!, text: "4", alignment: .center, userinteraction: true, color: .white)
        button4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectLabel)))
        
        button5 = buttonClass(frame: CGRect(x: 4*margin+buttonWidth, y: buttonRow, width: buttonWidth, height: 20*(self.view.frame.width/417)), font: UIFont(name: "OpenSans-Regular", size: 15*(self.view.frame.width/417))!, text: "5", alignment: .center, userinteraction: true, color: .white)
        button5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectLabel)))
        
        button6 = buttonClass(frame: CGRect(x: 5*margin+buttonWidth, y: buttonRow, width: buttonWidth, height: 20*(self.view.frame.width/417)), font: UIFont(name: "OpenSans-Regular", size: 15*(self.view.frame.width/417))!, text: "6", alignment: .center, userinteraction: true, color: .white)
        button6.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectLabel)))
        
        labels = [button1, button2, button3, button4, button5, button6]
        
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        view.addSubview(button4)
        view.addSubview(button5)
        view.addSubview(button6)
        
        
        //  Images
        
        //  The first example image was sourced from https://en.wikipedia.org/wiki/Jade_Belt_Bridge#/media/File:Gaoliang_Bridge.JPG

        image1 = imageClass(frame: CGRect(origin: CGPoint(x: margin, y: imageRow1), size: standardSize), resource: "img1", borderwidth: 3*(view.frame.width/417))
        image1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callMLModel)))
        
        
        //  The second example image was sourced from https://s3-media1.fl.yelpcdn.com/bphoto/53W4ATaHudIsoLQVE4TTug/o.jpg
        image2 = imageClass(frame: CGRect(origin: CGPoint(x: (view.frame.width/2)-margin, y: imageRow1), size: standardSize), resource: "img2", borderwidth: 3*view.frame.width/417)
        image2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callMLModel)))
        
        
        //  The third example image was sourced from https://www.visitnsw.com/sites/visitnsw/files/styles/gallery_full_width/public/2017-05/Charlotte_Pass_Ski_Resort%2C_Kosciuszko_National_Park._Photo_by_S_Pawsey_and_Charlotte_Pass_Village_Pty_Ltd.jpg?itok=JH3vpdTc
        image3 = imageClass(frame: CGRect(origin: CGPoint(x: view.frame.width-(view.frame.width/417)*50-2*margin, y: imageRow1), size: standardSize), resource: "img3", borderwidth: 3*(view.frame.width/417))
        image3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callMLModel)))

        
        //  The fourth example image was sourced from https://www.canyontours.com/wp-content/uploads/2014/10/grand-canyon-west-rim-colorado-river-500x500.jpg
        image4 = imageClass(frame: CGRect(origin: CGPoint(x: margin, y: imageRow2), size: standardSize), resource: "img4", borderwidth: 3*(view.frame.width/417))
        image4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callMLModel)))
        
        
        //  The fifth example image was sourced from http://www.tunisiesoir.com/wp-content/uploads/2019/02/190218153155_1_540x360.jpg
        image5 = imageClass(frame: CGRect(origin: CGPoint(x: (view.frame.width/2)-margin, y: imageRow2), size: standardSize), resource: "img5", borderwidth: 3*(view.frame.width/417))
        image5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callMLModel)))
        
        //  The sixth example image was sourced from https://i2.wp.com/www.alabamanewscenter.com/wp-content/uploads/2018/04/alabama-power-smart-house00029.jpg?ssl=1
        image6 = imageClass(frame: CGRect(origin: CGPoint(x: view.frame.width-(view.frame.width/417)*50-margin*2, y: imageRow2), size: standardSize), resource: "img6", borderwidth: 3*(view.frame.width/417))
        image6.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callMLModel)))
        
        
        view.addSubview(image1)
        view.addSubview(image2)
        view.addSubview(image3)
        view.addSubview(image4)
        view.addSubview(image5)
        view.addSubview(image6)
        images = [image1, image2, image3, image4, image5, image6]
        
        
        
        //  Results of machine learning assisted hashtag generation
        
        resultsLabel = UILabel(frame: CGRect(x: margin/2, y: 8.95*margin, width: view.frame.width-margin, height: 60*(self.view.frame.width/417)))
        resultsLabel.font = UIFont(name: "OpenSans-Regular", size: 18*(self.view.frame.width/417))
        resultsLabel.textAlignment = .center
        resultsLabel.lineBreakMode = .byWordWrapping
        resultsLabel.numberOfLines = 0
        resultsLabel.isUserInteractionEnabled = true
        resultsLabel.textColor = .white
        resultsLabel.alpha = 0
        resultsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(copyIt)))
        
        view.addSubview(resultsLabel)
        
        
        copiedLabel = UILabel(frame: CGRect(x: (view.bounds.width/2)-50*(view.frame.width/417), y: margin*10.2, width: 100*(self.view.frame.width/417), height: 20*(self.view.frame.width/417)))
        copiedLabel.font = UIFont(name: "OpenSans-Regular", size: 14*(self.view.frame.width/417))
        copiedLabel.textAlignment = .center
        copiedLabel.text = "Tap to copy!"
        copiedLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(copyIt)))
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
        
        view.layer.insertSublayer(pulseAnimation(numberOfPulses: 1, radius: 110*(self.view.frame.width/417), position: imageView.center, duration: 0.8), below: imageView.layer)
        
        finalHashtags = ""
        allScenes = []
        
        for u in images {
            if u == imageView && u.layer.borderColor != UIColor.purple.cgColor {
                
                let colorChange = CABasicAnimation(keyPath: "borderColor")
                colorChange.fromValue = UIColor.white.cgColor
                colorChange.toValue = UIColor.purple.cgColor
                colorChange.duration = 1
                colorChange.repeatCount = 1
                imageView.layer.borderWidth = 3*(self.view.frame.width/417)
                imageView.layer.borderColor = UIColor.purple.cgColor
                imageView.layer.add(colorChange, forKey: "borderColor")

            } else if u.layer.borderColor == UIColor.purple.cgColor && u != imageView {
                
                let colorChange = CABasicAnimation(keyPath: "borderColor")
                colorChange.fromValue = UIColor.purple.cgColor
                colorChange.toValue = UIColor.white.cgColor
                colorChange.duration = 1
                colorChange.repeatCount = 1
                u.layer.borderWidth = 3*(self.view.frame.width/417)
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
            view.layer.insertSublayer(pulseAnimation(numberOfPulses: 1, radius: 500*(self.view.frame.width/417), position: CGPoint(x: view.bounds.width/2, y: view.bounds.height+250*(self.view.frame.width/417)), duration: 1.2), above: resultsLabel.layer)
            
            copiedLabel.fadeOutInColor(textGiven: "Tap to copy!", colorChange: UIColor.white)
            resultsLabel.fadeOutIn(textGiven: finalHashtags, multiplier: (self.view.frame.width/417))
            
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

PlaygroundPage.current.liveView = vc.view

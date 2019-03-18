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

//  Setting up the view that will be used to interact with the application. The dimensions have been set to that of the iPad Pro.
let view = UIView(frame: CGRect(x: 0, y: 0, width: 834, height:1112))
view.backgroundColor = .white

let standardSize = CGSize(width: 100, height: 100)

//  Image 1
let image1 = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: standardSize))

if let sample = Bundle.main.path(forResource: "img1", ofType: "jpg") {
    let image = UIImage(contentsOfFile: sample)
    image1.image = image
}

view.addSubview(image1)

//  Image 2

let image2 = UIImageView(frame: CGRect(origin: CGPoint(x: 200, y: 200), size: standardSize))

if let sample = Bundle.main.path(forResource: "img2", ofType: "jpg") {
    let image = UIImage(contentsOfFile: sample)
    image2.image = image
}

//  Image 3

let image3 = UIImageView(frame: CGRect(origin: CGPoint(x: 200, y: 200), size: standardSize))

if let sample = Bundle.main.path(forResource: "img3", ofType: "jpg") {
    let image = UIImage(contentsOfFile: sample)
    image2.image = image
}


//  Image 4

let image4 = UIImageView(frame: CGRect(origin: CGPoint(x: 200, y: 200), size: standardSize))

if let sample = Bundle.main.path(forResource: "img4", ofType: "jpg") {
    let image = UIImage(contentsOfFile: sample)
    image2.image = image
}



//  Image 5

let image5 = UIImageView(frame: CGRect(origin: CGPoint(x: 200, y: 200), size: standardSize))

if let sample = Bundle.main.path(forResource: "img5", ofType: "jpg") {
    let image = UIImage(contentsOfFile: sample)
    image2.image = image
}



//  Image 6

let image6 = UIImageView(frame: CGRect(origin: CGPoint(x: 200, y: 200), size: standardSize))

if let sample = Bundle.main.path(forResource: "img6", ofType: "jpg") {
    let image = UIImage(contentsOfFile: sample)
    image2.image = image
}

let model = GoogLeNetPlaces()


//  Used to resize images that are too large for the GoogLeNetPlaces neural network to handle.
//  Knowing that the maximum image size processable is 224x224, we can safely resize to 200x200.

extension UIImage {
    func resize() -> UIImage {
        let targetSize = CGSize.init(width: 200, height: 200)
        
        let size = self.size
        let widthRatio = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


PlaygroundPage.current.liveView = view

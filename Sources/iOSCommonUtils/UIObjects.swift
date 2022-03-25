//
//  File.swift
//  
//
//  Created by Lee Yen Lin on 2022/2/10.
//
import UIKit

/// rgb to UIColor
///
/// rgbValue = 0xAEAEAE
public extension UIColor{
    static func rgbToUIColor(_ rgbValue: Int) -> UIColor {
        return UIColor(
            red: CGFloat((Float((rgbValue & 0xff0000) >> 16)) / 255.0),
            green: CGFloat((Float((rgbValue & 0x00ff00) >> 8)) / 255.0),
            blue: CGFloat((Float((rgbValue & 0x0000ff) >> 0)) / 255.0),
            alpha: 1.0)
    }
}

extension UIImage{
    func resizeImage(_ maxEdgeLength: CGFloat) -> UIImage {
        if (self.size.width > self.size.height && self.size.width <= maxEdgeLength) || (self.size.width < self.size.height && self.size.height <= maxEdgeLength) {
            return self
        }
        
        var size = CGSize(width: maxEdgeLength, height:
                            self.size.height * maxEdgeLength / self.size.width)
        if self.size.width < self.size.height{
            size = CGSize(width: self.size.width * maxEdgeLength / self.size.height, height: maxEdgeLength)
        }
        //        let renderer = UIGraphicsImageRenderer(size: size)
        //        let newImage = renderer.image { (context) in
        //            image.draw(in: renderer.format.bounds)
        //        }
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

final public class ViewUtils{
    public static var screenWidth: CGFloat{
        UIScreen.main.bounds.width
    }
    
    public static var screenHeight: CGFloat{
        UIScreen.main.bounds.height
    }
    
    public static var safeAreaInsets : UIEdgeInsets?{
        get{
            return UIApplication.shared.windows.first?.safeAreaInsets
        }
    }
}

public extension UIView {
    func roundCorners(_ radius: CGFloat, corners: CACornerMask) {
        self.layer.maskedCorners = CACornerMask(arrayLiteral: corners)
        self.layer.cornerRadius = radius
    }
    
    func toImage() -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let img = renderer.image { ctx in
            layer.render(in: ctx.cgContext)
            //            drawHierarchy(in: frame, afterScreenUpdates: true)
        }
        return img
    }
}

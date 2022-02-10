//
//  File.swift
//  
//
//  Created by Lee Yen Lin on 2022/2/10.
//

import Foundation
import UIKit

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
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        self.layer.maskedCorners = corners
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

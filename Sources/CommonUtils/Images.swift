//
//  File.swift
//  
//
//  Created by Lee Yen Lin on 2022/2/10.
//
import UIKit

public class Images{
    public static func resizeImage(image: UIImage, maxEdge: CGFloat) -> UIImage {
        if (image.size.width > image.size.height && image.size.width <= maxEdge) || (image.size.width < image.size.height && image.size.height <= maxEdge) {
            return image
        }
        
        var size = CGSize(width: maxEdge, height:
                            image.size.height * maxEdge / image.size.width)
        if image.size.width < image.size.height{
            size = CGSize(width: image.size.width * maxEdge / image.size.height, height: maxEdge)
        }
        //        let renderer = UIGraphicsImageRenderer(size: size)
        //        let newImage = renderer.image { (context) in
        //            image.draw(in: renderer.format.bounds)
        //        }
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

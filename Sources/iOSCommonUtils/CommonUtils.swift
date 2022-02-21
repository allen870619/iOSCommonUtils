//
//  File.swift
//  
//
//  Created by Lee Yen Lin on 2022/2/10.
//

import UIKit

func UIColorFromRGB(_ rgbValue: Int) -> UIColor! {
    return UIColor(
        red: CGFloat((Float((rgbValue & 0xff0000) >> 16)) / 255.0),
        green: CGFloat((Float((rgbValue & 0x00ff00) >> 8)) / 255.0),
        blue: CGFloat((Float((rgbValue & 0x0000ff) >> 0)) / 255.0),
        alpha: 1.0)
}

public class Line{
    public func shareLineMsg(_ msg: String?, copying: Bool = true){
        if let msg = msg {
            // write to clipboard
            if copying{
                UIPasteboard.general.string = msg
            }
            
            let content = msg.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let content = content {
                let application = UIApplication.shared
                let shareURL = URL(string: "https://line.me/R/msg/text/?\(content)")!
                if application.canOpenURL(shareURL){
                    application.open(shareURL, options: [:], completionHandler: nil)
                }else{
                    let lineURL = URL(string: "https://line.me/R/")!
                    application.open(lineURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
}

private func test() -> String{
    return "Hello, World!"
}

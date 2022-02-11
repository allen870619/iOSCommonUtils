//
//  File.swift
//  
//
//  Created by Lee Yen Lin on 2022/2/10.
//

import Foundation
import UIKit

open class KBShifterViewController: UIViewController{
    fileprivate var kbData = KeyboardData()
    
    // set mode
    public enum ShiftMode{
        case absolute
        case safeArea
        case scrollView
    }
    
    public var shiftMode: ShiftMode = .safeArea{
        didSet{
            unSubscribe()
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    // targetView
    public var kbTargetView: UIView?{
        set{
            kbData.currentUIView = newValue
        }
        get{
            kbData.currentUIView
        }
    }
    
    public func unSubscribe(){
        kbData.currentUIView = nil
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /* move up screen when showing keyboard */
    @objc public func keyboardWillShow(note: NSNotification) {
        if let currentView = kbData.currentUIView {
            // keyboard info
            let userInfo = note.userInfo!
            let kbHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            
            // target view
            let targetY = currentView.superview?.convert(currentView.frame, to: self.view).maxY ?? 0
            let visibleRectWithoutKeyboard = ViewUtils.screenHeight - kbHeight
            
            // check whether has been covered
            if targetY >= visibleRectWithoutKeyboard {
                switch shiftMode{
                case .safeArea:
                    let shift :CGFloat = (targetY - visibleRectWithoutKeyboard) + kbData.offset + kbData.moreOffset
                    UIView.animate(withDuration: duration){[self] in
                        self.additionalSafeAreaInsets.bottom = shift
                        self.view.layoutIfNeeded()
                    }
                case .scrollView:
                    guard let scrollView = kbTargetView as? UIScrollView else{
                        return
                    }
                    let navShift = self.navigationController?.navigationBar.frame.maxY ?? 0
                    scrollView.contentInset.bottom = targetY - visibleRectWithoutKeyboard + kbData.offset + kbData.moreOffset + navShift
                case .absolute: // not recommand
                    var rect = self.view.frame
                    /* 計算上移距離 */
                    rect.origin.y -= (targetY - visibleRectWithoutKeyboard) + kbData.offset + kbData.moreOffset
                    UIView.animate(withDuration: duration){
                        self.view.frame = rect
                    }
                }
            }
        }
    }
    
    /* move down screen when showing keyboard */
    @objc public func keyboardWillHide(note: NSNotification) {
        /* 鍵盤隱藏時將畫面下移回原樣 */
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(truncating: keyboardAnimationDetail[UIResponder.keyboardAnimationDurationUserInfoKey]! as! NSNumber)
        UIView.animate(withDuration: duration){[self] in
            switch shiftMode{
            case .safeArea:
                self.additionalSafeAreaInsets.bottom = 0
                self.view.layoutIfNeeded()
            case .scrollView:
                guard let scrollView = kbTargetView as? UIScrollView else{
                    return
                }
                scrollView.contentInset.bottom = .zero
            case .absolute:
                if self.view.frame.origin.y < 0{
                    self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.origin.y)
                }
            }
        }completion: { [self] _ in
            if shiftMode != .scrollView{
                kbData.currentUIView = nil
            }
        }
    }
}

public extension UIViewController{
    func tapToHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

private struct KeyboardData{
    // offest
    let offset :CGFloat = 16
    var moreOffset :CGFloat = 0
    
    // view
    var currentUIView : UIView?
}

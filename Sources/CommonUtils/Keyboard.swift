//
//  File.swift
//  
//
//  Created by Lee Yen Lin on 2022/2/10.
//

import Foundation
import UIKit


struct keyboardData{
    static let offset :CGFloat = 16
    static var moreOffset :CGFloat = 0
    /* 暫存輸入框元件 */
    static var currentUIView : UIView?
    /* 暫存 View 的範圍 */
    static var rect : CGRect?
    static var viewController : UIViewController!
    static var scrollView: UIScrollView?
    
    static func isDataNil() -> Bool{
        return currentUIView == nil || rect == nil || viewController == nil
    }
}

class KeyboardUtils{
    init(viewController: UIViewController){
        keyboardData.viewController = viewController
        keyboardData.rect = viewController.view.frame
    }
    
    //targetTextField
    func setTargetView(_ view: UIView?, moreOffset : CGFloat = 0) {
        keyboardData.currentUIView = view
        keyboardData.moreOffset = moreOffset
    }
    
    var targetView :UIView?{
        get{
            return keyboardData.currentUIView
        }
    }
}

extension UIViewController{
    /*
     Set observer and target tf to use move up/down
     Use BaseViewController to enable this feature
     
     keyboard = KeyboardUtils(viewController: self)
     keyboard.setRect(rect: view.bounds)
     
     NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
     NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
     */
    
    /* move up screen when showing keyboard */
    @objc func keyboardWillShow(note: NSNotification) {
        if(keyboardData.isDataNil()){
            return
        }
        
        if let currentTextField = keyboardData.currentUIView {
            let userInfo = note.userInfo!
            /* 取得鍵盤尺寸 */
            let keyboard = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            /* 計算輸入框最底部Y座標，原Y座標為上方位置，需要加上高度 */
            let targetY = currentTextField.frame.maxY
            /* 計算扣除鍵盤高度後的可視高度 */
            let visibleRectWithoutKeyboard = ViewUtils.screenHeight - keyboard.height
            /* 如果輸入框Y座標在可視高度外，表示鍵盤已擋住輸入框 */
            if targetY >= visibleRectWithoutKeyboard {
                var rect = keyboardData.rect!
                /* 計算上移距離 */
                rect.origin.y -= (targetY - visibleRectWithoutKeyboard) + keyboardData.offset + keyboardData.moreOffset
                UIView.animate(withDuration: duration){
                    self.view.frame = rect
                }
            }
        }
    }
    
    /* move down screen when showing keyboard */
    @objc func keyboardWillHide(note: NSNotification) {
        /* 鍵盤隱藏時將畫面下移回原樣 */
        if(keyboardData.isDataNil()){
            return
        }
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(truncating: keyboardAnimationDetail[UIResponder.keyboardAnimationDurationUserInfoKey]! as! NSNumber)
        if self.view.frame.origin.y < 0{
            UIView.animate(withDuration: duration){
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.origin.y)
            }completion: { _ in
                keyboardData.currentUIView = nil
            }
        }
    }
    
    /* move up screen when showing keyboard */
    @objc func keyboardWillShowSafe(note: NSNotification) {
        if(keyboardData.isDataNil()){
            return
        }
        
        if let currentTextField = keyboardData.currentUIView {
            let userInfo = note.userInfo!
            /* 取得鍵盤尺寸 */
            let keyboard = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            /* 計算輸入框最底部Y座標，原Y座標為上方位置，需要加上高度 */
            let targetY = currentTextField.superview?.convert(currentTextField.frame, to: nil).maxY ?? 0
            /* 計算扣除鍵盤高度後的可視高度 */
            let visibleRectWithoutKeyboard = ViewUtils.screenHeight - keyboard.height
            /* 如果輸入框Y座標在可視高度外，表示鍵盤已擋住輸入框 */
            if targetY >= visibleRectWithoutKeyboard {
                /* 計算上移距離 */
                let shift :CGFloat = (targetY - visibleRectWithoutKeyboard) + keyboardData.offset + keyboardData.moreOffset
                UIView.animate(withDuration: duration){
                    self.additionalSafeAreaInsets.bottom = shift
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    /* move down screen when showing keyboard */
    @objc func keyboardWillHideSafe(note: NSNotification) {
        /* 鍵盤隱藏時將畫面下移回原樣 */
        if(keyboardData.isDataNil()){
            return
        }
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(truncating: keyboardAnimationDetail[UIResponder.keyboardAnimationDurationUserInfoKey]! as! NSNumber)
        UIView.animate(withDuration: duration){
            self.additionalSafeAreaInsets.bottom = 0
            self.view.layoutIfNeeded()
        }completion: { _ in
            keyboardData.currentUIView = nil
        }
    }
    
    /* move up screen when showing keyboard */
    @objc func keyboardWillShowScroll(note: NSNotification) {
        if(keyboardData.isDataNil()){
            return
        }
        
        if let currentView = keyboardData.currentUIView {
            let userInfo = note.userInfo!
            /* 取得鍵盤尺寸 */
            let keyboard = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
            /* 計算輸入框最底部Y座標，原Y座標為上方位置，需要加上高度 */
            let targetY = currentView.superview?.convert(currentView.frame, to: nil).maxY ?? 0
            /* 計算扣除鍵盤高度後的可視高度 */
            let visibleRectWithoutKeyboard = ViewUtils.screenHeight - keyboard.height
            /* 如果輸入框Y座標在可視高度外，表示鍵盤已擋住輸入框 */
            if targetY >= visibleRectWithoutKeyboard {
                /* 計算上移距離 */
                let viewOriY = currentView.superview?.convert(currentView.frame, to: keyboardData.scrollView).minY ?? 0
                let navShift = self.navigationController?.navigationBar.frame.maxY ?? 0
                let shift :CGFloat = (viewOriY - (visibleRectWithoutKeyboard - currentView.frame.height)) + keyboardData.offset + keyboardData.moreOffset + navShift
                keyboardData.scrollView?.contentInset.bottom = keyboard.height
                keyboardData.scrollView?.setContentOffset(CGPoint(x: 0, y: shift), animated: true)
            }
        }
    }
    
    /* move down screen when showing keyboard */
    @objc func keyboardWillHideScroll(note: NSNotification) {
        /* 鍵盤隱藏時將畫面下移回原樣 */
        if(keyboardData.isDataNil()){
            return
        }
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(truncating: keyboardAnimationDetail[UIResponder.keyboardAnimationDurationUserInfoKey]! as! NSNumber)
        UIView.animate(withDuration: duration){
            keyboardData.scrollView?.contentInset.bottom = .zero
        }completion: { _ in
            keyboardData.currentUIView = nil
        }
    }
    
    /* tap to hide keyboard */
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

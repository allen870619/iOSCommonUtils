//
//  File.swift
//  
//
//  Created by Lee Yen Lin on 2022/2/10.
//

import Foundation
import UIKit

open class KBShifterViewController: UIViewController{
    
    // set mode
    public enum ShiftMode{
        /**
         All method's shift space are the height of the range been covered by keyboard + 16. (except kbHieght)
         shift = (covered height) + 16 + moreOffset(default 0)
         */
        // Use when view align to superview
        case absolute
        // Use when view align to safe area
        case safeArea
        // for scrollView
        case scrollView
        // Fixed, shift = keyboard height
        case kbHeight
    }
    
    /*
     Steps
     1. Set desire shift mode.
     2. Set target view when some inputView begin edit. (no needed for kbHeight)
     (optional)  set moreOffset, default = 0
     3. Kill observer when leave.
     */
    public var shiftMode: ShiftMode = .safeArea{
        didSet{
            unSubscribe()
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    // targetView
    public func setKbTargetView(_ view: UIView?, moreOffset: CGFloat = 0){
        kbData.currentUIView = view
        kbData.moreOffset = moreOffset
    }
    
    // more offset for shift
    public var moreOffset: CGFloat{
        set{
            kbData.moreOffset = newValue
        }
        get{
            kbData.moreOffset
        }
    }
    
    // kill observer
    public func unSubscribe(){
        kbData.currentUIView = nil
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /** private parts*/
    fileprivate var kbData = KeyboardData()
    
    /* move up screen when showing keyboard */
    @objc public func keyboardWillShow(note: NSNotification) {
        // keyboard info
        let userInfo = note.userInfo!
        let kbHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        // shift detect
        if shiftMode == .kbHeight{
            let shift :CGFloat = kbHeight + kbData.moreOffset
            UIView.animate(withDuration: duration){ [weak self] in
                self?.additionalSafeAreaInsets.bottom = shift
                self?.view.layoutIfNeeded()
            }
            return
        }
        
        if let currentView = kbData.currentUIView {
            // clear previous shift
            if shiftMode == .safeArea{
                additionalSafeAreaInsets.bottom = 0
                view.layoutIfNeeded()
            }else if shiftMode == .absolute{
                view.frame = view.frame.offsetBy(dx: 0, dy: -view.frame.origin.y)
            }
            
            // target view
            let targetY = view.convert(currentView.frame, to: view).maxY
            let visibleRectWithoutKeyboard = ViewUtils.screenHeight - kbHeight
            let coverHeight = targetY - visibleRectWithoutKeyboard
            
            // check whether has been covered
            if coverHeight >= 0 {
                switch shiftMode{
                case .safeArea:
                    let shift = coverHeight + kbData.offset + kbData.moreOffset
                    UIView.animate(withDuration: duration){[weak self] in
                        self?.additionalSafeAreaInsets.bottom = shift
                        self?.view.layoutIfNeeded()
                    }
                case .scrollView:
                    guard let scrollView = kbData.currentUIView as? UIScrollView else{
                        return
                    }
                    scrollView.contentInset.bottom = coverHeight + kbData.offset + kbData.moreOffset
                case .absolute: // not recommended
                    var rect = view.frame
                    let saveAreaBot = ViewUtils.safeAreaInsets?.bottom ?? 0
                    let shift = coverHeight + kbData.offset + kbData.moreOffset
                    rect.origin.y = -(shift + saveAreaBot)
                    UIView.animate(withDuration: duration){[weak self] in
                        self?.view.frame = rect
                    }
                case .kbHeight:
                    break
                }
            }
        }
    }
    
    /* move down screen when showing keyboard */
    @objc public func keyboardWillHide(note: NSNotification) {
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(truncating: keyboardAnimationDetail[UIResponder.keyboardAnimationDurationUserInfoKey]! as! NSNumber)
        
        UIView.animate(withDuration: duration){[weak self] in
            switch self?.shiftMode{
            case .safeArea, .kbHeight:
                self?.additionalSafeAreaInsets.bottom = 0
                self?.view.layoutIfNeeded()
            case .scrollView:
                (self?.kbData.currentUIView as? UIScrollView)?.contentInset.bottom = .zero
            case .absolute:
                if let vc = self{
                    if vc.view.frame.origin.y < 0{
                        self?.view.frame = vc.view.frame.offsetBy(dx: 0, dy: -vc.view.frame.origin.y)
                    }
                }
            case .none:
                break
            }
        }completion: { [self] _ in
            if !(kbData.currentUIView is UIScrollView) && shiftMode != .scrollView{
                kbData.currentUIView = nil // clear target view
            }
        }
    }
}

private struct KeyboardData{
    // offest
    let offset :CGFloat = 16
    var moreOffset :CGFloat = 0
    
    // view
    var currentUIView : UIView?
}

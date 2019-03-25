//
//  SwipeGestureRecognizerClosureWrapper.swift
//  Doufu
//
//  Created by 鑫翼資訊 on 2018/5/30.
//  Copyright © 2018年 SinyiTech. All rights reserved.
//

import Foundation
import UIKit

typealias UIViewGestureRecognizerClosure = (UISwipeGestureRecognizer) -> ()

class GestureRecognizerClosureWrapper: NSObject {
    let gestureClosure: UIViewGestureRecognizerClosure
    init(_ gestureClosure: @escaping UIViewGestureRecognizerClosure) {
        self.gestureClosure = gestureClosure
    }
}

extension UIView {
    
    private struct AssociatedKeys {
        static var targetGestureClosure = "targetGestureClosure"
    }
    
    private var targetGestureClosure: UIViewGestureRecognizerClosure? {
        get {
            guard let GestureRecognizerClosureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetGestureClosure) as? GestureRecognizerClosureWrapper else { return nil }
            return GestureRecognizerClosureWrapper.gestureClosure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetGestureClosure, GestureRecognizerClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargetGestureClosure(gestureClosure: @escaping UIViewGestureRecognizerClosure) {
        targetGestureClosure = gestureClosure
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(UIView.gestureClosureAction(gestureRecognizer:)))
        leftSwipeGesture.direction = UISwipeGestureRecognizer.Direction.left
        addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(UIView.gestureClosureAction(gestureRecognizer:)))
        rightSwipeGesture.direction = UISwipeGestureRecognizer.Direction.right
        addGestureRecognizer(rightSwipeGesture)
        
        let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(UIView.gestureClosureAction(gestureRecognizer:)))
        upSwipeGesture.direction = UISwipeGestureRecognizer.Direction.up
        addGestureRecognizer(upSwipeGesture)
        
        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(UIView.gestureClosureAction(gestureRecognizer:)))
        downSwipeGesture.direction = UISwipeGestureRecognizer.Direction.down
        addGestureRecognizer(downSwipeGesture)
    }
    
    @objc func gestureClosureAction(gestureRecognizer: UISwipeGestureRecognizer) {
        guard let targetGestureClosure = targetGestureClosure else { return }
        targetGestureClosure(gestureRecognizer)
    }
    
}

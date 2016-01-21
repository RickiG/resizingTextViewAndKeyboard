//
//  ViewController.swift
//  ReSizingTextViewPoC
//
//  Created by Ricki Gregersen on 21/01/16.
//  Copyright © 2016 youandthegang.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    
    let minHeightTextView: CGFloat = 50
    let maxHeightTextView: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.text = ""
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillChangeFrame:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        keyboardHeightConstraint.constant = 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Keyboard notifications
    
    func keyboardWillChangeFrame(n: NSNotification) {
        
        var height: CGFloat = 0
        var duration: NSTimeInterval = 0
        let option = UIViewAnimationOptions.CurveEaseInOut
        
        if let rect = n.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue {
            height = rect.size.height
        }
        
        if let interval = n.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
            duration = interval
        }
        
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(duration, delay: 0, options: option, animations: { () -> Void in
            
            self.keyboardHeightConstraint.constant = height
            self.view.layoutIfNeeded()
            
            }) { (complete) -> Void in
        }
    }
    
    func reSizeTextView(textView: UITextView) {
        
        view.layoutIfNeeded()
        var height = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: CGFloat.max)).height + 10
        
//        var height = textView.intrinsicContentSize().height
        
        if height < minHeightTextView {
            height = minHeightTextView
        }
        
        if height > maxHeightTextView {
            height = maxHeightTextView
            textView.scrollEnabled = true
        } else {
            textView.scrollEnabled = false
        }
        
        textViewHeightConstraint.constant = height + 10
        
        UIView.animateWithDuration(0.1) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        
        reSizeTextView(textView)
    }
}


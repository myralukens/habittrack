//
//  ViewController.swift
//  habittrack
//
//  Created by Myra Lukens on 4/25/17.
//  Copyright © 2017 Myra Lukens. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITextViewDelegate {
  @IBOutlet weak var jawL: UISwitch!
  @IBOutlet weak var jawR: UISwitch!
  @IBOutlet weak var eyebr: UISwitch!
  @IBOutlet weak var chin: UISwitch!
  @IBOutlet weak var trigger: UITextView!
  @IBOutlet weak var conseq: UITextView!
  @IBOutlet weak var scrollView: UIScrollView!
  var activeView: UITextView?
  var keyboardRect: CGRect?
  var activeFieldRect: CGRect?

  let trigEmptyDescription = "When it occurred, what was happening? Feelings? Thoughts?"
  let conseqEmptyDescription = "What were the consequences? Positive/negative"

  let ref = FIRDatabase.database().reference()

  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = true
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view, typically from a nib.
    trigger.delegate = self
    conseq.delegate = self

    trigger.text = "When it occurred, what was happening? Feelings? Thoughts?"
    trigger.textColor = UIColor.lightGray

    conseq.text = "What were the consequences? Positive/negative"
    conseq.textColor = UIColor.lightGray

    jawL.setOn(false, animated: false)
    jawR.setOn(false, animated: false)
    eyebr.setOn(false, animated: false)
    chin.setOn(false, animated: false)

    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    view.addGestureRecognizer(tap)

    registerForKeyboardNotifications()
    scrollView?.frame = self.view.frame
    scrollView?.isScrollEnabled = false
    scrollView?.showsVerticalScrollIndicator = false
    scrollView?.showsHorizontalScrollIndicator = false
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func viewDidLayoutSubviews() {
    scrollView?.sizeToFit()
    scrollView?.contentSize = (scrollView?.frame.size)!
    super.viewDidLayoutSubviews()
  }

  deinit {
    self.deregisterFromKeyboardNotifications()
  }

  func registerForKeyboardNotifications() {
    //Adding notifies on keyboard appearing
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(ScrollingFormViewController.keyboardWasShown),
                                           name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(ScrollingFormViewController.keyboardWillBeHidden),
                                           name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }

  func deregisterFromKeyboardNotifications() {
    //Removing notifies on keyboard appearing
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }

  func keyboardWasShown(notification: NSNotification) {
    let info: NSDictionary = notification.userInfo! as NSDictionary
    keyboardRect = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    adjustForKeyboard()
  }


  func keyboardWillBeHidden(notification: NSNotification) {
    keyboardRect = nil
    adjustForKeyboard()
  }

  func adjustForKeyboard() {
    if keyboardRect != nil && activeFieldRect != nil {
      let aRect: CGRect = scrollView!.convert(activeFieldRect!, to: nil)
      if (keyboardRect!.contains(CGPoint(x: aRect.origin.x, y: aRect.maxY))) {
        scrollView?.isScrollEnabled = true
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardRect!.size.height, 0.0)
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
        scrollView?.scrollRectToVisible(activeFieldRect!, animated: true)
      }
    } else {
      let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
      scrollView?.contentInset = contentInsets
      scrollView?.scrollIndicatorInsets = contentInsets
      scrollView?.isScrollEnabled = false
    }
  }

  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    activeFieldRect = textView.frame
    adjustForKeyboard()

    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
    return true
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    activeFieldRect = nil

    if textView.text.isEmpty {
      if textView == trigger {
        textView.text = trigEmptyDescription
      } else {
        textView.text = conseqEmptyDescription
      }

      textView.textColor = UIColor.lightGray
    }

    adjustForKeyboard()
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeFieldRect = textField.frame
    adjustForKeyboard()
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    activeFieldRect = nil
    adjustForKeyboard()
  }

  func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
  }


  @IBAction func trackTapped(_ sender: Any) {
    // save to database
    let date = Date()
    let calendar = Calendar.current

    let dateformatted = "\(calendar.component(.month, from: date))-\(calendar.component(.day, from: date))-\(calendar.component(.year, from: date))"
    let time = "\(calendar.component(.hour, from: date)):\(calendar.component(.minute, from: date)):\(calendar.component(.second, from: date))"

    if trigger.text == trigEmptyDescription {
      trigger.text = ""
    }

    if conseq.text == conseqEmptyDescription {
      conseq.text = ""
    }

    if jawL.isOn {
      let newTrig = ref.child("\(dateformatted)/jawL/\(time)/trigger")
      newTrig.setValue(trigger.text)
      let newConseq = ref.child("\(dateformatted)/jawL/\(time)/consequence")
      newConseq.setValue(conseq.text)

      jawL.setOn(false, animated: false)
    }

    if jawR.isOn {
      let newTrig = ref.child("\(dateformatted)/jawR/\(time)/trigger")
      newTrig.setValue(trigger.text)
      let newConseq = ref.child("\(dateformatted)/jawR/\(time)/consequence")
      newConseq.setValue(conseq.text)

      jawR.setOn(false, animated: false)
    }

    if eyebr.isOn {
      let newTrig = ref.child("\(dateformatted)/eyebrow/\(time)/trigger")
      newTrig.setValue(trigger.text)
      let newConseq = ref.child("\(dateformatted)/eyebrow/\(time)/consequence")
      newConseq.setValue(conseq.text)

      eyebr.setOn(false, animated: false)
    }

    if chin.isOn {
      let newTrig = ref.child("\(dateformatted)/chin/\(time)/trigger")
      newTrig.setValue(trigger.text)
      let newConseq = ref.child("\(dateformatted)/chin/\(time)/consequence")
      newConseq.setValue(conseq.text)

      chin.setOn(false, animated: false)
    }

    trigger.text = trigEmptyDescription
    trigger.textColor = UIColor.lightGray

    conseq.text = conseqEmptyDescription
    conseq.textColor = UIColor.lightGray

    self.navigationController?.isNavigationBarHidden = false
  }
}

//
//  ViewController.swift
//  habittrack
//
//  Created by Myra Lukens on 4/25/17.
//  Copyright © 2017 Myra Lukens. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
  @IBOutlet weak var jawL: UISwitch!
  @IBOutlet weak var jawR: UISwitch!
  @IBOutlet weak var eyebr: UISwitch!
  @IBOutlet weak var chin: UISwitch!
  @IBOutlet weak var trigger: UITextView!
  @IBOutlet weak var conseq: UITextView!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    trigger.delegate = self
    conseq.delegate = self

    trigger.text = "Placeholder"
    trigger.textColor = UIColor.lightGray

    conseq.text = "Placeholder"
    conseq.textColor = UIColor.lightGray

    jawL.setOn(false, animated: false)
    jawR.setOn(false, animated: false)
    eyebr.setOn(false, animated: false)
    chin.setOn(false, animated: false)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "Placeholder"
      textView.textColor = UIColor.lightGray
    }
  }

  @IBAction func trackTapped(_ sender: Any) {
    // save to database
  }

}


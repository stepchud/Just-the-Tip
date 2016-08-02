//
//  SplitBillViewController.swift
//  Just the Tip
//
//  Created by Stephen Chudleigh on 8/1/16.
//  Copyright © 2016 Stephen Chudleigh. All rights reserved.
//

import UIKit

class SplitBillViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var partySizePicker: UIPickerView!
    @IBOutlet weak var splitItButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize party size picker
        partySizePicker.dataSource = self
        partySizePicker.delegate = self
    }

    @IBAction func onSplitItPressed(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let partySize = partySizePicker.selectedRowInComponent(0) + 1
        defaults.setInteger(partySize, forKey: "partySize")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView == partySizePicker {
            return 1
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if pickerView == partySizePicker {
            return 10
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }

}

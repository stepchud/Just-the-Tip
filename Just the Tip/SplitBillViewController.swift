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
    @IBOutlet weak var partyOfLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize party size picker
        partySizePicker.dataSource = self
        partySizePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // update color scheme
        let scheme = currentColorScheme()
        self.view.backgroundColor = scheme.bg
        self.partyOfLabel.textColor = scheme.fg
    }

    @IBAction func onSplitItPressed(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        let partySize = partySizePicker.selectedRow(inComponent: 0) + 1
        defaults.set(partySize, forKey: partySizeKey)
        self.dismiss(animated: true, completion: nil)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func currentColorScheme() -> (fg: UIColor, bg: UIColor) {
        let defaults = UserDefaults.standard
        
        if (defaults.bool(forKey: colorInvertedKey)) {
            return (fg: UIColor.white, bg: UIColor.black)
        } else {
            return (fg: UIColor.black, bg: UIColor.white)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == partySizePicker {
            return 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if pickerView == partySizePicker {
            return 10
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let scheme = currentColorScheme()
        let pickerLabel = UILabel()
        pickerLabel.backgroundColor = scheme.bg
        let rowTitle = NSAttributedString(string: "\(row + 1)", attributes: [NSForegroundColorAttributeName: scheme.fg])
        pickerLabel.attributedText = rowTitle
        pickerLabel.textAlignment = .center
        return pickerLabel
    }

}

//
//  ViewController.swift
//  Just the Tip
//
//  Created by Stephen Chudleigh on 6/6/16.
//  Copyright © 2016 Stephen Chudleigh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billField.text = ""
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // update tip amounts
        let defaults = NSUserDefaults.standardUserDefaults()
        let amounts = defaults.objectForKey("tip:amounts") as? [Int] ?? [18,20,22]
        tipControl.setTitle("\(amounts[0])%", forSegmentAtIndex: 0)
        tipControl.setTitle("\(amounts[1])%", forSegmentAtIndex: 1)
        tipControl.setTitle("\(amounts[2])%", forSegmentAtIndex: 2)
        self.onEditingChanged([])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let amounts = defaults.objectForKey("tip:amounts") as? [Int] ?? [18,20,22]
        let tipPercentages = amounts.map{val in Double(val) / 100}
        let tipPercent = tipPercentages[tipControl.selectedSegmentIndex]
        var bill = 0.0
        if let billText = Double(billField.text!) {
            bill = billText
        }
        let tip = bill * tipPercent
        let total = bill + tip
        tipLabel.text =   String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}


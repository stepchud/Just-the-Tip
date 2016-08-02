//
//  ViewController.swift
//  Just the Tip
//
//  Created by Stephen Chudleigh on 6/6/16.
//  Copyright © 2016 Stephen Chudleigh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // text labels
    
    @IBOutlet weak var hrLine: UIView!
    @IBOutlet weak var totalTextLabel: UILabel!
    @IBOutlet weak var tipAmountTextLabel: UILabel!
    @IBOutlet weak var tipPercentTextLabel: UILabel!
    @IBOutlet weak var billAmountTextLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var increaseTipButton: UIButton!
    @IBOutlet weak var decreaseTipButton: UIButton!
    @IBOutlet weak var splitBillLabel: UILabel!
    
    let tipKey = "tip:amount"
    let formatter = NSNumberFormatter()
    
    var totalAmount = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register view with appdelegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.mainViewController = self
        
        // create default tip percent
        let defaults = NSUserDefaults.standardUserDefaults()
        var tipPercentText = "\(20)"
        if (defaults.objectForKey(tipKey)==nil){
            defaults.setInteger(20, forKey: tipKey)
        } else {
            tipPercentText = "\(defaults.integerForKey(tipKey))"
        }
        
        // hide split bill label
        self.splitBillLabel.hidden = true
        
        // locale formatter
        formatter.numberStyle = .CurrencyStyle
        let defaultText = formatter.stringFromNumber(self.totalAmount)
        
        tipLabel.text = defaultText
        tipPercentLabel.text = tipPercentText
        totalLabel.text = defaultText
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    func doubleTapped() {
        view.endEditing(true)

        // rotate color scheme
        let white = UIColor.whiteColor()
        let black = UIColor.blackColor()
        var bgColor = black
        var txtColor = white
        // get current bg
        if let currBg = view.backgroundColor {
            if currBg == black {
                bgColor = white
                txtColor = black
            }
        }
        
        view.backgroundColor = bgColor
    
        for label in [billAmountTextLabel, tipPercentTextLabel, tipPercentLabel, tipAmountTextLabel, tipLabel, totalTextLabel, totalLabel] {
            label.textColor = txtColor
        }
        
        //billField.backgroundColor = bgColor
        //billField.textColor = txtColor
        hrLine.backgroundColor = txtColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // use previous bill amount for 10 minutes
        let defaults = NSUserDefaults.standardUserDefaults()
        if let bgAt = defaults.objectForKey("backgroundedAt") as? NSDate {
            let bgIntervalSecs = NSDate().timeIntervalSinceDate(bgAt)
            print("last opened \(bgIntervalSecs) seconds ago")
            if (bgIntervalSecs < 10*60){ // less than 10 minutes since last opened
                let prevBill = defaults.stringForKey("previousBill")
                billField.text = prevBill
                self.onEditingChanged([])
            }
        }
        
        let partySize = defaults.integerForKey("partySize")
        if (partySize > 1 && totalAmount > 0) {
            let splitAmount = totalAmount / Double(partySize)
            let splitText = formatter.stringFromNumber(splitAmount)!
            self.splitBillLabel.text = "Split with \(partySize) is \(splitText)"
            self.splitBillLabel.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        // if (let amount ) check for an int in the array and use that value 
        let defaults = NSUserDefaults.standardUserDefaults()
        var tipPercent = 0.20
        let tipAmount = defaults.integerForKey(tipKey)
        if (tipAmount > 0) {
            tipPercent = Double(tipAmount) / 100.0
        }

        var bill = 0.0
        if let billText = Double(billField.text!) {
            bill = billText
        }
        let tip = bill * tipPercent
        self.totalAmount = bill + tip
        tipLabel.text =   formatter.stringFromNumber(tip)
        totalLabel.text = formatter.stringFromNumber(totalAmount)
    }

    @IBAction func onTipChanged(sender: UIButton) {
        var tipChange = 1
        if (sender==decreaseTipButton){
            tipChange = -1
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        var tipAmount = defaults.integerForKey(tipKey)
        tipAmount += tipChange;
        defaults.setInteger(tipAmount, forKey: tipKey)
        tipPercentLabel.text = "\(tipAmount)"
        self.onEditingChanged([tipAmount])
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
                if motion == .MotionShake {
            performSegueWithIdentifier("openBillSplit", sender: self)
        }
    }
}


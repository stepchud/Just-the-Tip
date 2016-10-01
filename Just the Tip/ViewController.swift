//
//  ViewController.swift
//  Just the Tip
//
//  Created by Stephen Chudleigh on 6/6/16.
//  Copyright © 2016 Stephen Chudleigh. All rights reserved.
//

import UIKit

let tipPercentKey = "tip:percent"
let colorInvertedKey = "color:inverted"
let partySizeKey = "party:size"
let bgTimerKey = "backgrounded:timer"

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

    let formatter = NumberFormatter()
    
    var totalAmount = 0.0
    
    override func viewDidLoad() {
        print("main viewDidLoad")
        
        super.viewDidLoad()

        // double tap to change color scheme
        self.registerEventListeners()

        // initialize UI state
        self.refreshViewState()
    }
    
    func registerEventListeners() {
        print("register listeners")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshViewState),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        
        // tap recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    func createDefaults() -> UserDefaults {
        // locale formatter
        formatter.numberStyle = .currency
        formatter.locale = NSLocale.current
        formatter.isLenient = true
        
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: tipPercentKey)==nil){ // first initialization
            print("first initialization")
            self.resetToZero()
            defaults.set(20, forKey: tipPercentKey)
            defaults.synchronize()
        }

        tipPercentLabel.text = "\(defaults.integer(forKey: tipPercentKey))"
        
        return defaults
    }
    
    func initViewState(_ defaults: UserDefaults?) {
        var splitBill = false
        var invertColors = false
        if let settings = defaults {
            splitBill = settings.integer(forKey: partySizeKey) > 1
            invertColors = settings.bool(forKey: colorInvertedKey)
        }
        
        print("init view \(splitBill) / \(invertColors)")
        self.splitBillLabel.isHidden = !splitBill
        let white = UIColor.white
        let black = UIColor.black
        self.updateColorTheme(bgColor: (invertColors ? black : white), txtColor: (invertColors ? white : black))
        self.billField.becomeFirstResponder()
    }

    func refreshViewState() {
        let defaults = self.createDefaults()
        self.resetTimerDefaults(defaults)
        self.initViewState(defaults)
    }

    func resetTimerDefaults(_ defaults: UserDefaults) {
        print("reset timer default")
        // use previous bill amount for 10 minutes
        if let bgAt = defaults.object(forKey: bgTimerKey) as? NSDate {
            print("timer reset")
            defaults.removeObject(forKey: bgTimerKey) // stop timeout
            let bgIntervalSecs = NSDate().timeIntervalSince(bgAt as Date)
            print("last opened \(bgIntervalSecs) seconds ago")
            if (bgIntervalSecs < 10 * 60){ // less than 10 minutes since last opened
                if let prevBill = defaults.string(forKey: "previousBill") {
                    billField.text = prevBill
                }
            } else { // been more than 10 minutes, reset state
                self.resetToZero()
                defaults.set(false, forKey: colorInvertedKey)
                defaults.set(1, forKey: partySizeKey)
            }
            defaults.synchronize()
        }
    }
    
    func doubleTapped() {
        view.endEditing(true)

        // rotate color scheme
        // get current setting
        let white = UIColor.white
        let black = UIColor.black
        let defaults = UserDefaults.standard
        let inverted = view.backgroundColor==UIColor.black
        defaults.set(!inverted, forKey: colorInvertedKey)
        // print("color was inverted \(inverted)")
        if (inverted) {
            self.updateColorTheme(bgColor: white, txtColor: black)
        } else {
            self.updateColorTheme(bgColor: black, txtColor: white)
        }
    }
    
    func updateColorTheme(bgColor: UIColor, txtColor: UIColor) {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = bgColor

            for label in [self.billAmountTextLabel, self.tipPercentTextLabel, self.tipPercentLabel, self.tipAmountTextLabel, self.tipLabel, self.totalTextLabel, self.totalLabel, self.splitBillLabel] {
                label!.textColor = txtColor
            }

            //billField.backgroundColor = bgColor
            //billField.textColor = txtColor
            self.hrLine.backgroundColor = txtColor
        })
    }
    
    func updateSplitBill(_ defaults: UserDefaults) {
        let partySize = defaults.integer(forKey: partySizeKey)
        if (partySize > 1 && totalAmount > 0) {
            let splitAmount = totalAmount / Double(partySize)
            let splitText = formatter.string(from: NSNumber(floatLiteral: splitAmount))
            self.splitBillLabel.text = "Split with \(partySize) is \(splitText!)"
            self.splitBillLabel.isHidden = false
        } else {
            self.splitBillLabel.isHidden = true
        }
    }
    
    func updateTotals() {
        // if (let amount ) check for an int in the array and use that value
        let defaults = UserDefaults.standard
        var tipPercent: Double
        let tipAmount = defaults.integer(forKey: tipPercentKey)
        if (tipAmount > 0) {
            tipPercent = Double(tipAmount) / 100.0
        } else {
            tipPercent = 0.0
        }
        
        var bill = 0.0
        let billText = billField.text!
        defaults.set(billText, forKey: "previousBill")
        print("current bill \(billText)")
        if let billParsed = formatter.number(from: billText) {
            bill = Double(billParsed)
        }
        let tip = bill * tipPercent
        self.totalAmount = bill + tip
        tipLabel.text =   formatter.string(from: NSNumber(floatLiteral: tip))
        totalLabel.text = formatter.string(from: NSNumber(floatLiteral: totalAmount))
        self.updateSplitBill(defaults)
    }
    
    func resetToZero() {
        let defaultText = formatter.string(from: NSNumber(floatLiteral: 0.0))
        tipLabel.text = defaultText
        totalLabel.text = defaultText
        billField.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.updateTotals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onBillFieldChanged(_ sender: AnyObject) {
        self.updateTotals()
    }

    @IBAction func onTipChanged(_ sender: UIButton) {
        var tipChange = 1
        if (sender==decreaseTipButton){
            tipChange = -1
        }
        let defaults = UserDefaults.standard
        var tipAmount = defaults.integer(forKey: tipPercentKey)
        tipAmount += tipChange;
        defaults.set(tipAmount, forKey: tipPercentKey)
        tipPercentLabel.text = "\(tipAmount)"
        self.updateTotals()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            billField.endEditing(true)
            performSegue(withIdentifier: "openBillSplit", sender: self)
        }
    }
}


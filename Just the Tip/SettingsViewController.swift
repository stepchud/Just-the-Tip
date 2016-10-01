//
//  SettingsViewController.swift
//  Just the Tip
//
//  Created by Stephen Chudleigh on 6/9/16.
//  Copyright © 2016 Stephen Chudleigh. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var poorTipField: UITextField!
    @IBOutlet weak var okTipField: UITextField!
    @IBOutlet weak var greatTipField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        var amounts = defaults.object(forKey: "tip:amounts") as? [Int] ?? [18,20,22]
        
        poorTipField.text = "\(amounts[0])"
        okTipField.text = "\(amounts[1])"
        greatTipField.text = "\(amounts[2])"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackClick(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onEditingChanged(sender: UITextField) {
        let defaults = UserDefaults.standard
        var amounts = defaults.object(forKey: "tip:amounts") as? [Int] ?? [18,20,22]
        if let poor = Int(poorTipField.text!) {
            amounts[0] = poor
        }
        if let okay = Int(okTipField.text!) {
            amounts[1] = okay
        }
        if let good = Int(greatTipField.text!) {
            amounts[2] = good
        }
        defaults.set(amounts, forKey: "tip:amounts")
    }
}

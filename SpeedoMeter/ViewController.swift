//
//  ViewController.swift
//  SpeedoMeter
//
//  Created by Mostafa Shuman on 8/16/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import UIKit
import CoreLocation
import Swinject
import SwinjectStoryboard

class ViewController: UIViewController {
    // MARK: properties
    var speedProvider: SPDLocationSpeedProvider! {
        didSet {
            speedProvider.delegate = self
        }
    }
    var speedChecker: SPDLocationSpeedChecker! {
        didSet {
            speedChecker.delegate = self
        }
    }
    private let maxDisplayableSpeed: CLLocationSpeed = 40 // 40 m/s or 144 km/h
    // MARK: Outlets
    @IBOutlet var speedLabels: [UILabel]!
    @IBOutlet weak var speedViewHightConstrain: NSLayoutConstraint!
    @IBOutlet var colorableView: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        for label in speedLabels {
            label.text = "0"
        }
        speedViewHightConstrain.constant = 0
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didTapMaxSpeed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Pick a max speed.", message: "You will be alerted when you exeed this max speed", preferredStyle: .alert)
        alertController.addTextField { [weak self] textField in
            textField.keyboardType = .numberPad
            if let maxSpeed = self?.speedChecker.maximumSpeed {
                textField.text = String(format: "%.0f",  maxSpeed.asKMH)
            }
        }
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {[weak self] (_) in
            guard let text = alertController.textFields?.first?.text else { return }
            guard let maxSpeed = Double(text) else { return }
            self?.speedChecker.maximumSpeed = maxSpeed.asMPS
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: SPDLocationSpeedProviderDelegate {
    func didUpdate(speed: CLLocationSpeed) {
        for label in speedLabels {
            label.text = String(format: "%.0f",  speed.asKMH)
        }
        view.layoutIfNeeded()
        let maxHight = view.bounds.height
        speedViewHightConstrain.constant = maxHight * CGFloat(speed / maxDisplayableSpeed)
        UIView.animate(withDuration: 1.4) {[weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
extension ViewController: SPDLocationSpeedCheckerDelegate {
    func exeedingMaximumSpeedChange(for speedChecker: SPDLocationSpeedChecker) {
        let color: UIColor = speedChecker.isExeededMaximumSpeed ? .speedometerRed : .speedometerBlue
        UIView.animate(withDuration: 1.0) {[weak self] in
            for view in self?.colorableView ?? [] {
                if let label = view as? UILabel {
                    label.textColor = color
                } else if let button = view as? UIButton {
                    button.setTitleColor(color, for: .normal)
                } else {
                    view.backgroundColor = color
                }
            }
        }
        
    }
}
// MARK: Extentions
extension UIColor {
    static let speedometerRed = UIColor(red: 255/255, green: 82/255, blue: 0/255, alpha: 1)
    static let speedometerBlue = UIColor(red: 0/255, green: 0/255, blue: 128/255, alpha: 1)
}
extension Double {
    var asMPS: CLLocationSpeed {
        return self * 3.6
    }
}
extension CLLocationSpeed {
    var asKMH: Double {
        return self * 3.6  // 1 m/s = 3.6 km/h
    }
}
// MARK: Assembly
class ViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.storyboardInitCompleted(ViewController.self) { (r, c) in
            c.speedProvider = r.resolve(SPDLocationSpeedProvider.self)!
            c.speedChecker = r.resolve(SPDLocationSpeedChecker.self)!
        }
    }
}

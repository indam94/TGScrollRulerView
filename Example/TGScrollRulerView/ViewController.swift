//
//  ViewController.swift
//  TGScrollRulerView
//
//  Created by indam94 on 11/30/2020.
//  Copyright (c) 2020 indam94. All rights reserved.
//

import UIKit
import TGScrollRulerView

class ViewController: UIViewController {

    let birthYearLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.textColor = .black
        aLabel.textAlignment = .center
        aLabel.translatesAutoresizingMaskIntoConstraints = false
        return aLabel
    }()
    let rulerView: TGScrollRulerView = {
        let aRulerView = TGScrollRulerView()
        aRulerView.minValue = 1900
        aRulerView.maxValue = 2020
        aRulerView.intervalValue = 1
        aRulerView.intervalValue2 = 5
        aRulerView.mainColor = .red
        aRulerView.translatesAutoresizingMaskIntoConstraints = false
        return aRulerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.rulerView.delegate = self
        
        self.view.addSubview(birthYearLabel)
        self.view.addSubview(rulerView)
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                
                birthYearLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
                birthYearLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 23),
                birthYearLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -23),
                
                rulerView.topAnchor.constraint(equalTo: birthYearLabel.bottomAnchor, constant: 23),
                rulerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                rulerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                rulerView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        } else {
            // Fallback on earlier versions
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: TGScrollRulerDelegate{
    func scrollRuler(value: Int){
        birthYearLabel.text = "\(value) YEAR"
    }
}

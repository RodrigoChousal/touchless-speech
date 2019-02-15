//
//  SettingsTableViewController.swift
//  NuevoAmanecer
//
//  Created by Rodrigo Chousal on 12/11/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
	
	var speed: Float!
	var sensibility: Float!
	var isBarrido: Bool!
	
	@IBOutlet weak var speedLabel: UILabel!
	@IBOutlet weak var sensibilityLabel: UILabel!
	
	@IBOutlet weak var speedSlider: UISlider!
	@IBOutlet weak var sensibilitySlider: UISlider!
	@IBOutlet weak var barridoSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		speedSlider.maximumValue = 5.0
		speedSlider.minimumValue = 0.1
				
		sensibilitySlider.maximumValue = 10.0
		sensibilitySlider.minimumValue = 0.1
    }
	
	override func viewDidAppear(_ animated: Bool) {
		self.speedLabel.text = speed.description
		self.sensibilityLabel.text = sensibility.description
		
		self.sensibilitySlider.value = sensibility
		self.speedSlider.value = speed
		self.barridoSwitch.isOn = isBarrido
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
	
	// MARK: - Action Methods
	
	@IBAction func speedChanged(_ sender: Any) {
		speedLabel.text = String(format: "%.01f", speedSlider.value)
		speed = speedSlider.value
	}
	
	@IBAction func sensibilityChanged(_ sender: Any) {
		sensibilityLabel.text = String(format: "%.01f", sensibilitySlider.value)
		sensibility = sensibilitySlider.value
	}
	
	@IBAction func switchChanged(_ sender: Any) {
		isBarrido = barridoSwitch.isOn
	}
	
	@IBAction func finishPressed(_ sender: Any) {
		if let cardVC = self.presentingViewController as? CardViewController {
			cardVC.speed = self.speed
			cardVC.sensibility = self.sensibility
			cardVC.isBarrido = self.isBarrido
		}
		self.dismiss(animated: true, completion: nil)
	}
	
}

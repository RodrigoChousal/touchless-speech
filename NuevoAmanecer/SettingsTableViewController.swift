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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cardVC = segue.destination as! CardViewController
		cardVC.speed = self.speed
		cardVC.sensibility = self.sensibility
		cardVC.isBarrido = self.isBarrido
    }
	
	// MARK: - Action Methods
	
	@IBAction func speedChanged(_ sender: Any) {
		speedLabel.text = speedSlider.value.description
		speed = speedSlider.value
	}
	
	@IBAction func sensibilityChanged(_ sender: Any) {
		sensibilityLabel.text = sensibilitySlider.value.description
		sensibility = sensibilitySlider.value
	}
	
	@IBAction func switchChanged(_ sender: Any) {
		isBarrido = barridoSwitch.isOn
	}
	
	@IBAction func cancelPressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
}

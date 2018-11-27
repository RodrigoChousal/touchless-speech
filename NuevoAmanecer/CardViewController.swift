//
//  CardViewController.swift
//  NuevoAmanecer
//
//  Created by Rodrigo Chousal on 11/27/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit

var vocabulary = Vocabulary()

class CardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var homeButton: UIButton!
	@IBOutlet weak var nextButton: UIButton!
	
	@IBOutlet weak var cardCollectionView: UICollectionView!
	
	@IBOutlet weak var sayButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var wordCollectionView: UICollectionView!
	
	var isHome = true
	var cards = [Card]()
	var selectedWords = [WordCard]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.cards = vocabulary.categoryCards
		
		cardCollectionView.delegate = self
		cardCollectionView.dataSource = self
		
        wordCollectionView.delegate = self
		wordCollectionView.dataSource = self
		
		if isHome { homeButton.isHidden = true }
		makeButtonsPretty()
    }
	
	// MARK: - CollectionViewDelegate
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == self.cardCollectionView {
			if self.isHome {
				let card = cards[indexPath.row] as! CategoryCard
				print("Selected category cell: " + card.title)
				showWords(fromCategoryCard: card)
			} else {
				print("Selected word cell")
//				let card = cards[indexPath.row] as! WordCard
//				addWord(fromWordCard: card)
			}
		} else { // Selected word list
			// Open word list
		}
	}
	
	// MARK: - CollectionViewDataSource
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == self.cardCollectionView {
			return self.cards.count
		} else {
			return self.selectedWords.count
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == self.cardCollectionView {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
			cell.titleLabel.text = self.cards[indexPath.row].title
			cell.imageView.image = self.cards[indexPath.row].image
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedWordCell", for: indexPath) as! SelectedWordCollectionViewCell
			cell.titleLabel.text = self.selectedWords[indexPath.row].title
			return cell
		}
	}
	
	// MARK: - Action Methods
	
	@IBAction func backPressed(_ sender: Any) {
	}
	
	@IBAction func nextPressed(_ sender: Any) {
	}
	
	@IBAction func homePressed(_ sender: Any) {
		print("Pressed home")
		self.isHome = true
		self.homeButton.isHidden = true
		self.cards = vocabulary.categoryCards
		self.cardCollectionView.reloadData()
	}
	
	@IBAction func sayPressed(_ sender: Any) {
	}
	
	@IBAction func deletePressed(_ sender: Any) {
		let lastIndex = IndexPath(item: selectedWords.count-1, section: 0)
		self.selectedWords.remove(at: lastIndex.row)
		self.wordCollectionView.deleteItems(at: [lastIndex])
	}
	
	// MARK: - Helper Methods
	
	func showWords(fromCategoryCard categoryCard: CategoryCard) {
		print("Showing words...")
		self.isHome = false
		self.homeButton.isHidden = false
		print("Showed home button")
		cards = categoryCard.wordCards
		self.cardCollectionView.reloadData()
	}
	
	func addWord(fromWordCard wordCard: WordCard) {
		self.selectedWords.append(wordCard)
		self.wordCollectionView.reloadData()
	}
	
	func makeButtonsPretty() {
		backButton.layer.cornerRadius = backButton.frame.width*0.2
		backButton.layer.borderWidth = 5
		backButton.layer.borderColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0).cgColor
		backButton.backgroundColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
		backButton.clipsToBounds = true
		
		nextButton.layer.cornerRadius = nextButton.frame.width*0.2
		nextButton.layer.borderWidth = 5
		nextButton.layer.borderColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0).cgColor
		nextButton.backgroundColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
		nextButton.clipsToBounds = true
		
		homeButton.layer.cornerRadius = homeButton.frame.width*0.5
		homeButton.layer.borderWidth = 5
		homeButton.layer.borderColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0).cgColor
		homeButton.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
		homeButton.clipsToBounds = true
		
		sayButton.layer.cornerRadius = 50
		sayButton.layer.borderWidth = 5
		sayButton.layer.borderColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0).cgColor
		sayButton.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
		sayButton.clipsToBounds = true
		
		deleteButton.layer.cornerRadius = 50
		deleteButton.layer.borderWidth = 5
		deleteButton.layer.borderColor = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1.0).cgColor
		deleteButton.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
		deleteButton.clipsToBounds = true
	}
}

//
//  CardViewController.swift
//  NuevoAmanecer
//
//  Created by Rodrigo Chousal on 11/27/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit
import AVFoundation
import AudioKit
import CoreAudioKit

var vocabulary = Vocabulary()

var mic: AKMicrophone!
var tracker: AKFrequencyTracker!
var silence: AKBooster!

class CardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AVSpeechSynthesizerDelegate {
	
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var homeButton: UIButton!
	@IBOutlet weak var nextButton: UIButton!
	
	@IBOutlet weak var cardCollectionView: UICollectionView!
	
	@IBOutlet weak var sayButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var wordCollectionView: UICollectionView!
	
	@IBOutlet weak var selectionIndicatorView: UIView!
	
	var speechSynth = AVSpeechSynthesizer()
	
	var isHome = true
	var cooledOff = true
	var cards = [Card]()
	var selectedWords = [WordCard]()
	var selectionIndex = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		cardCollectionView.delegate = self
		cardCollectionView.dataSource = self
		
		wordCollectionView.delegate = self
		wordCollectionView.dataSource = self
		
		speechSynth.delegate = self

		self.cards = vocabulary.categoryCards
		self.selectionIndicatorView.frame = backButton.frame
		
		highlightNextButton()
		prepareMic()
		prepareAudioSession()
		
		if isHome { homeButton.isHidden = true }
		makeButtonsPretty()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		AudioKit.output = silence
		do {
			try AudioKit.start()
		} catch {
			AKLog("AudioKit did not start!")
		}
		
		// Print mic info timer
		Timer.scheduledTimer(timeInterval: 0.1,
							 target: self,
							 selector: #selector(checkForHumming),
							 userInfo: nil,
							 repeats: true)
		
		// Loop through buttons timer
		Timer.scheduledTimer(timeInterval: 2.0,
							 target: self,
							 selector: #selector(highlightNextButton),
							 userInfo: nil,
							 repeats: true)
	}
	
	// MARK: - CollectionViewDelegate
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == self.cardCollectionView {
			if self.isHome {
				let card = cards[indexPath.row] as! CategoryCard
				showWords(fromCategoryCard: card)
			} else {
				let card = cards[indexPath.row] as! WordCard
				addWord(fromWordCard: card)
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
			cell.layer.borderWidth = 5
			cell.layer.borderColor = UIColor(red: 243/255, green: 156/255, blue: 17/255, alpha: 1.0).cgColor
			return cell
		}
	}
	
	// MARK: - Action Methods
	
	@IBAction func backPressed(_ sender: Any) {
		let offsetPerCard = cardCollectionView.contentSize.width/CGFloat(cards.count)
		let newOffset = cardCollectionView.contentOffset.x - offsetPerCard
		if newOffset > 0 {
			cardCollectionView.contentOffset.x -= offsetPerCard
		}
	}
	
	@IBAction func nextPressed(_ sender: Any) {
		let scrollWidth = cardCollectionView.contentSize.width
		let offsetPerCard = cardCollectionView.contentSize.width/CGFloat(cards.count)
		let newOffset = cardCollectionView.contentOffset.x + offsetPerCard
		if newOffset < scrollWidth {
			cardCollectionView.contentOffset.x += offsetPerCard
		}
	}
	
	@IBAction func homePressed(_ sender: Any) {
		self.isHome = true
		self.homeButton.isHidden = true
		self.cards = vocabulary.categoryCards
		self.cardCollectionView.contentOffset.x = 0
		self.cardCollectionView.reloadData()
	}
	
	@IBAction func sayPressed(_ sender: Any) {
		for word in selectedWords {
			let utterance = AVSpeechUtterance(string: word.title)
			utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
			speechSynth.speak(utterance)
		}
	}
	
	@IBAction func deletePressed(_ sender: Any) {
		if selectedWords.count != 0 {
			let lastIndex = IndexPath(item: selectedWords.count-1, section: 0)
			self.selectedWords.remove(at: lastIndex.row)
			self.wordCollectionView.deleteItems(at: [lastIndex])
		}
	}
	
	// MARK: - AVSpeechSynthesizer Delegate
	
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
		AKSettings.audioInputEnabled = true
		let audioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.overrideOutputAudioPort(.speaker)
			if #available(iOS 10.0, *) {
				try audioSession.setCategory(.playAndRecord, mode: .default)
			} else {
				// Workaround until https://forums.swift.org/t/using-methods-marked-unavailable-in-swift-4-2/14949 isn't fixed
				audioSession.perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playAndRecord)
			}
			try audioSession.setActive(true)
		} catch {
			print(error)
		}
	}
	
	// MARK: - Helper Methods
	
	func prepareMic() {
		AKSettings.audioInputEnabled = true
		mic = AKMicrophone()
		tracker = AKFrequencyTracker(mic)
		silence = AKBooster(tracker, gain: 0)
	}
	
	func prepareAudioSession() {
		let audioSession = AVAudioSession.sharedInstance()
		do {
			if #available(iOS 10.0, *) {
				try audioSession.setCategory(.record, mode: .default)
			} else {
				// Workaround until https://forums.swift.org/t/using-methods-marked-unavailable-in-swift-4-2/14949 isn't fixed
				audioSession.perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.record)
			}
			try audioSession.setActive(true)
		} catch {
			print(error)
		}
	}
	
	@objc func checkForHumming() {
		if cooledOff {
			var selectableTop = [backButton, homeButton, nextButton]
			if homeButton.isHidden { selectableTop = [backButton, nextButton] }
			let selectableCells = cardCollectionView.visibleCells
			let selectableBottom = [sayButton, deleteButton]
			
			let totalCount = selectableTop.count + selectableCells.count + selectableBottom.count
			
			let range1 = selectableTop.count
			let range2 = totalCount - selectableBottom.count
			
			let realIndex = selectionIndex
			
			print("Selecting: " + realIndex.description)
			if tracker.amplitude >= 0.05 {
				cooledOff = false
				switch realIndex {
				case _ where realIndex < range1: // 0, 1, 2
					if let button = selectableTop[realIndex] {
						button.sendActions(for: .touchUpInside)
					}
				case _ where realIndex >= range1 && realIndex < range2: // 3
					let cell = selectableCells[realIndex-range1]
					if let indexPath = cardCollectionView.indexPath(for: cell) {
						cardCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
						self.collectionView(cardCollectionView, didSelectItemAt: indexPath)
					}
				case _ where realIndex >= range2: // 4, 5
					if let button = selectableBottom[realIndex-range2] {
						button.sendActions(for: .touchUpInside)
					}
				default:
					print("ERROR! No executable selection index")
				}
			}
		}
	}
	
	@objc func highlightNextButton() {
		
		cooledOff = true
		
		var selectableTop = [backButton, homeButton, nextButton]
		if homeButton.isHidden { selectableTop = [backButton, nextButton] }
		let selectableCells = cardCollectionView.visibleCells
		let selectableBottom = [sayButton, deleteButton]
		
		let totalCount = selectableTop.count + selectableCells.count + selectableBottom.count
		
		let range1 = selectableTop.count
		let range2 = totalCount - selectableBottom.count
		
		if selectionIndex != (totalCount - 1) {
			selectionIndex += 1
		} else {
			selectionIndex = 0
		}
		
		print("Highlighting: " + selectionIndex.description)
		
		for i in 0...(totalCount-1) {
			if i == selectionIndex {
				// Highlight that interactable
				switch selectionIndex {
				case _ where selectionIndex < range1: // 0, 1, 2
					if let insideSelectable = selectableTop[selectionIndex] {
						if let topView = backButton.superview {
							let frameInView = topView.convert(insideSelectable.frame, to: view)
							selectionIndicatorView.frame = frameInView
						}
					}
				case _ where selectionIndex >= range1 && selectionIndex < range2: // 3
					let insideSelectable = selectableCells[selectionIndex-range1]
					let frameInView = cardCollectionView.convert(insideSelectable.frame, to: view)
					selectionIndicatorView.frame = frameInView
				case _ where selectionIndex >= range2: // 4, 5
					if let insideSelectable = selectableBottom[selectionIndex-range2] {
						if let bottomView = sayButton.superview {
							let frameInView = bottomView.convert(insideSelectable.frame, to: view)
							selectionIndicatorView.frame = frameInView
						}
					}
				default:
					print("ERROR! No executable selection index")
				}
			}
		}
	}
	
	func showWords(fromCategoryCard categoryCard: CategoryCard) {
		self.isHome = false
		self.homeButton.isHidden = false
		cards = categoryCard.wordCards
		self.cardCollectionView.contentOffset.x = 0
		self.cardCollectionView.reloadData()
	}
	
	func addWord(fromWordCard wordCard: WordCard) {
		self.selectedWords.append(wordCard)
		self.wordCollectionView.reloadData()
	}
	
	func makeButtonsPretty() {
		
		wordCollectionView.layer.cornerRadius = 12
		wordCollectionView.layer.borderWidth = 5
		wordCollectionView.layer.borderColor = UIColor(red: 243/255, green: 156/255, blue: 17/255, alpha: 1.0).cgColor
		wordCollectionView.backgroundColor = UIColor(red: 241/255, green: 195/255, blue: 15/255, alpha: 1.0)
		
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
		
		homeButton.layer.cornerRadius = homeButton.frame.width*0.2
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

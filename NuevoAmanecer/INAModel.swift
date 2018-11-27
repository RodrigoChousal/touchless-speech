//
//  INAModel.swift
//  NuevoAmanecer
//
//  Created by Rodrigo Chousal on 11/27/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import Foundation
import UIKit

class Vocabulary {
	var categoryCards = [CategoryCard]()
}

class Card {
	var image: UIImage
	var title: String
	
	init(title: String, image: UIImage) {
		self.title = title
		self.image = image
	}
}

class CategoryCard: Card {
	var wordCards: [WordCard]
	
	init(title: String, image: UIImage, wordCards: [WordCard]) {
		self.wordCards = wordCards
		super.init(title: title, image: image)
	}
}

class WordCard: Card {
	
}

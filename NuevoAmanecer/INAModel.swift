//
//  INAModel.swift
//  NuevoAmanecer
//
//  Created by Rodrigo Chousal on 11/27/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import Foundation
import UIKit

var image = UIImage(named: "placeholder") ?? UIImage()

class Vocabulary {
	
	var categoryCards = [CategoryCard(title: "Sentimientos",
									  image: image,
									  wordCards: [WordCard(title: "Enojado", image: image),
												  WordCard(title: "Feliz", image: image),
												  WordCard(title: "Triste", image: image),
												  WordCard(title: "Emocionado", image: image)]),
						 CategoryCard(title: "Personas",
									  image: image,
									  wordCards: [WordCard(title: "Papá", image: image),
												  WordCard(title: "Mamá", image: image),
												  WordCard(title: "Hermano", image: image),
												  WordCard(title: "Primo", image: image)]),
						 CategoryCard(title: "Objetos",
									  image: image,
									  wordCards: [WordCard(title: "Pelota", image: image),
												  WordCard(title: "Tablet", image: image),
												  WordCard(title: "Lápiz", image: image),
												  WordCard(title: "Mochila", image: image)]),
						 CategoryCard(title: "Comida",
									  image: image,
									  wordCards: [WordCard(title: "Pizza", image: image),
												  WordCard(title: "Elote", image: image),
												  WordCard(title: "Nieve", image: image),
												  WordCard(title: "Brocoli", image: image)]),
						 CategoryCard(title: "Colores",
									  image: image,
									  wordCards: [WordCard(title: "Azul", image: image),
												  WordCard(title: "Verde", image: image),
												  WordCard(title: "Negro", image: image),
												  WordCard(title: "Naranja", image: image)]),
						 CategoryCard(title: "Números",
									  image: image,
									  wordCards: [WordCard(title: "Nueve", image: image),
												  WordCard(title: "Ocho", image: image),
												  WordCard(title: "Siete", image: image),
												  WordCard(title: "Seis", image: image)]),
						 CategoryCard(title: "Letras",
									  image: image,
									  wordCards: [WordCard(title: "A", image: image),
												  WordCard(title: "B", image: image),
												  WordCard(title: "C", image: image),
												  WordCard(title: "D", image: image)])]
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

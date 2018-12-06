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
									  image: UIImage(named: "sentimientos") ?? image,
									  wordCards: [WordCard(title: "Enojado", image: UIImage(named: "enojado") ?? image),
												  WordCard(title: "Feliz", image: UIImage(named: "feliz") ?? image),
												  WordCard(title: "Triste", image: UIImage(named: "triste") ?? image),
												  WordCard(title: "Emocionado", image: UIImage(named: "emocionado") ?? image),
												  WordCard(title: "Confundido", image: UIImage(named: "confundido") ?? image),
												  WordCard(title: "Asustado", image: UIImage(named: "asustado") ?? image)]),
						 CategoryCard(title: "Personas",
									  image: UIImage(named: "personas") ?? image,
									  wordCards: [WordCard(title: "Papá", image: image),
												  WordCard(title: "Mamá", image: image),
												  WordCard(title: "Hermano", image: image),
												  WordCard(title: "Primo", image: image)]),
						 CategoryCard(title: "Objetos",
									  image: UIImage(named: "objetos") ?? image,
									  wordCards: [WordCard(title: "Pelota", image: UIImage(named: "pelota") ?? image),
												  WordCard(title: "Tablet", image: UIImage(named: "tablet") ?? image),
												  WordCard(title: "Lápiz", image: UIImage(named: "lapiz") ?? image),
												  WordCard(title: "Mochila", image: UIImage(named: "mochila") ?? image)]),
						 CategoryCard(title: "Comida",
									  image: UIImage(named: "comida") ?? image,
									  wordCards: [WordCard(title: "Pizza", image: UIImage(named: "pizza") ?? image),
												  WordCard(title: "Elote", image: UIImage(named: "elote") ?? image),
												  WordCard(title: "Nieve", image: UIImage(named: "nieve") ?? image),
												  WordCard(title: "Brocoli", image: UIImage(named: "brocoli") ?? image)]),
						 CategoryCard(title: "Colores",
									  image: UIImage(named: "colores") ?? image,
									  wordCards: [WordCard(title: "Azul", image: UIImage(named: "azul") ?? image),
												  WordCard(title: "Verde", image: UIImage(named: "verde") ?? image),
												  WordCard(title: "Negro", image: UIImage(named: "negro") ?? image),
												  WordCard(title: "Naranja", image: UIImage(named: "naranja") ?? image)]),
						 CategoryCard(title: "Números",
									  image: UIImage(named: "numeros") ?? image,
									  wordCards: [WordCard(title: "Nueve", image: image),
												  WordCard(title: "Ocho", image: image),
												  WordCard(title: "Siete", image: image),
												  WordCard(title: "Seis", image: image)]),
						 CategoryCard(title: "Letras",
									  image: UIImage(named: "letras") ?? image,
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

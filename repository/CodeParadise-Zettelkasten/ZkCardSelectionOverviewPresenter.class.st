Class {
	#name : #ZkCardSelectionOverviewPresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-Zettelkasten-Presenter'
}

{ #category : #accessing }
ZkCardSelectionOverviewPresenter >> cardSelection [

	^ self model
]

{ #category : #accessing }
ZkCardSelectionOverviewPresenter >> cardSelectionCollection [

	"Answer an ordered collection of card selection instances which form
	a chain of selections 'on top of each other'. The first element represents
	the root (and is in fact a card collection) and the following elements are
	all card selections on the previous element in the collection."

	^ self model asOrderedCollection
]

{ #category : #removing }
ZkCardSelectionOverviewPresenter >> removeCardSelection: aCardSelection [

	self parent
		removeCardSelection: aCardSelection
]

{ #category : #rendering }
ZkCardSelectionOverviewPresenter >> renderView [

	self
		renderAllChildViewsForModels: self cardSelectionCollection
		usingPresenter: ZkCardSelectionItemPresenter
		atSlotNamed: #selectionItems
]

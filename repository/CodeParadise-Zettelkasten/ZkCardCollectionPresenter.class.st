Class {
	#name : 'ZkCardCollectionPresenter',
	#superclass : 'CpPresenter',
	#category : 'CodeParadise-Zettelkasten-Presenter',
	#package : 'CodeParadise-Zettelkasten',
	#tag : 'Presenter'
}

{ #category : 'accessing' }
ZkCardCollectionPresenter >> collection [

	^ self model
]

{ #category : 'event handling' }
ZkCardCollectionPresenter >> handleAddCardRequested [

	"Add a new card to the library"

	self collection addCard
]

{ #category : 'rendering' }
ZkCardCollectionPresenter >> renderView [

	self
		renderAllChildViewsForModels: self collection cards
		atSlotNamed: #cards
]

{ #category : 'view' }
ZkCardCollectionPresenter >> viewCreated [

	super viewCreated.

	self view
		when: ZkAddCardRequested send: #handleAddCardRequested to: self
]

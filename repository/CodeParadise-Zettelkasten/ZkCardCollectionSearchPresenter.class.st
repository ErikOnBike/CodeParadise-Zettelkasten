Class {
	#name : #ZkCardCollectionSearchPresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-Zettelkasten-Presenter'
}

{ #category : #accessing }
ZkCardCollectionSearchPresenter >> cardSelection [

	^ self model
]

{ #category : #'event handling' }
ZkCardCollectionSearchPresenter >> handleSearchChanged: aFieldChanged [

	"The search criteria has changed, update the card selection"

	self cardSelection
		criteria: aFieldChanged value
]

{ #category : #'event handling' }
ZkCardCollectionSearchPresenter >> handleSearchFinalized: aFieldChanged [

	"The search is finalized, close my view and let the parent presenter know.

	Implementation:
	Reset the search after the parent processed the search results, so any
	following search operations start with an 'empty' search criteria."

	self view closeAndReset.

	self parent searchIsFinalized.

	self model reset
]

{ #category : #rendering }
ZkCardCollectionSearchPresenter >> renderView [

	self view
		renderSelectionCount: self cardSelection selectionCount
]

{ #category : #view }
ZkCardCollectionSearchPresenter >> viewCreated [

	super viewCreated.

	self view
		when: (CpFieldChanged id: #search) send: #handleSearchChanged: to: self ;
		when: (CpActionRequested id: #searchFinalized) send: #handleSearchFinalized: to: self
]

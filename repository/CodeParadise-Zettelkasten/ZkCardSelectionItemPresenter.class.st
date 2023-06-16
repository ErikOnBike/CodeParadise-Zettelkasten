Class {
	#name : #ZkCardSelectionItemPresenter,
	#superclass : #CpPresenter,
	#category : #'CodeParadise-Zettelkasten-Presenter'
}

{ #category : #accessing }
ZkCardSelectionItemPresenter >> cardSelection [

	^ self model
]

{ #category : #'event handling' }
ZkCardSelectionItemPresenter >> handleRemove [

	"The receiver is removed, let the parent presenter know"

	self parent
		removeCardSelection: self cardSelection
]

{ #category : #rendering }
ZkCardSelectionItemPresenter >> renderView [

	"Render the description of the card selection and make it removable if the selection
	is an actual selection. If the card selection is in fact a card collection, it should
	not be removable."

	self view
		renderDescription: self cardSelection description removable: self cardSelection isSelection
]

{ #category : #view }
ZkCardSelectionItemPresenter >> viewCreated [

	super viewCreated.

	self view
		when: ZkRemoveCardSelectionItem send: #handleRemove to: self
]

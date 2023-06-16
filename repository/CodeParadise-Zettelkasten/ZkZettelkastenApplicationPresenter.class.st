Class {
	#name : #ZkZettelkastenApplicationPresenter,
	#superclass : #CpPresenter,
	#instVars : [
		'currentSelection',
		'searchSelection'
	],
	#category : #'CodeParadise-Zettelkasten-Presenter'
}

{ #category : #accessing }
ZkZettelkastenApplicationPresenter >> currentSelection [

	^ currentSelection
]

{ #category : #accessing }
ZkZettelkastenApplicationPresenter >> model: aZettelkasten [

	"Set the new zettelkasten as model for the receiver.
	Create a new card selection on the zettelkasten's library for selection ann searching."

	super model: aZettelkasten.

	currentSelection := aZettelkasten cardCollection.
	searchSelection := ZkCardSelection onSource: aZettelkasten cardCollection
]

{ #category : #'event handling' }
ZkZettelkastenApplicationPresenter >> removeCardSelection: aCardSelection [

	"Remove the specified card selection.

	Implementation:
	Since the search selection lies on top of the current selection,
	use it to remove the card selection from. This way the search
	selection will also update correctly.
	The search selection can't be removed. It is always there, so no
	need for special handling."

	searchSelection removeCardSelection: aCardSelection.

	"Update if the current selection changed"
	currentSelection = aCardSelection
		ifTrue: [ currentSelection := searchSelection source ].

	self renderView
]

{ #category : #rendering }
ZkZettelkastenApplicationPresenter >> renderView [

	self
		renderChildViewForModel: self currentSelection
		usingPresenter: ZkCardSelectionOverviewPresenter
		atSlotNamed: #selection.

	self
		renderChildViewForModel: self currentSelection
		usingPresenter: ZkCardCollectionPresenter
		atSlotNamed: #collection.

	self
		renderChildViewForModel: self searchSelection
		usingPresenter: ZkCardCollectionSearchPresenter
		atSlotNamed: #search
]

{ #category : #'event handling' }
ZkZettelkastenApplicationPresenter >> searchIsFinalized [

	"The search is finalized. Keep the search selection as the new current
	selection and start with a clean search selection (on top of the previous)."

	currentSelection := searchSelection.
	searchSelection := ZkCardSelection onSource: currentSelection.

	self renderView
]

{ #category : #accessing }
ZkZettelkastenApplicationPresenter >> searchSelection [

	^ searchSelection
]

{ #category : #accessing }
ZkZettelkastenApplicationPresenter >> zettelkasten [

	^ self model
]

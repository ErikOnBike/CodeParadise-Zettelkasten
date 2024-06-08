Class {
	#name : 'ZkCardSelection',
	#superclass : 'CpModel',
	#instVars : [
		'source',
		'criteria',
		'selection'
	],
	#category : 'CodeParadise-Zettelkasten-Model',
	#package : 'CodeParadise-Zettelkasten',
	#tag : 'Model'
}

{ #category : 'instance creation' }
ZkCardSelection class >> new [

	"Do not instantiate card selections directly"

	self errorNewReplacedBy: #onSource:
]

{ #category : 'accessing' }
ZkCardSelection class >> onSource: aSourceObject [

	^ self basicNew
		initializeWithSource: aSourceObject ;
		yourself
]

{ #category : 'accessing' }
ZkCardSelection >> addCard [

	"Add a new card to the receiver. Add the new card to the source, since
	the receiver is not storing cards itself, but simply maintaining a selection.
	Although the new card might not match my criteria, add it nonetheless
	since the user will otherwise not understand why an added card is not
	available. Updating the receiver (using #update) will however remove
	the element from the receiver (but it will be accessible from the source)."

	| card |

	card := source addCard.
	selection add: card.

	self valueChanged.

	^ card
]

{ #category : 'accessing' }
ZkCardSelection >> asOrderedCollection [

	"Answer an ordered collection representing the receiver and its
	source(s). The first element of the collection will be the 'root'
	source (a card collection) and all following elements will be
	card selections on top of the previous element."

	^ OrderedCollection streamContents: [ :stream |
		self putOn: stream ]
]

{ #category : 'accessing' }
ZkCardSelection >> cardCount [

	^ self cards size
]

{ #category : 'accessing' }
ZkCardSelection >> cards [

	^ selection
]

{ #category : 'accessing' }
ZkCardSelection >> criteria [

	^ criteria
]

{ #category : 'accessing' }
ZkCardSelection >> criteria: aString [

	criteria := aString.

	self update
]

{ #category : 'accessing' }
ZkCardSelection >> description [

	"Answer a description for the receiver in the form:
		<criteria> (<card count>)"

	^ String streamContents: [ :stream |
		stream
			nextPutAll: self criteria ;
			nextPutAll: ' (' ;
			nextPutAll: self cardCount printString ;
			nextPut: $) ]
]

{ #category : 'initialization' }
ZkCardSelection >> initialize [

	"Initialize the receiver. Be aware the source has to be set
	before calling this method. See #initializeWithSource:"

	super initialize.

	"Empty criteria and selection represents all cards.
	Make a copy of the source cards for the selection, since
	it might change/divert from the cards itself."
	criteria := ''.
	selection := source cards clone
]

{ #category : 'initialization' }
ZkCardSelection >> initializeWithSource: aSourceObject [

	"First set the source, since it is used within #initialize"

	source := aSourceObject.

	self initialize
]

{ #category : 'testing' }
ZkCardSelection >> isSelection [

	^ true
]

{ #category : 'printing' }
ZkCardSelection >> printOn: aStream [

	aStream
		nextPutAll: self class name ;
		nextPut: $( ;
		print: self criteria ;
		nextPut: $)
]

{ #category : 'accessing' }
ZkCardSelection >> putOn: aStream [

	source putOn: aStream.

	aStream nextPut: self
]

{ #category : 'accessing' }
ZkCardSelection >> removeCardSelection: aCardSelection [

	self removeCardSelection: aCardSelection updating: OrderedCollection new
]

{ #category : 'accessing' }
ZkCardSelection >> removeCardSelection: aCardSelection updating: aCollection [

	"Remove the specified card selection from the chain of card selections
	the receiver is part of (see also class comment)"

	"Add the receiver to the end, walking up to the chain towards the
	card collection. Therefore perform updates in reverse order below
	using the #reverseDo:"
	aCollection add: self.

	source = aCardSelection
		ifTrue: [
			source := source source.
			aCollection reverseDo: [ :each | each updateForceValueChanged: true ] ]
		ifFalse: [
			source removeCardSelection: aCardSelection updating: aCollection ]
]

{ #category : 'accessing' }
ZkCardSelection >> reset [

	"Reset the receiver by making the criteria empty.
	If the receiver was not empty, it will signal a value change on reset."

	self criteria: ''
]

{ #category : 'accessing' }
ZkCardSelection >> selectionCount [

	"Answer a String representing the receiver's selection count"

	^ String streamContents: [ :stream |
		stream
			nextPutAll: self cardCount printString ;
			nextPut: $/ ;
			nextPutAll: source cardCount printString ]
]

{ #category : 'accessing' }
ZkCardSelection >> source [

	^ source
]

{ #category : 'accessing' }
ZkCardSelection >> update [

	self updateForceValueChanged: false
]

{ #category : 'accessing' }
ZkCardSelection >> updateForceValueChanged: aBoolean [

	"Update the receiver and announce a change if the receiver changed or if aBoolean is true"

	| newSelection |

	"Optimization for no criteria set"
	criteria ifEmpty: [

		"Make sure the selection represents all cards of the source"
		selection = source cards
			ifTrue: [
				"Force change announcement?"
				aBoolean ifTrue: [ self valueChanged ] ]
			ifFalse: [
				selection := source cards clone.
				self valueChanged ].

		^ self ].

	newSelection := source cards select: [ :each | each matches: criteria ].
	newSelection = selection
		ifTrue: [
			"Force change announcement?"
			aBoolean ifTrue: [ self valueChanged ].

			^ self ].

	selection := newSelection.

	self valueChanged
]

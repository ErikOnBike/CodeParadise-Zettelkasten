Class {
	#name : #ZkCard,
	#superclass : #CpModel,
	#instVars : [
		'id',
		'library',
		'title',
		'description',
		'tags',
		'cardLinks'
	],
	#category : #'CodeParadise-Zettelkasten-Model'
}

{ #category : #'instance creation' }
ZkCard class >> new [

	"Do not instantiate cards directly"

	self error: 'Please create new ', self name, ' using ', #newWithId:inLibrary:
]

{ #category : #'instance creation' }
ZkCard class >> newWithId: anInteger inLibrary: aLibrary [

	"Answer a new instance of the receiver with the specified id
	which is part of the specified library"

	^ self basicNew
		initializeWithId: anInteger inLibrary: aLibrary ;
		yourself
]

{ #category : #accessing }
ZkCard >> addTag: aString [

	(tags includes: aString)
		ifTrue: [ ^ self ].

	tags add: aString.

	self valueChanged
]

{ #category : #accessing }
ZkCard >> description [

	^ description
]

{ #category : #accessing }
ZkCard >> description: aString [

	description = aString
		ifTrue: [ ^ self ].

	description := aString.

	self valueChanged
]

{ #category : #accessing }
ZkCard >> id [

	^ id
]

{ #category : #initialization }
ZkCard >> initialize [

	super initialize.

	title := ''.
	description := ''.
	cardLinks := OrderedCollection new.
	tags := OrderedCollection new
]

{ #category : #initialization }
ZkCard >> initializeWithId: anInteger inLibrary: aLibrary [

	self initialize.

	id := anInteger.
	library := aLibrary
]

{ #category : #accessing }
ZkCard >> library [

	^ library
]

{ #category : #accessing }
ZkCard >> linkCard: aCard [

	| cardLink |

	cardLink := ZkCardLink from: self to: aCard.
	cardLinks add: cardLink.

	self valueChanged
]

{ #category : #accessing }
ZkCard >> linkedCards [

	"Answer a collection of unique cards the receiver is linked with"

	^ (cardLinks collect: [ :cardLink | cardLink to ])
		removeDuplicates
]

{ #category : #testing }
ZkCard >> matches: aString [

	^ (title includesSubstring: aString caseSensitive: false)
		or: [ (description includesSubstring: aString caseSensitive: false)
			or: [ tags anySatisfy: [ :each | each includesSubstring: aString caseSensitive: false ] ] ]
]

{ #category : #'private - accessing' }
ZkCard >> removeCardLink: aCardLink [

	cardLinks remove: aCardLink.

	self valueChanged
]

{ #category : #accessing }
ZkCard >> removeTag: aString [

	(tags includes: aString)
		ifFalse: [ ^ self ].

	tags remove: aString.

	self valueChanged
]

{ #category : #accessing }
ZkCard >> tags [

	^ tags
]

{ #category : #accessing }
ZkCard >> title [

	^ title
]

{ #category : #accessing }
ZkCard >> title: aString [

	title = aString
		ifTrue: [ ^ self ].

	title := aString.

	self valueChanged
]

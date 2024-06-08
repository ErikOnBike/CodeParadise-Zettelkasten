Class {
	#name : 'ZkCardLink',
	#superclass : 'Object',
	#instVars : [
		'from',
		'to',
		'tags'
	],
	#category : 'CodeParadise-Zettelkasten-Model',
	#package : 'CodeParadise-Zettelkasten',
	#tag : 'Model'
}

{ #category : 'instance creation' }
ZkCardLink class >> from: sourceCard to: destinationCard [

	^ self basicNew
		initializeWithFrom: sourceCard to: destinationCard ;
		yourself
]

{ #category : 'instance creation' }
ZkCardLink class >> new [

	"Do not instantiate cards directly"

	self errorNewReplacedBy: #from:to:
]

{ #category : 'accessing' }
ZkCardLink >> addTag: aString [

	(tags includes: aString)
		ifTrue: [ ^ self ].

	tags add: aString.

	self valueChanged
]

{ #category : 'accessing' }
ZkCardLink >> from [

	^ from
]

{ #category : 'initialization' }
ZkCardLink >> initialize [

	super initialize.

	tags := OrderedCollection new
]

{ #category : 'initialization' }
ZkCardLink >> initializeWithFrom: sourceCard to: destinationCard [

	self initialize.

	from := sourceCard.
	to := destinationCard
]

{ #category : 'removing' }
ZkCardLink >> remove [

	to removeCardLink: self
]

{ #category : 'accessing' }
ZkCardLink >> removeTag: aString [

	tags remove: aString.

	self valueChanged
]

{ #category : 'accessing' }
ZkCardLink >> tags [

	^ tags
]

{ #category : 'accessing' }
ZkCardLink >> to [

	^ to
]

Class {
	#name : 'ZkTagOperationRequested',
	#superclass : 'Announcement',
	#instVars : [
		'value'
	],
	#category : 'CodeParadise-Zettelkasten-Events',
	#package : 'CodeParadise-Zettelkasten',
	#tag : 'Events'
}

{ #category : 'accessing' }
ZkTagOperationRequested class >> value: aString [

	^ self basicNew
		initializeWithValue: aString ;
		yourself
]

{ #category : 'initialization' }
ZkTagOperationRequested >> initializeWithValue: aString [

	self initialize.

	value := aString
]

{ #category : 'accessing' }
ZkTagOperationRequested >> value [

	^ value
]

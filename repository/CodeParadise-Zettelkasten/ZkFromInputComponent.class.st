Class {
	#name : 'ZkFromInputComponent',
	#superclass : 'CpEventCondition',
	#category : 'CodeParadise-Zettelkasten-Events',
	#package : 'CodeParadise-Zettelkasten',
	#tag : 'Events'
}

{ #category : 'testing' }
ZkFromInputComponent class >> matches: anEvent [

	"Answer whether the receiver matches the specified event.
	The target of the event should be an input component."

	^ anEvent target isInputComponent or: [ anEvent target parent isInputComponent ]
]

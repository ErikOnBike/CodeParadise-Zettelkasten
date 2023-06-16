Class {
	#name : #ZkZettelkasten,
	#superclass : #CpModel,
	#instVars : [
		'cardCollection'
	],
	#category : #'CodeParadise-Zettelkasten-Model'
}

{ #category : #accessing }
ZkZettelkasten >> cardCollection [

	^ cardCollection
]

{ #category : #initialization }
ZkZettelkasten >> initialize [

	super initialize.

	cardCollection := ZkCardCollection new
]

{ #category : #presenter }
ZkZettelkasten >> preferredPresenterClass [

	"Currently the receiver does not have a preferred presenter class.
	(This prevents the Smalltalk browser from showing a warning.)"

	^ nil
]

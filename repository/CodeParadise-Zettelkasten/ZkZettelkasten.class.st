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

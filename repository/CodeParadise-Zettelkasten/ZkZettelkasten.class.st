Class {
	#name : 'ZkZettelkasten',
	#superclass : 'CpModel',
	#instVars : [
		'cardCollection'
	],
	#category : 'CodeParadise-Zettelkasten-Model',
	#package : 'CodeParadise-Zettelkasten',
	#tag : 'Model'
}

{ #category : 'accessing' }
ZkZettelkasten >> cardCollection [

	^ cardCollection
]

{ #category : 'initialization' }
ZkZettelkasten >> initialize [

	super initialize.

	cardCollection := ZkCardCollection new
]

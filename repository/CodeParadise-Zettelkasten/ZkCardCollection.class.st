"
Mention count for unique ids.

Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	cards:		<Object>
	count:		<Object>


    Implementation Points
"
Class {
	#name : 'ZkCardCollection',
	#superclass : 'CpModel',
	#instVars : [
		'cards',
		'nextCardId'
	],
	#category : 'CodeParadise-Zettelkasten-Model',
	#package : 'CodeParadise-Zettelkasten',
	#tag : 'Model'
}

{ #category : 'accessing' }
ZkCardCollection >> addCard [

	"Add a new card to the receiver and answer it"

	| card |

	card :=ZkCard newWithId: nextCardId inLibrary: self.
	cards add: card.

	"Increase id for next card"
	nextCardId := nextCardId + 1.

	"Announce the receiver has changed to allow interested parties (like my Views) to update"
	self valueChanged.

	^ card
]

{ #category : 'accessing' }
ZkCardCollection >> asOrderedCollection [

	^ OrderedCollection with: self
]

{ #category : 'accessing' }
ZkCardCollection >> cardCount [

	^ cards size
]

{ #category : 'accessing' }
ZkCardCollection >> cards [

	^ cards
]

{ #category : 'accessing' }
ZkCardCollection >> description [

	"Answer a description for the receiver in the form:
		<criteria> (<card count>)"

	^ String streamContents: [ :stream |
		stream
			nextPutAll: 'Collection (' ;
			nextPutAll: self cardCount printString ;
			nextPut: $) ]
]

{ #category : 'initialization' }
ZkCardCollection >> initialize [

	super initialize.

	nextCardId := 1.
	cards := OrderedCollection new
]

{ #category : 'testing' }
ZkCardCollection >> isSelection [

	^ false
]

{ #category : 'accessing' }
ZkCardCollection >> itemPutOn: aStream [

	aStream nextPut: self
]

{ #category : 'accessing' }
ZkCardCollection >> library [

	^ self
]

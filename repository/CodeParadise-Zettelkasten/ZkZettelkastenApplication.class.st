Class {
	#name : #ZkZettelkastenApplication,
	#superclass : #CpMvpWebApplication,
	#instVars : [
		'zettelkasten'
	],
	#category : #'CodeParadise-Zettelkasten-Application'
}

{ #category : #accessing }
ZkZettelkastenApplication class >> app [

	^ #zettelkasten
]

{ #category : #accessing }
ZkZettelkastenApplication class >> clientBehaviorClass [

	^ ZkZettelkastenWebClientBehavior
]

{ #category : #initialization }
ZkZettelkastenApplication class >> resetGlobalZettelkasten [

	<script>

	Smalltalk globals removeKey: #GlobalZettelkasten ifAbsent: [ "Ignore" ]
]

{ #category : #accessing }
ZkZettelkastenApplication >> applicationModel [

	^ zettelkasten
]

{ #category : #presenter }
ZkZettelkastenApplication >> applicationPresenterClass [

	^ ZkZettelkastenApplicationPresenter
]

{ #category : #accessing }
ZkZettelkastenApplication >> initialize [

	| globalZettelkasten |

	super initialize.

	globalZettelkasten := Smalltalk globals at: #GlobalZettelkasten ifAbsentPut: [ ZkZettelkasten new ].

	zettelkasten := globalZettelkasten
]

{ #category : #installing }
ZkZettelkastenApplication >> installExtensionMethods [

	"Install the extension methods from known Classes"

	super installExtensionMethods.

	self installExtensionMethodsFor: #webApplicationShoelaceExtension
]

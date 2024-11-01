Class {
	#name : 'ZkZettelkastenWebApplication',
	#superclass : 'CpMvpWebApplication',
	#instVars : [
		'zettelkasten'
	],
	#category : 'CodeParadise-Zettelkasten-Application',
	#package : 'CodeParadise-Zettelkasten',
	#tag : 'Application'
}

{ #category : 'accessing' }
ZkZettelkastenWebApplication class >> allowedPackages [

	"Answer a collection of Packages which are allowed to contain classes to install in the receiver.

	Add package with SlElement class for the Shoelace components.

	See comment in superclass."

	^ super allowedPackages, { SlElement package }
]

{ #category : 'accessing' }
ZkZettelkastenWebApplication class >> app [

	^ #zettelkasten
]

{ #category : 'initialization' }
ZkZettelkastenWebApplication class >> resetGlobalZettelkasten [

	<script>

	Smalltalk globals removeKey: #GlobalZettelkasten ifAbsent: [ "Ignore" ]
]

{ #category : 'accessing' }
ZkZettelkastenWebApplication >> applicationModel [

	^ zettelkasten
]

{ #category : 'presenter' }
ZkZettelkastenWebApplication >> applicationPresenterClass [

	^ ZkZettelkastenApplicationPresenter
]

{ #category : 'installing' }
ZkZettelkastenWebApplication >> extensionMethodCategories [

	"Answer the collection of extension method categories needed for the receiver"

	^ super extensionMethodCategories,
		#(webApplicationShoelaceExtension)
]

{ #category : 'accessing' }
ZkZettelkastenWebApplication >> initialize [

	| globalZettelkasten |

	super initialize.

	globalZettelkasten := Smalltalk globals at: #GlobalZettelkasten ifAbsentPut: [ ZkZettelkasten new ].

	zettelkasten := globalZettelkasten
]

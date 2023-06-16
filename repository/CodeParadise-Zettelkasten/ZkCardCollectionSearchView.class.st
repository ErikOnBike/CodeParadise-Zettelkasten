Class {
	#name : #ZkCardCollectionSearchView,
	#superclass : #CpView,
	#category : #'CodeParadise-Zettelkasten-View'
}

{ #category : #'web resources' }
ZkCardCollectionSearchView class >> style [

	<webResource: #css>

	^ '*, *:before, *:after {
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
	}
	#container {
		position: absolute;
		top: 0;
		left: 0;
		width: 0;
		height: 0;
		overflow: 0;
		display: flex;
		align-items: center;
		justify-content: center;
		background-color: rgba(0, 0, 0, 0);
		transition: background-color 1s;
		z-index: 10;
	}
	:host(.show) #container {
		width: 100%;
		height: 100%;
		background-color: rgba(0, 0, 0, .25);
	}
	#search {
		min-width: 3em;
		width: 10%;
		margin-top: -10em;
		transition: width 1s;
	}
	:host(.show) #search {
		width: 80%;
	}'
]

{ #category : #'web resources' }
ZkCardCollectionSearchView class >> template [

	<webResource: #html>

	^ '<div id="container">
		<div id="search"><sl-input id="search-input" size="large" pill><sl-icon name="search" slot="prefix"></sl-icon><span id="count" slot="suffix"></span></sl-input></div>
	</div>'
]

{ #category : #rendering }
ZkCardCollectionSearchView >> close [

	self
		removeClass: #show ;
		removeFocus
]

{ #category : #rendering }
ZkCardCollectionSearchView >> closeAndReset [

	"Close the view and reset the search to an empty String.

	Implementation:
	Order is important: First close the view to prevent another update for the empty String being set."


	self searchInput value: ''.

	self close
]

{ #category : #accessing }
ZkCardCollectionSearchView >> containerElement [

	^ self shadowRoot elementWithId: #container
]

{ #category : #accessing }
ZkCardCollectionSearchView >> countElement [

	^ self shadowRoot elementWithId: #count
]

{ #category : #rendering }
ZkCardCollectionSearchView >> focus [

	self searchInput focus
]

{ #category : #'event handling' }
ZkCardCollectionSearchView >> handleSearchChanged: anInputEvent [

	| inputValue |

	"Check if search is actually showing, otherwise ignore"
	self isShowing
		ifFalse: [ ^ self ].

	inputValue := anInputEvent target value.

	self serverAnnounce: (CpFieldChanged id: #search value: inputValue)
]

{ #category : #'event handling' }
ZkCardCollectionSearchView >> handleSearchFinalized: aKeyEvent [

	"Announce change, with true as parameter to indicate search is finished now"
	self serverAnnounce: (CpActionRequested id: #searchFinalized)
]

{ #category : #initialization }
ZkCardCollectionSearchView >> initializeShadowRoot [

	super initializeShadowRoot.

	self searchInput
		when: SlInputEvent send: #handleSearchChanged: to: self ;
		when: CpKeyPressEvent enter & CpNoModifiersDown send: #handleSearchFinalized: to: self
]

{ #category : #testing }
ZkCardCollectionSearchView >> isInputComponent [

	^ true
]

{ #category : #testing }
ZkCardCollectionSearchView >> isShowing [

	^ self isClassed: #show
]

{ #category : #rendering }
ZkCardCollectionSearchView >> renderSelectionCount: aString [

	self countElement
		textContent: aString
]

{ #category : #accessing }
ZkCardCollectionSearchView >> searchInput [

	^ self shadowRoot elementWithId: #'search-input'
]

{ #category : #rendering }
ZkCardCollectionSearchView >> show [

	self
		addClass: #show ;
		focus
]

Class {
	#name : #ZkCardSelectionItemView,
	#superclass : #CpView,
	#category : #'CodeParadise-Zettelkasten-View'
}

{ #category : #'web resources' }
ZkCardSelectionItemView class >> style [

	<webResource: #css>

	"
		#container
		The item is an inline element and multiple items in a row show as a chain
		(left/right fitting into each other).
	"

	^'*, *:before, *:after {
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
	}
	#container {
		position: relative;
		display: inline-flex;
		align-items: center;
		justify-content stretch;
		height: var(--sl-input-height-medium);
		line-height: calc(var(--sl-input-height-medium) - var(--sl-input-border-width) * 2);
		padding-left: 16px;
		padding-right: 16px;
		border-color: var(--sl-color-primary-400);
		color: var(--sl-color-primary-700);
	}
	:host(.removable) #container {
		padding-right: 6px;
	}
	#container::before,
	#container::after {
		position: absolute;
		left: 0;
		height: 50%;
		width: 100%;
		content: "";
		border: 1px solid #000;
		z-index: -1;
	}
	#container:hover::before,
	#container:hover::after {	
		background-color: var(--sl-color-primary-100);
	}
	#container::before {
		border-bottom: none;
		border-top-left-radius: var(--sl-input-border-radius-medium);
		border-top-right-radius: var(--sl-input-border-radius-medium);
		top: 0;
		transform: skew(20deg);
	}
	#container::after {
		border-top: none;
		border-bottom-left-radius: var(--sl-input-border-radius-medium);
		border-bottom-right-radius: var(--sl-input-border-radius-medium);
		bottom: 0;
		transform: skew(-20deg);
	}
	#remove {
		display: none;
		font-size: var(--sl-button-font-size-medium);
	}
	:host(.removable) #remove {
		display: inline;
	}'
]

{ #category : #'web resources' }
ZkCardSelectionItemView class >> template [

	"See comment in #style method"

	<webResource: #html>

	^ '<span id="container">
		<slot name="description"></slot>
		<sl-icon-button id="remove" name="x-lg"></sl-icon-button>
	</span>'
]

{ #category : #rendering }
ZkCardSelectionItemView >> createDescriptionElement [

	self appendChild: (CpHtmlElement newWithTag: #span) atSlotNamed: #description
]

{ #category : #accessing }
ZkCardSelectionItemView >> descriptionElement [

	^ self firstChildAtSlotNamed: #description
]

{ #category : #'event handling' }
ZkCardSelectionItemView >> handleRemove [

	self serverAnnounce: ZkRemoveCardSelectionItem
]

{ #category : #initialization }
ZkCardSelectionItemView >> initialize [

	super initialize.

	self createDescriptionElement
]

{ #category : #initialization }
ZkCardSelectionItemView >> initializeShadowRoot [

	super initializeShadowRoot.

	(self shadowRoot elementWithId: #remove)
		when: CpPrimaryClickEvent send: #handleRemove to: self
]

{ #category : #rendering }
ZkCardSelectionItemView >> renderDescription: aString [

	self descriptionElement
		textContent: aString
]

{ #category : #rendering }
ZkCardSelectionItemView >> renderDescription: aString removable: aBoolean [

	self descriptionElement
		textContent: aString.

	self classed: #removable if: aBoolean
]

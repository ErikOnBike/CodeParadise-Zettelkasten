Class {
	#name : 'ZkCardSelectionOverviewView',
	#superclass : 'CpView',
	#category : 'CodeParadise-Zettelkasten-View',
	#package : 'CodeParadise-Zettelkasten',
	#tag : 'View'
}

{ #category : 'web resources' }
ZkCardSelectionOverviewView class >> style [

	<webResource: #css>

	"
		#container
		The selection is based on a source which itself can be another selection.
		Therefore selection is shown recursively descending down the selection-source
		hierarchy.
	"

	^'*, *:before, *:after {
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
	}
	#container {
		display: flex;
		flex-flow: row nowrap;
		align-items: center;
		column-gap: 4px;
		padding: 6px;
	}
	#add-selection-item {
		font-size: 2em;
		padding-left: 4px;
	}'
]

{ #category : 'web resources' }
ZkCardSelectionOverviewView class >> template [

	"See comment in #style method"

	<webResource: #html>

	^ '<div id="container">
		<slot name="selectionItems"></slot> <sl-icon-button id="add-selection-item" name="plus-circle-dotted"></sl-icon-button>
	</div>'
]

{ #category : 'as yet unclassified' }
ZkCardSelectionOverviewView >> handleAddSelectionItem: aClickEvent [

	"Show the search bar when adding another selection item"

	self parent
		showSearch
]

{ #category : 'initialization' }
ZkCardSelectionOverviewView >> initializeShadowRoot [

	super initializeShadowRoot.

	(self shadowRoot elementWithId: #'add-selection-item')
		when: CpPrimaryClickEvent send: #handleAddSelectionItem: to: self 
]

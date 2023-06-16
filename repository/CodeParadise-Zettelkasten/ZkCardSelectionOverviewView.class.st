Class {
	#name : #ZkCardSelectionOverviewView,
	#superclass : #CpView,
	#category : #'CodeParadise-Zettelkasten-View'
}

{ #category : #'web resources' }
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
		column-gap: 4px;
		padding: 6px;
	}'
]

{ #category : #'web resources' }
ZkCardSelectionOverviewView class >> template [

	"See comment in #style method"

	<webResource: #html>

	^ '<div id="container">
		<slot name="selectionItems"></slot>
	</div>'
]

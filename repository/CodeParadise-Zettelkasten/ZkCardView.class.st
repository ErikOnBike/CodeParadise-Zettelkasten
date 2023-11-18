Class {
	#name : #ZkCardView,
	#superclass : #CpFieldsView,
	#category : #'CodeParadise-Zettelkasten-View'
}

{ #category : #'web resources' }
ZkCardView class >> globalStyle [

	<webResource: #css>

	^'/* Shoelace styling */
	zk-card sl-input::part(base) {
		box-shadow: none;
	}
	zk-card sl-input[slot="tags"]::part(prefix) {
		--sl-input-spacing-medium: 0;
	}'
]

{ #category : #'web resources' }
ZkCardView class >> style [

	<webResource: #css>

	"
		#container
		Card has a header for the id and title. The body of the card consists of the description,
		the linked cards and the tags (in that order). The body elements linked cards and tags
		have a fixed height. The description fills up the remaining height.

		The cards have a border with rounded corners.
	"

	^'*, *:before, *:after {
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
	}
	:host {
		height: 100%;
	}
	#container {
		display: flex;
		flex-flow: column nowrap;
		width: var(--zk-card-width);
		height: var(--zk-card-height);
		row-gap: 6px;
		padding: 8px;
		justify-content: space-between;
		border: 3px solid #000;
		border-radius: 16px;
		transition: width 1s, height 1s;
	}
	#header {
		display: flex;
		align-items: center;
	}
	#body {
		flex-grow: 1;
		display: flex;
		flex-flow: column nowrap;
		row-gap: 6px;
		justify-content: space-between;
		height: 100%;
		overflow-y: scroll;
	}
	#title	 {
		flex-grow: 1;
		margin-left: 8px;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}
	#description {
		flex-grow: 1;
		overflow: hidden;
	}
	#linked-cards {
		flex-grow: 0;
		background-color: rgba(255, 0, 0, .1);
	}
	#tags {
		flex-grow: 0;
		background-color: rgba(255, 255, 0, .1);
	}'
]

{ #category : #'web resources' }
ZkCardView class >> template [

	"See comment in #style method"

	<webResource: #html>

	^ '<div id="container">
		<div id="header"><span id="id"><slot name="id"></slot></span><span id="title"><slot name="title"></slot><span></div>
		<div id="body">
			<div id="description"><slot name="description"></slot></div>
			<div id="linked-cards"><slot name="linked-cards"></slot></div>
			<div id="tags"><slot name="tags"></slot></div>
		</div>
	</div>'
]

{ #category : #rendering }
ZkCardView >> createDescriptionElement [

	| textarea |

	textarea :=  SlTextarea new
		resizeNone ;
		addClass: #'fill-height' ;
		placeholder: '<description>' ;
		rows: 1 ;
		when: SlInputEvent send: #handleDescriptionChanged: to: self ;
		when: SlChangeEvent send: #handleDescriptionChanged: to: self ;
		yourself.

	^ self appendChild: textarea atSlotNamed: #description
]

{ #category : #rendering }
ZkCardView >> createIdElement [

	| tag |

	tag := SlTag new
		bePill ;
		yourself.

	^ self appendChild: tag atSlotNamed: #id
]

{ #category : #rendering }
ZkCardView >> createTagsElement [

	"Create an input element with tags as prefix.
	Add event handler to make <enter> key add a tag.
	A resize handler is put on the receiver to allow
	existing tags to be collapsed for small cards."

	self when: CpResizeEvent send: #handleResize: to: self.

	^ (self appendChild: SlInput new atSlotNamed: #tags)
		placeholder: '<tag>' ;
		prefix: (CpHtmlElement newWithTag: #span) ;
		when: SlInputEvent send: #handleTagChanged: to: self ;
		when: SlChangeEvent send: #handleTagChanged: to: self ;
		when: CpKeyPressEvent enter & CpNoModifiersDown send: #handleTagAdd: to: self ;
		yourself
]

{ #category : #rendering }
ZkCardView >> createTitleElement [

	^ (self appendChild: SlInput new atSlotNamed: #title)
		placeholder: '<title>' ;
		when: SlInputEvent send: #handleTitleChanged: to: self ;
		when: SlChangeEvent send: #handleTitleChanged: to: self ;
		yourself
]

{ #category : #'event handling' }
ZkCardView >> handleDescriptionChanged: anEvent [

	self handleEvent: anEvent forField: #description
]

{ #category : #'event handling' }
ZkCardView >> handleResize: aResizeEvent [

	| tagsInput tagsElement tagsElementWidth inputElement inputElementWidth |

	"Select the relevant parts: the prefix (containing the tags) and input parts of the Shoelace SlInput component"
	tagsInput := self firstChildAtSlotNamed: #tags.
	tagsElement := tagsInput firstChildAtSlotNamed: #prefix.
	inputElement := tagsInput partNamed: #input.

	"Retrieve the width of the tags and input"
	tagsElementWidth := (tagsElement propertyAt: #clientWidth) ifNil: [ 0 ].
	inputElementWidth := (inputElement propertyAt: #clientWidth) ifNil: [ 0 ].
	inputElementWidth = 0
		ifTrue: [ ^ self ].

	"Check size and decide type of tags (dropdown or list)"
	tagsElement tagName = #span
		ifTrue: [
			"If input is too small or tags are bigger than input, use dropdown list"
			(inputElementWidth < 128 or: [ tagsElementWidth > inputElementWidth ])
				ifTrue: [ self tagsBeDropdownList ] ]
		ifFalse: [ self flag: #TODO "Add #tagsBeInlined" ]
]

{ #category : #'event handling' }
ZkCardView >> handleTagAdd: aKeyEvent [

	| tagInput tag |

	tagInput := self tagInput.
	(tag := tagInput value)
		ifEmpty: [ ^ self ].

	"Reset input"
	tagInput value: ''.

	self serverAnnounce: (ZkAddTagRequested value: tag)
]

{ #category : #'event handling' }
ZkCardView >> handleTagChanged: anEvent [

	self flag: #TODO.	"Add support to autocomplete any known tags"
]

{ #category : #'event handling' }
ZkCardView >> handleTagRemove: aRemoveEvent [

	self serverAnnounce: (ZkRemoveTagRequested value: aRemoveEvent target contentText)
]

{ #category : #'event handling' }
ZkCardView >> handleTitleChanged: anEvent [

	self handleEvent: anEvent forField: #title
]

{ #category : #initialization }
ZkCardView >> initialize [

	super initialize.

	self
		createIdElement ;
		createTitleElement ;
		createDescriptionElement ;
		createTagsElement
]

{ #category : #rendering }
ZkCardView >> render: aString toInputAtSlotNamed: slotNameString [

	| inputElement |

	inputElement := self firstChildAtSlotNamed: slotNameString.

	"If the title element has focus, do not render new value"
	inputElement hasFocus
		ifTrue: [ ^ self ].

	inputElement value: aString
]

{ #category : #rendering }
ZkCardView >> renderDescription: aString [

	self render: aString toInputAtSlotNamed: #description
]

{ #category : #rendering }
ZkCardView >> renderId: aString [

	(self firstChildAtSlotNamed: #id)
		textContent: aString
]

{ #category : #rendering }
ZkCardView >> renderTags: aCollection [

	| tagsElement |

	tagsElement := self tagsElement.

	"Select either the dropdown list or use the tags element itself"
	(tagsElement firstDescendantMatching: 'sl-dropdown > :not([slot="trigger"])') ifNotNil: [ :dropdownListElement |
		tagsElement := dropdownListElement ].

	"Remove existing and then (re)add new tags"
	tagsElement removeChildren.
	aCollection do: [ :each |
		tagsElement appendChild: (SlTag new
			contentText: each ;
			beRemovable ;
			when: SlRemoveEvent send: #handleTagRemove: to: self ;
			yourself) ]
]

{ #category : #rendering }
ZkCardView >> renderTitle: aString [

	self render: aString toInputAtSlotNamed: #title
]

{ #category : #accessing }
ZkCardView >> tagInput [

	^ self firstChildAtSlotNamed: #tags
]

{ #category : #rendering }
ZkCardView >> tagsBeDropdownList [

	| tagsElement tags |

	"Test whether a dropdown list is already shown"
	tagsElement := self tagsElement.
	(tagsElement firstDescendantMatching: 'sl-dropdown')
		ifNotNil: [ ^ self ].

	tags := (tagsElement allDescendantsMatching: 'sl-tag')
		collect: [ :each | each textContent ].

	"Remove tags and add dropdown list"
	tagsElement removeChildren.
	tagsElement appendChild: (SlDropdown new
		attributeAt: #hoist put: '' ;
		appendChild: ((SlButton label: 'Tags')
			beSmall ;
			yourself) atSlotNamed: #trigger ;
		appendChild: ((CpHtmlElement newWithTag: #span)
			styleAt: #display put: #'inline-block' ;
			styleAt: #'background-color' put: '#fff' ;
			yourself) ;
		yourself).

	"Add tags again"
	self renderTags: tags
]

{ #category : #accessing }
ZkCardView >> tagsElement [

	"Answer the tags element (which is prefixed in the input field)"

	^ self tagInput prefix
]

Class {
	#name : 'ZkZettelkastenApplicationView',
	#superclass : 'CpView',
	#category : 'CodeParadise-Zettelkasten-View',
	#package : 'CodeParadise-Zettelkasten',
	#tag : 'View'
}

{ #category : 'web resources' }
ZkZettelkastenApplicationView class >> globalStyle [

	<webResource: #css>

	^ 'body {
	margin: 0;
	padding: 0 ;
	width: 100vw;
	height: 100vh;
	overflow: hidden;
	font-family: "SF Pro Text", "Helvetica Neue", Helvetica, Arial, sans-serif;
	--zk-library-columns: 4;
	--zk-card-ratio: calc(5 / 3);
	--zk-card-gap-horizontal: 12px;
	--zk-card-gap-vertical: 6px;
	--zk-card-width: calc(100vw / var(--zk-library-columns) - var(--zk-card-gap-horizontal));
	--zk-card-height: calc((var(--zk-card-width) + var(--zk-card-gap-horizontal)) / var(--zk-card-ratio) - var(--zk-card-gap-vertical));
}
sl-textarea.fill-height,
sl-textarea.fill-height::part(form-control),
sl-textarea.fill-height::part(form-control-input),
sl-textarea.fill-height::part(base),
sl-textarea.fill-height::part(textarea) {
	height: 100%;
}'
]

{ #category : 'web resources' }
ZkZettelkastenApplicationView class >> style [

	<webResource: #css>

	"
		#container
		The application is shown as a library (collection of cards) at the top of the window
		and a small status bar at the bottom of the window. Both use up only the minimal space
		required. The space between them is empty.

		#collection
		If the collection becomes too big, it will become scrollable (leavig the status bar
		attached to the bottom of the window).
	"

	^ '*, *:before, *:after {
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
	}
	#container {
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		gap: 8px;
		height: 100%;
	}
	#collection {
		flex-grow: 1;
		overflow-y: auto;
	}
	#status {
		font-size: 1.4rem;
		padding: 0px 12px 4px 12px;
	}'
]

{ #category : 'web resources' }
ZkZettelkastenApplicationView class >> template [

	<webResource: #html>

	^ '<div id="container">
	<div id="selection"><slot name="selection"></slot></div>
	<div id="collection"><slot name="collection"></slot></div>
	<div id="status"><slot name="status">Hello world</slot></div>
</div>
<slot name="search"></slot>'
]

{ #category : 'rendering' }
ZkZettelkastenApplicationView >> closeSearch [

	self searchElement close
]

{ #category : 'event handling' }
ZkZettelkastenApplicationView >> handleColumnsKey: aKeyEvent [

	"Display number of columns specified by the key"

	aKeyEvent preventDefault.

	self selectColumns: aKeyEvent key first digitValue
]

{ #category : 'event handling' }
ZkZettelkastenApplicationView >> handleEscapeKey: aKeyEvent [

	"Stop searching on escape"

	aKeyEvent preventDefault.
	self closeSearch
]

{ #category : 'event handling' }
ZkZettelkastenApplicationView >> handleSearchKey: aKeyEvent [

	"Perform search"

	aKeyEvent preventDefault.
	self showSearch
]

{ #category : 'initialization' }
ZkZettelkastenApplicationView >> initialize [

	super initialize.

	"Add some key event handlers on the body (where all key events will end up at the moment).
	For some actions both the action modifier and a non-action modifier are installed. The later
	only works when not inside an input component (in which case it will be handled by the input
	itself). Same holds for the digit keys which set the number of columns."

	CpHtmlElement documentBody
		when: CpKeyPressEvent escape send: #handleEscapeKey: to: self ;
		when: (CpKeyPressEvent key: '/') & CpActionKeyDown send: #handleSearchKey: to: self ;
		when: (CpKeyPressEvent key: '?') & CpActionKeyDown send: #handleSearchKey: to: self ;
		when: (CpKeyPressEvent key: '/') & ZkFromInputComponent not send: #handleSearchKey: to: self ;
		when: (CpKeyPressEvent key: '?') & ZkFromInputComponent not send: #handleSearchKey: to: self ;
		when: (CpKeyPressEvent keyRangeFrom: '2' to: '8') & CpActionKeyDown send: #handleColumnsKey: to: self ;
		when: (CpKeyPressEvent keyRangeFrom: '2' to: '8') & ZkFromInputComponent not send: #handleColumnsKey: to: self
]

{ #category : 'accessing' }
ZkZettelkastenApplicationView >> searchElement [

	^ self firstChildAtSlotNamed: #search
]

{ #category : 'rendering' }
ZkZettelkastenApplicationView >> selectColumns: columnCount [

	(columnCount between: 2 and: 6)
		ifFalse: [ ^ self ].

	CpHtmlElement documentBody
		styleAt: #'--zk-library-columns' put: columnCount printString
]

{ #category : 'rendering' }
ZkZettelkastenApplicationView >> showSearch [

	self searchElement show
]

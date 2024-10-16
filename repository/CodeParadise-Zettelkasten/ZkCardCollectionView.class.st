Class {
	#name : 'ZkCardCollectionView',
	#superclass : 'CpView',
	#category : 'CodeParadise-Zettelkasten-View',
	#package : 'CodeParadise-Zettelkasten',
	#tag : 'View'
}

{ #category : 'web resources' }
ZkCardCollectionView class >> style [

	<webResource: #css>

	"
		#container
		Create 'grid' of cards, fill row-by-row and let them wrap around. Cards will have a size which is a fixed
		part of the full width like 1/3 or 1/4 of the width. So an integral number of cards can be displayed.

		The card width and height (represented by var(--zk-card-width) and var(--zk-card-height) as defined in
		ZkZettelkastenApplicationView class >> #globalStyle) already have taken the gap between cards
		into account.

		For convenience a fixed gap is calculated. This is simply removed from the actual card width. Since gaps
		are between cards, one additionl gap is calculated for. This space is split between left and right margin. 

		#add-card
		One additional card is added which contains a plus sign (in an icon button), used to allow adding cards.
		It uses the calculated card size and (a percentage of) the card height to create a large size. The
		percentage is given as 0.8 instead of 80% otherwise the font-size is used as basis and not the calculated
		value.
	"

	^'*, *:before, *:after {
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
	}
	#container {
		display: flex;
		flex-flow: row wrap;
		column-gap: var(--zk-card-gap-horizontal);
		row-gap: var(--zk-card-gap-vertical);
		margin-left: calc(var(--zk-card-gap-horizontal) / 2);
		margin-right: calc(var(--zk-card-gap-horizontal) / 2);
	}
	#add-card {
		display: flex;
		align-items: center;
		justify-content: center;
		width: var(--zk-card-width);
		height: var(--zk-card-height);
		font-size: calc(var(--zk-card-height) * 0.8);
		transition: width 1s, height 1s, font-size 1s;
	}'
]

{ #category : 'web resources' }
ZkCardCollectionView class >> template [

	"See comment in #style method"

	<webResource: #html>

	^ '<div id="container">
		<slot name="cards"></slot>
		<div id="add-card"><sl-icon-button id="add-card-button" name="plus-circle-dotted"></sl-icon-button></div>
	</div>'
]

{ #category : 'accessing' }
ZkCardCollectionView >> addCardButton [

	^ self shadowRoot elementWithId: #'add-card-button'
]

{ #category : 'event handling' }
ZkCardCollectionView >> handleAddCardRequested [

	self serverAnnounce: ZkAddCardRequested
]

{ #category : 'initialization' }
ZkCardCollectionView >> initializeShadowRoot [

	super initializeShadowRoot.

	self addCardButton
		when: CpPrimaryClickEvent send: #handleAddCardRequested to: self
]

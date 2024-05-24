Class {
	#name : 'ZkCardPresenter',
	#superclass : 'CpPresenter',
	#category : 'CodeParadise-Zettelkasten-Presenter',
	#package : 'CodeParadise-Zettelkasten',
	#tag : 'Presenter'
}

{ #category : 'accessing' }
ZkCardPresenter >> card [

	^ self model
]

{ #category : 'event handling' }
ZkCardPresenter >> handleAddTagRequested: anAddTagRequested [

	self card addTag: anAddTagRequested value
]

{ #category : 'event handling' }
ZkCardPresenter >> handleDescriptionChanged: aFieldChanged [

	self card description: aFieldChanged value
]

{ #category : 'event handling' }
ZkCardPresenter >> handleRemoveTagRequested: anAddTagRequested [

	self card removeTag: anAddTagRequested value
]

{ #category : 'event handling' }
ZkCardPresenter >> handleTitleChanged: aFieldChanged [

	self card title: aFieldChanged value
]

{ #category : 'rendering' }
ZkCardPresenter >> renderView [

	| card |

	card := self card.

	self view
		renderId: card id printString ;
		renderTitle: card title ;
		renderDescription: card description ;
		renderTags: card tags asArray
]

{ #category : 'view' }
ZkCardPresenter >> viewCreated [

	super viewCreated.

	self view
		when: (CpFieldChanged id: #title) send: #handleTitleChanged: to: self ;
		when: (CpFieldChanged id: #description) send: #handleDescriptionChanged: to: self ;
		when: ZkAddTagRequested send: #handleAddTagRequested: to: self ;
		when: ZkRemoveTagRequested send: #handleRemoveTagRequested: to: self
]

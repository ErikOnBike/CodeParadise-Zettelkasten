Class {
	#name : 'ZkZettelkastenWebClientBehavior',
	#superclass : 'CpMvpWebClientBehavior',
	#category : 'CodeParadise-Zettelkasten-Application',
	#package : 'CodeParadise-Zettelkasten',
	#tag : 'Application'
}

{ #category : 'class initialization' }
ZkZettelkastenWebClientBehavior class >> beLoaded [

	SlIconButton beLoaded.
	SlDropdown beLoaded.
	SlInput beLoaded
]

{ #category : 'initialization' }
ZkZettelkastenWebClientBehavior >> addGlobalStyle [

	"Add global styling.

	Hide the placeholder when focus is given to an input element."

	CpHtmlElement documentAddStyle: '

		*, *:before, *:after {
			-moz-box-sizing: border-box;
			-webkit-box-sizing: border-box;
			box-sizing: border-box;
		}

		sl-input:focus::part(input)::placeholder,
		sl-textarea:focus::part(textarea)::placeholder {
			opacity: 0;
		}
	
		zk-card sl-input sl-tag {
			margin-left: 2px;
			--sl-color-neutral-50: rgba(0, 0, 128, .1);
		}'
]

{ #category : 'initialization' }
ZkZettelkastenWebClientBehavior >> initialize [

	super initialize.

	self addGlobalStyle
]

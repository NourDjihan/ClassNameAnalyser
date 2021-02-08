Class {
	#name : #DMFilterer,
	#superclass : #Object,
	#category : #CNBFeatureSelector
}

{ #category : #filtering }
DMFilterer >> removeAllDigitsAndSpecialCharsFrom: aName [

	| tokens |
	tokens := self removeAllDigitsFrom: aName.
	tokens := self removeAllSpecialCharsFrom: tokens.
	^ tokens
]

{ #category : #filtering }
DMFilterer >> removeAllDigitsFrom: aName [

	| tokens token |
	token := ''.
	tokens := aName piecesCutWhereCamelCase.
	tokens := tokens reject: [ :each | each isAllDigits ].
	tokens do: [ :each | token := token , each ]. 	
	^ token
]

{ #category : #filtering }
DMFilterer >> removeAllSpecialCharsFrom: aName [

	| tokenizer token tokens|
	token := ''.
	tokenizer := DMNameTokenizer new.
	tokens := aName piecesCutWhereNonAlphaNumeric.
	tokens := tokens reject: [ :each | each asString isAllAlphaNumerics not ].
	tokens do: [ :each | token := token , each asString ].	
	^ token
]
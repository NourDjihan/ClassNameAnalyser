Class {
	#name : #CNBAbstractViewModel,
	#superclass : #CNBAbstractModel,
	#instVars : [
		'color',
		'border'
	],
	#category : #CNBModels
}

{ #category : #accessing }
CNBAbstractViewModel >> border [ 
	border color: self defaultBorderColor.
	border width: self defaultBorderWidth.
	^border
]

{ #category : #accessing }
CNBAbstractViewModel >> border: aBorder [
	border := aBorder
]

{ #category : #accessing }
CNBAbstractViewModel >> borderColor [ 
	^border color isNotNil
		ifTrue: [ border color ] ifFalse: [ self defaultBorderColor ]
	
	

]

{ #category : #accessing }
CNBAbstractViewModel >> borderColor: aColor [ 	
	border color: aColor
]

{ #category : #accessing }
CNBAbstractViewModel >> color [ 
	^color isNotNil
	ifTrue: [ color ] ifFalse: [ self defaultColor ]
]

{ #category : #accessing }
CNBAbstractViewModel >> color: aColor [ 
	color := aColor
]

{ #category : #initialization }
CNBAbstractViewModel >> createBox [ 
	| box  |
		
	box := RSComposite new 
				model: self;
				color: self color;
				popupText: name;  
				withBorder; 
				border: self border.
	
	^box 
]

{ #category : #initialization }
CNBAbstractViewModel >> defaultBorderColor [
	^Color black
]

{ #category : #initialization }
CNBAbstractViewModel >> defaultBorderWidth [
	^1
	

]

{ #category : #initialization }
CNBAbstractViewModel >> defaultColor [ 
	^Color white darker
]

{ #category : #initialization }
CNBAbstractViewModel >> initialize [ 
	super initialize.
	border := RSBorder new
]

{ #category : #printing }
CNBAbstractViewModel >> printOn: aStream [
	super printOn: aStream. 
	aStream nextPutAll: ' ('.
	self name asString printOn: aStream.
	aStream nextPutAll: ')'

	
]
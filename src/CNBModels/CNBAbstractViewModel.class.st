Class {
	#name : #CNBAbstractViewModel,
	#superclass : #CNBAbstractModel,
	#instVars : [
		'box',
		'color',
		'border',
		'originalColor'
	],
	#category : #CNBModels
}

{ #category : #initialization }
CNBAbstractViewModel class >> defaultColor [ 
	^Color black
]

{ #category : #accessing }
CNBAbstractViewModel >> border [ 

	^ border 
			color: self defaultBorderColor;
			width: self defaultBorderWidth;
			yourself
]

{ #category : #accessing }
CNBAbstractViewModel >> border: aBorder [

	border := aBorder
]

{ #category : #accessing }
CNBAbstractViewModel >> borderColor [ 

	^ border 
			color isNotNil 
				ifTrue: [ border color ] 
				ifFalse: [ self defaultBorderColor ]
	
	

]

{ #category : #accessing }
CNBAbstractViewModel >> borderColor: aColor [ 	
	
	border color: aColor
]

{ #category : #accessing }
CNBAbstractViewModel >> box [

	^ box
]

{ #category : #accessing }
CNBAbstractViewModel >> color [ 

	^ color isNotNil
				ifTrue: [ color ]
				ifFalse: [ self defaultColor ]
]

{ #category : #accessing }
CNBAbstractViewModel >> color: aColor [ 

	color := aColor
]

{ #category : #initialization }
CNBAbstractViewModel >> createBox [ 

	^ box
			model: self;
			color: self color;
			popupText: name;  
			withBorder; 
			border: self border;
			yourself
]

{ #category : #initialization }
CNBAbstractViewModel >> defaultBorderColor [

	^ Color black
]

{ #category : #initialization }
CNBAbstractViewModel >> defaultBorderWidth [

	^ 1
	

]

{ #category : #initialization }
CNBAbstractViewModel >> defaultColor [ 

	^ Color white darker
]

{ #category : #initialization }
CNBAbstractViewModel >> initialize [ 
	super initialize.
	
	border := RSBorder new.
	box := RSComposite new.
	box when: RSMouseLeftClick do: [ :evt | self processEvent: evt ].
]

{ #category : #accessing }
CNBAbstractViewModel >> originalColor [

	 ^ originalColor 
]

{ #category : #accessing }
CNBAbstractViewModel >> originalColor: aColor [

	 originalColor := aColor
]

{ #category : #printing }
CNBAbstractViewModel >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: '('.
	self name asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #'events-processing' }
CNBAbstractViewModel >> processEvent: evt [

	^ self inspect 
]

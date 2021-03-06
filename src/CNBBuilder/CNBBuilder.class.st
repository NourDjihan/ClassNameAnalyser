Class {
	#name : #CNBBuilder,
	#superclass : #Object,
	#traits : 'CNBTColorAttributor + CNBTDataExtractor',
	#classTraits : 'CNBTColorAttributor classTrait + CNBTDataExtractor classTrait',
	#classInstVars : [
		'rootmodels',
		'conceptualmodel'
	],
	#category : #CNBBuilder
}

{ #category : #counting }
CNBBuilder class >> countIntrudersIn: aViewModel [
	^self new
		countIntrudersIn: aViewModel
]

{ #category : #enumerating }
CNBBuilder class >> do: anObject [
	^self new 
		do: anObject
]

{ #category : #doing }
CNBBuilder class >> doPackageModelsOf: aModel [

	^self new 
		doPackageModelsOf: aModel 
]

{ #category : #doing }
CNBBuilder class >> doPackageViewModelsOf: packageModels [
	^self new
	doPackageViewModelsOf: packageModels 
]

{ #category : #doing }
CNBBuilder class >> doPrefixesDictionaryFrom: aCollectionOfClassModels [
	^self new 
	doPrefixesDictionaryFrom: aCollectionOfClassModels

]

{ #category : #doing }
CNBBuilder class >> doRootsOf: aCollectionOfClassModels [ 
	^self new
		doRootsOf: aCollectionOfClassModels  
]

{ #category : #doing }
CNBBuilder class >> doTokenDictionaryFrom: aCollectionOfClassModels [
	^self new 
	doTokenDictionaryFrom: aCollectionOfClassModels

]

{ #category : #extraction }
CNBBuilder class >> extractBiggestClassDepthFrom: aConceptualModel [ 
	| classModels |
	classModels := self new 
		extractClassModelsFrom: aConceptualModel.
	^self new 
		extractBiggestClassDepthFrom: classModels.
]

{ #category : #extraction }
CNBBuilder class >> extractClassModelsFrom: packageModels [ 	
	^self new
		extractClassModelsFrom: packageModels 
]

{ #category : #extraction }
CNBBuilder class >> extractSmallestClassDepthFrom: aConceptualModel [
	| classModels |
	classModels := self new 
		extractClassModelsFrom: aConceptualModel.
	^self new 
		extractSmallestClassDepthFrom: classModels.

	
]

{ #category : #sorting }
CNBBuilder class >> sort: aCollection [ 

	^self new
		sortAccordingToPalette: aCollection 
]

{ #category : #assignments }
CNBBuilder >> assignColorByType: aType [

	(aType = CNBClassType trait)
	ifTrue: [ ^ palette traitColor ].
	
	(aType = CNBClassType monoClass)
	ifTrue: [ ^ palette monoClassColor ].
	
	(aType = CNBClassType monoToken)
	ifTrue: [  ^ palette monoTokenColor ].
	
	(aType = CNBClassType multiToken)
	ifTrue: [ ^ palette aColorForMultiToken ].
]

{ #category : #building }
CNBBuilder >> buildRootsFrom: classModels [

		^ (classModels collect: #root) 
			asSet
				collect: [ :aRootClass |
									CNBRootModel 
										model: aRootClass 
										with: (classModels select: [ :aClass | aClass root = aRootClass ]).
			 				].
]

{ #category : #coloring }
CNBBuilder >> color: rootModels [

	|  coloredRootModels |
	
	coloredRootModels := (self sortRootModels: rootModels)
		collect: 
			[ :each | each 
							color: (self 
											assignColorByType: each type) ].					
	^ coloredRootModels 
	
]

{ #category : #counting }
CNBBuilder >> countIntrudersIn: aCnbDescription [

	| conceptVModels intruders conceptIntruders |
	
	intruders := 0.
	conceptVModels := aCnbDescription packageViewModels flatCollect: #tokenViewModels.
	
	conceptVModels do: [ :eachCVM |
		conceptIntruders := eachCVM classViewModels select: [ :cvm |
			cvm root isMonoClass not and: [ 
				cvm root name ~= eachCVM root name ] ].
		
		intruders := intruders + conceptIntruders size ].	
		
	^intruders
	
]

{ #category : #building }
CNBBuilder >> do: anObject [

	^ anObject startBuilding 
]

{ #category : #building }
CNBBuilder >> doClassViewModelsOf: classmodels using: rootModels [

	^ classmodels 
			collect: [ :eachClassModel | | itsRoot | 
				itsRoot := rootModels 
					detect: [ :eachRootModel | eachClassModel root name = eachRootModel name ].
				
			CNBClassViewModel of: eachClassModel with: itsRoot. 
				 ]
]

{ #category : #building }
CNBBuilder >> doPackageModelsOf: aCND [

	^ aCND 
			model packages collect: [ :eachPackage | 
												CNBPackageModel 
													of: eachPackage 
													withSettings: aCND setting  ]
]

{ #category : #building }
CNBBuilder >> doPackageViewModelsOf: aCND [ 

		(aCND viewModel 
			packageModels 
				collect: [ :eachPackageModel |
						eachPackageModel packageViewModel:  
									(CNBPackageViewModel 
										of: eachPackageModel 
										with: (self 
													doTokenViewModelsOf: eachPackageModel 
													using: aCND viewModel rootModels)) ]).
		^ aCND viewModel packageModels collect: #packageViewModel
]

{ #category : #building }
CNBBuilder >> doRootsOf: classModels [

	| coloredRootModels rootModels |
						
	coloredRootModels := self 
			color: (self buildRootsFrom: classModels).
	
	rootModels := self 
			startFightOverTokensBetween: coloredRootModels.
	
	^ rootModels asSet
]

{ #category : #building }
CNBBuilder >> doTokenDictionaryFrom: classModels [

	| tokensDictionary tokens |
	tokensDictionary := Dictionary new.
	
	tokens := (classModels collect: #token).
	(classModels collect: #token) 
		do: [ :aToken | 
			tokensDictionary 
				at: aToken 
				put: (tokens occurrencesOf: aToken) ].
			
	^ tokensDictionary 
]

{ #category : #building }
CNBBuilder >> doTokenViewModelsOf: aPackageModel using: rootModels [
	"On enveloppe chaque class du package dans son concept box "

	^ (self extractTokensFrom: aPackageModel) asSet 
		collect: [ :aToken | 
			CNBTokenViewModel 
				of: aToken
				root: (self 
							selectBiggestHierarchyOf: aToken
							using: rootModels) 
				with: (self 
								doClassViewModelsOf: (aPackageModel extractClassModelsWithToken: aToken)
								using: rootModels)
				in: aPackageModel ]
]

{ #category : #initialize }
CNBBuilder >> initialize [
	super initialize.
	palette := CNBPalette
		with:
			{#red . #yellow . #blue .#purple . #brown . #magenta . #orange . #green.
			#pink . #tan . #cyan . #lightRed . #lightGreen . #lightMagenta.
			#lightOrange . #lightYellow . #paleGreen . #paleMagenta . #paleOrange.
			#palePeach . #paleRed . #lightBrown . #paleTan . #paleMagenta }
]

{ #category : #sorting }
CNBBuilder >> sortAccordingToPalette: aCollection [
	| newPalette |
	newPalette := palette multiTokenColors asOrderedCollection.
	
	newPalette
		addAll:
			{palette monoTokenColor.
			palette monoClassColor.
			palette defaultColor}.
			
	^ ((1 to: newPalette size)
		collect: [ :cursor | 
			aCollection
				select: [ :aConceptVM | aConceptVM color = (newPalette at: cursor) ] ]) flattened
]

{ #category : #sorting }
CNBBuilder >> sortRootModels: aSetOfRootModels [

	^ (aSetOfRootModels 
			sorted: #size descending)
]

{ #category : #internal }
CNBBuilder >> startFightOverTokensBetween: rootModels [
	| tokens |
	
	tokens := (rootModels flatCollect: [ :each | each tokensDictionary keys ]) asSet.
	tokens
		do: [ :aToken | 
			| fighters winner |
			fighters := (rootModels
								select: [ :aRoot | aRoot tokensDictionary includesKey: aToken ]) copy asOrderedCollection.
								
			(fighters anySatisfy: [ :aRootModel | aRootModel isMultiToken ])
				ifTrue: [ fighters removeAllSuchThat: [ :aRootM | aRootM isMonoClass or: [ aRootM isTrait ] ] ].
				
			winner := fighters
				detectMax: [ :aRM | (aRM tokensDictionary at: aToken) value ].
			winner dominantTokens: (winner tokensDictionary associationAt: aToken) ].
	^ rootModels
]

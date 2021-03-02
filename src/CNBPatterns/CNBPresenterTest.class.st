Class {
	#name : #CNBPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'projectCNB',
		'cnbCanvas',
		'presenter',
		'roots',
		'suffixModels',
		'allNodes'
	],
	#category : #CNBPatterns
}

{ #category : #tests }
CNBPresenterTest >> changeToCalypso [ 
	projectCNB := CNBRoassal3Builder projectNameMatches: 'calypso-*'.
	presenter projectSelector text: 'calypso-*'. 
	presenter onLoadProjectClicked.
	presenter cnbSpecView openWithSpec.
	suffixModels := projectCNB viewModel suffixModels reject: [ :each | each pattern isNil ]
]

{ #category : #running }
CNBPresenterTest >> setUp [
	super setUp.
	
	presenter := CNBPresenter new.
	projectCNB := CNBRoassal3Builder projectNameMatches: 'moose-*'.
	roots := projectCNB viewModel rootModels collect: [ :each | each ].
	cnbCanvas := projectCNB on: RSCanvas new.
	presenter projectSelector text: 'moose-*'. 
	presenter onLoadProjectClicked.
	presenter cnbSpecView openWithSpec.
	suffixModels := projectCNB viewModel suffixModels reject: [ :each | each pattern isNil ].
	allNodes := cnbCanvas deepNodes.
]

{ #category : #tests }
CNBPresenterTest >> testCanvasNotNil [


	self assert: presenter cnbSpecView canvas isNotNil equals: true
]

{ #category : #checkPatternsInCNB }
CNBPresenterTest >> testCheckAllHomogeneous [
	| homogeneous |
	homogeneous := suffixModels 
							select: [ :each | each pattern isHomogeneous ].
	
	self 
		assert: (homogeneous collect: #color) asSet size equals: 1
]

{ #category : #checkPatternsInCNB }
CNBPresenterTest >> testCheckAllHomogeneousColorSize [
	| homogeneous |
	homogeneous := suffixModels 
							select: [ :each | each pattern isHomogeneous ].
	
	self 
		assert: (homogeneous collect: #color) asSet size equals: 1
]

{ #category : #ScatteredVocabularyPattern }
CNBPresenterTest >> testCheckAllScatteredVocabularyInsidePackageSize [

	| scatteredVocabulary packageSuffixesDictionary packages |
	scatteredVocabulary := suffixModels 
							select: [ :each | each pattern isScatteredVocabulary ].
	
	packages := (scatteredVocabulary 
							collect: [ :each | each package ]) asSet.				
	packageSuffixesDictionary := (packages 
							collect: [ :each | 
								each -> (scatteredVocabulary 
								select: [ :suffix | suffix package = each ]) ]) asDictionary.
							
	packageSuffixesDictionary do: [ :each | 
				each value addAll: (scatteredVocabulary 
				select: [ :suffix | suffix package = each ])  ].
	self 
		assert: (packageSuffixesDictionary values allSatisfy: [ :each | each size >= CNBPatternSelector svMinSuffixSize ])  
		equals: true
]

{ #category : #ScatteredVocabularyPattern }
CNBPresenterTest >> testCheckAllScatteredVocabularySuffixHasNoOutsiders [

	| scatteredVocabulary |
	scatteredVocabulary := suffixModels 
							select: [ :each | each pattern isScatteredVocabulary ].
							
	
	self 
		assert: (scatteredVocabulary allSatisfy: [ :each | each hasNoOutsiders ])  
		equals: true
]

{ #category : #ScatteredVocabularyPattern }
CNBPresenterTest >> testCheckAllScatteredVocabularySuffixSize [

	| scatteredVocabulary |
	scatteredVocabulary := suffixModels 
							select: [ :each | each pattern isScatteredVocabulary ].
							
	
	self 
		assert: (scatteredVocabulary allSatisfy: [ :each | each size >= CNBPatternSelector svMinClassSize ])  
		equals: true
]

{ #category : #SnowFlakesTest }
CNBPresenterTest >> testCheckAllSnowFlakesColorSize [

	| snowFlakes |
	snowFlakes := suffixModels 
							select: [ :each | each pattern isSnowFlakes  ].
							
	
	self 
		assert: ((snowFlakes collect: #color) allSatisfy: [ :each | each isMonoClassColor ])  
		equals: true
]

{ #category : #SnowFlakesTest }
CNBPresenterTest >> testCheckAllSnowFlakesMaxSize [

	| snowFlakes |
	snowFlakes := suffixModels 
							select: [ :each | each pattern isSnowFlakes  ].
							
	
	self 
		assert: (snowFlakes allSatisfy: [ :each | each size >= CNBPatternSelector snowFlakesSize ])  
		equals: true
]

{ #category : #checkingOneSuffixPattern }
CNBPresenterTest >> testCheckConfetti [
	| aSuffixModel |
	self changeToCalypso.
	
	aSuffixModel := suffixModels 
		detect: [ :each | each name = 'Example' 
			and: [ each package = 'Calypso-NavigationModel-Tests' ] ].
		
	aSuffixModel checkConfetti.

	self
		assert: aSuffixModel pattern isConfetti
		
		equals: true  
]

{ #category : #confettiTests }
CNBPresenterTest >> testCheckConfettiNumberInCNB [

	| confetti |
	confetti := suffixModels select: [ :each | each pattern isConfetti  ].
	
	self 
		assert: confetti size 
		equals: 0
]

{ #category : #checkingOneSuffixPattern }
CNBPresenterTest >> testCheckFatBlob [
	| aSuffixModel |

	aSuffixModel := suffixModels detect: [ :each | each package = 'Moose-Algos-Graph-Tests'].
		
	aSuffixModel checkPatterns.
	
	self
		assert: aSuffixModel pattern isFatBlob  
		equals: true
]

{ #category : #HomogeneityBreakerTests }
CNBPresenterTest >> testCheckHomogeneityBreaker [
	| aSuffixModel  |
	self changeToCalypso.
	
	aSuffixModel := suffixModels 
		detect: [ :each | each name = 'Strategy' 
			and: [ each package = 'Calypso-SystemTools-QueryBrowser' ] ].
			
	aSuffixModel checkPatterns.
	
	self
		assert: aSuffixModel pattern isHomogeneityBreaker	
		equals: true
]

{ #category : #checkingOneSuffixPattern }
CNBPresenterTest >> testCheckHomogeneous [
	| aSuffixModel  |

	aSuffixModel := suffixModels 
		detect: [ :each | each name = 'Strategy' 
			and: [ each package = 'Moose-Query' ] ].
	
		
	aSuffixModel checkPatterns.
	self
		assert: aSuffixModel pattern isHomogeneous 
		
		equals: true  
]

{ #category : #checkingOneSuffixPattern }
CNBPresenterTest >> testCheckIntruder [
	| aSuffixModel |
	
	aSuffixModel := suffixModels detect: [ :each | each name = 'Command' ].
		
	aSuffixModel checkPatterns.
	
	self
		assert: aSuffixModel pattern isIntruder	
		equals: true  
]

{ #category : #checkingOneSuffixPattern }
CNBPresenterTest >> testCheckScatteredVocabulary [
	| aSuffixModel |
	
	aSuffixModel := suffixModels 
		detect: [ :each | each name = 'Task' 
							and: [ each package = 'Moose-SmalltalkImporter' ] ].
		
	aSuffixModel checkScatteredVocabulary.
	
	self
		assert: aSuffixModel pattern isScatteredVocabulary
		equals: true  
]

{ #category : #SnowFlakesTest }
CNBPresenterTest >> testCheckSnowFlakes [
	| aSuffixModel |
	
	aSuffixModel := suffixModels 
		detect: [ :each | each name = 'Engine' ].
	
		
	aSuffixModel checkPatterns.
	
	self
		assert: aSuffixModel pattern isSnowFlakes	
		equals: true  
]

{ #category : #SnowFlakesTest }
CNBPresenterTest >> testCheckSnowFlakesInCNB [

	| snowFlakes actualSnowFlakes |
	snowFlakes := suffixModels 
							select: [ :each | each pattern isSnowFlakes ].
							
	actualSnowFlakes := { 'Engine' . 'B' }.
	
	self 
		assert: (snowFlakes collect: #name) asSet equals: actualSnowFlakes asSet
]

{ #category : #tests }
CNBPresenterTest >> testColorHighlighted [
	| highlightedBoxes |

	
	highlightedBoxes := ((CNBPatternSelector of: projectCNB)
		selectPatternOf: #'Scattered Vocabulary').
		
	self
		assert: (highlightedBoxes collect: #color) asSet
		equals: { Color purple } asSet 
]

{ #category : #confettiTests }
CNBPresenterTest >> testConfettiOutsiders [

	| confetti |
	confetti := suffixModels select: [ :each | each pattern isConfetti  ].
	
	self 
		assert: (confetti allSatisfy: [ :each | 
						(each outsiders size <= CNBPatternSelector confettiPourcentage ) ])
		equals: true

	
]

{ #category : #confettiTests }
CNBPresenterTest >> testConfettiSize [

	| confetti |
	confetti := suffixModels select: [ :each | each pattern isConfetti  ].
	
	self 
		assert: (confetti allSatisfy: [ :each | 
						(each belongers size >= CNBPatternSelector confettiSize ) ])
		equals: true

	
]

{ #category : #FatBlobTests }
CNBPresenterTest >> testFatBlobsAreNotHomogeneous [

	| fatBlobs |
	fatBlobs := suffixModels select: [ :each | each pattern isFatBlob ].

	self 
		assert: (fatBlobs anySatisfy: [ :each | each pattern isHomogeneous ])
		equals: false
]

{ #category : #FatBlobTests }
CNBPresenterTest >> testFatBlobsBelongToMultiSuffix [

	| fatBlobs |
	fatBlobs := suffixModels select: [ :each | each pattern isFatBlob  ].
	
	self 
		assert: (fatBlobs allSatisfy: [ :each | each root isMultiSuffix ])
		equals: true
]

{ #category : #FatBlobTests }
CNBPresenterTest >> testFatBlobsHasNoOutsiders [

	| fatBlobs |
	fatBlobs := suffixModels select: [ :each | each pattern isFatBlob ].
	
	self 
		assert: (fatBlobs allSatisfy: [ :each | each outsiders isEmpty ])
		equals: true
]

{ #category : #FatBlobTests }
CNBPresenterTest >> testFatBlobsSize [

	| fatBlobs |
	fatBlobs := suffixModels select: [ :each | each pattern isFatBlob ].

	self 
		assert: (fatBlobs allSatisfy: [ :each | each size >= CNBPatternSelector fatBlobSize ])
		equals: true
]

{ #category : #goDarker }
CNBPresenterTest >> testGoDarkerForFatBlob [ 


	| expectedBoxes expectedColors actualColors  |
	
	expectedBoxes := presenter nodesToBeDarkerFor: #'Fat Blob'. 
	expectedColors := expectedBoxes collect: [ :each | each color ].
	self 
		assert: expectedColors  
		equals: actualColors  
	
	
	
	
	
]

{ #category : #goDarker }
CNBPresenterTest >> testGoDarkerForHomogeneityBreaker [
	
	| expectedFatBlobBoxes actualFatBlobBoxes suffixViewModels |
	
	expectedFatBlobBoxes := (presenter goDarkerFor: #'Homogeneity Breaker') 
	
]

{ #category : #goDarker }
CNBPresenterTest >> testGoDarkerForHomogeneous [
	
	| expectedBoxes actualBoxes classBoxes suffixBoxes |
	
	expectedBoxes := presenter nodesToHighlightFor: #'Homogeneous'. 
	suffixBoxes := suffixModels 
		select: [ :each | each pattern isHomogeneous ].
	classBoxes := suffixBoxes flatCollect: [ :each | each classViewModels ].
	actualBoxes := suffixBoxes union: classBoxes.
		
	self 
		assert: expectedBoxes  
		equals: actualBoxes 
	
	
	
	
]

{ #category : #goDarker }
CNBPresenterTest >> testGoDarkerForScatteredVocabulary [
	| highlightedBoxes darkerBoxes expectedBoxesToGoDarker actualBoxesToGoDarker |
	
	highlightedBoxes := ((CNBPatternSelector of: projectCNB) 
			selectPatternOf: #'Scattered Vocabulary').
	expectedBoxesToGoDarker := presenter nodesToBeDarkerFor: #'Scattered Vocabulary'.
	actualBoxesToGoDarker := cnbCanvas deepNodes 
		reject: [ :each | highlightedBoxes includes: each model ].

	presenter lookFor: #'Scattered Vocabulary'.
	darkerBoxes := presenter nodesToBeDarkerFor: #'Scattered Vocabulary'.
	self 
		assert: highlightedBoxes size 
		equals: (presenter lookFor: #'Scattered Vocabulary') size.
]

{ #category : #goDarker }
CNBPresenterTest >> testGoDarkerForSnowFlakes [
	
	| expectedFatBlobBoxes actualFatBlobBoxes suffixViewModels |
	
	expectedFatBlobBoxes := (presenter goDarkerFor: #'Snow Flakes') 
	
]

{ #category : #highlighting }
CNBPresenterTest >> testHighlightConfetti [ 
	
	| expectedBoxes actualBoxes classBoxes suffixBoxes |
	self changeToCalypso.
	
	expectedBoxes := presenter nodesToHighlightFor: #'Confetti'. 
	
	suffixBoxes := suffixModels 
		select: [ :each | each pattern isConfetti  ].
		
	classBoxes := suffixBoxes flatCollect: [ :each | each classViewModels ].
	
	actualBoxes := suffixBoxes union: classBoxes.
		
	self 
		assert: expectedBoxes  
		equals: actualBoxes 
]

{ #category : #highlighting }
CNBPresenterTest >> testHighlightFatBlob [

	| expectedBoxes actualBoxes classBoxes suffixBoxes |
	
	expectedBoxes := presenter nodesToHighlightFor: #'Fat Blob'. 
	
	suffixBoxes := suffixModels 
		select: [ :each | each pattern isFatBlob ].
		
	classBoxes := suffixBoxes flatCollect: [ :each | each classViewModels ].
	
	actualBoxes := suffixBoxes union: classBoxes.
		
	self 
		assert: expectedBoxes  
		equals: actualBoxes asOrderedCollection
	
	
	
	
]

{ #category : #highlighting }
CNBPresenterTest >> testHighlightHomogeneityBreaker [

	| expectedBoxes actualBoxes classBoxes suffixBoxes |
	self changeToCalypso.
	
	expectedBoxes := presenter nodesToHighlightFor: #'Homogeneity Breaker'. 
	
	suffixBoxes := suffixModels 
		select: [ :each | each pattern isHomogeneityBreaker ].
		
	classBoxes := suffixBoxes flatCollect: [ :each | each classViewModels ].
	
	actualBoxes := suffixBoxes union: classBoxes.
		
	self 
		assert: expectedBoxes  
		equals: actualBoxes 
	
	
	
	
]

{ #category : #highlighting }
CNBPresenterTest >> testHighlightIntruders [

	| expectedBoxes actualBoxes classBoxes suffixBoxes |
	
	expectedBoxes := presenter nodesToHighlightFor: #'Intruder'.
	 
	suffixBoxes := suffixModels 
		select: [ :each | each pattern isIntruder ].
		
	classBoxes := suffixBoxes flatCollect: [ :each | each classViewModels ].
	
	actualBoxes := suffixBoxes union: classBoxes.
		
	self 
		assert: expectedBoxes  
		equals: actualBoxes 
	
	
	
	
]

{ #category : #highlighting }
CNBPresenterTest >> testHighlightScatteredVocabulary [


	| expectedBoxes actualBoxes classBoxes suffixBoxes |
	
	expectedBoxes := presenter nodesToHighlightFor: #'Scattered Vocabulary'. 
	
	suffixBoxes := suffixModels 
		select: [ :each | each pattern isScatteredVocabulary ].
		
	classBoxes := suffixBoxes flatCollect: [ :each | each classViewModels ].
	
	actualBoxes := suffixBoxes union: classBoxes.
		
	self 
		assert: (expectedBoxes collect: #model) asOrderedCollection 
		equals: actualBoxes asOrderedCollection 
	
	
	
	
]

{ #category : #highlighting }
CNBPresenterTest >> testHighlightSnowFlakes [

	| expectedBoxes actualBoxes classBoxes suffixBoxes |
	
	expectedBoxes := presenter nodesToHighlightFor: #'Snow Flakes'. 
	
	suffixBoxes := suffixModels 
		select: [ :each | each pattern isConfetti ].
		
	classBoxes := suffixBoxes flatCollect: [ :each | each classViewModels ].
	
	actualBoxes := suffixBoxes union: classBoxes.
		
	self 
		assert: expectedBoxes  
		equals: actualBoxes 
	
	
	
	
]

{ #category : #HomogeneityBreakerTests }
CNBPresenterTest >> testHomogeneityBreakerExists [

	| homogeneityBreakers |
	self changeToCalypso.
	homogeneityBreakers := suffixModels 
			select: [ :each | each pattern isHomogeneityBreaker ].
	
	self 
		assert: homogeneityBreakers isNotEmpty 
		equals: true
]

{ #category : #HomogeneityBreakerTests }
CNBPresenterTest >> testHomogeneityBreakerIsNotIntruder [

	| homoBreaker intruders |
	homoBreaker := suffixModels 
			select: [ :each | each pattern isHomogeneityBreaker  ].
	intruders := suffixModels 
			select: [ :each | each pattern isIntruder ].
			
	self
		assert: homoBreaker = intruders 
		equals: false
	
	
]

{ #category : #HomogeneityBreakerTests }
CNBPresenterTest >> testHomogeneityBreakersInCNB [

	| homogeneityBreakers |
	homogeneityBreakers := suffixModels 
		select: [ :each | each pattern isHomogeneityBreaker].
		
	self 
		assert: homogeneityBreakers size 
		equals: 0
]

{ #category : #goDarker }
CNBPresenterTest >> testHomogeneousDarkerNodesDontIncludesHighlightedNodes [

	| highlightedNodes darkerNodes |
	presenter goDarkerFor: #'Homogeneous'.
	
	highlightedNodes := presenter nodesToHighlight.
	darkerNodes := presenter nodesToBeDarker.
	
		self 
			assert: (darkerNodes includesAll: highlightedNodes)
			equals: false
]

{ #category : #goDarker }
CNBPresenterTest >> testHomogeneousNodesGoDarkerColorName [

	| highlightedNodes |
	presenter goDarkerFor: #'Homogeneous'.
	highlightedNodes := presenter nodesToHighlight.
	self 
		assert: (highlightedNodes collect: #color) atRandom name
		equals: #gray
]

{ #category : #goDarker }
CNBPresenterTest >> testHomogeneousNodesGoDarkerColorSize [

	| highlightedNodes |
	presenter goDarkerFor: #'Homogeneous'.
	highlightedNodes := presenter nodesToHighlight.
	self 
		assert: (highlightedNodes collect: #color) asSet size 
		equals: 1
]

{ #category : #intrudersTests }
CNBPresenterTest >> testIntrudersAreNotMonoClasses [

	| intruders |
	intruders := suffixModels select: [ :each | each pattern isIntruder ].
																
	self 
		assert: (intruders anySatisfy: [ :each | each root isMonoClass ])
		equals: false
]

{ #category : #intrudersTests }
CNBPresenterTest >> testIntrudersPourcentage [

	| intruders |
	intruders := suffixModels select: [ :each | each pattern isIntruder ].
																
	self 
		assert: (intruders allSatisfy: [ :each | each outsiders size <=  (each size * CNBPatternSelector intrudersPercentage) percent ])
		equals: true
]

{ #category : #intrudersTests }
CNBPresenterTest >> testIntrudersSizeInsideCNB [

	| intruders |
	intruders := suffixModels select: [ :each | each pattern isIntruder ].
									
	self 
		assert: intruders size
		equals: 6
]

{ #category : #goDarker }
CNBPresenterTest >> testNodesGoDarker [

	| darkerNodes highlightedNodes |
	presenter goDarkerFor: #'Homogeneous'.
	highlightedNodes := presenter nodesToHighlight.
	self 
		assert: (highlightedNodes collect: #color) asSet size 
		equals: 1
]

{ #category : #tests }
CNBPresenterTest >> testNumberColorHighlighted [
	| highlightedBoxes |
	
	projectCNB := CNBRoassal3Builder projectNameMatches: 'moose-*'.
	
	highlightedBoxes := ((CNBPatternSelector of: projectCNB)
		selectPatternOf: #'Scattered Vocabulary').
		
	self assert: highlightedBoxes size equals: 3.
]

{ #category : #ScatteredVocabularyPattern }
CNBPresenterTest >> testScatteredVocabularySuffixesSizeInCNB [

	| scatteredVocabulary |
	scatteredVocabulary := suffixModels select: [ :each | each pattern isScatteredVocabulary ].
									
	self 
		assert: scatteredVocabulary size
		equals: 3
]
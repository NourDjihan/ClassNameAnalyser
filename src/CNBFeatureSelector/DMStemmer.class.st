Class {
	#name : #DMStemmer,
	#superclass : #DMMalAbstractStemmer,
	#category : #CNBFeatureSelector
}

{ #category : #'private-algorithm' }
DMStemmer >> isVowelAt: anIndex [
	
	^#eaoiuy includes: (string at: anIndex)
]

{ #category : #'private-algorithm' }
DMStemmer >> performStemming: aString [
	"Performs the Porter stemming algrothim. More see:
	M. Porter, An algorithm for suffix stripping, Program (1980)/ Vol. 14, No. 3, 130-137"
	
	string := aString asLowercase.
	string size > 2
		ifTrue:
			[self
				preprocessing;
				setMarks;
				step1a;
				step1b;
				step1c;
				step2;
				step3;
				step4;
				step5a;
				step5b].
	string := string asLowercase.
	^string
]

{ #category : #'private-algorithm' }
DMStemmer >> preprocessing [
	
	string first = $y ifTrue: [string at: 1 put: $Y].
	2
		to: string size
		do:
			[:index | 
			((string at: index) = $y and: [self isVowelAt: index - 1])
				ifTrue: [string at: index put: $Y]]
]

{ #category : #'private-algorithm' }
DMStemmer >> stemEndsWithConsonantVowelConsonant [
	
	^cursor >= 3
		and:
			[('Yywx' includes: (string at: cursor)) not
				and:
					[(self isConsonantAt: cursor)
						and:
							[(self isVowelAt: cursor - 1) and: [self isConsonantAt: cursor - 2]]]]
]

{ #category : #'private-algorithm' }
DMStemmer >> stemEndsWithDoubleConsonant [
	"comment stating purpose of message"
	
	^cursor >= 2
		and:
			[(string at: cursor) = (string at: cursor - 1)
				and: [self isConsonantAt: cursor]]
]

{ #category : #'private-algorithm' }
DMStemmer >> stemIncludesVowel [
	"comment stating purpose of message"
	
	1
		to: cursor
		do: [:index | (self isVowelAt: index) ifTrue: [^true]].
	^false
]

{ #category : #'private-algorithm' }
DMStemmer >> step1a [
	"comment stating purpose of message"
	
	string last == $s
		ifTrue:
			[(self endsWith: #sses)
				ifTrue:
					[string := string
						copyFrom: 1
						to: string size - 2]
				ifFalse:
					[(self endsWith: #ies)
						ifTrue:
							[string := string
								copyFrom: 1
								to: string size - 2]
						ifFalse:
							[(self endsWith: #ss)
								ifFalse:
									[string := string
										copyFrom: 1
										to: string size - 1]]]]	"#(#(#sses #ss) #(#ies #i) #(#ss #ss) #(#s #'')) do: 
			[:rule | 
			(self endsWith: rule first) 
				ifTrue: 
					[self setSuffix: rule last.
					^nil]]"
]

{ #category : #'private-algorithm' }
DMStemmer >> step1b [
	(self endsWith: 'eed')
		ifTrue: [ cursor >= r1
				ifTrue: [ self setSuffix: 'ee' ].
			^ nil ].
	(((self endsWith: 'ed') or: [ self endsWith: 'ing' ])
		and: [ self stemIncludesVowel ])
		ifFalse: [ ^ self ].
	self removeSuffix.
	#(#(#at #ate) #(#bl #ble) #(#iz #ize))
		do: [ :rule | 
			(self endsWith: rule first)
				ifTrue: [ self setSuffix: rule last.
					^ nil ] ].
	cursor := string size.
	(self stemEndsWithDoubleConsonant
		and: [ (string at: cursor) ~~ $s
				and: [ (string at: cursor) ~~ $z and: [ (string at: cursor) ~~ $l ] ] ])
		ifTrue: [ string := string copyFrom: 1 to: string size - 1.
			^ nil ].
	(cursor = r1 and: [ self stemEndsWithConsonantVowelConsonant ])
		ifTrue: [ self setSuffix: 'e' ]
]

{ #category : #'private-algorithm' }
DMStemmer >> step1c [
	
	(((self endsWith: 'y') or: [self endsWith: 'Y'])
		and: [self stemIncludesVowel])
		ifTrue:
			[string
				at: string size
				put: $i]
]

{ #category : #'private-algorithm' }
DMStemmer >> step2 [
	"comment stating purpose of message"
	
	#(#(#iveness #ive) #(#fulness #ful) #(#ousness #ous) #(#ization #ize) #(#ational #ate) #(#tional #tion) #(#biliti #ble) #(#ation #ate) #(#alism #al) #(#aliti #al) #(#iviti #ive) #(#ousli #ous) #(#entli #ent) #(#ator #ate) #(#enci #ence) #(#anci #ance) #(#logi #log) #(#izer #ize) #(#bli #ble) #(#alli #al) #(#eli #e))
		do:
			[:rule | 
			(self endsWith: (rule at: 1))
				ifTrue:
					[cursor >= r1 ifTrue: [self setSuffix: (rule at: 2)].
					^nil]]
]

{ #category : #'private-algorithm' }
DMStemmer >> step3 [
	
	#(#(#ative #'') #(#icate #ic) #(#alize #al) #(#iciti #ic) #(#ical #ic) #(#ness #'') #(#ful #''))
		do:
			[:rule | 
			(self endsWith: rule first)
				ifTrue:
					[cursor >= r1 ifTrue: [self setSuffix: rule last].
					^nil]]
]

{ #category : #'private-algorithm' }
DMStemmer >> step4 [
	#(#ement #ance #ence #able #ible #ment)
		do: [ :rule | 
			(self endsWith: rule)
				ifTrue: [ cursor >= r2
						ifTrue: [ self removeSuffix ].
					^ nil ] ].
	((self endsWith: 'ion') and: [ cursor >= r2 ])
		ifTrue: [ (#($s $t) anySatisfy: [ :each | (string at: cursor) = each ])
				ifTrue: [ self removeSuffix.
					^ nil ] ].
	#(#ant #ent #ism #ate #iti #ous #ive #ize #al #er #ic #ou)
		do: [ :rule | 
			(self endsWith: rule)
				ifTrue: [ cursor >= r2
						ifTrue: [ self removeSuffix ].
					^ nil ] ]
]

{ #category : #'private-algorithm' }
DMStemmer >> step5a [
	cursor := string size - 1.
	(string last == $e
		and: [ string size > r2
				or: [ string size > r1
						and: [ self stemEndsWithConsonantVowelConsonant not ] ] ])
		ifFalse: [ ^ self ].
	self removeSuffix.
	^ nil
]

{ #category : #'private-algorithm' }
DMStemmer >> step5b [
	
	cursor := string size.
	((self endsWith: 'll') and: [cursor + 1 >= r2])
		ifTrue: [self setSuffix: 'l']
]
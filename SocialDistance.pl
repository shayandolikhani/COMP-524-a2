givenSizes(6,15,10).
givenSizes(13,30,30).
givenSizes(27,120,50).


givenSafe(13,30,30).
givenSafe(6,30,10).
givenSafe(27,30,50).
givenSafe(13,15,50).
givenSafe(13,120,10).
givenSafe(27,120,30).
givenSafe(6,15,30).

smallDistance(6).
mediumDistance(13).
largeDistance(27).

smallDuration(15).
mediumDuration(30).
largeDuration(120).

smallExhalation(10).
mediumExhalation(30).
largeExhalation(50).


derivedSafe(Distance,Duration,Exhalation) :-
	givenSafe(Dist,Dur,Exh),
	Distance >= Dist, Duration =< Dur, Exhalation =< Exh.
	

distanceInterpolation(Distance, Result) :-
	smallDistance(SmallDist),
	Distance < SmallDist,
	Result = 0;
	
	mediumDistance(MediumDist), smallDistance(SmallDist),
	Distance < MediumDist, Distance >= SmallDist,
	Result = SmallDist;
	
	largeDistance(LargeDist), mediumDistance(MediumDist),
	Distance < LargeDist, Distance >= MediumDist,
	Result = MediumDist;
	
	largeDistance(LargeDist),
	Distance >= LargeDist,
	Result = LargeDist.
	
durationInterpolation(Duration, Result) :-
	largeDuration(LargeDur),
	Duration > LargeDur,
	Result = 200;
	
	mediumDuration(MediumDur), largeDuration(LargeDur),
	Duration > MediumDur, Duration =< LargeDur,
	Result = LargeDur;
	
	smallDuration(SmallDur), mediumDuration(MediumDur),
	Duration > SmallDur, Duration =< MediumDur,
	Result = MediumDur;
	
	smallDuration(SmallDur), Duration =< SmallDur,
	Result = SmallDur.
	

exhalationInterpolation(Exhalation, Result) :-
	largeExhalation(LargeExh),
	Exhalation > LargeExh,
	Result = 200;
	
	mediumExhalation(MediumExh), largeExhalation(LargeExh),
	Exhalation > MediumExh, Exhalation =< LargeExh,
	Result = LargeExh;
	
	smallExhalation(SmallExh), mediumExhalation(MediumExh),
	Exhalation > SmallExh, Exhalation =< MediumExh,
	Result = MediumExh;
	
	smallExhalation(SmallExh), Exhalation =< SmallExh,
	Result = SmallExh.
	

interpolatedSafe(Distance, Duration, Exhalation) :-
	distanceInterpolation(Distance, DistResult),
	durationInterpolation(Duration, DurResult),
	exhalationInterpolation(Exhalation, ExhResult),
	givenSafe(DistResult,DurResult,ExhResult).
	
	
interpolatedSafe(Distance, Duration) :-
	distanceInterpolation(Distance, DistResult),
	durationInterpolation(Duration, DurResult),
	mediumExhalation(MediumExh),
	givenSafe(DistResult,DurResult,MediumExh).
	
interpolatedSafe(Distance) :-
	distanceInterpolation(Distance, DistResult),
	mediumDuration(MediumDur),
	mediumExhalation(MediumExh),
	givenSafe(DistResult,MediumDur,MediumExh).
	 
	 
generateSafeDistancesAndDurations(Distance, Duration, Exhalation) :-
	exhalationInterpolation(Exhalation, ExhResult),
	givenSafe(Distance, Duration, ExhResult).
	
	
	
safeCombinations(
	[
		[13,30,30],
		[6,30,10],
		[27,30,50],
		[13,15,50],
		[13,120,10],
		[27,120,30],
		[6,15,30]
	]
).


listGivenSafe([Distance, Duration, Exhalation]) :-
	safeCombinations(SafeCombos),
	listGivenSafe([Distance, Duration, Exhalation], SafeCombos).
	
listGivenSafe(Inputs, [Safehead | Safetail]) :-
	Inputs = Safehead;
	listGivenSafe(Inputs, Safetail).

	
	
printGivenCombinations(N) :-
	write("Distance, Duration, Exhalation, IsSafe"), nl,
	safeCombinations(SafeCombos),
	printGivenCombinations(N, SafeCombos).


printGivenCombinations(N, [[Distance, Duration, Exhalation] | Safetail]) :-
	N > 0,
	write(Distance), write(","), write(Duration), write(","), write(Exhalation), write(","), write("true"), nl,
	N1 is N - 1,
	printGivenCombinations(N1, Safetail).
	
	
append([],List,List).

append([Head | Tail],List2,[Head | Result]) :-
	append(Tail,List2,Result).
	
listGenerateSafeDistancesAndDurations(Exhalation, GeneratedTable) :-
	exhalationInterpolation(Exhalation, ExhResult),
	safeCombinations(SafeCombos),
	listGenerateSafeDistancesAndDurations(ExhResult, GeneratedTable, [], SafeCombos).

listGenerateSafeDistancesAndDurations(_, GeneratedTable, TableToAppend, []) :-
	GeneratedTable = TableToAppend.

listGenerateSafeDistancesAndDurations(Z, GeneratedTable, TableToAppend, [[Distance, Duration, Exhalation] | Safetail]) :-
	Z \= Exhalation,
	listGenerateSafeDistancesAndDurations(Z, GeneratedTable, TableToAppend, Safetail);
	
	Z = Exhalation,
	append(TableToAppend, [[Distance, Duration]], Result),
	listGenerateSafeDistancesAndDurations(Z, GeneratedTable, Result, Safetail).
	
		
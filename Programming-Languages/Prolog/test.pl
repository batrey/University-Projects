%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You can run all tests using "ty." 
% Or you can run tests for individual parts, e.g., "test_isMember"
%
% Make sure that you have ``consulted'' all files you need to run 
% a particular test or tests. Remember to consult this file too.
%
% Use this to test everything and create Output.your, then exit from gprolog.
% Do a "diff Output.correct Output.your". The files should be identical
% except for some differences in the order of output for latter parts.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% mynot(A) succeeds if A fails
mynot(A):- A,!,fail.
mynot(_).

%%%%%%

ty :-
	tell('Output.your'), test, told.

% test everything
test :-
	test_year_1953_1996_novels,
	test_period_1800_1900_novels,
	test_lotr_fans,
	test_author_names,
	test_fans_names,
	test_mutual_novels,
	test_isMember,
	test_isUnion,
	test_isIntersection,
    test_isEqual,
    test_powerSet,
    test_puzzle.

%-------------------------------------------- PART 1 --------------------------------------------

test_year_1953_1996_novels :-
	nl, printstring("TESTING: Novels published during the year 1953 or 1996"), nl, nl,
	zeroInputOneOutput( year_1953_1996_novels, A, "1953_1996_Novel").

test_period_1800_1900_novels :-
	nl, printstring("TESTING: Novels published during the period 1800 to 1900"), nl, nl,
	zeroInputOneOutput(  period_1800_1900_novels, B, "1800_1900_Novel").

test_lotr_fans :-
	nl, printstring("TESTING: Characters who are fans of LOTR"), nl, nl,
	zeroInputOneOutput(  lotr_fans, C, "LOTR_Fan").

test_author_names :-
	nl, printstring("TESTING: Authors of the novels owned by Chandler"), nl, nl,
	zeroInputOneOutput( author_names, D, "Chandler's_novel_Author").

test_fans_names :-
	nl, printstring("TESTING: Characters who are fans of Brandon Sanderson's novels"), nl, nl,
	zeroInputOneOutput( fans_names, E, "Brandon_Sanderson_Fan" ).

test_mutual_novels :-
	nl, printstring("TESTING:  Novels common between either of Phoebe, Ross, and Monica"), nl, nl,
	zeroInputOneOutput( mutual_novels, F, "Phoebe_Ross_Monica_Novel").

%-------------------------------------------- PART 2 --------------------------------------------

test_isMember :-
	nl, printstring("TESTING: isMember"), nl, nl,
	twoInputBoolOutput( isMember, a, [a,b]),
	twoInputBoolOutput( isMember, a, [[a],b]),
	twoInputBoolOutput( isMember, [], [a,b]),
	twoInputBoolOutput( isMember, b, [a,[b,c]]),
	twoInputBoolOutput( isMember, c, [a,[b,[c]]]),
	twoInputBoolOutput( isMember, c, [a,b,c,d]).

test_isUnion :-
	nl, printstring("TESTING: isUnion"), nl, nl,
	twoInputOneOutput( isUnion, [], [], G, "XuY"),
	twoInputOneOutput( isUnion, [], [a,b], G, "XuY"),
	twoInputOneOutput( isUnion, [a], [a,b], G, "XuY"),
	twoInputOneOutput( isUnion, [a,b], [a], G, "XuY"),
	twoInputOneOutput( isUnion, [a,b], [b,c], G, "XuY"),
	twoInputOneOutput( isUnion, [b,c], [a,b], G, "XuY"),
	twoInputOneOutput( isUnion, [a,b], [c,d], G, "XuY"),
	twoInputOneOutput( isUnion, [a,[b]], [a,[a,b]], G, "XuY"),
	twoInputOneOutput( isUnion, [a,b,c], [a,[b,c]], G, "XuY"),
	twoInputOneOutput( isUnion, [a,b,c], [a,[b,[d]],c], G, "XuY").

test_isIntersection :-
	nl, printstring("TESTING: isIntersection"), nl, nl,
	twoInputOneOutput( isIntersection, [], [], H, "XnY"),
	twoInputOneOutput( isIntersection, [], [a,b], H, "XnY"),
	twoInputOneOutput( isIntersection, [a], [a,b], H, "XnY"),
	twoInputOneOutput( isIntersection, [a,b], [a], H, "XnY"),
	twoInputOneOutput( isIntersection, [a,b], [b,c], H, "XnY"),
	twoInputOneOutput( isIntersection, [b,c], [a,b], H, "XnY"),
	twoInputOneOutput( isIntersection, [a,b], [c,d], H, "XnY"),
	twoInputOneOutput( isIntersection, [a,[b]], [a,[a,b]], H, "XnY"),
	twoInputOneOutput( isIntersection, [a,b,c], [a,[b,c]], H, "XnY"),
	twoInputOneOutput( isIntersection, [a,b,c,[d]], [a,[b,[d]],c], H, "XnY").

test_isEqual :-
	nl, printstring("TESTING: isEqual"), nl, nl,
	twoInputBoolOutput( isEqual, [], []),
	twoInputBoolOutput( isEqual, [a], [a]),
	twoInputBoolOutput( isEqual, [a,b], [b,a]),
	twoInputBoolOutput( isEqual, [a,b,c], [a,b]),
	twoInputBoolOutput( isEqual, [a,[a]], [a,a]),
	twoInputBoolOutput( isEqual, [a,[a]], [[a],a]),
	twoInputBoolOutput( isEqual, [a,[b],[c]], [[b],[c],a]),
	twoInputBoolOutput( isEqual, [a,b,[c,d]], [a,b,c,d]),
	twoInputBoolOutput( isEqual, [a,[b],[c,d]], [a,[b],[d,c]]),
	twoInputBoolOutput( isEqual, [a,[b,[c,d]]], [a,[[c,d],b]]).

test_powerSet :- 
	nl, printstring("TESTING: powerSet"), nl, nl,
	oneInputOneOutput( powerSet, [], I, "P(X)"),
	oneInputOneOutput( powerSet, [a], I, "P(X)"),
	oneInputOneOutput( powerSet, [a,b], I, "P(X)"),
	oneInputOneOutput( powerSet, [b,a], I, "P(X)"),
	oneInputOneOutput( powerSet, [a,[b]], I, "P(X)"),
	oneInputOneOutput( powerSet, [[a,b]], I, "P(X)"),
	oneInputOneOutput( powerSet, [a,[]], I, "P(X)"),
	oneInputOneOutput( powerSet, [a,b,[c]], I, "P(X)"),
	oneInputOneOutput( powerSet, [a,[b,c]], I, "P(X)"),
	oneInputOneOutput( powerSet, [a,[b,[c,[d]]]], I, "P(X)").

%-------------------------------------------- PART 3 --------------------------------------------

test_puzzle :-  nl, printstring("TESTING puzzle"), nl, nl,
        solve, nl, nl,
        fail; true. 

%-------------------------------------------- TESTERS --------------------------------------------
/* semi-general tester.
 * run Predicate on A1, A2, A3
 * assume output goes to A3, whose name is in the string SA3.
 */

twoInputOneOutput(Predicate,A1,A2,A3,SA3) :-
	printstring("testing: "), write(Predicate),
	printstring("("), write(A1),
	printstring(","), write(A2),
	printstring(","), printstring(SA3),
	printstring(")"), nl,
	T =..[Predicate,A1,A2,A3], call(T),
	printstring(SA3), printstring(" = "),
	write(A3), nl, nl,
	fail; true.

/* semi-general tester.
 * run Predicate on A1, A2
 * assume output goes to A2, whose name is in the string SA2.
 */

oneInputOneOutput(Predicate,A1,A2,SA2) :-
	printstring("testing: "), write(Predicate),
	printstring("("), write(A1),
	%printstring(","), write(A2),
	printstring(","), printstring(SA2),
	printstring(")"), nl,
	T =..[Predicate,A1,A2], call(T),
	printstring(SA2), printstring(" = "),
	write(A2), nl, nl,
	fail; true.

/* semi-general tester.	
 * run Predicate on A1,A2.
 * returns yes/no.
 */

twoInputBoolOutput(Predicate,A1,A2) :-
	printstring("testing: "), write(Predicate),
	printstring("("), write(A1),
	printstring(","), write(A2),
	printstring(")"), nl,
	T =..[Predicate,A1,A2],
	((call(T),printstring("yes"));(mynot(T),printstring("no"))),
	nl, nl,
	fail; true.

/* semi-general tester.	
 * run Predicate on A1.
 * assume output goes to A1, whose name is in the string SA1.
 */

zeroInputOneOutput(Predicate,A1,SA1) :-
	printstring("testing: "), write(Predicate),
	printstring("("), printstring(SA1),
	printstring(")"), nl,
	T =..[Predicate,A1], call(T),
	printstring(SA1), printstring(" = "),
	write(A1), nl, nl,
	fail; true.

/* a way to output strings. */

printstring([]).
printstring([H|T]) :- put(H), printstring(T).

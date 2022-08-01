/*******************************************/
/**    Your solution goes in this file    **/ 
/*******************************************/

/*******************************************/
/***********      PART 1      **************/
/*******************************************/
 
 
year_1953_1996_novels(Novel):-
  novel(Novel,Year),
  (Year = 1953; Year =1996). 


period_1800_1900_novels(Novel):-
 novel(Novel,Year),
 between(1800, 1900, Year).
  
lotr_fans(Name):- 
 fan(Name, Novels_liked),
 member(the_lord_of_the_rings,Novels_liked).
 
author_names(Name):-
 fan(chandler,Novels_liked),
 author(Name, Novels_written),
 helperCut(Novels_liked,Novels_written).

helperCut(Novels_written,Novels_liked):- 
 member(X,Novels_liked),
 member(X,Novels_written),!.
  

  
 fans_names(Name):-
  author(brandon_sanderson,Novels_written),
  fan(Name,Novels_liked),
  member(X,Novels_written),
   member(X,Novels_liked).
   
 mutual_novels(X):-
 fan(phoebe,PNovels_liked),
 fan(monica,MNovels_liked),
 fan(ross,RNovels_liked), 
 ((member(X,PNovels_liked),member(X,MNovels_liked));
 (member(X,PNovels_liked),member(X,RNovels_liked));
 (member(X,RNovels_liked),member(X,MNovels_liked))).
 
  


/*******************************************/
/***********      PART 2      **************/
/*******************************************/

/*isMember(X, X).     
isMember(X, [_H|T]) :- 
   (isMember(X, _H); 
   isMember(X, T)). */
   
/* FIXED MEMBER METHOD */
isMember(X, [X|_]).
isMember(X, [_|T]) :-
   isMember(X, T).
   
   
/* isUnion([],L,L). 
isUnion([H|T],Y,[H|Z])  :- 
    isUnion(T,Y,Z). */
    
isUnion([], L, L).
isUnion([H|T1], Y, Z) :-
        memberchk(H, Y),
        !,
        isUnion(T1, Y, Z).
isUnion([H|T1], Y, [H|T2]) :-
        isUnion(T1, Y, T2).

   
/* isIntersection([], _, []).
isIntersection([H|T], Y, [H|T2]) :-
    isMember(H, Y),
    isIntersection(T, Y, T2).
isIntersection([_|T], Y, Z) :-
    isIntersection(T, Y, Z). */
    
/* FIXED INTERSECTION METHOD */
isIntersection([], _, []).
isIntersection([H|T], Y, [H|T2]) :-
    isMember(H, Y),
    !,
    isIntersection(T, Y, T2).
isIntersection([_|T], Y, Z) :-
    isIntersection(T, Y, Z).
    
containsAll([],_).
containsAll([H|T],Y):-
    isMember(H,Y),
    select(H,Y,Z),
    containsAll(T,Z).
isEqual(X,Y):-
    containsAll(X,Y),
    containsAll(Y,X).
    
powerSet( [], [[]]).
powerSet( [H|T], Z) :-
  powerSet(T, X),
  maplist(isUnion([H]), X, Y),
  isUnion(X, Y, Z).
    
    
/*******************************************/
/***********      PART 3      **************/
/*******************************************/
direction(l).
direction(r).

same(A,B) :-
  \+ opposite(A,B).
  
opposite(A,B) :-
  (A = l, B = r);
  (A = r, B = l).

state(Farmer, Wolf, Goat, Cabbage) :-
  direction(Farmer),
  direction(Wolf),
  direction(Goat),
  direction(Cabbage).

unsafe(state(Farmer, Wolf, Goat, Cabbage)) :-
  (same(Wolf, Goat), opposite(Farmer, Wolf));
  (same(Goat, Cabbage), opposite(Farmer, Goat)).
  
safe(state(A,B,C,D)) :-
  \+ unsafe(state(A,B,C,D)).

%arc(step, initial, final) :- opposite(A,B), safe(state()).
arc(take(wolf, A, B), state(A, A, C, D), state(B, B, C, D)) :-
  opposite(A, B),
  safe(state(B, B, C, D)).
  
arc(take(goat, A, B), state(A, C, A, D), state(B, C, B, D)) :-
  opposite(A, B),
  safe(state(B, C, B, D)).
  
arc(take(cabbage, A, B), state(A, C, D, A), state(B, C, D, B)) :-
  opposite(A, B),
  safe(state(B, C, D, B)).

arc(take(none, A, B), state(A, C, D, E), state(B, C, D, E)) :-
  opposite(A, B),
  safe(state(B, C, D, E)).

go(B, B, [], _).
go(A,B, [M|Tmoves], Path) :-
  arc(M, A, I),
  (\+ member(I, Path)),
  append(Path, [A], NewPath),
  go(I, B, Tmoves, NewPath).

solve :-
  go(state(l,l,l,l),state(r,r,r,r),X,[]),
  printList(X).
  
printList([]).
printList([H|T]) :-
  write(H), nl,
  printList(T).
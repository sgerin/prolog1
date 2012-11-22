/*etat initial*/

/*etat_initial(etat_courant(0,0)).*/
etat_initial(etat_courant(X,Y)) :- X = 0, Y = 0.

/* etat final */

etat_final(etat_courant(X,Y)) :- X = 4, Y = 0.
etat_final(etat_courant(X,Y)) :- X = 0, Y = 4.

/* etat impossible */

impossible(etat_courant(X,_)) :- X > 8.
impossible(etat_courant(_,Y)) :- Y > 5.
impossible(etat_courant(X,_)) :- X < 0.
impossible(etat_courant(_,Y)) :- Y < 0.

/* 
remplir-vider les cruches */

etatsuivant(etat_courant(X,Y),etat_courant(8,Y)) :- X < 8.
etatsuivant(etat_courant(X,Y),etat_courant(X,5)) :- Y < 5.
etatsuivant(etat_courant(X,Y),etat_courant(0,Y)) :- X > 0.
etatsuivant(etat_courant(X,Y),etat_courant(X,0)) :- Y > 0.

/* vider la 8 dans la 5 */
/* si la 8 contient plus que ce qui manque dans 5*/
etatsuivant(etat_courant(X,Y),etat_courant(V,5)) :- X > (5 - Y), V is X - (5 - Y), V < X, not(impossible(etat_courant(X,Y))).
/* si la 8 ne contient pas assez pour remplir la 5*/
etatsuivant(etat_courant(X,Y),etat_courant(0,W)) :- X =< (5 - Y), W is Y + X, W > Y, not(impossible(etat_courant(X,Y))).
/* vider la petite dans la grande */
/* si la 5 contient plus que ce qui manque dans la 8*/
etatsuivant(etat_courant(X,Y),etat_courant(8,W)) :- Y > (8 - X), W is Y - (8 - X), W < Y, not(impossible(etat_courant(X,Y))).
/* si la 5 ne contient pas assez pour remplir la 8*/
etatsuivant(etat_courant(X,Y),etat_courant(V,0)) :- Y =< (8 - X), V is X + Y, X+Y > X, not(impossible(etat_courant(X,Y))).

/* recherche avec accumulateur */
possible(X, X, CList, CList).
possible(X, Y, CList, List) :-
	etatsuivant(X, Z),
	not(member(Z, CList)),
	possible(Z, Y, [Z | CList], List).

chemin(X, Y, LListe) :- possible(X, Y, [X], LListe).

cherche_cruche :- etat_final(etat_courant(X,Y)), etat_initial(etat_courant(XX,YY)), chemin(etat_courant(XX,YY),etat_courant(X,Y), Liste),reverse(Liste,R),write(R).


	
/* etats impossibles */
impossible(etatcourant(PasCa,Ca,Ca,PasCa)) :- PasCa \= Ca.
impossible(etatcourant(PasCa,PasCa,Ca,Ca)) :- PasCa \= Ca.
/* transbahuter le chou */
etatsuivant(etatcourant(Moi,Chou,Chevre,Loup),etatcourant(0,0,Chevre,Loup)) :- Chou = 1, Moi = 1, not(impossible(etatcourant(0,0,Chevre,Loup))).
etatsuivant(etatcourant(Moi,Chou,Chevre,Loup),etatcourant(1,1,Chevre,Loup)) :- Chou = 0, Moi = 0, not(impossible(etatcourant(1,1,Chevre,Loup))).
/* transbahuter la chevre */
etatsuivant(etatcourant(Moi,Chou,Chevre,Loup),etatcourant(0,Chou,0,Loup)) :- Chevre = 1, Moi = 1, not(impossible(etatcourant(0,Chou,0,Loup))).
etatsuivant(etatcourant(Moi,Chou,Chevre,Loup),etatcourant(1,Chou,1,Loup)) :- Chevre = 0, Moi = 0, not(impossible(etatcourant(1,Chou,1,Loup))).
/* transbahuter le loup */
etatsuivant(etatcourant(Moi,Chou,Chevre,Loup),etatcourant(0,Chou,Chevre,0)) :- Loup = 1, Moi = 1, not(impossible(etatcourant(0,Chou,Chevre,0))).
etatsuivant(etatcourant(Moi,Chou,Chevre,Loup),etatcourant(1,Chou,Chevre,1)) :- Loup = 0, Moi = 0, not(impossible(etatcourant(1,Chou,Chevre,1))).
/* transbahuter le moi tout seul */
etatsuivant(etatcourant(Moi,Chou,Chevre,Loup),etatcourant(0,Chou,Chevre,Loup)) :- Moi = 1, not(impossible(etatcourant(0,Chou,Chevre,Loup))).
etatsuivant(etatcourant(Moi,Chou,Chevre,Loup),etatcourant(1,Chou,Chevre,Loup)) :- Moi = 0, not(impossible(etatcourant(1,Chou,Chevre,Loup))).

/* recherche avec accumulateur */
possible_riviere(X, X, CList, CList).
possible_riviere(X, Y, CList, List) :-
	etatsuivant(X, Z),
	not(member(Z, CList)),
	possible_riviere(Z, Y, [Z | CList], List).

chemin_riviere(X, Y, FoundPath) :- possible_riviere(X, Y, [X], FoundPath).

/* recherche en largeur */
recherche_largeur(X,Y,C) :- cherche(Y,[[X]],C).

cherche(Y,[[Y|Chs]|_],[Y|Chs]) :- !. /* la solution est la bonne mais inversee */
cherche(Y,[[S|Chs]|AutresChemins],Sol) :- findall([Suc,S|Chs],etatsuivant(S,Suc),NewChemins),
											append(AutresChemins,NewChemins,Chemins),
											cherche(Y,Chemins,Sol).

but_riviere :- chemin_riviere(etatcourant(0,0,0,0),etatcourant(1,1,1,1), Liste),reverse(Liste,R),write(R).

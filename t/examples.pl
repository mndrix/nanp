:- use_module(library(nanp)).
:- op(1050,xfy,'<->').

term_expansion(Number <-> Formats, Tests ) :-
    maplist(expand(Number),Formats,Heads,Tests),
    maplist(tap:register_test,Heads).

expand(Number,Format-Codes,Head,(Head:-Test)) :-
    system:format(atom(Head),"~w <-> ~w `~s`", [Number,Format,Codes]),
    Test = (
        nanp:format(Format,Number,Output),
        Output == Codes,
        nanp:format(Format,Input,Codes),
        Input == Number
    ).

:- use_module(library(tap)).

'valid phone numbers' :-
    valid(nanp(234,235,5678)),
    valid(nanp(281,234,5678)).

'central office exchange cannot end with 11' :-
    invalid(nanp(234,911,9876)).

'area code may not start with 1' :-
    invalid(nanp(123,234,5678)).

'37X area code forbidden' :-
    invalid(nanp(374,555,0000)).

'96X area code forbidden' :-
    invalid(nanp(963,555,1111)).

nanp(760,666,8462) <-> [
    %dial(de) - `001-760-666-8462`,
    dial(us) - `1-760-666-8462`,
    e_164 - `+17606668462`,
    %international - `+1-760-666-8462`,
    %local - `666-8462`,
    ten_digit - `760-666-8462`,
    traditional - `(760) 666-8462`,
    uri - `tel:+17606668462`
].

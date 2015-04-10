:- module(nanp, [invalid/1, valid/1, format/3]).
:- use_module(library(clpfd)).

%% valid(?Number)
%
%  True if Number is a valid phone number.  A Number is represented
%  as a term like `nanp(Area,Office,Subscriber)`.
valid(nanp(Area,Office,Subscriber)) :-
    valid_area_code(Area,_,_,_),
    valid_office_code(Office,_,_,_),
    valid_subscriber_code(Subscriber,_,_,_,_).

% see http://www.nanpa.com/area_codes/index.html for rules
valid_area_code(NXX,N,X1,X2) :-
    NXX in 200..999,
    N in 2..9,
    X1 in 0..8,  % 9 is prohibited until a theoretical, future expansion
    X2 in 0..9,
    NXX #= 100*N + 10*X1 + X2,
    N #= 3 #==> X1 #\= 7,
    N #= 9 #==> X1 #\= 6.

% see http://www.nanpa.com/number_resource_info/co_codes.html for rules
valid_office_code(NXX,N,X1,X2) :-
    NXX in 200..999,
    N in 2..9,
    [X1,X2] ins 0..9,
    NXX #= 100*N + 10*X1 + X2,
    X1 #= 1 #==> X2 #\= 1.

valid_subscriber_code(S,A,B,C,D) :-
    S in 0..9999,
    [A,B,C,D] ins 0..9,
    S #= 1000*A + 100*B + 10*C + D.

% easily recognizable code
erc(NXX) :-
    valid_area_code(NXX,_,X,X).

% N11 codes
n11(NXX) :-
    valid_office_code(NXX,_,1,1).


%% invalid(+Number) is semidet.
%
%  True if Number is not a valid phone number.  A Number is represented
%  as a term like `nanp(Area,Office,Subscriber)`.
invalid(Number) :-
    \+ valid(Number).


%% format(?Format,?Number,?String:codes)
%
%  True if String represents Number according to Format.
%  At least one of Format, Number or String must be instantiated.
%  Format is on of the following phone number formats:
%
%    * `e_164` - [E.164](https://en.wikipedia.org/wiki/E.164) (like "+17606668462")
%    * `dial(us)` - how to dial from inside the US (like "1-760-666-8462")
%    * `traditional` - traditional American format (like "(760) 666-8462")
%    * `uri` - as a URI (like "tel:+17606668462")
%
%  This predicate may be used for parsing and formatting telephone numbers.
format(Format,Number,Codes) :-
    phrase(format(Format,Number),Codes).

format(e_164,nanp(A,O,S)) --> % https://en.wikipedia.org/wiki/E.164
    "+1",
    area_code(A),
    office_code(O),
    subscriber_code(S).
format(dial(us),nanp(A,O,S)) --> % format describes dialing a number from US
    "1-",
    area_code(A),
    "-",
    office_code(O),
    "-",
    subscriber_code(S).
format(traditional,nanp(A,O,S)) --> % http://goo.gl/kkHkZY
    "(",
    area_code(A),
    ") ",
    office_code(O),
    "-",
    subscriber_code(S).
format(uri,Number) -->
    "tel:",
    format(e_164,Number).

area_code(A) -->
    { valid_area_code(A,N,X1,X2) },
    digit(N),
    digit(X1),
    digit(X2).

office_code(O) -->
    { valid_office_code(O,N,X1,X2) },
    digit(N),
    digit(X1),
    digit(X2).

subscriber_code(S) -->
    { valid_subscriber_code(S,A,B,C,D) },
    digit(A),
    digit(B),
    digit(C),
    digit(D).

digit(N) -->
    [C],
    { digit_char(N,C) }.

digit_char(0,0'0).
digit_char(1,0'1).
digit_char(2,0'2).
digit_char(3,0'3).
digit_char(4,0'4).
digit_char(5,0'5).
digit_char(6,0'6).
digit_char(7,0'7).
digit_char(8,0'8).
digit_char(9,0'9).

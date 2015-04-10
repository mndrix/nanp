# Synopsis

```prolog
:- use_module(library(nanp), []).

?- nanp:format(e_164,nanp(760,666,8462),String).
String = "+17606668462".

?- nanp:format(traditional,Num,`(760) 666-8462`).
Num = nanp(760, 666, 8462).
```

# Description

A library for working with telephone numbers assigned under the North American Numbering Plan.  This includes telephone numbers from many countries in North America and the Caribbean.


# Installation

Using SWI-Prolog 7.1 or later:

    ?- pack_install(nanp).

This module uses [semantic versioning](http://semver.org/).

Source code available and pull requests accepted at
http://github.com/mndrix/nanp

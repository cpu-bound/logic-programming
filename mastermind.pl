% ----------------------------------------
%    Juego de Mastermind (mastermind.pl)
% ----------------------------------------

:- dynamic past_guess/2.

% Colores disponibles
colors([red, green, blue, yellow, orange, purple]).


% Funcion principal del juego
start :-
    write('Welcome to Mastermind!'), nl,
    write('Available colors: red, green, blue, yellow, orange, purple'), nl, nl, nl,
    write('Enter your guesses as a list of 4 colors, e.g. [red,blue,green,yellow].'), nl,
    write('You have 12 attempts.'), nl,
    colors(Colors),
    random_code(Colors, 4, Secret),
    play(Secret, 1).


% Genera un codigo aletorio 
% random_code(+Colors, +N, -Code)
random_code(_, 0, []) :- !.
random_code(Colors, N, [C|Rest]) :-
    length(Colors, L),
    random_between(1, L, Index),
    nth1(Index, Colors, C),
    N1 is N - 1,
    random_code(Colors, N1, Rest).


% Bucle del juego. Se detiene si se llegan a los 12 intentos o se adivida el secreto.
% play(+Secret, +Attempt) :-
play(Secret, Attempt) :-
    Attempt =< 12,
    nl, write('Attempt '), write(Attempt), write('/12'), nl,
    write('Your guess: '),
    read(Guess),
    ( valid_guess(Guess) ->
        feedback(Secret, Guess, Blacks, Whites),
        assert(past_guess(Guess, [Blacks, Whites])),
        write('Feedback: '), write(Blacks), write(' black(s), '), write(Whites), write(' white(s).'), nl,
        ( Blacks =:= 4 ->
            write('Congratulations! You guessed the secret code!'), nl,
            retractall(past_guess(_,_))
        ;
            Attempt1 is Attempt + 1,
            play(Secret, Attempt1)
        )
    ;
        write('Invalid guess. Please enter a list of 4 valid colors.'), nl,
        play(Secret, Attempt)
    ).


play(Secret, Attempt) :-
    Attempt > 12,
    nl, write('You ran out of attempts! The secret code was: '), write(Secret), nl,
    retractall(past_guess(_,_)).


% Evalua si Guess es valido
% valid_guess(+Guess)
valid_guess(Guess) :-
    is_list(Guess),
    length(Guess, 4),
    colors(Colors),
    forall(member(C, Guess), member(C, Colors)).


% Evalua Guess con el Secreto y da cuantos blacks y whites hay.
% feedback(+Secret, +Guess, -Blacks, -Whites)
feedback(Secret, Guess, Blacks, Whites) :-
    blacks(Secret, Guess, Blacks, SecretRest, GuessRest),
    whites(SecretRest, GuessRest, Whites).


% Cuenta aciertos exactos en el guess (color y posicion)
% blacks(+Secret, +Guess, -Blacks, -SecretRest, -GuessRest),
blacks([], [], 0, [], []).
blacks([S|Ss], [G|Gs], Blacks, SecretRest, GuessRest) :-
    ( S == G ->
        Blacks1 is 1,
        blacks(Ss, Gs, Blacks2, SecretRest, GuessRest),
        Blacks is Blacks1 + Blacks2
    ;
        blacks(Ss, Gs, Blacks2, SRest, GRest),
        SecretRest = [S|SRest],
        GuessRest = [G|GRest],
        Blacks = Blacks2
    ).


% Cuenta aciertos en color o posicion en guess
% whites(+SecretRest, +GuessRest, -Whites)
whites([], _, 0).
whites(_, [], 0).
whites(SecretRest, GuessRest, Whites) :-
    findall(C, (member(C, GuessRest), member(C, SecretRest)), Matches),
    sort(Matches, Unique),
    length(Unique, Whites).




% ---------------------------------------
%    Ejemplo de uso
% ---------------------------------------

% swipl
% ?- consult('mastermind.pl').
% ?- start.

% Attempt 1/12
% Your guess: [red,blue,green,yellow].
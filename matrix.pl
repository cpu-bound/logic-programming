% ---------------------------------------
%    Operaciones matriciales (matrix.pl)
% ---------------------------------------
% La matriz se representa como una lista de listas.
% Cada lista interna es una fila de la matriz
%
% [ [1,2,3],
%   [4,5,6],
%   [7,8,9] ]

% ---------------------------------------
% Funciones genericas
% ---------------------------------------

% Suma todos los elementos de una lista
% sum_list(+List, -Sum)
sum_list([], 0).
sum_list([H|T], Sum) :-
    sum_list(T, Rest),
    Sum is H + Rest.


% Multiplica todos los elementos de una lista
% prod_list(+List, -Product)
prod_list([], 1).
prod_list([H|T], Product) :-
    prod_list(T, Rest),
    Product is H * Rest.


% Devuelve la n-ésima fila de la matriz (empezando en 1)
% nth_row(+Matrix, +RowIndex, -Row)
nth_row(Matrix, RowIndex, Row) :-
    nth1(RowIndex, Matrix, Row).


% Devuelve la n-ésima columna de la matriz (empezando en 1) como lista
% nth_column(+Matrix, +ColIndex, -Column)
nth_column([], _, []).
nth_column([Row|Rest], ColIndex, [Elem|ColumnRest]) :-
    nth1(ColIndex, Row, Elem),
    nth_column(Rest, ColIndex, ColumnRest).


% Devuelve todos los elementos de la matriz como lista
% flatten_matrix(+Matrix, -FlatList)
flatten_matrix([], []).
flatten_matrix([Row|Rest], Flat) :-
    flatten_matrix(Rest, FlatRest),
    append(Row, FlatRest, Flat).


% ---------------------------------------
%    Operaciones de suma
% ---------------------------------------

% Suma todos los elementos de la matriz
% matrix_sum(+Matrix, -Sum)
matrix_sum(Matrix, Sum) :-
    flatten_matrix(Matrix, Flat),
    sum_list(Flat, Sum).

% Suma todos los elementos de la fila dada por parámetro
% matrix_row_sum(+Matrix, -RowIndex, -Sum)
matrix_row_sum(Matrix, RowIndex, Sum) :-
    nth_row(Matrix, RowIndex, Row),
    sum_list(Row, Sum).


% Suma todos los elementos de la columna dada por parámetro
% matrix_col_sum(+Matrix, -ColIndex, -Sum)
matrix_col_sum(Matrix, ColIndex, Sum) :-
    nth_column(Matrix, ColIndex, Column),
    sum_list(Column, Sum).

% ---------------------------------------
%    Operaciones de multiplicacion
% ---------------------------------------

% Multiplica todos los elementos de la matriz
% matrix_product(+Matrix, -Product)
matrix_product(Matrix, Product) :-
    flatten_matrix(Matrix, Flat),
    prod_list(Flat, Product).


% Multiplica todos los elementos de la fila dada por parámetro
% matrix_row_product(+Matrix, +RowIndex, -Product)
matrix_row_product(Matrix, RowIndex, Product) :-
    nth_row(Matrix, RowIndex, Row),
    prod_list(Row, Product).


% Multiplica todos los elementos de la columna dada por parámetro
% matrix_col_product(+Matrix, +ColIndex, -Product)
matrix_col_product(Matrix, ColIndex, Product) :-
    nth_column(Matrix, ColIndex, Column),
    prod_list(Column, Product).


% ---------------------------------------
%    Ejemplo de uso
% ---------------------------------------

% swipl
% ?- consult('matrix.pl').

% ------------ Suma ------------
% ?- Matrix = [[1,2,3],[4,5,6],[7,8,9]],
%    matrix_sum(Matrix, S).
% S = 45.

% ?- Matrix = [[1,2,3],[4,5,6],[7,8,9]],
%    matrix_row_sum(Matrix, 2, S).
% S = 15.

% ?- Matrix = [[1,2,3],[4,5,6],[7,8,9]],
%    matrix_col_sum(Matrix, 3, S).
% S = 18.

% ------------ Producto ------------
% ?- Matrix = [[1,2,3],[4,5,6],[7,8,9]],
%    matrix_product(Matrix, P).
% P = 362880.

% ?- Matrix = [[1,2,3],[4,5,6],[7,8,9]],
%    matrix_row_product(Matrix, 1, P).
% P = 6.

% ?- Matrix = [[1,2,3],[4,5,6],[7,8,9]],
%    matrix_col_product(Matrix, 2, P).
% P = 80.
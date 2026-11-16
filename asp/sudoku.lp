
% =====================================================================
% Sudoku Solver using Answer Set Programming (ASP)
% =====================================================================
%
% Group Members
%   Yibrah Mehari      : yibrah.gebregziabher@uni-potsdam.de
%   Bertram Bräuninger : bertram.braeuninger@uni-potsdam.de
%
% ---------------------------------------------------------------------
% Problem Statement
% ---------------------------------------------------------------------
% Instance:
%   A 9x9 grid that is partially filled with digits from 1 to 9.
%
% Solution:
%   A complete grid satisfying the following constraints:
%     (R) Every row contains each digit from 1 to 9 exactly once.
%     (C) Every column contains each digit from 1 to 9 exactly once.
%     (S) Every 3x3 subgrid contains each digit from 1 to 9 exactly once.
%
% The size of each subgrid is defined by the constant SUBGRID_SIZE.
% Subgrids are labeled from 0 to SUBGRID_SIZE^2 - 1.
%
% A cell (X,Y) is mapped to its subgrid using:
%
%       ((X-1)/s)*s + ((Y-1)/s)
%
% where s = SUBGRID_SIZE and division is integer division.
% =====================================================================


% ---------------------------------------------------------------------
% 0. Parameters
% ---------------------------------------------------------------------
#const subgrid_size = 3.  % Side length of each subgrid.


% ---------------------------------------------------------------------
% 1. Problem Instance
% ---------------------------------------------------------------------
% The initial/3 predicate represents the partially filled  numbers in the puzzle.
% Each fact initial(X,Y,N) specifies that cell (X,Y) contains digit N.
%
% Every given number must be part of  the solution.

sudoku(X,Y,N) :- initial(X,Y,N).


% ---------------------------------------------------------------------
% 2. Domains
% ---------------------------------------------------------------------
index(1..9).                  % Valid row and column indices.
digit(1..9).                  % Valid Sudoku digits.

cell(X,Y) :- index(X), index(Y).  % All cells in the grid.


% ---------------------------------------------------------------------
% 3. Assign Exactly One Digit to Every Cell
% ---------------------------------------------------------------------
1 { sudoku(X,Y,N) : digit(N) } 1 :- cell(X,Y).


% ---------------------------------------------------------------------
% 4. Constraints
% ---------------------------------------------------------------------

% (R) Row constraint:
% No digit may appear more than once in the same row.

:- sudoku(X,Y,N), sudoku(X2,Y,N), X != X2.


% (C) Column constraint:
% No digit may appear more than once in the same column.

:- sudoku(X,Y,N), sudoku(X,Y2,N), Y != Y2.


% Map each cell to its corresponding subgrid.
% Subgrid labels range from 0 to SUBGRID_SIZE^2 - 1.

subgrid(X,Y,((X-1)/subgrid_size)*subgrid_size +((Y-1)/subgrid_size)) :- cell(X,Y).


% (S) Subgrid constraint:
% No digit may appear more than once in the same 3x3 subgrid.

:- sudoku(X,Y,N),
   sudoku(X2,Y2,N),
   subgrid(X,Y,S),
   subgrid(X2,Y2,S),
   (X,Y) != (X2,Y2).


% ---------------------------------------------------------------------
% 5. Output
% ---------------------------------------------------------------------


#show sudoku/3.


% Progenitor function: SIMPLEX
% Runs the Simplex algorithm. Assumes linear program is in canonical form
% @PARAM: A -> Constraint Matrix
%        x -> Vector of all variables
%        b -> Vector of constraint bounds
%        C -> Objective function
%        m -> Min/Max (0,1)
%        g -> Generate Graph (0,1) (2 dim only)
function Simplex(A,x,b,C,m,g)
%   -- help function simplex --
%       Simplex(A,x,b,C,m,g) where A is the constraint matrix, x is the vector of all variables,
%       b is the vector of constraint bounds, C is the objective function, m is whether the 
%       program is min (0) or max (1) and g is whether you want the program to generate a graph (1)
%       or not (0). Simplex has no return.
    disp("SIMPLEX")
    A
    x
    b
    C
    MiddleWare(A,x,b,C,m,g)
end

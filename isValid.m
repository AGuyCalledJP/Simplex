% Dimension error handling 
% @AUTHOR: Jewell Day
% @PARAM: A -> Constraint Matrix
%        x -> Vector of all variables
%        b -> Vector of constraint bounds
%        C -> Objective function
function isValid( A,x,b,C )
%this functions insures the inputs have compatable dinemsions

aSz = size(A);
xSz = size(x);
bSz = size(b);
cSz = size(C);

if aSz(2) < xSz(2)
    error("Vector of variables is too large")
elseif aSz(2) > xSz(2)
    error("Vector of variables is too small")
elseif aSz(1) > bSz(2)
    error("not enough constraint bounds")
elseif aSz(1) < bSz(2)
    error("too many constraint bounds")
elseif aSz(2) > cSz(2)
    error("not enough objective coefficients")
elseif aSz(2) < cSz(2)
    error("too many objective coefficients")
end
end


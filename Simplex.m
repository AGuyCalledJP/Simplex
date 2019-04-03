%Progenitor function: SIMPLEX
%Assumes linear program is in canonical form
%@PARAM: A -> Constraint Matrix
%        x -> All vars
%        b -> Bounds for constraints
%        C -> Objective function
%        m -> Min/Max (0,1)
%        g -> Generate Graph (0,1) (2 dim only)
function Simplex(A,x,b,C,m,g)
    disp("SIMPLEX")
    disp(A)
    disp(x)
    disp(b)
    disp(C)
    MiddleWare(A,x,b,C,m,g)
end

% TESTER CODE
try
    A = [1 1 1 0 0
         5 2 0 1 0 
         0 1 0 0 1];
    x = [1 2 3 4 5];
    b = [4 11 4];
    C = [10 3 0 0 0];
    Simplex(A,x,b,C,1,0);
catch e
    disp(e) 
end

try
    A = [1 1 -1 0 0
         1 -1 0 -1 0
         1 2 0 0 1];
    x = [1 2 3 4 5];
    b = [3 1 4];
    C = [1 3 0 0 0];
    Simplex(A,x,b,C,1,0);
catch e
    disp(e) 
end
try
    A = [1 0 1 0 0
         0 1 0 1 0 
         1 1 0 0 1];
    x = [1 2 3 4 5];
    b = [6 6 11];
    C = [1 1 0 0 0];
    Simplex(A,x,b,C,0,0);
catch e
    disp(e) 
end

try 
    A = [2 -2 1 -1
         4 0 0 1];
    x = [1 2 3 4];
    b = [6 16];
    C = [4 6 0 0];
    Simplex(A,x,b,C,1,0);
catch e
    disp(e) 
end

try 
    A = [1 4 -1 0
         0 1 0 -1];
    x = [1 2 3 4];
    b = [10 11];
    C = [1 1 0 0];
    Simplex(A,x,b,C,1,0);
catch e
    disp(e) 
end

try
    A = [2 -1 4 1 0
         4 2 5 0 -1];
    x = [1 2 3 4 5];
    b = [18 10];
    C = [4 2 7 0 0];
    Simplex(A,x,b,C,1,0);
catch e
    disp(e) 
end


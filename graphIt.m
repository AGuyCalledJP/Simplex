% @PARAM A -> Constraint matrix 
%        b -> Vector of constraint bounds
%        x -> Vector of all variables
%        v -> Number of original non-slack variables
%        path -> n x 2 matrix of the (x,y) corrdinates for the nth iteration the simplex algorithm took
% @RETURN none

function graphIt(A,b,x,v,path)
%   -- help function graphIt --
%   graphIt(A,b,x,v,path) where A is the constraint matrix, b is the vector of constraint bounds,
%   x is the vector of variables, v is the number of original (non-slack) variables and path is an 
%   n x 2 matrix holding the (x,y) coordinates for the nth iteration the simplex algorithm took. This 
%   function doesn't have a return. 
%
%   This is a support function which takes the path found in MaximizeGraphical and draws a graph from 
%   the coordinates the algorithm went through

    tBasic = length(x) - v;
    % Find number of basic variables above
    
    % Generate possible solutions 
    seed = zeros(1,length(x));
    for i = 1:tBasic
       seed(i) = 1; 
    end
    
    % Generate all permutations of basic solutions 
    P = perms(seed);
    
    % Generate all unique rows of the permutations 
    U = unique(P, 'rows');
    
    % Traverse through U matrix
    % V is all the columns of A that correspond to basic variables for this permuation 
    % Take V inverse * b'
    for i = 1:length(U)
       V = A(:,find(U(i,:)));
       res = V \ b';
       k = 1;
       % Store actual values just computed
       for j = 1:length(U(i,:))
           if U(i,j) == 1
               U(i,j) = res(k);
               k = k + 1;
           end
       end
    end
    
    % Generate all unique rows of the matrix U
    U = unique(U, 'rows');
    
    % Get all rows of U that are strictly positive
    new = [];
    len = 1;
    for i = 1:length(U)
        r = U(i,:)>=0;
        % tells if it is all greater than 0
        % if its all positive it gets put in a list of keepers and then the keepers
        % are later all put in an array
        if all(r)
            new(len) = i;
            len = len + 1;
        end
    end
    
    % Take first two columns and split them off by coordinate pairs : seperate as first column 
    % being x and second column being y
    U = U(new,:);
    pairs = U(:,[1 2]);
    x = pairs(:,1);
    y = pairs(:,2);
    
    % Add coordinates to the path matrix
    v = path(:,1);
    w = path(:,2);
    
    % Plot data found
    figure
    hold on
    plot(x,y)
    plot(v,w)
end

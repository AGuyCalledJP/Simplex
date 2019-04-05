% This function graphs the path taken through the feasible region by the algorithm
% Inputs: Matrix A, vector b, x is the list of variables,
% v is the number of original non-slack variables there are,
% path is the path the simplex algorithm took (found in maximizeGraphical)
% No return

function graphIt(A,b,x,v,path)
    % Want to take all permutations of basic soluitons 
    % ALL VALUES IN THE VECTOR MUST BE POSITIVE
    
    % Find number of basic variables
    tBasic = length(x) - v;
    % Generate possible solutions 
    seed = zeros(1,length(x));
    for i = 1:tBasic
       seed(i) = 1; 
    end
    
    % Generate all permutations of basic solutions using MatLab perm() function
    P = perms(seed);
    % Generate all unique rows of the permutations using Matlab unique() function
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
        % all tells if it is all greater than 0
        % if its all positive it gets put in a list of keepers and then the keepers
        % are later all put in an array
        if all(r)
            new(len) = i;
            len = len + 1;
        end
    end
    % disp(new);
    
    % Take first two columsn and splitting them off my coordinate pairs : seperate as first column 
    % being x and second column being y
    U = U(new,:);
    pairs = U(:,[1 2]);
    x = pairs(:,1);
    y = pairs(:,2);
    
    % this is path that was passed in at the start
    v = path(:,1);
    w = path(:,2);
    
    % Plot data found
    figure
    hold on
    plot(x,y)
    plot(v,w)
end

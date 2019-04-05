% This function graphs the path taken through the feasible region by the algorithm
% Inputs: Matrix A, vector b, WHAT ARE X AND V AND PATH?
% Does this output anything?

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
    % WHAT IS THIS BLOCK DOING?
    for i = 1:length(U)
       V = A(:,find(U(i,:)));
       res = V \ b';
       k = 1;
       for j = 1:length(U(i,:))
           if U(i,j) == 1
               U(i,j) = res(k);
               k = k + 1;
           end
       end
    end
    U = unique(U, 'rows');
    
    % Get all rows of U that are strictly positive????
    new = [];
    len = 1;
    for i = 1:length(U)
        r = U(i,:)>=0;
        if all(r)
            new(len) = i;
            len = len + 1;
        end
    end
    % disp(new);
    
    % WHAT DOES THIS SECTION DO?
    % WHAT DOES PAIRS DO?
    U = U(new,:);
    pairs = U(:,[1 2]);
    x = pairs(:,1);
    y = pairs(:,2);
    
    v = path(:,1);
    w = path(:,2);
    
    % Plot data found
    figure
    hold on
    plot(x,y)
    plot(v,w)
end

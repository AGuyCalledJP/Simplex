% @PARAM  A -> Constraint matrix 
%         b -> Vector of constraint bounds
%         x -> Vector of all variables
%         v -> Number of original variables
% @RETURN -1 when the origin is feasible, otherwise it minimizes the program and returns the solution to the simplex
%           algorithm

function res = findMe(A,b,x,v)
%       -- help function findMe --
%       res = findMe(A,b,x,v) where A is the constraint matrix, b is the vector of constraint bounds
%       x is the vector of all variables and v is the number of original variables. FindMe returns -1
%       when the origin is feasible. Otherwise, it minimized the program and returns the solution to the simplex
%       algorithm.
%
%       This is a supporting function to check if the origin is a feasible solution and find a new initial
%       feasible solution if the origin is infeasible.

    % Get column and row size of A
    [m,n] = size(A);
    
    % Determine how many problem constraints we have 
    % potential problems: if a constraint must be greater than or equal to a positive number, 
    %                     if a constraint must be less than or equal to a negative number,                  
    pardner = zeros(1,m);
    
    % Identify potential problems for each row
    for i = 1:m
        isNeg = 0;
        for j = 1:n % parse through columns
            if A(i,j) == 0
                % do nothing 
            elseif A(i,j) < 0 % set isNeg
                isNeg = 1; 
            elseif A(i,j) > 0 % set isNeg
                isNeg = 0;
            end
        end
        
        % update pardner(i) for each row i
        if isNeg && b(i) > 0
           pardner(i) = 1;
        elseif ~isNeg && b(i) < 0
           pardner(i) = 1;
        elseif ~isNeg && b(i) > 0
           pardner(i) = 1;
        elseif isNeg && b(i) < 0
           pardner(i) = 1;
        end
    end 
   
    %add new variables to A, x, and c
    if pardner>0
        % if find(~(pardner)) is not full of zeros we need to find a new initial solution
        
        % create a newX vector with a new row for every problem detected
        num = length(pardner) - length(find(~pardner));
        start = length(x);
        % have newX contain a 1 in the new rows added and a 0 otherwise
        newX = zeros(1,start + num);
        for i = 1:start + num
            newX(i) = i;
        end
        
        % create a newC vector of same length as newX
        newC = zeros(1,length(newX));
        q = num;
        tail = length(newX) + 1;
        while q > 0
            newC(tail - q) = 1;
            q = q - 1;
        end
        
        % Make a new A matrix
        % Add the new problem columns to the size of newA
        newA = zeros(m, n + num);
        here = num - 1;
        % traverse through A rows
        for i = 1:m
            foundOne = 0;
            % traverse through A columns
            for j = 1:n + num
                if j <= n
                    % if not in problem column just copy over from matrix A
                    newA(i,j) = A(i,j);
                else
                    % When it's a problem then we add a 1 to the spot of problem
                    if pardner(i) == 1 && j == (n + num) - here && ~foundOne
                        newA(i,j) = 1;
                        here = here - 1;
                        foundOne = 1;
                    end
                end
            end
        end
        
        % Make new x_not with all 0's
        x_not = zeros(length(newX),1);
        
        % Set vector of indexes where array is 0
        aInds = find(newC);
        
        % Set vector of indexes where array is not 0 (where there's a problem)
        sInds = find(~newC);
        
        % at indexes which problem constraint we're at (how many we've already gone through)
        at = 1;
        
        % Navigate through, when we're at a problem constraint we want to 
        % set the value of x_not to the value of b(i) 
        for i = 1:length(pardner)
           if pardner(i) == 1
               % 
               x_not(aInds(at)) = b(i);
               at = at + 1;
           else 
               x_not(sInds(v + i)) = b(i);
           end
        end
        
        % Make new B where x_not is 0
        newB = find(x_not)';
        
        % Make new N where x_not is not 0
        newN = find(~x_not)';
        
        % Call Maximize() on new data found
        hold = Maximize(x_not, newB, newN, -newC, -newA, newX, -b, 0);
        if hold == -2
            % Then infeasible linear program
            msg = 'Lp was Infeasible';
            error(msg)
        else
            % Otherwise return the solution to Maximize
            diff = length(newX) - length(x);
            res = hold(1:length(hold)-diff, 1);
        end
    else 
        % if no problems were found (origin is feasible) we return -1
        res = -1;
    end
end

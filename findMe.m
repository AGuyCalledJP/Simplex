% Function to find an initial solution when the origin is not feasible 
% Inputs: matrix A, vector b, WHAT ARE X AND V?
% Output: -1 when the origin is feasible 
function res = findMe(A,b,x,v)
    %get column and row size of A
    [m,n] = size(A);
    
    %Determine how many problem constraints we have 
    %potential problems: if a constraint must be greater than or equal to a positive number, 
    %                    if a constraint must be less than or equal to a negative number,
    %                    
    pardner = zeros(1,m);
    %Identify potential problems for each row
    for i = 1:m
        isNeg = 0;
        for j = 1:n %parse through columns
            if A(i,j) == 0
                %do nothing 
            elseif A(i,j) < 0 %set isNeg
                isNeg = 1; 
            elseif A(i,j) > 0 %set isNeg
                isNeg = 0;
            end
        end
        %update pardner(i) for each row i
        if isNeg && b(i) > 0
           pardner(i) = 1;
        elseif ~isNeg && b(i) < 0
           pardner(i) = 1;
        end
    end
    %disp(pardner)
    
    %add new vars to A, x, and c
    if ~isempty(find(~pardner))
        %if find(~(pardner)) is not full of zeros we need to find a new initial solution
        
        %disp(find(~pardner))
        %create a newX vector with a new row for every problem detected
        num = length(pardner) - length(find(~pardner));
        start = length(x);
        %have newX contain a 1 in the new rows added and a 0 otherwise
        newX = zeros(1,start + num);
        for i = 1:start + num
            newX(i) = i;
        end
        %disp(newX)
        
        %create a newC vector of same length as newX
        newC = zeros(1,length(newX));
        q = num;
        tail = length(newX) + 1;
        while q > 0
            newC(tail - q) = 1;
            q = q - 1;
        end
        % disp(newC)
        
        % Make new A matrix
        % disp(A)
        % Add the new problem columns to the size of newA
        newA = zeros(m, n + num);
        here = num - 1;
        % traverse through A rows
        for i = 1:m
            foundOne = 0;
            % traverse through A columns
            for j = 1:n + num
                if j <= n
                    % WHAT IS HAPPENING HERE
                    newA(i,j) = A(i,j);
                else
                    %Otherwise we DO WHAT?
                    if pardner(i) == 1 && j == (n + num) - here && ~foundOne
                        newA(i,j) = 1;
                        here = here - 1;
                        foundOne = 1;
                    end
                end
            end
        end
        
        % disp(newA)
        
        % Make new x_not
        x_not = zeros(length(newX),1);
        % WHAT DOES FIND DO AGAIN?
        aInds = find(newC);
        sInds = find(~newC);
        at = 1;
        % NEED A REMINDER ON THIS
        for i = 1:length(pardner)
           if pardner(i) == 1
               x_not(aInds(at)) = b(i);
               at = at + 1;
           else 
               x_not(sInds(v + i)) = b(i);
           end
        end
        
        %Make new B and N
        newB = find(x_not)';
        newN = find(~x_not)';
        
        % Call Maximize() on new data found
        % REMINDER ON THIS AS WELL
        hold = Maximize(x_not, newB, newN, -newC, -newA, newX, -b);
        diff = length(newX) - length(x);
        res = hold(1:length(hold)-diff, 1);
    else 
        %if no problems were found we return -1
        res = -1;
    end
end

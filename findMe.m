function res = findMe(A,b,x,v)
    [m,n] = size(A);
    
    %Determine how many problem constraints we have 
    pardner = zeros(1,m);
    for i = 1:m
        isNeg = 0;
        for j = 1:n
            if A(i,j) == 0
                
            elseif A(i,j) < 0
                isNeg = 1;
            elseif A(i,j) > 0
                isNeg = 0;
            end
        end
        if isNeg && b(i) > 0
           pardner(i) = 1;
        elseif ~isNeg && b(i) < 0
           pardner(i) = 1;
        end
    end
    %disp(pardner)
    
    %add new vars to A, x, and c
    if ~isempty(find(~pardner))
        %disp(find(~pardner))
        num = length(pardner) - length(find(~pardner));
        start = length(x);
        newX = zeros(1,start + num);
        for i = 1:start + num
            newX(i) = i;
        end
        %disp(newX)
        newC = zeros(1,length(newX));
        q = num;
        tail = length(newX) + 1;
        while q > 0
            newC(tail - q) = 1;
            q = q - 1;
        end
        %disp(newC)
        
        %Make new A
        %disp(A)
        newA = zeros(m, n + num);
        here = num - 1;
        for i = 1:m
            foundOne = 0;
            for j = 1:n + num
                if j <= n
                    newA(i,j) = A(i,j);
                else
                    if pardner(i) == 1 && j == (n + num) - here && ~foundOne
                        newA(i,j) = 1;
                        here = here - 1;
                        foundOne = 1;
                    end
                end
            end
        end
        
        %disp(newA)
        
        %Make new x_not
        x_not = zeros(length(newX),1);
        aInds = find(newC);
        sInds = find(~newC);
        at = 1;
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
        
        hold = Maximize(x_not, newB, newN, -newC, -newA, newX, -b);
        diff = length(newX) - length(x);
        res = hold(1:length(hold)-diff, 1);
    else
        res = -1;
    end
end
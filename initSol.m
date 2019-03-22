function res = initSol(A,b,x,B,N,C)
    [m,n] = size(A);
    
    %Determine how many problem constraints we have 
    pardner = zeros(1,m);
    for i = 1:m
        isNeg = 0;
        for j = 1:n
            if A(i,j) == 0
                ;
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
    disp(pardner)
    
    %add new vars to A, x, and c
    if ~isempty(find(~pardner))
        disp(find(~pardner))
        num = length(pardner) - length(find(~pardner));
        start = length(x);
        newX = zeros(1,start + num);
        for i = 1:start + num
            newX(i) = i;
        end
        disp(newX)
        newC = zeros(1,length(newX));
        q = num;
        tail = length(newX) + 1;
        while q > 0
            newC(tail - q) = 1;
            q = q - 1;
        end

        disp(newC)
        
        %Make new A
        newA = zeros(m, n + num);
        
    else
        res = -1
    end
end
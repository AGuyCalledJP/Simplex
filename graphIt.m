function graphIt(A,b,x,v,path)
    %Want to take all permutations of basic soluitons 
    tBasic = length(x) - v;
    %generate possible solutions 
    seed = zeros(1,length(x));
    for i = 1:tBasic
       seed(i) = 1; 
    end
    P = perms(seed);
    U = unique(P, 'rows');
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
    pairs = U(:,[1 2]);
    x = pairs(:,1);
    y = pairs(:,2);
    
    v = path(:,1);
    w = path(:,2);
    
    figure
    hold on
    plot(x,y)
    plot(v,w)
end
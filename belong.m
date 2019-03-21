function res = belong(B,i)
    l = ismember(B,i);
    res = 0;
    for i = 1:length(l)
       if l(i) == 1
          res = 1;
       end
    end
end
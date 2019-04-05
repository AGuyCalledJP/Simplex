% Checks if an element i is a member in a matrix
% @PARAM: Matrix B, element i (what we're searching for)
% @RETURN: Returns 1 if element i is found, 0 otherwise
function res = belong(B,i)
    l = ismember(B,i);
    res = 0;
    for i = 1:length(l)
       if l(i) == 1
          res = 1;
       end
    end
end

% Checks if an element i is a member in a matrix
% @PARAM: B -> Matrix being searched
%         i -> element being searched for
% @RETURN: Returns 1 if element i is found, 0 otherwise

function res = belong(B,i)
%   -- help function belong --
%   res = belong(B,i) where B is the matrix being searched 
%   and element i is what is being searched for. This function
%   returns res = 1 if the element is contained in the matrix
%   and 0 otherwise.

    l = ismember(B,i);
    res = 0;
    for i = 1:length(l)
       if l(i) == 1
          res = 1;
       end
    end
end

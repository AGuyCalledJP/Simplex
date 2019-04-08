% Simplex algorithm for maximization. Assumes cannonical form
% @PARAM: x_not -> initial feasible solution
%        B -> Set of basic vars -> corresponds to column numbering
%        N -> Set of non-basic vars -> corresponds to column numbering
%        A -> Constraint Matrix
%        x -> vector of all variables
%        b -> Vector of bounds for constraints
%        path -> n x 2 matrix of (x,y) coordinates of n iterations of the simplex algorithm
%        iter -> number of iterations
% @RETURN path -> n x 2 matrix filled by (x,y) coordinates of the n iteations taken by the simplex algortithm

function [r,completePath] = MaximizeGraphical(x_not, B, N, C, A, x, b, path, iter)
%     -- help function MaximizeGraphical --
%     [r,completePath] = MaximizeGraphical(x_not,B,N,C,A,x,b,path) where x_not is the initial feasible solution,
%     B is the set of basic variables, N is the set of non-basic variables, A is the constraint matrix,
%     x is the vector of all variables, b is the vector of the bounds of the constraints and path is 
%     an n x 2 matrix of (x,y) coordinates of n iterations of the simplex algorithm. Returns optimal solution vector r
%     and an n x 2 matrix containing the (x,y) coordinate the algorithm was at for each of the n iterations of the 
%     algorithm.

    % Add initial starting point to path matrix
    path(end+1, 1) = x_not(1);
    path(end, 2) = x_not(2);
    
    % First need to set B' and N'
    down = length(A(:,1));
    basic = length(B);
    nonBasic = length(N);
    
    % Set Bp, Cb, Np, Cn to zeros
    Bp = zeros(down, basic);
    Cb = zeros(basic, 1);
    Np = zeros(down, nonBasic);
    Cn = zeros(nonBasic, 1);
    
    % Extract columns of A corresponding to B to form Bp
    % A(:,1); <- grab a column
    for i = 1:basic
       ind = B(i);
       col = A(:,ind);
       Bp(:,i) = col;
    end
    
    % Find Cb
    for i = 1:basic
       ind = B(i);
       val = C(ind);
       Cb(i) = val;
    end
    
    % Make Np from corresponding columns of A
    for i = 1:nonBasic
       ind = N(i);
       col = A(:,ind);
       Np(:,i) = col;
    end
    
    % Find CN
    for i = 1:nonBasic
       ind = N(i); 
       val = C(ind);
       Cn(i) = val;
    end
    
    % Calculate y -> B'y = -Cb
    y = Bp' \ -Cb;
    
    % Calculate Reduced Cost
    Cnhat = Cn' + (y' * Np);
    
    % Find the most improving feasible direction
    ei = 0;
    maxV = 0;
    for i = 1:length(Cnhat)
        if Cnhat(i) > 0
            ei = i;
            maxV = N(i);
        end
    end
    if ei == 0
        if iter == 0
            % Linear program is not feasible
            r = -2;
            completePath = [];
        else
            % Max found: Return x_not and completePath       
             r = x_not;
             completePath = path;   
        end
    else 
       % Set entering variable
       enter = maxV;
       
       % Create simplex direction for the winner
       d = Bp \ -A(:,enter);
       
       % If direction d is not negative conduct ratio test 
       % (Means there is a feasible improving direction so not at optimum yet)
       if 1 && ~all(d >= 0) 
           % Ratio test
           lambda = inf;
           li = 0;
           for i = 1:basic
               % get relevant basic var
               place = B(i);
               % get relevant sol component
               xi = x_not(place);
               % get relevant direction component
               di = d(i);
               if di ~= 0
                   lam = -xi / di;
                   if lam < lambda && lam > 0
                      lambda = lam;
                      li = place;
                   end
               end
           end

           % Set Leaving variable 
           leave = x(ismember(x,li));
           
           % Construct proper simplex direction
           dK = zeros(length(x_not),1);
           dind = 1;
           for i = 1:length(dK)
              if i == enter
                  dK(i) = 1;
              elseif belong(B,i)
                  dK(i) = d(dind);
                  dind = dind + 1;
              else 
                  dK(i) = 0;
              end
           end
            
           % Find step size
           step = (lambda * dK);
           
           % Update Solution
           x_not = x_not + step;
           
           % Set column to enter and leave in B and N
           r1 = ismember(B,leave);
           r2 = ismember(N,enter);
           B(r1) = enter;
           N(r2) = leave;
           
           % Sort matrices B and N and run MaximizeGraphical() again to update
           % simplex direction
           B = sort(B);
           N = sort(N);
           
          [r,completePath] = MaximizeGraphical(x_not, B, N, C, A, x, b, path, iter + 1);
       
       else 
          % Otherwise there is no more feasible improving directions and we are at optimum 
          % Return r and completePath
          r = x_not;
          completePath = path;
       end
    end
end

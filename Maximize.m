% Simplex algorithm for maximization. Assumes cannonical form
% @PARAM: x_not -> initial feasible sol
%        B -> Set of basic vars -> corresponds to column numbering
%        N -> Set of non-basic vars -> corresponds to column numbering
%        A -> Constraint Matrix
%        x -> All vars
%        b -> Vector of bounds for constraints
%        iter -> total iterations
% @RETURN: r -> Optimal solution vector
function r = Maximize(x_not, B, N, C, A, x, b,iter)
%     -- help for Maximize() --
%     r = Maxmize(x_not,B,N,C,A,x,b) for the initial feasible solution x_not,
%     set of basic variables B, set of non-basic variables N, constraint 
%     matrix A, vector of variables x, and the vector of bounds for constraints b.
%     Function returns the optimal solution vector r. 
%
%     Assumes canonical form. 
%     This is a supporting function which performs the steps of the simplex algorithm on an initial solution $x_{not}$.

    % first need to set B' and N'
    down = length(A(:,1));
    basic = length(B);
    nonBasic = length(N);
    
    % Set Bp, Cb, Np, Cn to zeros
    Bp = zeros(down, basic);
    Cb = zeros(basic, 1);
    Np = zeros(down, nonBasic);
    Cn = zeros(nonBasic, 1);

    % Form Bp from corresponding columns of A
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
        else
            % Max found
            r = x_not;   
        end
    else
       % Set entering variable
       enter = maxV;

       % Create simplex direction for the entering
       d = Bp \ -A(:,enter);
       
       % Conduct ratio test as long as direction vector is not negative
       % (There is a feasible improving direction to go in)
       if 1 && ~all(d >= 0) 
           % Ratio test
           lambda = inf;
           li = 0;
           for i = 1:basic
               % Get relevant basic var
               place = B(i);
               % Get relevant sol component
               xi = x_not(place);
               % Get relevant direction component
               di = d(i);
               if di ~= 0
                   lam = -xi / di;
                   if lam < lambda && lam > 0
                      lambda = lam;
                      li = place;
                   end
               end
           end
 
           % Find leaving variable
           leave = x(ismember(x,li));
           % disp(leave)
           
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
    
           % Set correct columns in matrix to be leaving or entering
           r1 = ismember(B,leave);
           r2 = ismember(N,enter);
           B(r1) = enter;
           N(r2) = leave;
           
           % Sort B and N and call Maximize() again 
           B = sort(B);
           N = sort(N);
            
           % Call Maximize to see if can still be improved
           r = Maximize(x_not, B, N, C, A, x, b,iter + 1);

       else 
          msg = 'Lp is Unbounded'
          error(msg)
       end
    end
end

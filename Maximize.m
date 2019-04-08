%Simplex algorithm for maximization. Assumes cannonical form
%@PARAM: x_not -> initial feasible sol
%        B -> Set of basic vars -> corresponds to column numbering
%        N -> Set of non-basic vars -> corresponds to column numbering
%        A -> Constraint Matrix
%        x -> All vars
%        b -> Vector of bounds for constraints
%        iter -> total iterations
%@RETURN: r -> Optimal solution vector
function r = Maximize(x_not, B, N, C, A, x, b,iter)
%     -- help for Maximize() --
%     r = Maxmize(x_not,B,N,C,A,x,b) for the initial feasible solution x_not,
%     set of basic variables B, set of non-basic variables N, constraint 
%     matrix A, vector of variables x, and the vector of bounds for constraints b.
%     Function returns the optimal solution vector r. 

    % disp("Current solution")
    % disp(x_not)
    % disp(A)
    % disp(x)
    % disp(b)
    % disp(C)
    
    % first need to set B' and N'
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
    
    % disp("Basic vars")
    % disp(B)
    % disp("Non-Basic vars")
    % disp(N)
    % disp("B prime")
    % disp(Bp)
    % disp("C basic")
    % disp(Cb)
    % disp("N prime")
    % disp(Np)
    % disp("C non-basic")
    % disp(Cn)
    
    % Calculate y -> B'y = -Cb
    y = Bp' \ -Cb;
    % disp("y")
    % disp(y)
    
    % Calculate Reduced Cost
    Cnhat = Cn' + (y' * Np);
    % disp("Cnhat")
    % disp(Cnhat)
    
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
            r = -2;
        else
%             disp("Max found")
%             disp(x_not)
            r = x_not;   
        end
    else 
       enter = maxV;
         % disp("Entering Variable")
         % disp(enter)
       
       % Create simplex direction for the winner
       d = Bp \ -A(:,enter);
         % disp("d")
         % disp(d)
       
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
           % disp("Max lambda")
           % disp(lambda)
           % disp("Leaving Var")
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
           
           % disp("Simplex direction")
           % disp(dK)

           % Update Solution
           step = (lambda * dK);
           x_not = x_not + step;
           
           % disp("Update Solution")
           % disp(x_not)
           
           % Set correct columns in matrix to be leaving or entering
           r1 = ismember(B,leave);
           r2 = ismember(N,enter);
           B(r1) = enter;
           N(r2) = leave;
           
           % Sort B and N and call Maximize() again 
           B = sort(B);
           N = sort(N);
           
           % pause
           
           r = Maximize(x_not, B, N, C, A, x, b,iter + 1);

       % Otherwise there are no more feasible directions to travel
       % We are at optimium -- return r
       else 
          % disp("No more feasible directions to travel") 
          % disp(x_not)
          msg = "Lp is Unbounded"
          error(msg)
       end
    end
end

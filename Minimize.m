%Simplex algorithm for minimzation. Assumes Cannonical Form
%@PARAM: x_not -> init feasible sol
%        B -> Set of basic vars -> corresponds to column numbering
%        N -> Set of non-basic vars -> corresponds to column numbering
%        A -> Constraint Matrix
%        x -> All vars
%        b -> Bounds for constraints
function Minimize(x_not, B, N, C, A, x, b)
    disp("Current solution")
    disp(x_not)
    disp(A)
    disp(x)
    disp(b)
    disp(C)
    
    %first need to set B' and N'
    down = length(A(:,1));
    basic = length(B);
    nonBasic = length(N);
    Bp = zeros(down, basic);
    Cb = zeros(basic, 1);
    Np = zeros(down, nonBasic);
    Cn = zeros(nonBasic, 1);
    
    %Extract columns of A corresponding to B to form Bp
    %A(:,1); <- grab a column
    for i = 1:basic
       ind = B(i);
       col = A(:,ind);
       Bp(:,i) = col;
    end
    
    %Find Cb
    for i = 1:basic
       ind = B(i);
       val = C(ind);
       Cb(i) = val;
    end
    
    %Make Np
    for i = 1:nonBasic
       ind = N(i);
       col = A(:,ind);
       Np(:,i) = col;
    end
    
    %Find CN
    for i = 1:nonBasic
       ind = N(i); 
       val = C(ind);
       Cn(i) = val;
    end
    disp("Basic vars")
    disp(B)
    disp("Non-Basic vars")
    disp(N)
    disp("B prime")
    disp(Bp)
    disp("C basic")
    disp(Cb)
    disp("N prime")
    disp(Np)
    disp("C non-basic")
    disp(Cn)
    
    %Calculate y -> B'y = -Cb
    y = Bp' \ -Cb;
    disp("y")
    disp(y)
    
    %Calculate Reduced Cost
    a = Cn';
    b = (y' * Np);
    Cnhat = a + b;
    disp("Cnhat")
    disp(Cnhat)
    
    %Find the most improving feasible direction
    ei = 0;
    minV = inf;
    for i = 1:length(Cnhat)
        if Cnhat(i) < minV
            ei = i;
            minV = N(i);
        end
    end
    if ei == 0
       disp("Min found")
       disp(x_not)
    else 
       enter = minV;
       disp("Entering Variable")
       disp(enter)
       %disp(maxV)
       
       %Create simplex direction for the winner
       %d = Bp \ -A(:,2);
       d = Bp \ -A(:,enter);
       disp("d")
       disp(d)
       
       if 1 && ~all(d >= 0) 
           %Ratio test
           lambda = 0;
           li = 0;
           for i = 1:basic
               %get relevant basic var
               place = B(i);
               %get relevant sol component
               xi = x_not(place);
               %get relevant direction component
               di = d(i);
               if di ~= 0
                   lam = -xi / di;
                   if lam < lambda && lam < 0 
                      lambda = lam;
                      li = place;
                   end
               end
           end
           disp("Max lambda")
           disp(lambda)
           disp("Leaving Var")
           leave = x(ismember(x,li));
           disp(leave)
           
           %Construct proper simplex direction
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
           disp("Simplex direction")
           disp(dK)
           %Update Solution
           step = (lambda * dK);
           x_not = x_not + step;
           disp("Update Solution")
           disp(x_not)
           
%            disp(B)
%            disp(N)
%            disp(leave)
%            disp(enter) 
           r1 = ismember(B,leave);
           r2 = ismember(N,enter);
           B(r1) = enter;
           N(r2) = leave;
           B = sort(B);
           N = sort(N);
           prompt = "Run again? (y/n)";
           z = input(prompt,'s');
           y = "y";
           disp(z)
           if strcmp(z,y)
               Minimize(x_not, B, N, C, A, x, b);
           else 
               ;
           end
       else 
          disp("No more feasible directions to travel") 
          disp(x_not)
       end
    end
end
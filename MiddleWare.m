% Error handling and some behind the scenes work
% @AUTHOR: Jared Polonitza and Sarah McClain
% @PARAM: A -> Constraint Matrix
%         x -> Vector of all variables
%         b -> Vector of constraint bounds
%         C -> Objective function
%         m -> Min/Max (0,1)
%         g -> Generate Graph (0,1) -- 2 dim only
% @RETURN None
function MiddleWare(A,x,b,C,m,g)
%       -- help function MiddleWare --
%       MiddleWare(A,x,b,C,m,g) where A is the constraint matrix, x is the vector of all variables,
%       b is the vector of constraint bounds, C is the objective function, m is whether the program is 
%       to be minimized (0) or maximized (1), and g is whether the program will be graphed (1) or not 
%       graphed (0). This is a suppport function and has no return.
%
%       This is a supporting function that handles errors with the input from the user and connects the
%       different versions of the simplex algorithm code (minimization vs maximization, graphing vs no graphing) 
%       in one function to be called in the main simplex function. By making a separate MiddleWare function you
%       can manipulate the parameters in Maximize in order to minimize a linear program without making a separate Minimize function.
    
    % Make sure we have a valid matrix
    isValid(A,x,b,C);
    % Find basic and non basic variables
   [o,p] = size(A);
    v = p - o;
    
    % Find a initial feasible solution
    x_not = findMe(A,b,x,v);
    
    % If origin can be an initial feasible solution
    if x_not == -1
        x_not = zeros(length(x),1);
        bInd = 1;
        for i = v + 1:length(x_not)
           x_not(i) = b(bInd);
           bInd = bInd + 1;
        end
    elseif x_not == -2
        msg = "LP was Infeasible";
        error(msg)
    end
    
    % Set the B and N matrices
    B = find(x_not)';
    N = find(~x_not)';
    
    % Minimization so negate C,A,b
    if m == 0 
        if g == 0
            % no graphing since g=0
            % r is solution found by simplex
            r = Maximize(x_not, B, N, -C, -A, x, -b, 0);
            if r ~= -2
                % Find max as long as LP is feasible
                max = C * r;
                disp("Global optimum of: " + max);
                disp("Achieved at: ");
                disp(r');
            else 
                msg = "LP was Infeasible";
                error(msg)
            end
        elseif g == 1
            % graphing since g=1
            road = [];
           [r,path] = MaximizeGraphical(x_not, B, N, -C, -A, x, -b, road, 0);
            if r ~= -2
                % Find max as long as LP is feasible 
                max = C * r;
                disp("Global optimum of: " + max);
                disp("Achieved at: ");
                disp(r');
                graphIt(A,b,x,v,path);  
            else 
                msg = "LP was Infeasible";
                error(msg)
            end
        else 
            error("Uncrecognized command")
        end
        
    % Maximization
    elseif m == 1
        if g == 0
            % no graphing since g=0
            % r is solution found from simplex algorithm
            r = Maximize(x_not, B, N, C, A, x, b, 0);
            if r ~= -2
                % Find max as long as LP is feasible
                max = C * r;
                disp("Global optimum of: " + max);
                disp("Achieved at: ");
                disp(r');
            else 
                msg = "LP was Infeasible";
                error(msg)
            end
        elseif g == 1
            % Graphing since g=1
            % r is solution found from simplex and path is matrix of (x,y) coordinates the algorithm took
            [r,path] = MaximizeGraphical(x_not, B, N, C, A, x, b, [], 0);
            if r ~= -2
                % Find max as long as LP is feasible
                max = C * r;
                disp("Global optimum of: " + max);
                disp("Achieved at: ");
                disp(r');
                
                % plot direction taken by algorithm
                graphIt(A,b,x,v,path);  
            else 
                msg = "LP was Infeasible";
                error(msg)
            end
        else 
            % Anything else besides 0 or 1 put in for g
            error('Uncrecognized command')
        end 
    else 
       % Anything besides 0 or 1 put in for m
       error('Unrecognized command') 
    end
end

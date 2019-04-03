%Error handling and some behind the scenes work
%@AUTHOR: Jared Polonitza
%@PARAM: A -> Constraint Matrix
%        x -> All vars
%        b -> Bounds for constraints
%        C -> Objective function
%        m -> Min/Max (0,1)
%        g -> Generate Graph (2 dim only)
% TODO - Find initial feasible solution
%      - Find basic and non-basic vars
function MiddleWare(A,x,b,C,m,g)
    %Do error checking here
    
    %Find basic and non basic vars
   [o,p] = size(A);
    v = p - o;
    x_not = findMe(A,b,x,v);
    %disp(x_not)
    if x_not == -1
        %Find inital solution -> assumes origin feasible
        x_not = zeros(length(x),1);
        %disp(length(x_not));
        bInd = 1;
        for i = v + 1:length(x_not)
           x_not(i) = b(bInd);
           bInd = bInd + 1;
        end
    end
    B = find(x_not)';
    N = find(~x_not)';
       

    %disp(x_not)
    
    if m == 0
        if g == 0
            %"minimization"
            r = Maximize(x_not, B, N, -C, -A, x, -b);
            max = C * r;
            disp("Global optimum of: " + max);
            disp("Achieved at: ");
            disp(r');
        elseif g == 1
            %get path
            road = [];
            [r,path] = MaximizeGraphical(x_not, B, N, -C, -A, x, -b, road);
            max = C * r;
            disp("Global optimum of: " + max);
            disp("Achieved at: ");
            disp(r');
            %plot
            graphIt(A,b,x,v,path);
        else 
            disp("Uncrecognized command")
        end
    elseif m == 1
        if g == 0
            r = Maximize(x_not, B, N, C, A, x, b);
            max = C * r;
            disp("Global optimum of: " + max);
            disp("Achieved at: ");
            disp(r');
        elseif g == 1
            %get path
            [r,path] = MaximizeGraphical(x_not, B, N, C, A, x, b, []);
            max = C * r;
            disp("Global optimum of: " + max);
            disp("Achieved at: ");
            disp(r');
            %plot
            graphIt(A,b,x,v,path);
        else 
            disp("Uncrecognized command")
        end 
    else 
       disp("Unrecognized command") 
    end
end
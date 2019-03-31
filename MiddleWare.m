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
    if x_not == -1
        %Find inital solution -> assumes origin feasible
        x_not = zeros(length(x),1);
        for i = 1:length(B)
            x_not(B(i)) = b(i);
        end
    end
    B = find(x_not);
    N = find(~x_not);
       

    disp(x_not)
    
    if m == 0
        if g == 0
            %"minimization"
            Maximize(x_not, B, N, -C, -A, x, -b)
        elseif g == 1
            %generate extreme points
            
            %get path
            
            %plot
            
            
            ;
        else 
            disp("Uncrecognized command")
        end
    elseif m == 1
        if g == 0
            Maximize(x_not, B, N, C, A, x, b)
        elseif g == 1
            ;
        else 
            disp("Uncrecognized command")
        end 
    else 
       disp("Unrecognized command") 
    end
end
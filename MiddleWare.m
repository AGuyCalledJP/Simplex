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
    B = find(~C);
    N = find(C);
    
    %What if we always just find our own inital basic feasible soluiton
    %always
    water = initSol(A,b,x,B,N,C);
    x_not = [];
    if water == -1    
        %Find inital solution -> assumes origin feasible
        x_not = zeros(length(x),1);
        for i = 1:length(B)
            x_not(B(i)) = b(i);
        end 
    else 
        x_not = water;
    end
    
    disp(x_not)
    
    if m == 0
        if g == 0
            Minimize(x_not, B, N, C, A, x, b)
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
% This function finds the index of dissimilarity for the given world, with
% a slightly modified algorithm.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function val = findids(n,agents,numred)

allpos = zeros([(n*n) 2]);							% Generates all positions of the world
temp = 1;
for i = 1:n
    for k = 1:n	
        allpos(temp, :) = [i k] - 0.5;
        temp = temp + 1;
    end
end

xall = agents(:,1);
yall = agents(:,2);
data = [0 0 0];
sum = 0;

for i = 1:length(allpos)							% Loops through all positions of the world
    xpos = allpos(i,1);
    ypos = allpos(i,2);
    for j = ypos-1:ypos+1							% Searches all positions around the current position
        for k = xpos-1:xpos+1
            bool = boundcheck(k,j,n);						% Checks if position is on the board
            if bool == true
                data(3) = data(3)+1;						% Increments total spaces around current agent
                check = find(xall == k & yall == j,1);				% Checks if the space is populated by another agent
                if isempty(check) == false
                    if strcmp(getcolor(check,numred),'red') == true		% Increments correct color of neighbor if it exists
                        data(1) = data(1)+1;
                    else
                        data(2) = data(2)+1;
                    end
                end
            end
        end
    end
    sum = sum + abs((data(2)/data(3))-(data(1)/data(3)));			% Sums all the data up with modified index algorithm
    data = [0 0 0];								% Resets storage for next iteration
end

val = sum/(n*n);								% Divides by total number of spaces

end

% Local function to analyze whether the position to be checked is within the
% bounds of the board. Returns true if within.
% NOTE: Only difference from analyzebounds in issatisfied is that this one 
% counts the agent itself.

function boolean = boundcheck(x,y,bound)

if x < 0 || y < 0 || x > bound || y > bound					% If either x or y falls negative or goes beyond upper borders, not a valid position -> false
    boolean = false;
else									% ...else, valid position -> true
    boolean = true;
end

end

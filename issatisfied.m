% This function checks whether the specific agent indicated by xpos and ypos
% is satisfied according to the ratios passed in. Returns a boolean (bool)
% containing the status of the agent's satisfaction.

% Note: Algorithm overhaul for v3 to hopefully improve efficiency and allow
% for future flexibility. Refer to v2 for deprecated algorithm.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [bool,vals] = issatisfied(color,numred,xpos,ypos,agents,bound,redratio,blueratio)

xall = agents(:,1);								% Gets the x positions of all the agents
yall = agents(:,2);								% Gets the y positions of all the agents
redblue = [0 0];								% Row vector to keep track of the number of red and blue neighbors in the form [red blue]

for i = ypos-1:ypos+1								% Outer loop to check y positions below and above the current agent
    for k = xpos-1:xpos+1							% Inner loop to check x positions left and right of the agent
        if analyzebounds(k,i,xpos,ypos,bound) == true				% Checks if position to be checked is valid (i.e. within borders)
            check = find(xall == k & yall == i,1);				% If valid, find agent that resides at that spot
            if isempty(check) == false						% If agent is found to be there...
                if strcmp(getcolor(check,numred),'red') == true			% ...and if color is red...
                    redblue = [redblue(1)+1 redblue(2)];			% Increment red count
                else								% ...else (color is blue)
                    redblue = [redblue(1) redblue(2)+1];			% Increment blue count
                end
            end
        end
    end
end

redown = redratio(1);								% Percentage of own that red wants
redother = redratio(2);								% Percentage of other that red wants
blueown = blueratio(1);								% Percentage or own that blue wants
blueother = blueratio(2);							% Percentage of other that blue wants
total = redblue(1) + redblue(2);						% Total count of red and blue neighbors

if total == 0									% If no neighbors, agent is satisfied
    bool = true;
elseif strcmp(color,'red') == true						% If color is red...
    if redblue(1)/total >= redown && redblue(2)/total >= redother		% ...and if ratio of own and other meets wants, agent is satisfied
        bool = true;
    else									% ...else, not satisfied
        bool = false;
    end
else										% ...or color is blue
    if redblue(2)/total >= blueown && redblue(1)/total >= blueother		% ...and if ratio of own and other meets wants, agent is satisfied
        bool = true;					
    else									% ...else, not satisfied
        bool = false;
    end
end

vals = [redblue(1) redblue(2) total];						% Returns parameters needed for proportion of "others"

end

% Local function to analyze whether the position to be checked is within the
% bounds of the board. Returns true if within.

function boolean = analyzebounds(x,y,ix,iy,bound)

if x == ix && y == iy								% Make sure agent's own position is not to be checked
    boolean = false;
else
    if x < 0 || y < 0 || x > bound || y > bound					% If either x or y falls negative or goes beyond upper borders, not a valid position -> false
        boolean = false;
    else									% ...else, valid position -> true
        boolean = true;
    end
end

end

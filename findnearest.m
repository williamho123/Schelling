% This function finds the nearest empty position where the agent at the 
% specifed index will be satisfied. It returns a 1x2 matrix of form [x y]
% representing the new position. If no positions satisfy, it remains in 
% its original position.  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pos = findnearest(color,numred,index,agents,bound,redratio,blueratio)

xpos = agents(index,1);								% xpos of agent wanting to move
ypos = agents(index,2);								% ypos of agent wanting to move

allpos = zeros([(bound*bound) 2]);						% Initializes matrix of zeros corresponding to number of possible positions on board
temp = 1;
for i = 1:bound									% Same as code in Schelling_Simulation: generates all possible positions on board
    for k = 1:bound
        allpos(temp, :) = [i k] - 0.5;
        temp = temp + 1;
    end
end

allempty = setdiff(allpos, agents, 'rows');					% Finds positions not occupied (i.e. positions that are empty)

alldist = zeros([1 length(allempty)]);						% Initializes row vector of zeros for storing distance data between agent and empty spaces
for i = 1:length(allempty)							% Computes the distance between the agent and each empty space; adds to row vector with 
    alldist(i) = pdist([xpos ypos; allempty(i,:)]);				% same index as allempty
end

isvalid = false;								% Boolean condition controlling status of while loop
while isvalid == false								% While not satisfied, continue; else, break
    if isempty(alldist) == true							% If none of the positions work, break out of loop
        break;
    else
        [~, ind] = min(alldist);						% Finds the minimum distance in alldist from agent to empty space.
        [bool, ~] = issatisfied(color,numred,allempty(ind,1),allempty(ind,2),agents,bound,redratio,blueratio);	% Checks to see if agent is satisfied at that empty space with min distance
        if bool == false							% If not satisfied, remove that distance from alldist and remove that position from allempty
            alldist(ind) = [];
            allempty(ind,:) = [];
        else									% If satisfied, set isvalid to true to break out of loop
            isvalid = true;
        end
    end
    
end

if isvalid == false								% If loop has been terminated but isvalid == false, means break keyword invoked
    pos = [xpos ypos];								% Means no empty position will satisfy so stay where agent currently is
else
    pos = allempty(ind,:);							% Returns position in allempty with minimum distance and where the agent will be satisfied
end

end


% This script runs the simulation. 
% Base function call: Schelling_Simulation(10,0.5,0,0.5,0,36,36,10)
% Visuals can be commented out when running through command line.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function result = Schelling_Simulation(pn,prrown,prrother,pbrown,pbrother,pred,pblue,prounds)

% Global Constants %
n = pn;                 							% nxn grid for the world of the agents
redratio = [prrown prrother];                                          		% Percentage wanted of own color and other color for red
blueratio = [pbrown pbrother];							% Percentage wanted of own color and other color for blue
numred = pred;		            						% Number red agents
numblue = pblue;								% Number blue agents
rounds = prounds;								% Specified rounds to play
offset = 0.5;                                                   		% Offset from gridlines so centered circles in the drawing

%{
% Initialize figures and their respective handles %
initialfig = figure(1);
finalfig = figure(2);

% Draws nxn grid on the initial figure %
figure(initialfig);								% Sets to initialfig
plot(0,0)
xlim([0,n])									% x direction from [0,n]
ylim([0,n])									% y direction from [0,n]
set(gca,'xtick',1:n)								% Sets tick marks for x,y at intervals of 1 unit up to n
set(gca,'ytick',1:n)
grid
axis square
%}

% Generates the initial random agents and their positions %
allpos = zeros([(n*n) 2]);							% Matrix of zeros with the number of rows representing possible positions
temp = 1;									% Temporary variable to input x positions for every y position
for i = 1:n
    for k = 1:n									% Nested loops to generate all possible positions within the nxn grid
        allpos(temp, :) = [i k];						% Assigns possible position into allpos
        temp = temp + 1;							% Increments temp to account for next x position
    end
end

allpos = allpos(randperm(n*n),:);						% Shuffles the rows of the matrix to randomize the positions

redagentsxy = zeros([numred 2]);						% Initializes zero matrix with number of red agents corresponding to rows
for i = 1:numred								% Loops through numred times to choose positions for all red agents.
    temp = randi([1 length(allpos)]);						% Chooses a random integer within bounds of 1 and number of rows of allpos
    redagentsxy(i,:) = allpos(temp,:) - offset;					% Inserts the position1 from the random integer chosen to next row of redagentsxy
    allpos(temp,:) = [];							% Removes inserted position from allpos to prevent repeats
end

blueagentsxy = zeros([numblue 2]);					% Same thing as redagentsxy, except for blue agents
for i = 1:numblue
    temp = randi([1 length(allpos)]);
    blueagentsxy(i,:) = allpos(temp,:) - offset;
    allpos(temp,:) = [];
end

allagentsxy = cat(1,redagentsxy,blueagentsxy);					% Creates master matrix of all agents; first half rows is red, latter half is blue
										% 1st column is x positions, 2nd column is y positions
%{
% Renders agents onto their positions on the initial figure %
viscircles(allagentsxy(1:numred,:), zeros([1 numred]) + 0.5, 'EdgeColor','r')	% Renders red agents onto the grid
viscircles(allagentsxy(numred+1:end,:), zeros([1 numblue]) + 0.5,'EdgeColor','b')  % Renders blue agents onto the grid
%}

% Randomly checks each agent to see if they are satisfied; if not, move to
% nearest position where they become satisfied. Record satisfaction data.
redcount = 0;									% Count to record number of red satisfied in each round
bluecount = 0;									% Count to record number of blue satisfied in each round
redsat = zeros([1 rounds]);							% Percentage of red agents satisfied per round in each index
bluesat = zeros([1 rounds]);							% Percentage of blue agents satisfied per round in each index
totalsat = zeros([1 rounds]);							% Percentage of total agents satisfied per round in each index
redothercount = zeros([1 2]);							% Count to keep track of other agents for red
blueothercount = zeros([1 2]);							% Count to keep track of other agents for blue
redother = zeros([1 rounds]);							% Average percentage of other neighbors for red
blueother = zeros([1 rounds]);							% Average percentage of other neighbors for blue
totalother = zeros([1 rounds]);							% Average percentage of other neighbors total
disarray = zeros([1 rounds]);
for i = 1:rounds								% Loop through number of times corresponding to rounds
    temp = randperm(numblue+numred);						% Temporary matrix containing random permutation of numbers from 1 to numred+numblue inclusive
    for k = 1:length(temp)							% Loops through each value in temporary permuted matrix, choosing index at that position
        color = getcolor(temp(k),numred);					% Gets the color of the current agent being evaluated
        [bool,redblue] = issatisfied(color,numred,allagentsxy(temp(k),1),allagentsxy(temp(k),2),allagentsxy,n,redratio,blueratio);  % Chooses value at k and checks if agent there is satisified
        if bool == false
            allagentsxy(temp(k),:) = findnearest(color,numred,temp(k),allagentsxy,n,redratio,blueratio);	% If agent is not satisfied, find nearest position where he is satisfied
        else									% Otherwise, increment satisfaction counts
            if strcmp(color,'red')
                redcount = redcount+1;						% Increment red satisfaction count
            else
                bluecount = bluecount+1;					% Increment blue satisfaction count
            end
        end
        if strcmp(color,'red')
            redothercount = [redothercount(1)+redblue(2) redothercount(2)+redblue(3)];
        else
            blueothercount = [blueothercount(1)+redblue(1) blueothercount(2)+redblue(3)];
        end
    end
    redsat(i) = redcount/numred;						% Computes percentage red satisfied for ith round
    bluesat(i) = bluecount/numblue;						% Computes percentage blue satisfied for ith round
    totalsat(i) = (redcount+bluecount)/(numred+numblue);			% Computes percentage total satisfied for ith round
    redother(i) = redothercount(1)/redothercount(2);				% Computes average percentage of other neighbors for reds
    blueother(i) = blueothercount(1)/blueothercount(2);				% Computes average percentage of other neighbors for blues
    totalother(i) = (redothercount(1)+blueothercount(1))/(redothercount(2)+blueothercount(2));	% Computes average percentage of other neighbors total
    disarray(i) = findids(n,allagentsxy,numred);
    redcount = 0;								% Resets counts for next round
    bluecount = 0;
    redothercount = [0 0];
    blueothercount = [0 0];
end

% Combines data vectors into a single matrix and writes them to a
% .csv file % (EDIT: I/O has been moved to sim_multiple)
% r1:totalsat r2:redsat r3:bluesat r4:redothers
% r5:blueothers r6:totalothers r7:dissimilarity index
data = cat(1,totalsat,redsat,bluesat,redother,blueother,totalother,disarray);
%path = strcat('~/Projects/Schellingv4/',foldname,'/');
%name = strcat(path,'run',num2str(runnum),'.csv');			
%csvwrite(name,data);

result = data;

%{
% Draws nxn grid on the final figure %
figure(finalfig);								% Same initializations as initialfig above
plot(0,0)
xlim([0,n])
ylim([0,n])
set(gca,'xtick',1:n)
set(gca,'ytick',1:n)
grid
axis square

% Renders agents onto their positions in the final figure %
viscircles(allagentsxy(1:numred,:), zeros([1 numred]) + 0.5, 'EdgeColor','r')	% Draws the red agents onto finalfig
viscircles(allagentsxy(numred+1:end,:), zeros([1 numblue]) + 0.5,'EdgeColor','b')	% Draws the blue agents onto final fig
%}

end

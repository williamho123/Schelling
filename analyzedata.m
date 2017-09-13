% This function takes in the data from all the simulations and finds
% the 5th, 50th, and 95th percentile of each statistical category
% per round.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [d5th,d50th,d95th] = analyzedata(data,rounds,runs)

files = data;

dsize = size(files{1});
dmatrix = zeros([runs 1]);						% Temporary matrix to store data that will be analyzed
data5th = zeros([dsize(1) rounds]);					% Respective storage containers for the statistical categories
data50th = zeros([dsize(1) rounds]);
data95th = zeros([dsize(1) rounds]);

for i = 1:dsize(1)							% Outermost loop that goes through each statistical category
    for j = 1:rounds							% Middle loop that goes through the rounds of each simulation
        for k = 1:runs							% Innermost loop that goes the number of runs for the simulation
            dmatrix(k) = files{k}(i,j);					% Assigns data into the temporary matrix
        end
        pctmat = prctile(dmatrix,[5,50,95],1);				% Computes the percentiles and stores them into repsective matrices
        data5th(i,j) = pctmat(1);
        data50th(i,j) = pctmat(2);
        data95th(i,j) = pctmat(3);
    end
end

d5th = data5th;
d50th = data50th;
d95th =  data95th;

end

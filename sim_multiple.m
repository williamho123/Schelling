% Upper-level script. Allows for multiple runs of the simulation with the same
% set of parameters. Conducts I/O. Makes directories to accomodate different
% data outputs and writes data files for each run. Gathers percentiles 
% and writes results out.  

% @author: William Ho
% @version: 4.3
% @revised: July 27, 2016

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sim_multiple(p1,p2,p3,p4,p5,p6,p7,p8,runs)

NUM_STATS = 7;

p1s = num2str(p1);								% Converts all inputs into strings
p2s = num2str(p2);
p3s = num2str(p3);
p4s = num2str(p4);
p5s = num2str(p5);
p6s = num2str(p6);
p7s = num2str(p7);
p8s = num2str(p8);

pbsind = getenv('PBS_ARRAY_INDEX');						% PBS Batch Environment index
foldname = strcat(pbsind,'_',p1s,'_',p2s,'_',p3s,'_',p4s,'_',p5s,'_',p6s,'_',p7s,'_',p8s);  % Folder name to write outputs to
genpath = strcat('~/Projects/Schellingv4/',foldname,'/');			% General path to write file to
mkdir(foldname);

alldata = cell(1,runs);								% Stores the statistics of every run for every index in the cell array

for i = 1:runs									% Runs the simulation the amount of times specified by runs
    alldata{i} = Schelling_Simulation(p1,p2,p3,p4,p5,p6,p7,p8);    
end

%{
for i = 1:runs									% Writes statistics to disk with unique file name
    filename = strcat('run',num2str(i),'.csv');
    fullpath = strcat(genpath,filename);
    csvwrite(fullpath,alldata{i});
end
%}

[d5th,d50th,d95th] = analyzedata(alldata,p8,runs);				% Computes percentiles for the amount of runs in alldata
pctname1 = strcat(genpath,'summary_5th','.csv');
pctname2 = strcat(genpath,'summary_50th','.csv');
pctname3 = strcat(genpath,'summary_95th','.csv');

csvwrite(pctname1,d5th);							% Writes out the percentile data to the disc
csvwrite(pctname2,d50th);
csvwrite(pctname3,d95th);

% DATA WRITTEN HERE CONSOLIDATES BASED ON PERCENTILE FOR GIVEN PARAMS
writenames = cell(NUM_STATS,1);						% Names to write files with
writenames{1} = 'Total_Satisfied_PCONS.csv';
writenames{2} = 'Red_Satisfied_PCONS.csv';
writenames{3} = 'Blue_Satisfied_PCONS.csv';
writenames{4} = 'Total_Other_PCONS.csv';
writenames{5} = 'Red_Other_PCONS.csv';
writenames{6} = 'Blue_Other_PCONS.csv';
writenames{7} = 'Index_of_Dissimilarity_PCONS.csv';

pconsolid = percentileconsolidate(d5th,d50th,d95th);

for i = 1:length(pconsolid)
    csvwrite(strcat(genpath,writenames{i}),pconsolid{i});
end

end

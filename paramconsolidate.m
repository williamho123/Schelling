% This function consolidates the percentile data from the simulations
% with different parameters and writes them out to the disk. Allows 
% data comparison between runs with different parameters. Each .csv
% file written has this format: columns correspond to each round 
% while rows represent the parameters specified by paramfile (correspond
% to varying preferences).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function paramconsolidate(paramfile)

NUM_STATS = 7;								% Global variable to standardize number of statistics being computed

genpath = '~/Projects/Schellingv4/';					% Paths to retrieve the params file
filepath = strcat(genpath,paramfile);
params = importdata(filepath);						% Reads the params file into matrix
paramsize = size(params);

d5t = cell(1,paramsize(1));						% Storage containers for the respective percentiles read in
d50t = cell(1,paramsize(1));
d95t = cell(1,paramsize(1));

names = cell(paramsize(1),1);						% Generates file names in order to read the data in from those files

for i = 1:paramsize(1)							% Loop to do the above
    temp = params(i,:);
    name = num2str(i);
    for k = 1:length(temp)-1
        name = strcat(name,'_',num2str(temp(k)));
    end
    names{i} = name;
end

for i = 1:length(names)							% Reads the percentile data in for the different parameters
    d5t{i} = csvread(strcat(genpath,names{i},'/summary_5th.csv'));
    d50t{i} = csvread(strcat(genpath,names{i},'/summary_50th.csv'));
    d95t{i} = csvread(strcat(genpath,names{i},'/summary_95th.csv'));
end

storage5 = zeros([length(names) params(1,8)]);				% Initializations for storing the consolidated data for different params
storage50 = zeros([length(names) params(1,8)]);
storage95 = zeros([length(names) params(1,8)]);

d5tc = cell(1,NUM_STATS);						% Initalizations for storing data by statistical category
d50tc = cell(1,NUM_STATS);
d95tc = cell(1,NUM_STATS);

for i = 1:length(d5tc)							% Loops through data sets to gather statistics for different parameters
    for k = 1:length(d5t)						% and places them into matrix
        storage5(k,:) = d5t{k}(i,:);
        storage50(k,:) = d50t{k}(i,:);
        storage95(k,:) = d95t{k}(i,:);
    end
    d5tc{i} = storage5;							% Then adds them to the cell array for individual statistical category
    d50tc{i} = storage50;
    d95tc{i} = storage95;
end

writenames = cell(NUM_STATS,1);						% Names to write files with
writenames{1} = 'Total_Satisfied.csv';					% Reference for order of consolidated stats in d5tc,d50tc,d95tc
writenames{2} = 'Red_Satisfied.csv';
writenames{3} = 'Blue_Satisfied.csv';
writenames{4} = 'Total_Other.csv';
writenames{5} = 'Red_Other.csv';
writenames{6} = 'Blue_Other.csv';
writenames{7} = 'Index_of_Dissimilarity.csv';

conspath = strcat(genpath,'Consolidated/');				% Writes the consolidated data for each set of parameters into respective folders
d5tcpath = strcat(conspath,'5thPercentile/');
d50tcpath = strcat(conspath,'50thPercentile/');
d95tcpath = strcat(conspath,'95thPercentile/');
mkdir(conspath);
mkdir(d5tcpath);
mkdir(d50tcpath);
mkdir(d95tcpath);

for i = 1:length(writenames)
    csvwrite(strcat(d5tcpath,writenames{i}),d5tc{i});
    csvwrite(strcat(d50tcpath,writenames{i}),d50tc{i});
    csvwrite(strcat(d95tcpath,writenames{i}),d95tc{i});
end

end

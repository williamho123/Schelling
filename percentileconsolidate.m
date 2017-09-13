% This function consolidates data for the parameters into the separate
% statistical categories based on percentiles to allow for analyzation of
% confidence intervals. Output cell array follows basic order of data
% presented in summary files.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = percentileconsolidate(d5th,d50th,d95th)

dsize = size(d5th);
tempstorage = zeros([3 dsize(2)]);
data = cell(1,dsize(1));

for i = 1:dsize(1)                                                              % Systematically go through each percentile data to retrieve correct data
    tempstorage(1,:) = d5th(i,:);
    tempstorage(2,:) = d50th(i,:);
    tempstorage(3,:) = d95th(i,:);
    data{i} = tempstorage;                                                      % Store in output cell array
end

result = data;

end
% This function returns the color of the agent of the current index 
% passed in. Outputs a string.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function color = getcolor(ind,numred)

if ind > numred									% If index is greater than number of reds, must be a blue
    color = 'blue';
else										% Otherwise, it's a red
    color = 'red';
end

end

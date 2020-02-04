function showCards(Cards)
for i = 1:length(Cards)
    fprintf('%s', Cards{i}.sign);
    switch(Cards{i}.col)
        case 1
            fprintf('\th');
        case 2
            fprintf('\ts');
        case 3
            fprintf('\td');
        case 4
            fprintf('\tc');
        otherwise
            fprintf('\tundefined');
    end
    fprintf('\n');
end
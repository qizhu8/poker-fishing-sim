function Cards = formCards(mode, number)
if mode == 0    % random form cards
    if nargin == 1
        error('you should input the number of cards you want to form');
        return;
    end
    if number < 0
        error('invalid number of cards');
        return
    end
end
if mode < 0
    error('invalid mode');
end

%%--variables declaration--%%
switch mode
    case 0
        Cards = cell(number, 1);
    otherwise
        Cards = cell(54*mode, 1);
end

%%--form cards--%%
switch mode
    case 0
        for i = 1:number
            sign = randi([1,14]);
            Cards{i}.sign = pokerSignTransfer(sign);
            if sign ~= 14
                Cards{i}.col = randi([1,4]);
            else
                Cards{i}.col = randi([1,2]);
            end
        end
    otherwise
        index = 1;
        for m = 0 : mode-1
            for n = 1:4
                for k = 1:13
                    Cards{index}.sign = pokerSignTransfer(k);
                    Cards{index}.col = n;
                    index = index + 1;
                end
            end
            Cards{index}.sign = pokerSignTransfer(14); % big joker
            Cards{index}.col = 1;
            index = index + 1;
            
            Cards{index}.sign = pokerSignTransfer(14); % small joker
            Cards{index}.col = 2;
            index = index + 1;
        end
end
        
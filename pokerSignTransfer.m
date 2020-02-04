function result = pokerSignTransfer(indexOrSign);
% indexOrSign = 9;
if (strmatch(class(indexOrSign), 'char'))
    switch indexOrSign
        case 'A'
            result = 1;
        case '10'
            result = 10;
        case 'J'
            result = 11;
        case 'Q'
            result = 12;
        case 'K'
            result = 13;
        case 'Joker'
            result = 14;
        otherwise
            result = indexOrSign - '0';
    end
else
    switch indexOrSign
        case 1
            result = 'A';
        case 10
            result = '10';
        case 11
            result = 'J';
        case 12
            result = 'Q';
        case 13
            result = 'K';
        case 14
            result = 'Joker';
        otherwise
            result = char('0' + indexOrSign);
    end
end
    
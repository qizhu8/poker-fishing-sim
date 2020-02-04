%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is used to simulate the way people ruffle pokers
% inputs:
%     oCards: (original cards) the cards need to be ruffled
%             two attributions. 
%                  sign(char) is for sign (A 2 3 ... J Q K Joker)
%                  col is for the color of cards (1-heart 2-spade 3-diamond 4-club)
%     mode  : the mode to ruffle cards
%     times : exceeding this ruffling for how many times
% outputs:
%     nCards: (new cards) the cards after ruffling
%     index : the changing index of original cards
% 
% instruction of modes:
% -1:no operation
% 0: random place
%     place cards randomly.
% 1: cross insert
%     in the reality, the operator will split cards to two piles. Then they will 
%     form a new pile by randomly insert one to another
% 2: stratch and place one the top
%     man will get some pieces of cards from the middle of one pile, and 
%     then place them on the top
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The function was written by Anguswang on 2/25/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [nCards, index] = ruffleCards(oCards, mode, times)
%%--test data--%%
% clc,clear,close
% oCards = cell(10, 1);
% for i = 1:10
%     oCards{i}.sign = pokerSignTransfer(randi([1,13]));
%     oCards{i}.col = randi([1,4]);
% end
% mode = -1;
% times = 2;


% showCards(oCards);
if (length(oCards)==0)
%     error('no cards to be processed!');
    nCards = [];
    index = [];
    return;
end
if (mode >2 || mode < -1)
    error('invalid mode!');
    return;
end
if (times < 0)
    error('invalid times!');
    return;
end

if mode == -1
    nCards = oCards;
    index = 1:length(oCards);
end

index = 1:length(oCards);
for m = 1:times
switch mode
    case -1
        index_t = 1:length(oCards);
    case 0 % random place
        index_t = randperm(length(oCards));
    case 1 % cross insert
        index_t = 1:length(oCards);
        part1 = index_t(1:floor(length(index_t)/2));
        part2 = index_t(floor(length(index_t)/2)+1:end);
        p1_i = 1;
        p2_i = 1;
        for i = 1:length(oCards)
            if(rand < 0.5) % get one card from part1
                if(p1_i <= length(part1)) % get card from part1
                    index_t(i) = part1(p1_i);
                    p1_i = p1_i + 1;
                else % there is no enough cards in part1, then get one from part2
                    index_t(i) = part2(p2_i);
                    p2_i = p2_i + 1;
                end
            else % get one card from part2
                if(p2_i <= length(part2)) % get cards from part2
                    index_t(i) = part2(p2_i);
                    p2_i = p2_i + 1;
                else % no enough cards from part2, then get one from part1
                    index_t(i) = part1(p1_i);
                    p1_i = p1_i + 1;
                end                
            end
        end
    case 2 % stratch and place one the top
        index_t = 1:length(oCards);
        starti = randi([1,length(oCards)]);
        endi = randi([1,length(oCards)]);
        if starti > endi
            t = starti;
            starti = endi;
            endi = t;
        end
        ti = [starti:endi];
        index_t(ti) = [];
        index_t = [index_t, ti];
    otherwise
        error('undesigned mode!!!');
end

index = index(index_t);
end
%%--process cards by index--%%
nCards = cell(length(oCards), 1);
for i = 1:length(oCards)
    nCards{i} = oCards{index(i)};
end

% disp('%%%%%%%%%%%%%%%%');
% showCards(nCards);
% cardsOnTheTable = [
%     9,10,13,13,7,14,11,11,3,5,8,13,1,12,5,12,8,6,9,6,2,6,14,10,2,11,10
%     1,2,2,1,2,1,4,2,3,4,2,3,1,1,3,4,1,1,4,2,3,3,2,1,4,3,4
%  ];
% loc = [2, 24];
function [cardsOnTheTable_n, cards] = getWonCards(cardsOnTheTable, loc)
cardsToBeGot = cardsOnTheTable(:,loc(1):end);
cards = cell(length(cardsToBeGot), 1);
for i = 1:length(cardsToBeGot)
    cards{i}.sign = pokerSignTransfer(cardsToBeGot(1, i));
    cards{i}.col = cardsToBeGot(2, i);
end
cardsOnTheTable_n = cardsOnTheTable(:, 1:loc(1)-1);
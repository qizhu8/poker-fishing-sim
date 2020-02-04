%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function is to inspect how many pairs of cards in the hand of
% one player
% inputs:
%     Cards: (cell) cards to be inspected
%         two attributions. 
%                  sign(char) is for sign (A 2 3 ... J Q K Joker)
%                  col is for the color of cards (1-heart 2-spade 3-diamond 4-club)
% outputs:
%     pairsNumber: number of pairs of cards.
%     singleNumber: number of single cards.
% e.g.
%     2 2 A 2 => 1 pairs(2, 2) 2 single(2, 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The function was written by Anguswang on 2/25/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [pairsNumber, singleNumber] = inspectCards(Cards)
%%--test--%%
% clc,clear,close all;
% Cards = cell(10, 1);
% for i = 1:10
%     Cards{i}.sign = pokerSignTransfer(randi([1,13]));
%     Cards{i}.col = randi([1,4]);
% end
pairsNumber = 0;
singleNumber = 0;
cardN = zeros(length(Cards), 1);
for i = 1:length(Cards)
    cardN(i) = pokerSignTransfer(Cards{i}.sign);
end

for i = 1:14 % from A 2 3  to J Q K Joker
    pairsNumber = pairsNumber + floor(length(find(cardN == i))/2);
end
singleNumber = length(Cards) - 2*pairsNumber;
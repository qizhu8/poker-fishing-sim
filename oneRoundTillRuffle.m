%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is to simulate the process of 'fishing' till one player's cards is clear and waiting for ruffling
% inputs:
%     Cards_p1: (cell)cards player1 holds
%         two attributions. 
%                      sign(char) is for sign (A 2 3 ... J Q K Joker)
%                      col is for the color of cards (1-heart 2-spade 3-diamond 4-club)
%     Cards_p2: (cell)cards player2 holds
%     Cards_p1_toRuf: cards player1 won but not merged
%     Cards_p2_toRuf: cards player2 won but not merged
%     cardsOnTheTable: cards remain on the table
%     IsP1Turn: 1: player1's turn to place the first card  0: player2's turn
%     mode:
%         0: if playerX won some cards, it's his/her turn to place new cards
%         1: if playerX won some cards, s/he still need to wait for the mate to place the card
%     showCom: 1: show the brief process of this round, 2: show detailed process 0: no words, just the process
% outputs:
%     Cards_p1_n: (cell)cards player1 possesses till the end of this round
%     Cards_p2_n: (cell)cards player2 possesses till the end of this round
%     Cards_p1_toRuf: (cell)cards player1 won
%     Cards_p2_toRuf: (cell)cards player2 won
%     cardsOnTheTable: cards remain. An 2xM array. row1: num, row2: col
%     IsP1Turn: 1: it's player1's turn for next card
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The function was written by Anguswang on 3/5/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clc,clear,close all;
% load testCards
% IsP1Turn = 1;
% showCom = 2;
function [Cards_p1_n, Cards_p2_n, Cards_p1_toRuf, Cards_p2_toRuf, cardsOnTheTable, IsP1Turn] = oneRoundTillRuffle(Cards_p1, Cards_p2, Cards_p1_toRuf, Cards_p2_toRuf, cardsOnTheTable, IsP1Turn, mode, showCom)
cardsNum_p1 = length(Cards_p1);
cardsNum_p2 = length(Cards_p2);
index_p1 = 1; % the index of cards player1 will show
index_p2 = 1;
% cardsOnTheTable = [];
numOfCardsOnTheTable = 0;
Cards_p1_n = [];
Cards_p2_n = [];
% Cards_p1_toRuf = [];
% Cards_p2_toRuf = [];
tmpCard.sign = 'A';
tmpCard.col = 1;
tmpCardWon = [];
while ((index_p1 <= cardsNum_p1) && (index_p2 <= cardsNum_p2)) % each one has cards for next round
    if IsP1Turn 
        % P1's turn
        tmpCard.sign = Cards_p1{index_p1}.sign;
        tmpCard.col = Cards_p1{index_p1}.col;
        index_p1 = index_p1 + 1;
        if showCom > 1
            fprintf('p1 -> %s, %s\n', tmpCard.sign, tmpCard.col);
        end
    else
        % P2's turn
        tmpCard.sign = Cards_p2{index_p2}.sign;
        tmpCard.col = Cards_p2{index_p2}.col;
        index_p2 = index_p2 + 1;
        if showCom > 1
            fprintf('p2 -> %s, %s\n', tmpCard.sign, tmpCard.col);
        end
    end
    % place the card on the table
    cardsOnTheTable = [cardsOnTheTable, [pokerSignTransfer(tmpCard.sign); tmpCard.col]];
    numOfCardsOnTheTable = numOfCardsOnTheTable + 1;
    %%--get won cards--%%
    loc = find(cardsOnTheTable(1,1:numOfCardsOnTheTable-1) == cardsOnTheTable(1, numOfCardsOnTheTable));
    if length(loc)
        % someone won some cards
        % get the won cards
        [cardsOnTheTable, tmpCardWon] = getWonCards(cardsOnTheTable, loc);
        if IsP1Turn
            Cards_p1_toRuf = [Cards_p1_toRuf; tmpCardWon];
            if showCom > 1
                fprintf('p1 \t\t+%d\n', length(tmpCardWon));
            end
        else
            Cards_p2_toRuf = [Cards_p2_toRuf; tmpCardWon];
            if showCom > 1
                fprintf('\tp2 \t\t+%d\n', length(tmpCardWon));
            end
        end
        numOfCardsOnTheTable = (loc(1)-1);
        if mode ~= 0
            IsP1Turn = ~IsP1Turn;
        end
    else
        IsP1Turn = ~IsP1Turn;
    end
end

if index_p1 <= cardsNum_p1
    Cards_p1_n = cell(cardsNum_p1-index_p1+1, 1);
    for i = 1:cardsNum_p1-index_p1+1
        Cards_p1_n{i}.sign = Cards_p1{index_p1+i-1}.sign;
        Cards_p1_n{i}.col = Cards_p1{index_p1+i-1}.col;
    end
end
if index_p2 <= cardsNum_p2
    Cards_p2_n = cell(cardsNum_p2-index_p2+1, 1);
    for i = 1:cardsNum_p2-index_p2+1
        Cards_p2_n{i}.sign = Cards_p2{index_p2+i-1}.sign;
        Cards_p2_n{i}.col = Cards_p2{index_p2+i-1}.col;
    end
end

if showCom
    if index_p1 > cardsNum_p1
        fprintf('p1 remains %d cards won %d cards\n', cardsNum_p1-index_p1+1, length(Cards_p1_toRuf));
        fprintf('p2 remains %d cards won %d cards\n', cardsNum_p2-index_p2+1, length(Cards_p2_toRuf));
        fprintf('%d cards on the table\n', length(cardsOnTheTable));
    end
    if index_p2 > cardsNum_p2
        fprintf('p1 remains %d cards won %d cards\n', cardsNum_p1-index_p1+1, length(Cards_p1_toRuf));
        fprintf('p2 remains %d cards won %d cards\n', cardsNum_p2-index_p2+1, length(Cards_p2_toRuf));
        fprintf('%d cards on the table\n', length(cardsOnTheTable));
    end
end
% showCards(Cards_p1_n)
% showCards(Cards_p2_n)
% cardsOnTheTable

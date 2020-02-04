%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program is to simulate the process of the Fishing Game
% only two players 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The program was written by Anguswang on 2/25/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc,clear,close all;
%%--parameters--%%
%%%---control variables---%%%
suitsOfCards = 2;   % the suits of cards that people use in the game
numberOfCards = 54; % if just want cards randomly, other than a complete suit, then 'suitsOfCards' should be 0, and numberOfCards should be larger than 0
initialCardsRuffleMode = [0, 1, 1, 2, 2, 2, 2];   % 0, 1, 2 are ruffle modes. details in ruffleCards.m 
ruffleCardsMode1 = [1, 1, 2]; % the style of ruffling cards for player1
% ruffleCardsMode1 = [0];
% ruffleCardsMode2 = [1, 1, 2, 2, 2]; % the style of ruffling cards for player2
ruffleCardsMode2 = [-1]; % -1:no operation

distributeCardsMode = 1; % 0: player1 get the first half and player2 gets the reminder;  1: each play takes turns to get cards
commandSwitch = 0; % 0: no comments  1: brief  2: details
gameComMode = 0;   % 0: no comments  1: brief  2: details
showGraph = 0;     % 0: no graph, 1: show
gameMode = 0;      % 0: player who won cards will place another card immediately after 1: player who won will let the other player places a card
totalSimTimes = 10000;  % the total experiments rounds
wonTimesForPlayers = [0, 0]; % times won for two players

for pSimTimes = 1:totalSimTimes
    %%%---tmp variables---%%%
    originalCardsState = [0, 0];
    cardsOnTheTable = [];
    Cards_p1 = []; % cards hold by player1
    Cards_p2 = []; % cards hold by player2
    Cards_p1_won = []; % cards p1 won
    Cards_p2_won = []; % cards p2 won
    CardsNumberOfPlayers = [0, 0];  % number of cards in each players' hands
    CardsStateOfPlayers = [0, 0; 0, 0]; % row1 => player1 row 2 => player2 col1=> number of pairs of cards col2 number of single cards
    cardsStateForGame = [];
    roundOfGame = 0; % one ruffle => one round

    IsP1Turn = 1;      % player1 places cards first? 1: Y, 0: N 
    %%--form cards and ruffling--%%
    Cards = formCards(suitsOfCards, numberOfCards);
    [originalCardsState(1), originalCardsState(2)] = inspectCards(Cards); % the state of all the cards
    if commandSwitch
        fprintf('\t this is a new round\n');
        fprintf('cards mode is %d \n', suitsOfCards)
        fprintf('for original cards, there are:\n');
        fprintf('%d cards in all\n', length(Cards));
        fprintf('%d pairs\n', originalCardsState(1));
        fprintf('%d single\n', originalCardsState(2));
    end
    numberOfCards = length(Cards);
    for i = initialCardsRuffleMode
        Cards = ruffleCards(Cards, i, 1);  
    end

    %%--distribute cards--%%
    Cards_p1 = cell(floor(numberOfCards/2), 1);
    Cards_p2 = cell(numberOfCards-floor(numberOfCards/2), 1);
    ti = 1;
    switch distributeCardsMode
        case 0
            ti = 1;
            for i = 1:floor(numberOfCards/2)
                Cards_p1{i}.sign = Cards{i}.sign;
                Cards_p1{i}.col = Cards{i}.col;
            end
            for i = floor(numberOfCards/2)+1 : numberOfCards
                Cards_p2{ti}.sign = Cards{i}.sign;
                Cards_p2{ti}.col = Cards{i}.col;
                ti = ti + 1;
            end
        case 1
            ti = 1;
            for i = 1:numberOfCards
                if mod(i, 2)
                    Cards_p1{ti}.sign = Cards{i}.sign;
                    Cards_p1{ti}.col = Cards{i}.col;
                else
                    Cards_p2{ti}.sign = Cards{i}.sign;
                    Cards_p2{ti}.col = Cards{i}.col;
                    ti = ti + 1;
                end
            end
        otherwise % same with case 0
            ti = 1;
            for i = 1:floor(numberOfCards/2)
                Cards_p1{i}.sign = Cards{i}.sign;
                Cards_p1{i}.col = Cards{i}.col;
            end
            for i = floor(numberOfCards/2)+1 : numberOfCards
                Cards_p2{ti}.sign = Cards{i}.sign;
                Cards_p2{ti}.col = Cards{i}.col;
                ti = ti + 1;
            end
    end

    %%--get the state of cards of players--%%
    CardsNumberOfPlayers = [length(Cards_p1), length(Cards_p2), length(cardsOnTheTable)];
    [CardsStateOfPlayers(1, 1), CardsStateOfPlayers(1, 2)] = inspectCards(Cards_p1);
    [CardsStateOfPlayers(2, 1), CardsStateOfPlayers(2, 2)] = inspectCards(Cards_p2);
    if commandSwitch > 1
        fprintf('player1:\n');
        fprintf('\t%d cards in all\n', CardsNumberOfPlayers(1));
        fprintf('\t%d pairs\n', CardsStateOfPlayers(1, 1));
        fprintf('\t%d single\n', CardsStateOfPlayers(1, 2));
        fprintf('player2:\n');
        fprintf('\t%d cards in all\n', CardsNumberOfPlayers(2));
        fprintf('\t%d pairs\n', CardsStateOfPlayers(2, 1));
        fprintf('\t%d single\n', CardsStateOfPlayers(2, 2));
    end

    %%--play games--%
    roundOfGame = 1;
    while (CardsNumberOfPlayers(1) ~= 0 && CardsNumberOfPlayers(2) ~= 0)
        [Cards_p1, Cards_p2, Cards_p1_won, Cards_p2_won, cardsOnTheTable, IsP1Turn] = oneRoundTillRuffle(Cards_p1, Cards_p2, Cards_p1_won, Cards_p2_won, cardsOnTheTable, IsP1Turn, gameMode, gameComMode);
        if length(Cards_p1)==0
            Cards_p1 = [Cards_p1; Cards_p1_won];
            clear Cards_p1_won;
            Cards_p1_won = [];
    %         Cards_p1 = mergeCards(Cards_p1, Cards_p1_toRuf);
            for i = ruffleCardsMode1
                Cards_p1 = ruffleCards(Cards_p1, i, 1);  
            end

        else
            Cards_p2 = [Cards_p2; Cards_p2_won];
            clear Cards_p2_won;
            Cards_p2_won = [];
    %         Cards_p2 = mergeCards(Cards_p2, Cards_p2_toRuf);
            for i = ruffleCardsMode2
                Cards_p2 = ruffleCards(Cards_p2, i, 1);  
            end
        end
        CardsNumberOfPlayers = [length(Cards_p1), length(Cards_p2), length(cardsOnTheTable)];
        [CardsStateOfPlayers(1, 1), CardsStateOfPlayers(1, 2)] = inspectCards([Cards_p1; Cards_p1_won]);
        [CardsStateOfPlayers(2, 1), CardsStateOfPlayers(2, 2)] = inspectCards([Cards_p2; Cards_p2_won]);
        cardsStateForGame = [cardsStateForGame, [roundOfGame, length(Cards_p1)+length(Cards_p1_won), length(Cards_p2)+length(Cards_p2_won), length(cardsOnTheTable),CardsStateOfPlayers(1, 1),CardsStateOfPlayers(2, 1)]'];
        if commandSwitch > 1
            fprintf('player1:\n');
            fprintf('\t%d cards in all\n', CardsNumberOfPlayers(1));
            fprintf('\t%d pairs\n', CardsStateOfPlayers(1, 1));
            fprintf('\t%d single\n', CardsStateOfPlayers(1, 2));
            fprintf('player2:\n');
            fprintf('\t%d cards in all\n', CardsNumberOfPlayers(2));
            fprintf('\t%d pairs\n', CardsStateOfPlayers(2, 1));
            fprintf('\t%d single\n', CardsStateOfPlayers(2, 2));
        end
        if CardsNumberOfPlayers(1) == 0
            wonTimesForPlayers(2) = wonTimesForPlayers(2)+1;            
            fprintf('at %d time''s exp round %d, player2 won!\n', pSimTimes, roundOfGame);
            fprintf('p1 won %d times %d%%, p2 won %d times %d%%\n', wonTimesForPlayers(1), round(100*wonTimesForPlayers(1)/(wonTimesForPlayers(1)+wonTimesForPlayers(2))), wonTimesForPlayers(2), round(100*wonTimesForPlayers(2)/(wonTimesForPlayers(1)+wonTimesForPlayers(2))));
        else if CardsNumberOfPlayers(2) == 0
                wonTimesForPlayers(1) = wonTimesForPlayers(1)+1;                
                fprintf('at %d time''s exp round %d, player1 won!\n', pSimTimes, roundOfGame);
                fprintf('p1 won %d times %d%%, p2 won %d times %d%%\n', wonTimesForPlayers(1), round(100*wonTimesForPlayers(1)/(wonTimesForPlayers(1)+wonTimesForPlayers(2))), wonTimesForPlayers(2), round(100*wonTimesForPlayers(2)/(wonTimesForPlayers(1)+wonTimesForPlayers(2))));
            end
        end
        if commandSwitch
            disp([roundOfGame, CardsNumberOfPlayers]);
        end
        roundOfGame = roundOfGame + 1;
    end

    if showGraph
        figure(1)
        % cards player1 hold
        plot(cardsStateForGame(1,:), cardsStateForGame(2,:), 'b');
        hold on;
        % cards player2 hold
        plot(cardsStateForGame(1,:), cardsStateForGame(3,:), 'r');
        hold on;
        % cards one the table
        plot(cardsStateForGame(1,:), cardsStateForGame(4,:), 'k');
        hold on;
        % pairs player1 hold
        stem(cardsStateForGame(1,:), cardsStateForGame(5,:), 'b--');
        hold on;
        % pairs player2 hold
        stem(cardsStateForGame(1,:), cardsStateForGame(6,:), 'r--');
        hold on;
        % 1/2 number of cards player1 hold
        plot(cardsStateForGame(1,:), cardsStateForGame(2,:)/2, 'b--');
        hold on;
        % 1/2 number of cards player2 hold
        plot(cardsStateForGame(1,:), cardsStateForGame(3,:)/2, 'r--');
        hold on;
        legend('player1', 'player2', 'on the table', 'pairs for player1', 'pairs for player2');
        title('state of cards players hold');
    end
end
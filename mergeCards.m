function cards = mergeCards(cards_1, cards_2)
cardsNum_1 = length(cards_1);
cardsNum_2 = length(cards_2);
cards = cell(cardsNum_1 + cardsNum_2, 1);
for i = 1:cardsNum_1
    cards{i}.sign = cards_1{i}.sign;
    cards{i}.col = cards_1{i}.col;
end
for i = 1:cardsNum_2
    cards{i+cardsNum_1}.sign = cards_2{i}.sign;
    cards{i+cardsNum_1}.col = cards_2{i}.col;
end
function [ a ] = GraphComparableBlock( predictedRisk, realizedRisk, window, prediction, counter, rr, pr, date )
%This function graphs the performance of the block matrix and block
%algorithm filters relative to the minimum variance portfolio
n = (7*window+prediction)*100 + 4*counter;
hold
filterLength = length(realizedRisk);
t=1:filterLength;
h = figure(n);

%Graph the predicted risk according to the block matrix and block algorithm 
%weights for the and the predicted risk of the minimum variance portfolio
predGraph = subplot(2,1,1);
plot(t, sqrt(predictedRisk), t, sqrt(pr(1))*ones(1,filterLength));
legend('MVDR','Block', 'Block Matrix','Real', 'Location', 'EastOutside');
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'predicted'));
xlabel('Iteration');
ylabel('Risk');

%Graph the realized risk according to the block matrix and block algorithm 
%weights for the and the realized risk of the minimum variance portfolio
realGraph = subplot(2,1,2);
plot(t, sqrt(realizedRisk), t, sqrt(rr(1))*ones(1,filterLength));
legend('Sample','Block', 'Block Matrix', 'Real', 'Location', 'EastOutside');
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'realized'));
xlabel('Iteration');
ylabel('Risk');

saveTitle = strcat('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\blockcomp2\Window', num2str(window),'Prediction',num2str(prediction),'-blockcomp',num2str(counter));

saveas(h, saveTitle, 'pdf');

end

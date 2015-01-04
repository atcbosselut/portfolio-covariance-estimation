function [ a ] = GraphComparable( predictedRisk, realizedRisk, norms, window, prediction, counter, rr, pr, date )
%This function graphs the performance of the iterative MVDR filter applied
%to the sample covariance, RMT-0, RMT-M and single index model matrices
%relative to the minimum variance portfolio
n = (7*window+prediction)*100 + 4*counter;
hold
filterLength = length(realizedRisk);
t=1:filterLength;
h = figure(n);

%Graph the norm of the difference between the iterative MVDR weights for
%the sample covariance, RMT-0, RMT-M, and single index model matrices and
%the weight in the MVDR filter
normGraph = subplot(3,1,1);
plot(t, norms);
legend('Sample','RMT-O', 'RMT-M', 'SI', 'Location', 'EastOutside');
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'norms'));
xlabel('Iteration');
ylabel('Norm');

%Graph the predicted risk according to the iterative MVDR weights for the 
%sample covariance, RMT-0, RMT-M and single index model matrices and the
%predicted risk of the minimum variance portfolio
predGraph = subplot(3,1,2);
plot(t, sqrt(predictedRisk), t, sqrt(pr(1))*ones(1,filterLength));
legend('Sample','RMT-O', 'RMT-M', 'SI', 'Real', 'Location', 'EastOutside');
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'predicted'));
xlabel('Iteration');
ylabel('Risk');

%Graph the realized risk according to the iterative MVDR weights for the 
%sample covariance, RMT-0, RMT-M and single index model matrices and the
%realized risk of the minimum variance portfolio
realGraph = subplot(3,1,3);
plot(t, sqrt(realizedRisk), t, sqrt(rr(1))*ones(1,filterLength));
legend('Sample','RMT-O', 'RMT-M', 'SI', 'Real', 'Location', 'EastOutside');
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'realized'));
xlabel('Iteration');
ylabel('Risk');

saveTitle = strcat('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\', date,'\Window', num2str(window),'\Pred',num2str(prediction),'\comp\Window', num2str(window),'Prediction',num2str(prediction),'-',num2str(counter));

saveas(h, saveTitle, 'pdf');

end

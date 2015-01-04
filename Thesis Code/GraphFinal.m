function [ a ] = GraphFinal( predictedRisk, realizedRisk, window, prediction, counter, rr, pr, date, Estimator )
%This function graphs the performance of either the iterative MVDR filter
%or block matrix filter applied to the sample covariance, RMT-0, RMT-M, or
%single index model matrices relative to the minimum variance portfolio
n = (7*window+prediction)*100 + 4*counter;
hold
filterLength = length(realizedRisk)
t=1:filterLength;

%Set minimum variance portfolio parameters
rr = rr*ones(1,filterLength);
pr = pr*ones(1,filterLength);
h = figure(n);

%Graph the predicted risk according to the filter weights for the 
%sample covariance, RMT-0, RMT-M and single index model matrices and the
%predicted risk of the minimum variance portfolio
predGraph = subplot(2,1,1);
plot(t, predictedRisk', t, pr);
legend(Estimator,'Sample','RMT-0', 'RMT-M', 'SI', 'Location', 'EastOutside');
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'predicted'));
xlabel('Iteration');
ylabel('Risk');

%Graph the realized risk according to the filter weights for the 
%sample covariance, RMT-0, RMT-M and single index model matrices and the
%realized risk of the minimum variance portfolio
realGraph = subplot(2,1,2);
plot(t, realizedRisk', t, rr);
legend(Estimator, 'Sample','RMT-0', 'RMT-M', 'SI', 'Location', 'EastOutside');
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'realized'));
xlabel('Iteration');
ylabel('Risk');

saveTitle = strcat('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\Window', num2str(window),'Prediction',num2str(prediction),'-',num2str(counter));

saveas(h, saveTitle, 'pdf');

end

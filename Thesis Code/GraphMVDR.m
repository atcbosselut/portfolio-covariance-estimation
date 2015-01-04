function [ a ] = GraphMVDR( predictedRisk, realizedRisk, norms, window, prediction, counter, rr, pr, date )
%This function graphs the performance of the iterative MVDR filter

n = (7*window+prediction)*100 + 4*counter;
hold
filterLength = length(realizedRisk);
t=1:filterLength;

%Graph the norm of the difference between the iterative MVDR weights for the sample covariance matrix and
%the weight in the MVDR filter
h = figure(n);
normGraph = subplot(3,1,1);
plot(t, norms);
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'norms'));
xlabel('Iteration');
ylabel('Norm');

%Graph the predicted risk according to the iterative MVDR weights for the sample covariance matrix and the
%predicted risk of the minimum variance portfolio
predGraph = subplot(3,1,2);
plot(t, sqrt(predictedRisk), '-b', t, sqrt(pr)*ones(1,filterLength), '-r');
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'predicted'));
xlabel('Iteration');
ylabel('Risk');

%Graph the realized risk risk according to the iterative MVDR weights for the sample covariance matrix and the
%realized risk of the minimum variance portfolio
realGraph = subplot(3,1,3);
plot(t, sqrt(realizedRisk), '-b', t, sqrt(rr)*ones(1,filterLength), '-r');
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'realized'));
xlabel('Iteration');
ylabel('Risk');

%Save the charts
saveTitle = strcat('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\', date,'\Window', num2str(window),'\Pred',num2str(prediction),'\sample\Window', num2str(window),'Prediction',num2str(prediction),'-',num2str(counter));
saveas(h, saveTitle, 'pdf');

end


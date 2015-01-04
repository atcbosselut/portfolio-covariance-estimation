function [ a ] = GraphMVDRSpectral(predictedRisk, realizedRisk, norms, window, prediction, counter, rr, pr )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n = (7*window+prediction)*100 + 4*counter;
hold
filterLength = length(realizedRisk);
t=1:filterLength;
h = figure(n+1);

%Graph the norm of the difference between the iterative MVDR weights for the RMT-0 matrix and
%the weight in the MVDR filter
normGraphO = subplot(3,1,1);
plot(t, norms(:,1));
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'norm-O'));
xlabel('Iteration');
ylabel('Norm');

%Graph the predicted risk according to the iterative MVDR weights for the RMT-0 matrix and the
%predicted risk of the minimum variance portfolio
predGraphO = subplot(3,1,2);
plot(t, sqrt(predictedRisk(:,1)), '-b', t, sqrt(pr(1))*ones(1,filterLength), '-r');
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'predicted-RMT-O'));
xlabel('Iteration');
ylabel('Risk');

%Graph the realized risk according to the iterative MVDR weights for the RMT-0 matrix and the
%realized risk of the minimum variance portfolio
realGraphO = subplot(3,1,3);
plot(t, sqrt(realizedRisk(:,1)), '-b', t, sqrt(rr(1))*ones(1,filterLength), '-r');
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'realized-RMT-O'));
xlabel('Iteration');
ylabel('Risk');


saveTitle = strcat('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\',date,'\Window', num2str(window),'\Pred',num2str(prediction),'\rmto\RMT-O-Window', num2str(window),'Prediction',num2str(prediction),'-',num2str(counter));

saveas(h, saveTitle, 'pdf');
h = figure(n+2);

%Graph the norm of the difference between the iterative MVDR weights for the RMT-M matrix and
%the weight in the MVDR filter
normGraphO = subplot(3,1,1);
plot(t, norms(:,2));
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'norm-M'));
xlabel('Iteration');
ylabel('Norm');

%Graph the predicted risk according to the iterative MVDR weights for the RMT-M matrix and the
%predicted risk of the minimum variance portfolio
predGraphM = subplot(3,1,2);
plot(t, sqrt(predictedRisk(:,2)), '-b', t, sqrt(pr(2))*ones(1,filterLength), '-r');
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'predicted-RMT-M'));
xlabel('Iteration');
ylabel('Risk');

%Graph the realized risk according to the iterative MVDR weights for the RMT-M matrix and the
%realized risk of the minimum variance portfolio
realGraphM = subplot(3,1,3);
plot(t, sqrt(realizedRisk(:,2)), '-b', t, sqrt(rr(2))*ones(1,filterLength), '-r');
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'realized-RMT-M'));
xlabel('Iteration');
ylabel('Risk');

saveTitle = strcat('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\',date,'\Window', num2str(window),'\Pred',num2str(prediction),'\rmtm\RMT-M-SpectralWindow', num2str(window),'Prediction',num2str(prediction),'-',num2str(counter));

saveas(h, saveTitle, 'pdf');

h = figure(n+3);

%Graph the norm of the difference between the iterative MVDR weights for the single index model and
%the weight in the MVDR filter
normGraphSI = subplot(3,1,1);
plot(t, norms(:,3));
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'norm-SI'));
xlabel('Iteration');
ylabel('Norm');

%Graph the predicted risk according to the iterative MVDR weights for the single index model and the
%predicted risk of the minimum variance portfolio
predGraphSI = subplot(3,1,2);
plot(t, sqrt(predictedRisk(:,3)), '-b', t, sqrt(pr(3))*ones(1,filterLength), '-r');
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'predicted-SI'));
xlabel('Iteration');
ylabel('Risk');

%Graph the realized risk according to the iterative MVDR weights for the single index model and the
%realized risk of the minimum variance portfolio
realGraphSI = subplot(3,1,3);
plot(t, sqrt(realizedRisk(:,3)), '-b', t, sqrt(rr(3))*ones(1,filterLength), '-r');
title(strcat('Window', num2str(window),'Prediction',num2str(prediction),'realized-SI'));
xlabel('Iteration');
ylabel('Risk');

saveTitle = strcat('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\',date,'\Window', num2str(window),'\Pred',num2str(prediction),'\si\SI-SpectralWindow', num2str(window),'Prediction',num2str(prediction),'-',num2str(counter));

saveas(h, saveTitle, 'pdf');
end


%xlsread('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\9EstimatorsDailyPricesClean.xlsx')

function [ iterationNumber ] = MVDRWindows( prices, timeRange, numStocks, filterLength, date )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    format long
    iterationNumber = zeros((round(timeRange/30))+1,12,6);
    SPData = xlsread('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\S&PReturns.xlsx');
    for x = 1:6
        iterationNumber(1,:,x) = [30 0 60 0 90 0 120 0 180 0 240 0];
    end
    windowCounter = 3;
    bestIndex = zeros(2,23);
    predictionCounter = 2;
    windowLengths = [30 60 90 120 180 240];
    predictionLengths = [30 60 90 120 180 240];
    while (windowCounter < 7)
        while(predictionCounter < 7)
            temp = IterationsDiff(windowLengths(windowCounter), predictionLengths(predictionCounter), prices, timeRange, numStocks, filterLength, SPData, date)	%Call Iterations, which computed the average predicted and realized risk for each time window of the set (In this case for a 1 month time window, there will be 132 iterations)
            tempSize = size(temp);
            if(windowLengths(windowCounter)>=predictionLengths(predictionCounter))
                s = windowLengths(windowCounter):predictionLengths(predictionCounter):2766;
                q = figure(7*windowCounter+predictionCounter);
                subplot(2,1,1)
                plot(s(1,1:end-1),temp(1:(tempSize(1)-1)/2 + 1,1:end-1));
                title('Cross-Validation Best Index Estimates');
                legend('RRL', '3.33%', '6.66%', '10%', '16.67%', '20%', '33.33%', 'Location', 'EastOutside');
                xlabel('Time Range');
                ylabel('Index');
                subplot(2,1,2);
                plot(s(1,1:end-1),temp(((tempSize(1)-1)/2 + 2):end,1:end-1));
                title('Difference in Risk between CV Best and MVDR best')
                legend('3.33%', '6.66%', '10%', '16.67%', '20%', '33.33%', 'Location', 'EastOutside');
                xlabel('Time Range');
                ylabel('Percentage Difference');
                saveTitle = strcat('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\', date,'\CV\Window', num2str(windowLengths(windowCounter)),'Prediction',num2str(predictionLengths(predictionCounter)));

                saveas(q, saveTitle, 'pdf');
            else
                s = windowLengths(windowCounter):windowLengths(windowCounter):2766-(predictionLengths(predictionCounter)-windowLengths(windowCounter));
                q = figure(7*windowCounter+predictionCounter);
                subplot(2,1,1)
                length(s(1,1:end-1))
                length(temp(1:(tempSize(1)-1)/2 + 1,:))
                plot(s(1,1:end-1),temp(1:(tempSize(1)-1)/2 + 1,:));
                title('Cross-Validation Best Index Estimates');
                legend('RRL', '3.33%', '6.66%', '10%', '16.67%', '20%', '33.33%', 'Location', 'EastOutside');
                xlabel('Time Range');
                ylabel('Index');
                subplot(2,1,2);
                plot(s(1,1:end-1),temp(((tempSize(1)-1)/2 + 2):end,:));
                title('Difference in Risk between CV Best and MVDR best')
                legend('3.33%', '6.66%', '10%', '16.67%', '20%', '33.33%', 'Location', 'EastOutside');
                xlabel('Time Range');
                ylabel('Percentage Difference');
                saveTitle = strcat('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\', date,'\CV\Window', num2str(windowLengths(windowCounter)),'Prediction',num2str(predictionLengths(predictionCounter)));

                saveas(q, saveTitle, 'pdf');
            end
            
            
%             columnIndex = 2*(predictionCounter-1)+1;
%             size(iterationNumber)
%             iterationNumber(2:length(temp)+1, columnIndex:(columnIndex+1), windowCounter) = temp';
            predictionCounter = 7; %CHANGE
        end
        windowCounter = 7%windowCounter + 1
        predictionCounter = 1;
    end
end

function [ bestIndex ] = IterationsDiff(windowLength, predictionLength, prices, timeRange, numStocks, filterLength, SPData, date )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    introMatrix = prices(1, 1:(numStocks+1));
    percentages = [1/30 1/15 .1 1/6 .2 1/3];
    if (predictionLength <= windowLength)
        predictedRisks = zeros(3,round((timeRange-windowLength)/predictionLength));
        realizedRisks = zeros(3,round((timeRange-windowLength)/predictionLength));
        mvdrIdealIndices = zeros(3,round((timeRange-windowLength)/predictionLength));
        bestIndex = zeros(2*(length(percentages))+1,round((timeRange-windowLength)/predictionLength));
    else
        predictedRisks = zeros(3,round((timeRange-predictionLength)/windowLength));
        realizedRisks = zeros(3,round((timeRange-predictionLength)/windowLength));
        mvdrIdealIndices = zeros(3,round((timeRange-predictionLength)/windowLength));
        bestIndex = zeros(2*(length(percentages))+1,round((timeRange-windowLength)/predictionLength));
    end
    
    counter = 1;
    norms = zeros(filterLength,4);
    realizedRisksMVDR = zeros(filterLength,4);
    predictedRisksMVDR = zeros(filterLength,4);
    realizedRisksMVDRavg = zeros(filterLength,4);
    predictedRisksMVDRavg = zeros(filterLength,4);
    normsAvg = zeros(filterLength,4);
    weightMatrix = zeros(numStocks, filterLength, 4);
    weightsSamp = zeros(4, numStocks);
    predictedRisksavg = zeros(4,1);
    realizedRisksavg = zeros(4,1);
    pr = zeros(4,1);
    rr = zeros(4,1);
    
    %weightMatrix = zeros(
    
    subMat = [introMatrix; prices(2: (windowLength+1), 1:(numStocks+1))];
    if windowLength ~= (length(subMat(2:end,1)))
       disp(strcat('WL:',num2str(counter),'-',num2str(length(subMat(2:end,1)))))
    end
    sampCovMat = SampleCovMatrix(numStocks, subMat, windowLength);
    spec = SpectralEstimators(sampCovMat, numStocks, windowLength);
    rmt_o = spec(:,:,1);
    rmt_m = spec(:,:,2);
    si = SingleIndexModel(subMat, numStocks, windowLength, SPData);
    weightsSamp(1,:) = MinVarPortfolio(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);
    weightsSamp(2,:) = MinVarPortfolio(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-O covariance estimator
    weightsSamp(3,:) = MinVarPortfolio(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks); 
    weightsSamp(4,:) = MinVarPortfolio(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);    
    for num = 1:4
        pr(num) = weightsSamp(num,:)*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*weightsSamp(num,:)';
        predictedRisksMVDR(:,num) = diag(weightMatrix(:,:,num)'*(sampCovMat(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,:,num));                
    end
    weightMatrix(:,:,1) = MVDREstimator(sampCovMat, numStocks, filterLength);
    weightMatrix(:,:,2) = MVDREstimator(rmt_o, numStocks, filterLength);
    weightMatrix(:,:,3) = MVDREstimator(rmt_m, numStocks, filterLength);
    weightMatrix(:,:,4) = MVDREstimator(si, numStocks, filterLength);
%     abspredRiskMVDR = abs(predictedRisksMVDR);
%     minPreds = (find(abspredRiskMVDR==min(abspredRiskMVDR)));
%     predictedRisks(1,counter) = minPreds(1);                               %Calculate the predicted variance of the portfolio    
    timer = 0;
    bestIndex(2:length(percentages)+1, counter) = crossvalidate(subMat, numStocks, windowLength, filterLength, percentages);

    for a = (windowLength+2):timeRange
        if (timer == predictionLength && predictionLength <= windowLength)
            for num = 1:4
                predictedRisksMVDRavg(:, num) = predictedRisksMVDRavg(:, num) + predictedRisksMVDR(:, num);
                predictedRisksavg(num) = predictedRisksavg(num) + pr(num);
            end
            
            subMat2 = [introMatrix; prices((a-predictionLength):(a-1),1:(numStocks+1))];
            disp(strcat('PL:',num2str(a-predictionLength),'-',num2str(a-1)));
            if predictionLength ~= (length(subMat2(2:end,1)))
                disp(strcat('PL:',num2str(counter),'-',num2str(length(subMat2(2:end,1))),'-',num2str(a)))
            end
            
            sampCovMat2 = SampleCovMatrix(numStocks, subMat2, predictionLength);
            wmvdr = MinVarPortfolio(sampCovMat2(2:(numStocks+1), 2:(numStocks+1)), numStocks);
            for num = 1:4
                rr(num) = weightsSamp(num,:)*sampCovMat2(2:(numStocks+1),2:(numStocks+1))*weightsSamp(num,:)';
                realizedRisksMVDR(:, num) = diag(weightMatrix(:,:,num)'*(sampCovMat2(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,:,num));
                normComp = weightMatrix(:,:,num) - (wmvdr')*ones(1,filterLength);
                for t = 1:filterLength;
                    norms(t,num) = norm(normComp(:,t));
                end
            end
            bestIndex(1,counter) = find(realizedRisksMVDR(:,1)==min(realizedRisksMVDR(:,1)));
            bestIndex(length(percentages)+2:end,counter) = realizedRisksMVDR(round(bestIndex(2:length(percentages)+1,counter)),1) - realizedRisksMVDR(bestIndex(1,counter),1)*ones(length(percentages),1);

%             mvdrIdealIndices(counter) = find(norms==min(norms));
%             realizedRisks(1,counter) = find(realizedRisksMVDR==min(abs(realizedRisksMVDR)));     
%             GraphMVDR(predictedRisksMVDR(:,1), realizedRisksMVDR(:,1), norms, windowLength, predictionLength, counter,rr(1),pr(1), date);
%             GraphMVDRSpectral(predictedRisksMVDR(:,2:end), realizedRisksMVDR(:,2:end), norms, windowLength, predictionLength, counter,rr(2:end),pr(2:end), date);
            GraphComparable(predictedRisksMVDR, realizedRisksMVDR, norms, windowLength, predictionLength, counter, rr, pr, date);
            counter = counter + 1;
            
            subMat = [introMatrix; subMat((predictionLength+2):end, 1:(numStocks+1)) ; prices((a-predictionLength):(a-1),1:(numStocks+1))];
            if windowLength ~= (length(subMat(2:end,1)))
                disp(strcat('WL:',num2str(counter),'-',num2str(length(subMat(2:end,1))),'-',num2str(a)))
            end
            sampCovMat = SampleCovMatrix(numStocks, subMat, windowLength);
            spec = SpectralEstimators(sampCovMat, numStocks, windowLength);
            rmt_o = spec(:,:,1);
            rmt_m = spec(:,:,2);
            si = SingleIndexModel(subMat, numStocks, windowLength, SPData);
            weightsSamp(1,:) = MinVarPortfolio(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);
            weightsSamp(2,:) = MinVarPortfolio(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-O covariance estimator
            weightsSamp(3,:) = MinVarPortfolio(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);
            weightsSamp(4,:) = MinVarPortfolio(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
            weightMatrix(:,:,1) = MVDREstimator(sampCovMat, numStocks, filterLength);
            weightMatrix(:,:,2) = MVDREstimator(rmt_o, numStocks, filterLength);
            weightMatrix(:,:,3) = MVDREstimator(rmt_m, numStocks, filterLength);
            weightMatrix(:,:,4) = MVDREstimator(si, numStocks, filterLength);          
            for num = 1:4
                pr(num) = weightsSamp(num,:)*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*weightsSamp(num,:)';
                predictedRisksMVDR(:,num) = diag(weightMatrix(:,:,num)'*(sampCovMat(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,:,num));            
            end
            
            
%             abspredRiskMVDR = abs(predictedRisksMVDR);
%             minPreds = (find(abspredRiskMVDR==min(abspredRiskMVDR)));
%             predictedRisks(1,counter) = minPreds(1);
            
            timer = 0;
            for num = 1:4
                realizedRisksMVDRavg(:, num) = realizedRisksMVDRavg(:, num) + realizedRisksMVDR(:, num);
                realizedRisksavg(num) = realizedRisksavg(num) + rr(num);
                normsAvg(:, num) = normsAvg(:, num) + norms(:, num);
            end
            bestIndex(2:length(percentages)+1, counter) = crossvalidate(subMat, numStocks, predictionLength, filterLength, percentages);
        elseif (timer == windowLength && predictionLength > windowLength)
            for num = 1:4
                predictedRisksMVDRavg(:, num) = predictedRisksMVDRavg(:, num) + predictedRisksMVDR(:, num);
                predictedRisksavg(num) = predictedRisksavg(num) + pr(num);
            end
            
            if (a+predictionLength > timeRange)
                subMat2 = [introMatrix; prices(a:end,1:(numStocks+1))];
                sampCovMat2 = SampleCovMatrix(numStocks, subMat2, size(subMat2,1)-1);
            else    
                subMat2 = [introMatrix; prices((a-windowLength):(a-windowLength+predictionLength-1),1:(numStocks+1))];
                sampCovMat2 = SampleCovMatrix(numStocks, subMat2, predictionLength);
            end
%             disp(strcat('PL:',num2str(a-windowLength),'-',num2str(a-windowLength+predictionLength-1)));
            if predictionLength ~= (length(subMat2(2:end,1)))
                disp(strcat('PL:',num2str(counter),'-',num2str(length(subMat2(2:end,1))),'-',num2str(a)))
            end
            
            wmvdr = MinVarPortfolio(sampCovMat2(2:(numStocks+1), 2:(numStocks+1)), numStocks);
            for num = 1:4
                rr(num) = weightsSamp(num,:)*sampCovMat2(2:(numStocks+1),2:(numStocks+1))*weightsSamp(num,:)';
                realizedRisksMVDR(:, num) = diag(weightMatrix(:,:,num)'*(sampCovMat2(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,:,num));
                normComp = weightMatrix(:,:,num) - (wmvdr')*ones(1,filterLength);
                for t = 1:filterLength;
                    norms(t, num) = norm(normComp(:,t));
                end
            end
            bestIndex(1,counter) = find(realizedRisksMVDR(:,1)==min(realizedRisksMVDR(:,1)));
            bestIndex(length(percentages)+2:end,counter) = realizedRisksMVDR(round(bestIndex(2:length(percentages)+1,counter))) - realizedRisksMVDR(bestIndex(1,counter),1)*ones(length(percentages),1);

%             mvdrIdealIndices(counter) = find(norms==min(norms));
%             realizedRisks(1,counter) = find(realizedRisksMVDR==min(abs(realizedRisksMVDR)));                               %Calculate the predicted variance of the portfolio                
%             GraphMVDR(predictedRisksMVDR(:,1), realizedRisksMVDR(:,1), norms, windowLength, predictionLength, counter,rr(1),pr(1), date);
%             GraphMVDRSpectral(predictedRisksMVDR(:,2:end), realizedRisksMVDR(:,2:end), norms, windowLength, predictionLength, counter,rr(2:end),pr(2:end), date);
            GraphComparable(predictedRisksMVDR, realizedRisksMVDR, norms, windowLength, predictionLength, counter, rr, pr, date);

            counter = counter + 1;
            
            if ((a+predictionLength) > timeRange+1)
                break;
            else    
                subMat = [introMatrix; prices((a-windowLength):(a-1), 1:(numStocks+1))];
                sampCovMat = SampleCovMatrix(numStocks, subMat, windowLength);
            end
%             disp(strcat('WL:',num2str(a-windowLength),'-',num2str(a-1)));
            if windowLength ~= (length(subMat(2:end,1)))
                disp(strcat('WL:',num2str(counter),'-',num2str(length(subMat(2:end,1))),'-',num2str(a)))
            end
            spec = SpectralEstimators(sampCovMat, numStocks, windowLength);
            rmt_o = spec(:,:,1);
            rmt_m = spec(:,:,2);
            si = SingleIndexModel(subMat, numStocks, windowLength, SPData);
            weightsSamp(1,:) = MinVarPortfolio(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);
            weightsSamp(2,:) = MinVarPortfolio(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-O covariance estimator
            weightsSamp(3,:) = MinVarPortfolio(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);
            weightsSamp(4,:) = MinVarPortfolio(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
            weightMatrix(:,:,1) = MVDREstimator(sampCovMat, numStocks, filterLength);
            weightMatrix(:,:,2) = MVDREstimator(rmt_o, numStocks, filterLength);
            weightMatrix(:,:,3) = MVDREstimator(rmt_m, numStocks, filterLength);
            weightMatrix(:,:,4) = MVDREstimator(si, numStocks, filterLength);
            for num = 1:4
                pr(num) = weightsSamp(num,:)*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*weightsSamp(num,:)';
                predictedRisksMVDR(:,num) = diag(weightMatrix(:,:,num)'*(sampCovMat(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,:,num));
            end

%             abspredRiskMVDR = abs(predictedRisksMVDR);
%             minPreds = (find(abspredRiskMVDR==min(abspredRiskMVDR)));
%             predictedRisks(1,counter) = minPreds(1);                               %Calculate the predicted variance of the portfolio    
            

            timer = 0;            
            for num = 1:4
                realizedRisksMVDRavg(:, num) = realizedRisksMVDRavg(:, num) + realizedRisksMVDR(:, num);
                realizedRisksavg(num) = realizedRisksavg(num) + rr(num);
                normsAvg(:, num) = normsAvg(:, num) + norms(:, num);
            end
            bestIndex(2:length(percentages)+1, counter) = crossvalidate(subMat, numStocks, windowLength, filterLength, percentages);
        end
        timer = timer + 1;
        
    end
    realizedRisksMVDRavg = realizedRisksMVDRavg/(counter-1);
    predictedRisksMVDRavg = predictedRisksMVDRavg/(counter-1);
    realizedRisksavg = realizedRisksavg/(counter-1);
    predictedRisksavg = predictedRisksavg/(counter-1);
    normsAvg = normsAvg/(counter-1);
%     GraphMVDR(predictedRisksMVDRavg(:,1), realizedRisksMVDRavg(:,1), normsAvg(:,1), windowLength, predictionLength, 10000,realizedRisksavg(1),predictedRisksavg(1), date);
%     GraphMVDRSpectral(predictedRisksMVDRavg(:,2:end), realizedRisksMVDRavg(:,2:end), normsAvg(:,2:end), windowLength, predictionLength, 10000,realizedRisksavg(2:end),predictedRisksavg(2:end), date);
    GraphComparable(predictedRisksMVDRavg, realizedRisksMVDRavg, normsAvg, windowLength, predictionLength, 10000, realizedRisksavg, predictedRisksavg, date);

    theOutput = [mvdrIdealIndices' predictedRisks(1,1:size(realizedRisks,2))' realizedRisks'];
end
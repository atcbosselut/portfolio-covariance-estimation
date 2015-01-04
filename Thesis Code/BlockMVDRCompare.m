%xlsread('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\9EstimatorsDailyPricesClean.xlsx')

function [ iterationNumber ] = BlockMVDRCompare( prices, timeRange, numStocks, filterLength, date )
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
    predictionCounter = 3;
    windowLengths = [30 60 90 120 180 240];
    predictionLengths = [30 60 90 120 180 240];
    while (windowCounter < 7)
        while(predictionCounter < 7)
            temp = IterationsDiff(windowLengths(windowCounter), predictionLengths(predictionCounter), prices, timeRange, numStocks, filterLength, SPData, date);	%Call Iterations, which computed the average predicted and realized risk for each time window of the set (In this case for a 1 month time window, there will be 132 iterations)
            tempSize = size(temp);
%             if(windowLengths(windowCounter)>=predictionLengths(predictionCounter))
%                 s = windowLengths(windowCounter):predictionLengths(predictionCounter):2766;
%                 q = figure(7*windowCounter+predictionCounter);
%                 subplot(2,1,1)
%                 plot(s(1,1:end-1),temp(1:(tempSize(1)-1)/2 + 1,1:end-1));
%                 title('Cross-Validation Best Index Estimates');
%                 legend('RRL', '3.33%', '6.66%', '10%', '16.67%', '20%', '33.33%', 'Location', 'EastOutside');
%                 xlabel('Time Range');
%                 ylabel('Index');
%                 subplot(2,1,2);
%                 plot(s(1,1:end-1),temp(((tempSize(1)-1)/2 + 2):end,1:end-1));
%                 title('Difference in Risk between CV Best and Block best')
%                 legend('3.33%', '6.66%', '10%', '16.67%', '20%', '33.33%', 'Location', 'EastOutside');
%                 xlabel('Time Range');
%                 ylabel('Percentage Difference');
% %                 saveTitle = strcat('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\', date,'\CV\Window', num2str(windowLengths(windowCounter)),'Prediction',num2str(predictionLengths(predictionCounter)));
% % 
% %                 saveas(q, saveTitle, 'pdf');
%             else
%                 s = windowLengths(windowCounter):windowLengths(windowCounter):2766-(predictionLengths(predictionCounter)-windowLengths(windowCounter));
%                 q = figure(7*windowCounter+predictionCounter);
%                 subplot(2,1,1)
%                 length(s(1,1:end-1))
%                 length(temp(1:(tempSize(1)-1)/2 + 1,:))
%                 plot(s(1,1:end-1),temp(1:(tempSize(1)-1)/2 + 1,:));
%                 title('Cross-Validation Best Index Estimates');
%                 legend('RRL', '3.33%', '6.66%', '10%', '16.67%', '20%', '33.33%', 'Location', 'EastOutside');
%                 xlabel('Time Range');
%                 ylabel('Index');
%                 subplot(2,1,2);
%                 plot(s(1,1:end-1),temp(((tempSize(1)-1)/2 + 2):end,:));
%                 title('Difference in Risk between CV Best and Block best')
%                 legend('3.33%', '6.66%', '10%', '16.67%', '20%', '33.33%', 'Location', 'EastOutside');
%                 xlabel('Time Range');
%                 ylabel('Percentage Difference');
%                 saveTitle = strcat('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\', date,'\CV\Window', num2str(windowLengths(windowCounter)),'Prediction',num2str(predictionLengths(predictionCounter)));
% 
%                 saveas(q, saveTitle, 'pdf');
%             end
            
            
%             columnIndex = 2*(predictionCounter-1)+1;
%             size(iterationNumber)
%             iterationNumber(2:length(temp)+1, columnIndex:(columnIndex+1), windowCounter) = temp';
            predictionCounter = predictionCounter+1; %CHANGE
        end
        windowCounter = windowCounter + 1;
        predictionCounter = 3;
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
    realizedRisksMVDR = zeros(filterLength,3);
    predictedRisksMVDR = zeros(filterLength,3);
    realizedRisksMVDRavg = zeros(filterLength,3);
    predictedRisksMVDRavg = zeros(filterLength,3);
    normsAvg = zeros(filterLength,4);
    weightMatrix = zeros(numStocks, filterLength, 3);
    weightsSamp = zeros(3, numStocks);
    predictedRisksavg = zeros(3,1);
    realizedRisksavg = zeros(3,1);
    pr = zeros(3,1);
    rr = zeros(3,1);
    
    %weightMatrix = zeros(
    
    subMat = [introMatrix; prices(2: (windowLength+1), 1:(numStocks+1))];
    if windowLength ~= (length(subMat(2:end,1)))
       disp(strcat('WL:',num2str(counter),'-',num2str(length(subMat(2:end,1)))))
    end
    sampCovMat = SampleCovMatrix(numStocks, subMat, windowLength);
    weightsSamp(1,:) = MinVarPortfolio(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);
    for num = 1:3
        pr(num) = weightsSamp(num,:)*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*weightsSamp(num,:)';
        predictedRisksMVDR(:,num) = diag(weightMatrix(:,:,num)'*(sampCovMat(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,:,num));                
    end
    weightMatrix(:,:,1) = MVDREstimator(sampCovMat, numStocks, filterLength);
    weightMatrix(:,:,2) = BlockEstimator(sampCovMat, numStocks, filterLength);
    weightMatrix(:,:,3) = BlockMatrixEstimator(sampCovMat, numStocks, filterLength);

%     abspredRiskMVDR = abs(predictedRisksMVDR);
%     minPreds = (find(abspredRiskMVDR==min(abspredRiskMVDR)));
%     predictedRisks(1,counter) = minPreds(1);                               %Calculate the predicted variance of the portfolio    
    timer = 0;
%     bestIndex(2:length(percentages)+1, counter) = crossvalidate(subMat, numStocks, windowLength, filterLength, percentages);

    for a = (windowLength+2):timeRange
        if (timer == predictionLength && predictionLength <= windowLength)
            for num = 1:3
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
            for num = 1:3
                rr(num) = weightsSamp(num,:)*sampCovMat2(2:(numStocks+1),2:(numStocks+1))*weightsSamp(num,:)';
                realizedRisksMVDR(:, num) = diag(weightMatrix(:,:,num)'*(sampCovMat2(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,:,num));
            end
%             bestIndex(1,counter) = find(realizedRisksMVDR(:,1)==min(realizedRisksMVDR(:,1)));
%             bestIndex(length(percentages)+2:end,counter) = realizedRisksMVDR(round(bestIndex(2:length(percentages)+1,counter)),1) - realizedRisksMVDR(bestIndex(1,counter),1)*ones(length(percentages),1);

%             mvdrIdealIndices(counter) = find(norms==min(norms));
%             realizedRisks(1,counter) = find(realizedRisksMVDR==min(abs(realizedRisksMVDR)));     
%             GraphComparableBlock(predictedRisksMVDR, realizedRisksMVDR, windowLength, predictionLength, counter, rr, pr, date);
            counter = counter + 1;
            
            subMat = [introMatrix; subMat((predictionLength+2):end, 1:(numStocks+1)) ; prices((a-predictionLength):(a-1),1:(numStocks+1))];
            if windowLength ~= (length(subMat(2:end,1)))
                disp(strcat('WL:',num2str(counter),'-',num2str(length(subMat(2:end,1))),'-',num2str(a)))
            end
            sampCovMat = SampleCovMatrix(numStocks, subMat, windowLength);

            weightsSamp(1,:) = MinVarPortfolio(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);

            weightMatrix(:,:,1) = MVDREstimator(sampCovMat, numStocks, filterLength);
            weightMatrix(:,:,2) = BlockEstimator(sampCovMat, numStocks, filterLength);
            weightMatrix(:,:,3) = BlockMatrixEstimator(sampCovMat, numStocks, filterLength);

            for num = 1:3
                pr(num) = weightsSamp(num,:)*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*weightsSamp(num,:)';
                predictedRisksMVDR(:,num) = diag(weightMatrix(:,:,num)'*(sampCovMat(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,:,num));            
            end
            
            
%             abspredRiskMVDR = abs(predictedRisksMVDR);
%             minPreds = (find(abspredRiskMVDR==min(abspredRiskMVDR)));
%             predictedRisks(1,counter) = minPreds(1);
            
            timer = 0;
            for num = 1:3
                realizedRisksMVDRavg(:, num) = realizedRisksMVDRavg(:, num) + realizedRisksMVDR(:, num);
                realizedRisksavg(num) = realizedRisksavg(num) + rr(num);
            end
%             bestIndex(2:length(percentages)+1, counter) = crossvalidate(subMat, numStocks, predictionLength, filterLength, percentages);
        elseif (timer == windowLength && predictionLength > windowLength)
            for num = 1:3
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
            for num = 1:3
                rr(num) = weightsSamp(num,:)*sampCovMat2(2:(numStocks+1),2:(numStocks+1))*weightsSamp(num,:)';
                realizedRisksMVDR(:, num) = diag(weightMatrix(:,:,num)'*(sampCovMat2(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,:,num));
            end
%             bestIndex(1,counter) = find(realizedRisksMVDR(:,1)==min(realizedRisksMVDR(:,1)));
%             bestIndex(length(percentages)+2:end,counter) = realizedRisksMVDR(round(bestIndex(2:length(percentages)+1,counter))) - realizedRisksMVDR(bestIndex(1,counter),1)*ones(length(percentages),1);

%             mvdrIdealIndices(counter) = find(norms==min(norms));
%             realizedRisks(1,counter) = find(realizedRisksMVDR==min(abs(realizedRisksMVDR)));                               %Calculate the predicted variance of the portfolio                
%             GraphComparableBlock(predictedRisksMVDR, realizedRisksMVDR, windowLength, predictionLength, counter, rr, pr, date);

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

            weightMatrix(:,:,1) = MVDREstimator(sampCovMat, numStocks, filterLength);
            weightMatrix(:,:,2) = BlockEstimator(sampCovMat, numStocks, filterLength);
            weightMatrix(:,:,3) = BlockMatrixEstimator(sampCovMat, numStocks, filterLength);

            for num = 1:3
                pr(num) = weightsSamp(num,:)*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*weightsSamp(num,:)';
                predictedRisksMVDR(:,num) = diag(weightMatrix(:,:,num)'*(sampCovMat(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,:,num));
            end

            timer = 0;            
            for num = 1:3
                realizedRisksMVDRavg(:, num) = realizedRisksMVDRavg(:, num) + realizedRisksMVDR(:, num);
                realizedRisksavg(num) = realizedRisksavg(num) + rr(num);
            end
%             bestIndex(2:length(percentages)+1, counter) = crossvalidate(subMat, numStocks, windowLength, filterLength, percentages);
        end
        timer = timer + 1;
        
    end
    realizedRisksMVDRavg = realizedRisksMVDRavg/(counter-1);
    predictedRisksMVDRavg = predictedRisksMVDRavg/(counter-1);
    realizedRisksavg = realizedRisksavg/(counter-1);
    predictedRisksavg = predictedRisksavg/(counter-1);
    normsAvg = normsAvg/(counter-1);
    GraphComparableBlock(predictedRisksMVDRavg, realizedRisksMVDRavg, windowLength, predictionLength, 10000, realizedRisksavg, predictedRisksavg, date);

    theOutput = [mvdrIdealIndices' predictedRisks(1,1:size(realizedRisks,2))' realizedRisks'];
end
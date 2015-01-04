%xlsread('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\9EstimatorsDailyPricesClean.xlsx')

function [ bestIndex ] = FinalWindows( prices, timeRange, numStocks, date )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    format long
    iterationNumber = zeros((round(timeRange/30))+1,12,6);
    SPData = xlsread('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\S&PReturns.xlsx');
    for x = 1:6
        iterationNumber(1,:,x) = [30 0 60 0 90 0 120 0 180 0 240 0];
    end
    windowCounter = 3;
    bestIndex = zeros(6,6);
    bestIndex2 = zeros(6,6);
    predictionCounter = 3;
    averages = zeros(6,6,6,10);

    stddevs = zeros(6,6,6,10);

    windowLengths = [30 60 90 120 180 240];
    predictionLengths = [30 60 90 120 180 240];
    while (windowCounter < 7)
        while(predictionCounter < 7)
            temp = IterationsDiff(windowLengths(windowCounter), predictionLengths(predictionCounter), prices, timeRange, numStocks, SPData, date);	%Call Iterations, which computed the average predicted and realized risk for each time window of the set (In this case for a 1 month time window, there will be 132 iterations)
            averages(:,predictionCounter,windowCounter,1) = mean(temp(:,:,1),2);
            averages(:,predictionCounter,windowCounter,2) = mean(temp(:,:,2),2);
            averages(:,predictionCounter,windowCounter,3) = mean(temp(:,:,3),2);
            averages(:,predictionCounter,windowCounter,4) = mean(temp(:,:,4),2);
            averages(:,predictionCounter,windowCounter,5) = mean(temp(:,:,5),2);
            averages(:,predictionCounter,windowCounter,6) = mean(temp(:,:,6),2);
            averages(:,predictionCounter,windowCounter,7) = mean(temp(:,:,7),2);
            averages(:,predictionCounter,windowCounter,8) = mean(temp(:,:,8),2);
            averages(:,predictionCounter,windowCounter,9) = mean(temp(:,:,9),2);
            averages(:,predictionCounter,windowCounter,10) = mean(temp(:,:,10),2);
            
%             xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\averages.xlsx',averages(:,:,:,1),1);
%             xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\averages.xlsx',averages(:,:,:,2),2);
%             xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\averages.xlsx',averages(:,:,:,3),3);
%             xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\averages.xlsx',averages(:,:,:,4),4);
%             xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\averages.xlsx',averages(:,:,:,5),5);
%             xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\averages.xlsx',averages(:,:,:,6),6);
%             xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\averages.xlsx',averages(:,:,:,7),7);
%             xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\averages.xlsx',averages(:,:,:,8),8);
%             xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\averages.xlsx',averages(:,:,:,9),9);
%             xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\averages.xlsx',averages(:,:,:,10),10);
            
            
            stddevs(:,predictionCounter,windowCounter,1) = std(temp(:,:,1),0,2);
            stddevs(:,predictionCounter,windowCounter,2) = std(temp(:,:,2),0,2);
            stddevs(:,predictionCounter,windowCounter,3) = std(temp(:,:,3),0,2);
            stddevs(:,predictionCounter,windowCounter,4) = std(temp(:,:,4),0,2);
            stddevs(:,predictionCounter,windowCounter,5) = std(temp(:,:,5),0,2);
            stddevs(:,predictionCounter,windowCounter,6) = std(temp(:,:,6),0,2);
            stddevs(:,predictionCounter,windowCounter,7) = std(temp(:,:,7),0,2);
            stddevs(:,predictionCounter,windowCounter,8) = std(temp(:,:,8),0,2);
            stddevs(:,predictionCounter,windowCounter,9) = std(temp(:,:,9),0,2);
            stddevs(:,predictionCounter,windowCounter,10) = std(temp(:,:,10),0,2);
            
            bestIndex(windowCounter,predictionCounter) = find(averages(:,predictionCounter,windowCounter)==min(averages(:,predictionCounter,windowCounter)));
            bestIndex2(windowCounter,predictionCounter) = find(averages(:,predictionCounter,windowCounter)==min(averages(:,predictionCounter,windowCounter)));

            predictionCounter = 7; %CHANGE
        end
        windowCounter = 7;%CHANGE
        predictionCounter = 1;
    end
%     xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\stddevx.xlsx',stddevs(:,:,:,1),1);
%     xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\stddevx.xlsx',stddevs(:,:,:,2),2);
%     xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\stddevx.xlsx',stddevs(:,:,:,3),3);
%     xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\stddevx.xlsx',stddevs(:,:,:,4),4);
%     xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\stddevx.xlsx',stddevs(:,:,:,5),5);
%     xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\stddevx.xlsx',stddevs(:,:,:,6),6);
%     xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\stddevx.xlsx',stddevs(:,:,:,7),7);
%     xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\stddevx.xlsx',stddevs(:,:,:,8),8);
%     xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\stddevx.xlsx',stddevs(:,:,:,9),9);
%     xlswrite('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\ReportData\stddevx.xlsx',stddevs(:,:,:,10),10);
    averages
    stddevs
end

function [ bestIndex ] = IterationsDiff(windowLength, predictionLength, prices, timeRange, numStocks, SPData, date )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    introMatrix = prices(1, 1:(numStocks+1));
    percentages = [1/30 1/15 .1 1/6 .2 1/3];
    if (predictionLength <= windowLength) 
        bestIndex = zeros(2*(length(percentages))+1,round((timeRange-windowLength)/predictionLength),10);
    else
        bestIndex = zeros(2*(length(percentages))+1,round((timeRange-windowLength)/predictionLength),10);
    end
    
    counter = 1;
    realizedRisksEstimators = zeros(150,2);
    predictedRisksEstimators = zeros(150,2);
    realizedRisksEstimatorsavg = zeros(150,2);
    predictedRisksEstimatorsavg = zeros(150,2);
    weightMatrix = zeros(numStocks, 150, 2);
    weightsSamp = zeros(4, numStocks);
    predictedRisksavg = zeros(4,1);
    realizedRisksavg = zeros(4,1);
    pr = zeros(4,1);
    rr = zeros(4,1);
    
    
    subMat = [introMatrix; prices(2: (windowLength+1), 1:(numStocks+1))];
    if windowLength ~= (length(subMat(2:end,1)))
       disp(strcat('WL:',num2str(counter),'-',num2str(length(subMat(2:end,1)))))
    end
    sampCovMat = SampleCovarianceMatrixFinal(numStocks, subMat, windowLength);
    spec = SpectralEstimators(sampCovMat, numStocks, windowLength);
    rmt_o = spec(:,:,1);
    rmt_m = spec(:,:,2);
    si = SingleIndexModel(subMat, numStocks, windowLength, SPData);
    weightsSamp(1,:) = MinVarPortfolio(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);
    weightsSamp(2,:) = MinVarPortfolio(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-O covariance estimator
    weightsSamp(3,:) = MinVarPortfolio(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks); 
    weightsSamp(4,:) = MinVarPortfolio(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);    
    
    weightMatrix(:,:,1) = MVDREstimator(sampCovMat, numStocks, 150);
    weightMatrix(:,1:20,2) = BlockMatrixEstimator(sampCovMat, numStocks, 20);
    timer = 0;
    
    
    for a = (windowLength+2):timeRange
        if (timer == predictionLength && predictionLength <= windowLength)
            bestIndex(2:length(percentages)+1, counter,1) = crossvalidate(subMat, numStocks, windowLength, 150, percentages);
            bestIndex(2:length(percentages)+1, counter,2) = crossvalidateblock(subMat, numStocks, windowLength, 20, percentages);
            for num = 1:4
                if num==1
                    predictedRisksEstimatorsavg(:, num) = predictedRisksEstimatorsavg(:, num) + predictedRisksEstimators(:, num);
                elseif num==2
                    predictedRisksEstimatorsavg(1:20, num) = predictedRisksEstimatorsavg(1:20, num) + predictedRisksEstimators(1:20, num);
                end
                predictedRisksavg(num) = predictedRisksavg(num) + pr(num);
            end
            for num = 1:4
                pr(num) = sqrt(250/windowLength*weightsSamp(num,:)*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*weightsSamp(num,:)');
                if (num ==1)
                    predictedRisksEstimators(:,num) = sqrt(250/windowLength*diag(weightMatrix(:,:,num)'*(sampCovMat(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,:,num)));
                elseif (num==2)
                    predictedRisksEstimators(1:20,num) = sqrt(250/windowLength*diag(weightMatrix(:,1:20,num)'*(sampCovMat(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,1:20,num)));
                end
            end
            subMat2 = [introMatrix; prices((a-predictionLength):(a-1),1:(numStocks+1))];
            
            disp(strcat('PL:',num2str(a-predictionLength),'-',num2str(a-1)));

            sampCovMat2 = SampleCovarianceMatrixFinal(numStocks, subMat2, predictionLength);
            for num = 1:4
                rr(num) = sqrt(250/predictionLength*weightsSamp(num,:)*sampCovMat2(2:(numStocks+1),2:(numStocks+1))*weightsSamp(num,:)');
                if (num ==1)
                    realizedRisksEstimators(:,num) = sqrt(250/predictionLength*diag(weightMatrix(:,:,num)'*(sampCovMat2(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,:,num)));
                elseif (num==2)
                    realizedRisksEstimators(1:20,num) = sqrt(250/predictionLength*diag(weightMatrix(:,1:20,num)'*(sampCovMat2(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,1:20,num)));
                end
            end
            bestIndex(1,counter,1) = find(realizedRisksEstimators(:,1)==min(realizedRisksEstimators(:,1)));
            bestIndex(length(percentages)+2:end,counter,1) = realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,1)),1) - realizedRisksEstimators(bestIndex(1,counter,1),1)*ones(length(percentages),1);
            bestIndex(1,counter,2) = find(realizedRisksEstimators(1:20,2)==min(realizedRisksEstimators(1:20,2)));

            bestIndex(length(percentages)+2:end,counter,2) = realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,2)),2) - realizedRisksEstimators(bestIndex(1,counter,2),2)*ones(length(percentages),1);
            bestIndex(length(percentages)+2:end,counter,3) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,1)),1) - (rr(1)*ones(length(percentages),1)))./(rr(1)*ones(length(percentages),1));
            bestIndex(length(percentages)+2:end,counter,4) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,2)),2) - (rr(1)*ones(length(percentages),1)))./(rr(1)*ones(length(percentages),1));
            bestIndex(length(percentages)+2:end,counter,5) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,1)),1) - (rr(2)*ones(length(percentages),1)))./(rr(2)*ones(length(percentages),1));
            bestIndex(length(percentages)+2:end,counter,6) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,2)),2) - (rr(2)*ones(length(percentages),1)))./(rr(2)*ones(length(percentages),1));
            bestIndex(length(percentages)+2:end,counter,7) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,1)),1) - (rr(3)*ones(length(percentages),1)))./(rr(3)*ones(length(percentages),1));
            bestIndex(length(percentages)+2:end,counter,8) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,2)),2) - (rr(3)*ones(length(percentages),1)))./(rr(4)*ones(length(percentages),1));
            bestIndex(length(percentages)+2:end,counter,9) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,1)),1) - (rr(4)*ones(length(percentages),1)))./(rr(4)*ones(length(percentages),1));
            bestIndex(length(percentages)+2:end,counter,10) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,2)),2) - (rr(4)*ones(length(percentages),1)))./(rr(4)*ones(length(percentages),1));
%             GraphFinal(predictedRisksEstimators(1:20,2), realizedRisksEstimators(1:20,2), windowLength, predictionLength, counter, rr, pr, date, 'Block Matrix');
%             GraphFinal(predictedRisksEstimators(:,1), realizedRisksEstimators(:,1), windowLength, predictionLength, counter+50, rr, pr, date, 'MVDR AV');

            
            counter = counter + 1;
            
            subMat = [introMatrix; subMat((predictionLength+2):end, 1:(numStocks+1)) ; prices((a-predictionLength):(a-1),1:(numStocks+1))];

            sampCovMat = SampleCovarianceMatrixFinal(numStocks, subMat, windowLength);
            spec = SpectralEstimators(sampCovMat, numStocks, windowLength);
            rmt_o = spec(:,:,1);
            rmt_m = spec(:,:,2);
            si = SingleIndexModel(subMat, numStocks, windowLength, SPData);
            weightsSamp(1,:) = MinVarPortfolio(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);
            weightsSamp(2,:) = MinVarPortfolio(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-O covariance estimator
            weightsSamp(3,:) = MinVarPortfolio(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);
            weightsSamp(4,:) = MinVarPortfolio(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
            weightMatrix(:,:,1) = MVDREstimator(sampCovMat, numStocks, 150);
            weightMatrix(:,1:20,2) = BlockMatrixEstimator(sampCovMat, numStocks, 20);   
            for num = 1:4
                pr(num) = sqrt(250/windowLength*weightsSamp(num,:)*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*weightsSamp(num,:)');
                if (num ==1)
                    predictedRisksEstimators(:,num) = sqrt(250/windowLength*diag(weightMatrix(:,:,num)'*(sampCovMat(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,:,num)));
                elseif (num==2)
                    predictedRisksEstimators(1:20,num) = sqrt(250/windowLength*diag(weightMatrix(:,1:20,num)'*(sampCovMat(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,1:20,num)));
                end
            end
            
            for num = 1:4
                if num==1
                    realizedRisksEstimatorsavg(:, num) = realizedRisksEstimatorsavg(:, num) + realizedRisksEstimators(:, num);
                elseif num==2
                    realizedRisksEstimatorsavg(1:20, num) = realizedRisksEstimatorsavg(1:20, num) + realizedRisksEstimators(1:20, num);
                end
                realizedRisksavg(num) = realizedRisksavg(num) + rr(num);
            end

            timer = 0;

        elseif (timer == windowLength && predictionLength > windowLength)
            for num = 1:4
                if num==1
                    predictedRisksEstimatorsavg(:, num) = predictedRisksEstimatorsavg(:, num) + predictedRisksEstimators(:, num);
                elseif num==2
                    predictedRisksEstimatorsavg(1:20, num) = predictedRisksEstimatorsavg(1:20, num) + predictedRisksEstimators(1:20, num);
                end
                predictedRisksavg(num) = predictedRisksavg(num) + pr(num);
            end
            
            if (a+predictionLength > timeRange)
                subMat2 = [introMatrix; prices(a:end,1:(numStocks+1))];
                sampCovMat2 = SampleCovarianceMatrixFinal(numStocks, subMat2, size(subMat2,1)-1);
            else    
                subMat2 = [introMatrix; prices((a-windowLength):(a-windowLength+predictionLength-1),1:(numStocks+1))];
                sampCovMat2 = SampleCovarianceMatrixFinal(numStocks, subMat2, predictionLength);
            end

            
            for num = 1:4
                rr(num) = sqrt(250/predictionLength*weightsSamp(num,:)*sampCovMat2(2:(numStocks+1),2:(numStocks+1))*weightsSamp(num,:)');
                if (num ==1)
                    realizedRisksEstimators(:,num) = sqrt(250/predictionLength*diag(weightMatrix(:,:,num)'*(sampCovMat2(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,:,num)));
                elseif (num==2)
                    realizedRisksEstimators(1:20,num) = sqrt(250/predictionLength*diag(weightMatrix(:,1:20,num)'*(sampCovMat2(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,1:20,num)));
                end
            end
            bestIndex(1,counter,1) = find(realizedRisksEstimators(:,1)==min(realizedRisksEstimators(:,1)));
            bestIndex(length(percentages)+2:end,counter,1) = realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,1)),1) - realizedRisksEstimators(bestIndex(1,counter,1),1)*ones(length(percentages),1);
            bestIndex(1,counter,2) = find(realizedRisksEstimators(1:20,2)==min(realizedRisksEstimators(1:20,2)));
            bestIndex(length(percentages)+2:end,counter,2) = realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,2)),2) - realizedRisksEstimators(bestIndex(1,counter,2),2)*ones(length(percentages),1);
            bestIndex(length(percentages)+2:end,counter,3) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,1)),1) - (rr(1)*ones(length(percentages),1)))./(rr(1)*ones(length(percentages),1));
            bestIndex(length(percentages)+2:end,counter,4) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,2)),2) - (rr(1)*ones(length(percentages),1)))./(rr(1)*ones(length(percentages),1));
            bestIndex(length(percentages)+2:end,counter,5) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,1)),1) - (rr(2)*ones(length(percentages),1)))./(rr(2)*ones(length(percentages),1));
            bestIndex(length(percentages)+2:end,counter,6) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,2)),2) - (rr(2)*ones(length(percentages),1)))./(rr(2)*ones(length(percentages),1));
            bestIndex(length(percentages)+2:end,counter,7) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,1)),1) - (rr(3)*ones(length(percentages),1)))./(rr(3)*ones(length(percentages),1));
            bestIndex(length(percentages)+2:end,counter,8) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,2)),2) - (rr(3)*ones(length(percentages),1)))./(rr(4)*ones(length(percentages),1));
            bestIndex(length(percentages)+2:end,counter,9) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,1)),1) - (rr(4)*ones(length(percentages),1)))./(rr(4)*ones(length(percentages),1));
            bestIndex(length(percentages)+2:end,counter,10) = (realizedRisksEstimators(round(bestIndex(2:length(percentages)+1,counter,2)),2) - (rr(4)*ones(length(percentages),1)))./(rr(4)*ones(length(percentages),1));
            GraphFinal(predictedRisksEstimatorsavg(1:20,2), realizedRisksEstimatorsavg(1:20,2), windowLength, predictionLength, counter, realizedRisksavg, predictedRisksavg, date, 'Block Matrix');
            GraphFinal(predictedRisksEstimatorsavg(:,1), realizedRisksEstimatorsavg(:,1), windowLength, predictionLength, counter+50, realizedRisksavg, predictedRisksavg, date, 'MVDR AV');

            counter = counter + 1;
            
            if ((a+predictionLength) > timeRange+1)
                break;
            else    
                subMat = [introMatrix; prices((a-windowLength):(a-1), 1:(numStocks+1))];
                sampCovMat = SampleCovarianceMatrixFinal(numStocks, subMat, windowLength);
            end

            spec = SpectralEstimators(sampCovMat, numStocks, windowLength);
            rmt_o = spec(:,:,1);
            rmt_m = spec(:,:,2);
            si = SingleIndexModel(subMat, numStocks, windowLength, SPData);
            weightsSamp(1,:) = MinVarPortfolio(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks)
            weightsSamp(2,:) = MinVarPortfolio(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-O covariance estimator
            weightsSamp(3,:) = MinVarPortfolio(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);
            weightsSamp(4,:) = MinVarPortfolio(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
            weightMatrix(:,:,1) = MVDREstimator(sampCovMat, numStocks, 150);
            weightMatrix(:,1:20,2) = BlockMatrixEstimator(sampCovMat, numStocks, 20);
            for num = 1:4
                pr(num) = sqrt(250/windowLength*weightsSamp(num,:)*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*weightsSamp(num,:)');
                if (num ==1)
                    predictedRisksEstimators(:,num) = sqrt(250/windowLength*diag(weightMatrix(:,:,num)'*(sampCovMat(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,:,num)));
                elseif (num==2)
                    predictedRisksEstimators(1:20,num) = sqrt(250/windowLength*diag(weightMatrix(:,1:20,num)'*(sampCovMat(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix(:,1:20,num)));
                end
             end

            timer = 0; 
            
            for num = 1:4
                if num==1
                    realizedRisksEstimatorsavg(:, num) = realizedRisksEstimatorsavg(:, num) + realizedRisksEstimators(:, num);
                elseif num==2
                    realizedRisksEstimatorsavg(1:20, num) = realizedRisksEstimatorsavg(1:20, num) + realizedRisksEstimators(1:20, num);
                end
                realizedRisksavg(num) = realizedRisksavg(num) + rr(num);
            end
            bestIndex(2:length(percentages)+1, counter,1) = crossvalidate(subMat, numStocks, windowLength, 150, percentages);
            bestIndex(2:length(percentages)+1, counter,2) = crossvalidateblock(subMat, numStocks, windowLength, 20, percentages);
        end
        timer = timer + 1;
        
    end
    realizedRisksEstimatorsavg = realizedRisksEstimatorsavg/(counter-1);
    predictedRisksEstimatorsavg = predictedRisksEstimatorsavg/(counter-1);
    realizedRisksavg = realizedRisksavg/(counter-1);
    predictedRisksavg = predictedRisksavg/(counter-1);
    GraphFinal(predictedRisksEstimatorsavg(1:20,2), realizedRisksEstimatorsavg(1:20,2), windowLength, predictionLength, 20000, realizedRisksavg, predictedRisksavg, date, 'Block Matrix');
    GraphFinal(predictedRisksEstimatorsavg(:,1), realizedRisksEstimatorsavg(:,1), windowLength, predictionLength, 10000, realizedRisksavg, predictedRisksavg, date, 'MVDR AV');
    bestIndex = bestIndex(length(percentages)+2:end,:,:);
end
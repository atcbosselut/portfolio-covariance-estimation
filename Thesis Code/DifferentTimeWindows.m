%DifferentTimeWindows(xlsread('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\9EstimatorsDailyPricesClean.xlsx'), 2766, 84)


function [ a ] = DifferentTimeWindows(prices, timeRange, numStocks )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    format long
    temp = zeros(4,1,10);
    SPData = xlsread('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\S&PReturns.xlsx');
    annualized_risk_averages = zeros(5,6,10);					%Initializes vector where average annualized risks for each time window are stored
    for setup = 1:10
        annualized_risk_averages(1, 1:6,setup) = [30 60 90 120 180 240];	%Set the identifier as the number of months in each time window
    end
    windowCounter = 1;
    predictionCounter = 1;
    windowLengths = [30 60 90 120 180 240];
    predictionLengths = [30 60 90 120 180 240];
    while (windowCounter < 7)
        while(predictionCounter < 7)
            temp = IterationsDiff(windowLengths(windowCounter), predictionLengths(predictionCounter), prices, timeRange, numStocks, SPData)*sqrt(250/predictionLengths(windowCounter));	%Call Iterations, which computed the average predicted and realized risk for each time window of the set (In this case for a 1 month time window, there will be 132 iterations)
            annualized_risk_averages(2, predictionCounter, :) = temp(1,1,:);                       %Store the average annualized predicted risk for 1 month time windows
            annualized_risk_averages(3, predictionCounter, :) = temp(2,1,:);                       %Store the average annualized realized risk
            annualized_risk_averages(4, predictionCounter, :) = temp(3,1,:);
            annualized_risk_averages(5, predictionCounter, :) = temp(4,1,:);
            predictionCounter = predictionCounter + 1;
        end
        switch windowCounter
            case 1
                window30 = annualized_risk_averages(:,:,1:4);
            case 2
                window60 = annualized_risk_averages(:,:,1:4);
            case 3
                window90 = annualized_risk_averages(:,:,1:4);
            case 4
                window120 = annualized_risk_averages(:,:,1:4);
            case 5
                window180 = annualized_risk_averages(:,:,1:4);
            case 6
                window240 = annualized_risk_averages(:,:,1:4);
        end
        predictionCounter = 1;
        windowCounter = windowCounter + 1;
    end
    window30
    window60
    window90
    window120
    window180
    window240
    
    

    figure(1);
    scm30 = subplot(3,2,1);
    plot(predictionLengths, window30(2,:,1), '-o', predictionLengths, window30(3,:,1), '-o');
    title('Sample Covariance Matrix - 30');
    xlabel('Prediction Length');
    ylabel('risk');
    rmto30 = subplot(3,2,2);
    plot(predictionLengths, window30(2,:,2), '-o', predictionLengths, window30(3,:,2), '-o');
    title('RMT-0 - 30');
    xlabel('Prediction Length');
    ylabel('risk');
    rmtm30 = subplot(3,2,3);
    plot(predictionLengths, window30(2,:,3), '-o', predictionLengths, window30(3,:,3), '-o');
    title('RMT-M - 30');
    xlabel('Prediction Length');
    ylabel('risk');
    si30 = subplot(3,2,4);
    plot(predictionLengths, window30(2,:,4), '-o', predictionLengths, window30(3,:,4), '-o');
    title('SI - 30');
    xlabel('Prediction Length');
    ylabel('risk');
    reliability30 = zeros(5,6,4);
    reliability30(1,:,:) = window30(1,:,:);
    reliability30(2,:,:) = abs(window30(3,:,:) - window30(2,:,:));%./window30(2,:,:);
    reliability30;
    rel30 = subplot(3,2,[5 6]);
    plot(predictionLengths, reliability30(2,:,1), '-ob', predictionLengths, reliability30(2,:,2), '-og',predictionLengths, reliability30(2,:,3), '-or',predictionLengths, reliability30(2,:,4), '-oc')
    title('Reliability - Short - 60');
    xlabel('Prediction Length');
    ylabel('Reliability');
    hgsave('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\Figure30.fig');
    
    figure(2);
    scm60 = subplot(3,2,1);
    plot(predictionLengths, window60(2,:,1), '-o', predictionLengths, window60(3,:,1), '-o');
    title('Sample Covariance Matrix - 60');
    xlabel('Prediction Length');
    ylabel('risk');
    rmto60 = subplot(3,2,2);
    plot(predictionLengths, window60(2,:,2), '-o', predictionLengths, window60(3,:,2), '-o');
    title('RMT-0 - 60');
    xlabel('Prediction Length');
    ylabel('risk');
    rmtm60 = subplot(3,2,3);
    plot(predictionLengths, window60(2,:,3), '-o', predictionLengths, window60(3,:,3), '-o');
    title('RMT-M - 60');
    xlabel('Prediction Length');
    ylabel('risk');
    si60 = subplot(3,2,4);
    plot(predictionLengths, window60(2,:,4), '-o', predictionLengths, window60(3,:,4), '-o');
    title('SI - 60');
    xlabel('Prediction Length');
    ylabel('risk');
    reliability60 = zeros(5,6,4);
    reliability60(1,:,:) = window60(1,:,:);
    reliability60(2,:,:) = abs(window60(3,:,:) - window60(2,:,:));%./window60(2,:,:);
    reliability60;
    rel60 = subplot(3,2,[5 6]);
    plot(predictionLengths, reliability60(2,:,1), '-ob', predictionLengths, reliability60(2,:,2), '-og',predictionLengths, reliability60(2,:,3), '-or',predictionLengths, reliability60(2,:,4), '-oc')
    title('Reliability - Short - 60');
    xlabel('Prediction Length');
    ylabel('Reliability');
    hgsave('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\Figure60.fig');
    
    figure(3);
    scm90 = subplot(3,2,1);
    plot(predictionLengths, window90(2,:,1), '-ob', predictionLengths, window90(3,:,1), '-og', predictionLengths, window90(4,:,1), '-oc', predictionLengths, window90(5,:,1), '-or');
    title('Sample Covariance Matrix - 90');
    xlabel('Prediction Length');
    ylabel('risk');
    rmto90 = subplot(3,2,2);
    plot(predictionLengths, window90(2,:,2), '-ob', predictionLengths, window90(3,:,2), '-og', predictionLengths, window90(4,:,2), '-oc', predictionLengths, window90(5,:,2), '-or');
    title('RMT-0 - 90');
    xlabel('Prediction Length');
    ylabel('risk');
    rmtm90 = subplot(3,2,3);
    plot(predictionLengths, window90(2,:,3), '-ob', predictionLengths, window90(3,:,3), '-og', predictionLengths, window90(4,:,3), '-oc', predictionLengths, window90(5,:,3), '-or');
    title('RMT-M - 90');
    xlabel('Prediction Length');
    ylabel('risk');
    si90 = subplot(3,2,4);
    plot(predictionLengths, window90(2,:,4), '-ob', predictionLengths, window90(3,:,4), '-og', predictionLengths, window90(4,:,4), '-oc', predictionLengths, window90(5,:,4), '-or');
    title('SI - 90');
    xlabel('Prediction Length');
    ylabel('risk');
    reliability90 = zeros(5,6,4);
    reliability90(1,:,:) = window60(1,:,:);
    reliability90(2,:,:) = abs(window90(3,:,:) - window90(2,:,:));%./window90(2,:,:);
    reliability90(3,:,:) = abs(window90(5,:,:) - window90(4,:,:));%./window90(4,:,:);
    reliability90;
    rel90 = subplot(3,2,5);
    plot(predictionLengths, reliability90(2,:,1), '-ob', predictionLengths, reliability90(2,:,2), '-og',predictionLengths, reliability90(2,:,3), '-or',predictionLengths, reliability90(2,:,4), '-oc')
    title('Reliability - Short - 90');
    xlabel('Prediction Length');
    ylabel('Reliability');
    rel90ns = subplot(3,2,6);
    plot(predictionLengths, reliability90(3,:,1), '-ob', predictionLengths, reliability90(3,:,2), '-og',predictionLengths, reliability90(3,:,3), '-or',predictionLengths, reliability90(3,:,4), '-oc')
    title('Reliability - No Short - 90');
    xlabel('Prediction Length');
    ylabel('Reliability');
    hgsave('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\Figure90.fig');
    
    figure(4);
    scm120 = subplot(3,2,1);
    plot(predictionLengths, window120(2,:,1), '-ob', predictionLengths, window120(3,:,1), '-og', predictionLengths, window120(4,:,1), '-oc', predictionLengths, window120(5,:,1), '-or');
    title('Sample Covariance Matrix - 120');
    xlabel('Prediction Length');
    ylabel('risk');
    rmto120 = subplot(3,2,2);
    plot(predictionLengths, window120(2,:,2), '-ob', predictionLengths, window120(3,:,2), '-og', predictionLengths, window120(4,:,2), '-oc', predictionLengths, window120(5,:,2), '-or');
    title('RMT-0 - 120');
    xlabel('Prediction Length');
    ylabel('risk');
    rmtm120 = subplot(3,2,3);
    plot(predictionLengths, window120(2,:,3), '-ob', predictionLengths, window120(3,:,3), '-og', predictionLengths, window120(4,:,3), '-oc', predictionLengths, window120(5,:,3), '-or');
    title('RMT-M - 120');
    xlabel('Prediction Length');
    ylabel('risk');
    si120 = subplot(3,2,4);
    plot(predictionLengths, window120(2,:,4), '-ob', predictionLengths, window120(3,:,4), '-og', predictionLengths, window120(4,:,4), '-oc', predictionLengths, window120(5,:,4), '-or');
    title('SI - 120');
    xlabel('Prediction Length');
    ylabel('risk');
    reliability120 = zeros(5,6,4);
    reliability120(1,:,:) = window60(1,:,:);
    reliability120(2,:,:) = abs(window120(3,:,:) - window120(2,:,:));%./window120(2,:,:);
    reliability120(3,:,:) = abs(window120(5,:,:) - window120(4,:,:));%./window120(4,:,:);
    reliability120;
    rel120 = subplot(3,2,5);
    plot(predictionLengths, reliability120(2,:,1), '-ob', predictionLengths, reliability120(2,:,2), '-og',predictionLengths, reliability120(2,:,3), '-or',predictionLengths, reliability120(2,:,4), '-oc')
    title('Reliability - Short - 120');
    xlabel('Prediction Length');
    ylabel('Reliability');
    rel120ns = subplot(3,2,6);
    plot(predictionLengths, reliability120(3,:,1), '-ob', predictionLengths, reliability120(3,:,2), '-og',predictionLengths, reliability120(3,:,3), '-or',predictionLengths, reliability120(3,:,4), '-oc')
    title('Reliability - No Short - 120');
    xlabel('Prediction Length');
    ylabel('Reliability');
    hgsave('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\Figure120.fig');
    
    figure(5);
    scm180 = subplot(3,2,1);
    plot(predictionLengths, window180(2,:,1), '-ob', predictionLengths, window180(3,:,1), '-og', predictionLengths, window180(4,:,1), '-oc', predictionLengths, window180(5,:,1), '-or');
    title('Sample Covariance Matrix - 180');
    xlabel('Prediction Length');
    ylabel('risk');
    rmto180 = subplot(3,2,2);
    plot(predictionLengths, window180(2,:,2), '-ob', predictionLengths, window180(3,:,2), '-og', predictionLengths, window180(4,:,2), '-oc', predictionLengths, window180(5,:,2), '-or');
    title('RMT-0 - 180');
    xlabel('Prediction Length');
    ylabel('risk');
    rmtm180 = subplot(3,2,3);
    plot(predictionLengths, window180(2,:,3), '-ob', predictionLengths, window180(3,:,3), '-og', predictionLengths, window180(4,:,3), '-oc', predictionLengths, window180(5,:,3), '-or');
    title('RMT-M - 180');
    xlabel('Prediction Length');
    ylabel('risk');
    si180 = subplot(3,2,4);
    plot(predictionLengths, window180(2,:,4), '-ob', predictionLengths, window180(3,:,4), '-og', predictionLengths, window180(4,:,4), '-oc', predictionLengths, window180(5,:,4), '-or');
    title('SI - 180');
    xlabel('Prediction Length');
    ylabel('risk');
    reliability180 = zeros(5,6,4);
    reliability180(1,:,:) = window60(1,:,:);
    reliability180(2,:,:) = abs(window180(3,:,:) - window180(2,:,:));%./window180(2,:,:);
    reliability180(3,:,:) = abs(window180(5,:,:) - window180(4,:,:));%./window180(4,:,:);
    reliability180;
    rel180 = subplot(3,2,5);
    plot(predictionLengths, reliability180(2,:,1), '-ob', predictionLengths, reliability180(2,:,2), '-og',predictionLengths, reliability180(2,:,3), '-or',predictionLengths, reliability180(2,:,4), '-oc')
    title('Reliability - Short - 180');
    xlabel('Prediction Length');
    ylabel('Reliability');
    rel180ns = subplot(3,2,6);
    plot(predictionLengths, reliability180(3,:,1), '-ob', predictionLengths, reliability180(3,:,2), '-og',predictionLengths, reliability180(3,:,3), '-or',predictionLengths, reliability180(3,:,4), '-oc')
    title('Reliability - No Short - 180');
    xlabel('Prediction Length');
    ylabel('Reliability');
    hgsave('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\Figure180.fig');
    
    figure(6);
    scm240 = subplot(3,2,1);
    plot(predictionLengths, window240(2,:,1), '-ob', predictionLengths, window240(3,:,1), '-og', predictionLengths, window240(4,:,1), '-oc', predictionLengths, window240(5,:,1), '-or');
    title('Sample Covariance Matrix - 240');
    xlabel('Prediction Length');
    ylabel('risk');
    rmto240 = subplot(3,2,2);
    plot(predictionLengths, window240(2,:,2), '-ob', predictionLengths, window240(3,:,2), '-og', predictionLengths, window240(4,:,2), '-oc', predictionLengths, window240(5,:,2), '-or');
    title('RMT-0 - 240');
    xlabel('Prediction Length');
    ylabel('risk');
    rmtm240 = subplot(3,2,3);
    plot(predictionLengths, window240(2,:,3), '-ob', predictionLengths, window240(3,:,3), '-og', predictionLengths, window240(4,:,3), '-oc', predictionLengths, window240(5,:,3), '-or');
    title('RMT-M - 240');
    xlabel('Prediction Length');
    ylabel('risk');
    si240 = subplot(3,2,4);
    plot(predictionLengths, window240(2,:,4), '-ob', predictionLengths, window240(3,:,4), '-og', predictionLengths, window240(4,:,4), '-oc', predictionLengths, window240(5,:,4), '-or');
    title('SI - 240');
    xlabel('Prediction Length');
    ylabel('risk');
    reliability240 = zeros(5,6,4);
    reliability240(1,:,:) = window60(1,:,:);
    reliability240(2,:,:) = abs(window240(3,:,:) - window240(2,:,:));%./window240(2,:,:);
    reliability240(3,:,:) = abs(window240(5,:,:) - window240(4,:,:));%./window240(4,:,:);
    reliability240;
    rel240 = subplot(3,2,5);
    plot(predictionLengths, reliability240(2,:,1), '-ob', predictionLengths, reliability240(2,:,2), '-og',predictionLengths, reliability240(2,:,3), '-or',predictionLengths, reliability240(2,:,4), '-oc')
    title('Reliability - Short - 120');
    xlabel('Prediction Length');
    ylabel('Reliability');
    rel40ns = subplot(3,2,6);
    plot(predictionLengths, reliability240(3,:,1), '-ob', predictionLengths, reliability240(3,:,2), '-og',predictionLengths, reliability240(3,:,3), '-or',predictionLengths, reliability240(3,:,4), '-oc')
    title('Reliability - No Short - 120');
    xlabel('Prediction Length');
    ylabel('Reliability');
    hgsave('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\Data Charts\Figure240.fig');
    
    a = annualized_risk_averages(:,:,1:4);
end

function [ risk_averages ] = IterationsDiff(windowLength, predictionLength, prices, timeRange, numStocks, SPData )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    risk_averages = zeros(4,1,10);
    introMatrix = prices(1, 1:(numStocks+1));
    if (predictionLength <= windowLength)
        predictedRisks = zeros(1,round((timeRange-windowLength)/predictionLength));
        realizedRisks = zeros(1,round((timeRange-windowLength)/predictionLength));
        predictedRisksNoShort = zeros(1,round((timeRange-windowLength)/predictionLength));
        realizedRisksNoShort = zeros(1,round((timeRange-windowLength)/predictionLength));
    else
        predictedRisks = zeros(1,round((timeRange-predictionLength)/windowLength));
        realizedRisks = zeros(1,round((timeRange-predictionLength)/windowLength));
        predictedRisksNoShort = zeros(1,round((timeRange-predictionLength)/windowLength));
        realizedRisksNoShort = zeros(1,round((timeRange-predictionLength)/windowLength));
    end
    counter = 1;
    weightsNoShort = [];
    subMat = [introMatrix; prices(2: (windowLength+1), 1:(numStocks+1))];
    sampCovMat = SampleCovMatrix(numStocks, subMat, windowLength);
    spec = SpectralEstimators(sampCovMat, numStocks, windowLength);
    rmt_o = spec(:,:,1);
    rmt_m = spec(:,:,2);
    si = SingleIndexModel(subMat, numStocks, windowLength, SPData);
    weights = MinVarPortfolio(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                         %Get the weights of the minimum variance portfolio for the sample covariance matrix
    weights_rmt_o = MinVarPortfolio(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-O covariance estimator
    weights_rmt_m = MinVarPortfolio(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-M covariance estimator
    weights_si = MinVarPortfolio(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
    predictedRisks(1,counter) = weights*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights.');                               %Calculate the predicted variance of the portfolio    
    predictedRisks(2,counter) = weights_rmt_o*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o.');                        %Calculate the predicted variance of the portfolio for the RMT-O covariance estimator    
    predictedRisks(3,counter) = weights_rmt_m*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m.');                        %Calculate the predicted variance of the portfolio for the RMT-M covariance estimator
    predictedRisks(4,counter) = weights_si*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si.');
    if (windowLength > numStocks)
        weightsNoShort = NoShortingMinVarPort(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);     					%Get the weights of the no shorting minimum variance portfolio
        weights_rmt_o_ns = NoShortingMinVarPort(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                            %Get the weights of the no shorting minimum variance portfolio        
        weights_rmt_m_ns = NoShortingMinVarPort(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);                            %Get the weights of the no shorting minimum variance portfolio
        weights_si_ns = NoShortingMinVarPort(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
        predictedRisksNoShort(1,counter) = weightsNoShort*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weightsNoShort.');   	%Calculate the predicted variance of the no shorting portfolio for the sample covariance matrix
        predictedRisksNoShort(2,counter) = weights_rmt_o_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o_ns.');       %Calculate the predicted variance of the no shorting portfolio for the RMT-O covariance estimator
        predictedRisksNoShort(3,counter) = weights_rmt_m_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m_ns.');       %Calculate the predicted variance of the no shorting portfolio for the RMT-M covariance estimator
        predictedRisksNoShort(4,counter) = weights_si_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si_ns.');
    end
    timer = 0;
    for a = (windowLength+2):timeRange
        timer = timer + 1;
        if (timer == predictionLength && predictionLength <= windowLength)
            subMat2 = [introMatrix; prices((a-predictionLength):a,1:(numStocks+1))];
            sampCovMat2 = SampleCovMatrix(numStocks, subMat2, predictionLength);
            realizedRisks(1,counter) = weights*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weights.');                               %Calculate the predicted variance of the portfolio    
            realizedRisks(2,counter) = weights_rmt_o*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o.');
            realizedRisks(3,counter) = weights_rmt_m*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m.');
            realizedRisks(4,counter) = weights_si*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weights_si.');
            if (windowLength > numStocks)
                realizedRisksNoShort(1,counter) = weightsNoShort*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weightsNoShort.');   	%Calculate the predicted variance of the no shorting portfolio for the sample covariance matrix
                realizedRisksNoShort(2,counter) = weights_rmt_o_ns*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o_ns.');
                realizedRisksNoShort(3,counter) = weights_rmt_m_ns*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m_ns.');
                realizedRisksNoShort(4,counter) = weights_si_ns*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weights_si.');
            end
            counter = counter + 1;
            subMat = [introMatrix; subMat((predictionLength+2):end, 1:(numStocks+1)) ; prices((a-predictionLength+1):a,1:(numStocks+1))];
            subMat
            sampCovMat = SampleCovMatrix(numStocks, subMat, windowLength);
            spec = SpectralEstimators(sampCovMat, numStocks, windowLength);
            rmt_o = spec(:,:,1);
            rmt_m = spec(:,:,2);
            si = SingleIndexModel(subMat, numStocks, windowLength, SPData);
            weights = MinVarPortfolio(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                         %Get the weights of the minimum variance portfolio for the sample covariance matrix
            weights_rmt_o = MinVarPortfolio(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-O covariance estimator
            weights_rmt_m = MinVarPortfolio(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-M covariance estimator
            weights_si = MinVarPortfolio(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
            predictedRisks(1,counter) = weights*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights.');                               %Calculate the predicted variance of the portfolio    
            predictedRisks(2,counter) = weights_rmt_o*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o.');                        %Calculate the predicted variance of the portfolio for the RMT-O covariance estimator
            predictedRisks(3,counter) = weights_rmt_m*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m.');                        %Calculate the predicted variance of the portfolio for the RMT-M covariance estimator
            predictedRisks(4,counter) = weights_si*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si.');
            if (windowLength > numStocks)
                weightsNoShort = NoShortingMinVarPort(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);     					%Get the weights of the no shorting minimum variance portfolio
                weights_rmt_o_ns = NoShortingMinVarPort(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                            %Get the weights of the no shorting minimum variance portfolio
                weights_rmt_m_ns = NoShortingMinVarPort(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);                            %Get the weights of the no shorting minimum variance portfolio
                weights_si_ns = NoShortingMinVarPort(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
                predictedRisksNoShort(1,counter) = weightsNoShort*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weightsNoShort.');   	%Calculate the predicted variance of the no shorting portfolio for the sample covariance matrix
                predictedRisksNoShort(2,counter) = weights_rmt_o_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o_ns.');       %Calculate the predicted variance of the no shorting portfolio for the RMT-O covariance estimator
                predictedRisksNoShort(3,counter) = weights_rmt_m_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m_ns.');       %Calculate the predicted variance of the no shorting portfolio for the RMT-M covariance estimator
                predictedRisksNoShort(4,counter) = weights_si_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si_ns.');
            end          
            timer = 0;
            predictionLength
            windowLength 
        elseif (timer == windowLength && predictionLength > windowLength)
            if (a+predictionLength > timeRange)
                subMat2 = [introMatrix; prices(a:end,1:(numStocks+1))];
                sampCovMat2 = SampleCovMatrix(numStocks, subMat2, size(subMat2,1)-1);
            else    
                subMat2 = [introMatrix; prices(a:(a+predictionLength),1:(numStocks+1))];
                sampCovMat2 = SampleCovMatrix(numStocks, subMat2, predictionLength);
            end
            realizedRisks(1,counter) = weights*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weights.');                               %Calculate the predicted variance of the portfolio    
            realizedRisks(2,counter) = weights_rmt_o*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o.');
            realizedRisks(3,counter) = weights_rmt_m*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m.');
            realizedRisks(4,counter) = weights_si*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weights_si.');
            if (windowLength > numStocks)
                realizedRisksNoShort(1,counter) = weightsNoShort*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weightsNoShort.');   	%Calculate the predicted variance of the no shorting portfolio for the sample covariance matrix
                realizedRisksNoShort(2,counter) = weights_rmt_o_ns*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o_ns.');
                realizedRisksNoShort(3,counter) = weights_rmt_m_ns*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m_ns.');
                realizedRisksNoShort(4,counter) = weights_si_ns*sampCovMat2(2:(numStocks+1), 2:(numStocks+1))*(weights_si.');
            end
            counter = counter + 1;
            if ((a+predictionLength) > timeRange+1)
                break;
            else    
                subMat = [introMatrix; prices(a:(a+windowLength), 1:(numStocks+1))];
                sampCovMat = SampleCovMatrix(numStocks, subMat, windowLength);
            end
            spec = SpectralEstimators(sampCovMat, numStocks, windowLength);
            rmt_o = spec(:,:,1);
            rmt_m = spec(:,:,2);
            si = SingleIndexModel(subMat, numStocks, size(subMat, 1)-1, SPData);
            weights = MinVarPortfolio(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                         %Get the weights of the minimum variance portfolio for the sample covariance matrix
            weights_rmt_o = MinVarPortfolio(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-O covariance estimator
            weights_rmt_m = MinVarPortfolio(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-M covariance estimator
            weights_si = MinVarPortfolio(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
            predictedRisks(1,counter) = weights*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights.');                               %Calculate the predicted variance of the portfolio    
            predictedRisks(2,counter) = weights_rmt_o*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o.');                        %Calculate the predicted variance of the portfolio for the RMT-O covariance estimator
            predictedRisks(3,counter) = weights_rmt_m*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m.');                        %Calculate the predicted variance of the portfolio for the RMT-M covariance estimator
            predictedRisks(4,counter) = weights_si*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si.');
            if (windowLength > numStocks)
                weightsNoShort = NoShortingMinVarPort(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);     					%Get the weights of the no shorting minimum variance portfolio
                weights_rmt_o_ns = NoShortingMinVarPort(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                            %Get the weights of the no shorting minimum variance portfolio
                weights_rmt_m_ns = NoShortingMinVarPort(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);                            %Get the weights of the no shorting minimum variance portfolio
                weights_si_ns = NoShortingMinVarPort(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
                predictedRisksNoShort(1,counter) = weightsNoShort*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weightsNoShort.');   	%Calculate the predicted variance of the no shorting portfolio for the sample covariance matrix
                predictedRisksNoShort(2,counter) = weights_rmt_o_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o_ns.');       %Calculate the predicted variance of the no shorting portfolio for the RMT-O covariance estimator
                predictedRisksNoShort(3,counter) = weights_rmt_m_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m_ns.');       %Calculate the predicted variance of the no shorting portfolio for the RMT-M covariance estimator
                predictedRisksNoShort(4,counter) = weights_si_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si_ns.');
            end          
            timer = 0;
            predictionLength
            windowLength 
        end
              
    end
    predicted_risk_average = sqrt(mean(predictedRisks,2));                      %Average predicted risk by the optimization
    realized_risk_average = sqrt(mean(realizedRisks,2));                        %Convert variances to risks 
    if (windowLength > numStocks)
        predicted_risk_average_no_short = sqrt(mean(predictedRisksNoShort,2));      %Average predicted risk by the optimization
        realized_risk_average_no_short = sqrt(mean(realizedRisksNoShort,2));		%Convert variances to risks 
    else
        predicted_risk_average_no_short = zeros(10);
        realized_risk_average_no_short = zeros(10);
    end
    risk_averages(:,:,1) = [predicted_risk_average(1); realized_risk_average(1); predicted_risk_average_no_short(1); realized_risk_average_no_short(1)]; %and store it in an array that will be returned
    risk_averages(:,:,2) = [predicted_risk_average(2); realized_risk_average(2); predicted_risk_average_no_short(2); realized_risk_average_no_short(2)]; %and store it in an array that will be returned
    risk_averages(:,:,3) = [predicted_risk_average(3); realized_risk_average(3); predicted_risk_average_no_short(3); realized_risk_average_no_short(3)]; %and store it in an array that will be returned
    risk_averages(:,:,4) = [predicted_risk_average(4); realized_risk_average(4); predicted_risk_average_no_short(4); realized_risk_average_no_short(4)];
end
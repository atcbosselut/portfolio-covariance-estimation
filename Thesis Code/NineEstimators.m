%NineEstimators(xlsread('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\9EstimatorsDailyPricesClean.xlsx'), 2767, 84)



function [ annualized_risk_averages ] = NineEstimators( prices, timeRange, numStocks )
    SPData = xlsread('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\S&PReturns.xlsx');
    format long
    temp = zeros(4,1,10);
    annualized_risk_averages = zeros(5,7,10);					%Initializes vector where average annualized risks for each time window are stored
    for setup = 1:10
        annualized_risk_averages(1, 1:7,setup) = [1 2 3 6 9 12 24];	%Set the identifier as the number of months in each time window
    end
    %Time Window 1 month
    temp = Iterations(132, prices, timeRange, numStocks, SPData)*sqrt(12);	%Call Iterations, which computed the average predicted and realized risk for each time window of the set (In this case for a 1 month time window, there will be 132 iterations)
    annualized_risk_averages(2, 1, :) = temp(1,1,:);                       %Store the average annualized predicted risk for 1 month time windows
    annualized_risk_averages(3, 1, :) = temp(2,1,:);                       %Store the average annualized realized risk
    annualized_risk_averages(4, 1, :) = temp(3,1,:);
    annualized_risk_averages(5, 1, :) = temp(4,1,:);
    
    %Time Window 2 months
    temp = Iterations(66, prices, timeRange, numStocks, SPData)*sqrt(6);	%A Time Window of 2 months leaves 66 iterations to be completed
    annualized_risk_averages(2, 2,:) = temp(1,1,:);		%Annualize the returned risk from a two month time window
    annualized_risk_averages(3, 2,:) = temp(2,1,:);
    annualized_risk_averages(4, 2,:) = temp(3,1,:);
    annualized_risk_averages(5, 2,:) = temp(4,1,:);
    
    %Time Window 3 months
    temp = Iterations(44, prices, timeRange, numStocks, SPData)*sqrt(4);	%A Time Window of 3 months leaves 44 iterations to be completed
    annualized_risk_averages(2, 3,:) = temp(1,1,:);		%Annualize the returned risk from a three month time window
    annualized_risk_averages(3, 3,:) = temp(2,1,:);
    annualized_risk_averages(4, 3,:) = temp(3,1,:);
    annualized_risk_averages(5, 3,:) = temp(4,1,:);
    
    %Time Window 6 months
    temp = Iterations(22, prices, timeRange, numStocks, SPData)*sqrt(2);	%A Time Window of 6 months leaves 22 iterations to be completed
    annualized_risk_averages(2, 4,:) = temp(1,1,:);		%Annualize the returned risk from a six month time window
    annualized_risk_averages(3, 4,:) = temp(2,1,:);
    annualized_risk_averages(4, 4,:) = temp(3,1,:);
    annualized_risk_averages(5, 4,:) = temp(4,1,:);
  
    %Time Window 9 months  
    temp = Iterations(14, prices, timeRange, numStocks, SPData)*sqrt(4/3);	%A Time Window of 9 months leaves 14 iterations to be completed
    annualized_risk_averages(2, 5,:) = temp(1,1,:);		%Annualize the returned risk from a nine month time window
    annualized_risk_averages(3, 5,:) = temp(2,1,:);
    annualized_risk_averages(4, 5,:) = temp(3,1,:);
    annualized_risk_averages(5, 5,:) = temp(4,1,:);
    
    %Time Window 12 months
    temp = Iterations(11, prices, timeRange, numStocks, SPData);	% A Time Window of 1 year leaves 11 iterations to be completed
    annualized_risk_averages(2, 6,:) = temp(1,1,:);
    annualized_risk_averages(3, 6,:) = temp(2,1,:);
    annualized_risk_averages(4, 6,:) = temp(3,1,:);
    annualized_risk_averages(5, 6,:) = temp(4,1,:);
    
    %Time Window 24 months
    temp = Iterations(9, prices, timeRange, numStocks, SPData)*sqrt(1/2);
    annualized_risk_averages(2, 7,:) = temp(1,1,:);
    annualized_risk_averages(3, 7,:) = temp(2,1,:);
    annualized_risk_averages(4, 7,:) = temp(3,1,:);
    annualized_risk_averages(5, 7,:) = temp(4,1,:);
%     
    annualized_risk_averages

    
    axis equal
    plot(annualized_risk_averages(1, 1:7),annualized_risk_averages(5, 1:7));
    hold
    plot(annualized_risk_averages(1, 1:7),annualized_risk_averages(3, 1:7));
end

function [risk_averages] = Iterations(numIterations, prices, timeRange, numStocks, SPData)
    risk_averages = zeros(4,1,10);
    introMatrix = prices(1, 1:(numStocks+1));
    predictedRisks = zeros(1,numIterations-2,10);
    realizedRisks = zeros(1,numIterations-2,10);
    predictedRisksNoShort = zeros(1,numIterations-2,10);
    realizedRisksNoShort = zeros(1,numIterations-2,10);
    modFactor = 132/numIterations;
    base = 2;
    counter = 0;
    weights = [];
    weightsNoShort = [];
    if (modFactor < 14) %Applies to time windows of 1, 2, 3, 6, 9 and 12 months
        timer = 0;
        for a = 2:timeRange
            if (a > 2) && (floor(round(mod(prices(a,1),2000)/100))) ~= (floor(round(mod(prices(a-1,1),2000)/100)))   %If the time window ends
                timer = timer + 1;
                if (timer == floor(modFactor))
                    subMat = [introMatrix; prices(base:a-1, 1:(numStocks+1))];
                    sampCovMat = SampleCovMatrix(numStocks, subMat, a-base); 													%calculate the sample covariance matrix
                    spec = SpectralEstimators(sampCovMat, numStocks, a-base);
                    rmt_o = spec(:,:,1);
                    rmt_m = spec(:,:,2);
                    si = SingleIndexModel([introMatrix; prices(base:a-1,1:(numStocks+1))], numStocks, a-base, SPData); 
                    if (counter > 0)
                        realizedRisks(1,counter) = weights*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights.');   			%Calculate the realized risk of the portfolio from the previous optimization
                        realizedRisks(2,counter) = weights_rmt_o*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o.');
                        realizedRisks(3,counter) = weights_rmt_m*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m.');
                        realizedRisks(4,counter) = weights_si*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si.');
                        if modFactor >= 6
                            realizedRisksNoShort(1,counter) = weightsNoShort*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weightsNoShort.');
                            realizedRisksNoShort(2,counter) = weights_rmt_o_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o_ns.');
                            realizedRisksNoShort(3,counter) = weights_rmt_m_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m_ns.');
                            realizedRisksNoShort(4,counter) = weights_si_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si_ns.');
                        end
                    end
                    counter = counter + 1;
                    weights = MinVarPortfolio(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                         %Get the weights of the minimum variance portfolio for the sample covariance matrix
                    weights_rmt_o = MinVarPortfolio(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-O covariance estimator
                    weights_rmt_m = MinVarPortfolio(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-M covariance estimator
                    weights_si = MinVarPortfolio(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
                    if (modFactor >= 6)
                        weightsNoShort = NoShortingMinVarPort(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);     					%Get the weights of the no shorting minimum variance portfolio
                        weights_rmt_o_ns = NoShortingMinVarPort(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                            %Get the weights of the no shorting minimum variance portfolio
                        weights_rmt_m_ns = NoShortingMinVarPort(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);                            %Get the weights of the no shorting minimum variance portfolio
                        weights_si_ns = NoShortingMinVarPort(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
                        sum(weightsNoShort);
                    end
                    if (counter < numIterations-1)
                        predictedRisks(1,counter) = weights*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights.');                               %Calculate the predicted variance of the portfolio for the sample covariance matrix
                        predictedRisks(2,counter) = weights_rmt_o*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o.');                        %Calculate the predicted variance of the portfolio for the RMT-O covariance estimator
                        predictedRisks(3,counter) = weights_rmt_m*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m.');                        %Calculate the predicted variance of the portfolio for the RMT-M covariance estimator
                        predictedRisks(4,counter) = weights_si*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si.');
                        if modFactor >= 6
                            predictedRisksNoShort(1,counter) = weightsNoShort*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weightsNoShort.');   	%Calculate the predicted variance of the no shorting portfolio for the sample covariance matrix
                            predictedRisksNoShort(2,counter) = weights_rmt_o_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o_ns.');       %Calculate the predicted variance of the no shorting portfolio for the RMT-O covariance estimator
                            predictedRisksNoShort(3,counter) = weights_rmt_m_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m_ns.');       %Calculate the predicted variance of the no shorting portfolio for the RMT-M covariance estimator
                            predictedRisksNoShort(4,counter) = weights_si_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si_ns.');
                        end
                    end
                    base = a;                                                                                   			%Do next Time Window
                    timer = 0;
                end             
            end
        end
    elseif floor(modFactor) == 14			%Time Window of 2 years
        timer = 0;
        for a = 2:timeRange
            if (a > 2) && (floor(mod(prices(a,1),100000)/10000) ~= floor(mod(prices(a-1,1),100000)/10000))   			%If the time window ends
                timer = timer + 1;
                if (timer == 2)
                    subMat = [introMatrix; prices(base:a-1, 1:(numStocks+1))];
                    sampCovMat = SampleCovMatrix(numStocks, subMat, a-base); 												%calculate the sample covariance matrix
                    spec = SpectralEstimators(sampCovMat, numStocks, a-base);
                    rmt_o = spec(:,:,1);
                    rmt_m = spec(:,:,2);
                    si = SingleIndexModel(subMat, numStocks, a-base, SPData); 
                    if (counter > 0)
                        realizedRisks(1,counter) = weights*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights.');                            %Calculate the realized variance of the portfolio from the previous optimization
                        realizedRisks(2,counter) = weights_rmt_o*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o.');                %Calculate the realized variance of the portfolio for the RMT-O covariance estimator
                        realizedRisks(3,counter) = weights_rmt_m*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m.');                %Calculate the realized variance of the portfolio for the RMT-M covariance estimator
                        realizedRisks(4,counter) = weights_si*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si.');
                        realizedRisksNoShort(1,counter) = weightsNoShort*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weightsNoShort.');       %Calculate the realized variance of the no shorting portfolio for the sample covariance matrix
                        realizedRisksNoShort(2,counter) = weights_rmt_o_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o_ns.');   %Calculate the realized variance of the no shorting portfolio for the RMT-O covariance estimator
                        realizedRisksNoShort(3,counter) = weights_rmt_m_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m_ns.');   %Calculate the realized variance of the no shorting portfolio for the RMT-M covariance estimator
                        realizedRisksNoShort(4,counter) = weights_si_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si_ns.');
                    end
                    counter = counter + 1;
                    weights = MinVarPortfolio(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                         %Get the weights of the minimum variance portfolio for the sample covariance matrix
                    weights_rmt_o = MinVarPortfolio(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-O covariance estimator
                    weights_rmt_m = MinVarPortfolio(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                        %Get the weights of the minimum variance portfolio for the RMT-M covariance estimator
                    weights_si = MinVarPortfolio(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
                    weightsNoShort = NoShortingMinVarPort(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);                             %Get the weights of the no shorting minimum variance portfolio for the sample covariance matrix
                    weights_rmt_o_ns = NoShortingMinVarPort(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                %Get the weights of the no shorting minimum variance portfolio for the RMT-O covariance estimator
                    weights_rmt_m_ns = NoShortingMinVarPort(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);                                %Get the weights of the no shorting minimum variance portfolio for the RMT-M covariance estimator
                    weights_si_ns = NoShortingMinVarPort(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
                    if (counter < numIterations-1)
                        predictedRisks(1,counter) = weights*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights.');                           %Calculate the predicted variance of the portfolio for the sample covariance matrix
                        predictedRisks(2,counter) = weights_rmt_o*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o.');                    %Calculate the predicted variance of the portfolio for the RMT-O covariance estimator
                        predictedRisks(3,counter) = weights_rmt_m*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m.');                    %Calculate the predicted variance of the portfolio for the RMT-M covariance estimator
                        predictedRisks(4,counter) = weights_si*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si.');
                        predictedRisksNoShort(1,counter) = weightsNoShort*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weightsNoShort.');   	%Calculate the predicted variance of the no shorting portfolio for the sample covariance matrix
                        predictedRisksNoShort(2,counter) = weights_rmt_o_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o_ns.');       %Calculate the predicted variance of the no shorting portfolio for the RMT-O covariance estimator
                        predictedRisksNoShort(3,counter) = weights_rmt_m_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m_ns.');       %Calculate the predicted variance of the no shorting portfolio for the RMT-M covariance estimator
                        predictedRisksNoShort(4,counter) = weights_si_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si_ns.');
                    end
                    base = a;                                                   										%Do next Time Window
                    timer = 0;
                end
            end
        end
		timer = 0;
		base = 254;
        for b = 254:timeRange	%The two year window is repeated starting a year later to add more data points (condition from the literature)
            if (b > 2) && (floor(mod(prices(b,1),100000)/10000) ~= floor(mod(prices(b-1,1),100000)/10000))   			%If the time window ends
                timer = timer + 1;
                if (timer == 2)
                    subMat = [introMatrix; prices(base:b-1, 1:(numStocks+1))];
                    sampCovMat = SampleCovMatrix(numStocks, subMat, b-base); 												%calculate the sample covariance matrix
                    spec = SpectralEstimators(sampCovMat, numStocks, b-base);
                    rmt_o = spec(:,:,1);
                    rmt_m = spec(:,:,2);
                    si = SingleIndexModel([introMatrix; prices(base:a-1,1:(numStocks+1))], numStocks, b-base, SPData); 
                    if (counter > 0)
                        realizedRisks(1,counter) = weights*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights.');   			%Calculate the realized risk of the portfolio from the previous optimization
                        realizedRisks(2,counter) = weights_rmt_o*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o.');
                        realizedRisks(3,counter) = weights_rmt_m*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m.');
                        realizedRisks(4,counter) = weights_si*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si.');
                        realizedRisksNoShort(1,counter) = weightsNoShort*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weightsNoShort.');
                        realizedRisksNoShort(2,counter) = weights_rmt_o_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o_ns.');
                        realizedRisksNoShort(3,counter) = weights_rmt_m_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m_ns.');
                        realizedRisksNoShort(4,counter) = weights_si_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si_ns.');
                    end
                    counter = counter + 1;
                    weights = MinVarPortfolio(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);     				%Get the weights of the minimum variance portfolio
                    weights_rmt_o = MinVarPortfolio(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);
                    weights_rmt_m = MinVarPortfolio(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);
                    weights_si = MinVarPortfolio(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
                    weightsNoShort = NoShortingMinVarPort(sampCovMat(2:(numStocks+1), 2:(numStocks+1)), numStocks);     					%Get the weights of the no shorting minimum variance portfolio
                    weights_rmt_o_ns = NoShortingMinVarPort(rmt_o(2:(numStocks+1), 2:(numStocks+1)), numStocks);     					%Get the weights of the no shorting minimum variance portfolio
                    weights_rmt_m_ns = NoShortingMinVarPort(rmt_m(2:(numStocks+1), 2:(numStocks+1)), numStocks);     					%Get the weights of the no shorting minimum variance portfolio
                    weights_si_ns = NoShortingMinVarPort(si(2:(numStocks+1), 2:(numStocks+1)), numStocks);
                    if (counter < numIterations-1)
                        predictedRisks(1,counter) = weights*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights.');   		%Calculate the predicted variance of the portfolio
                        predictedRisks(2,counter) = weights_rmt_o*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o.');
                        predictedRisks(3,counter) = weights_rmt_m*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m.');
                        predictedRisks(4,counter) = weights_si*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si.');
                        predictedRisksNoShort(1,counter) = weightsNoShort*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weightsNoShort.');   		%Calculate the predicted variance of the no shorting portfolio
                        predictedRisksNoShort(2,counter) = weights_rmt_o_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_o_ns.');
                        predictedRisksNoShort(3,counter) = weights_rmt_m_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_rmt_m_ns.');   		%Calculate the predicted variance of the no shorting portfolio
                        predictedRisksNoShort(4,counter) = weights_si_ns*sampCovMat(2:(numStocks+1), 2:(numStocks+1))*(weights_si_ns.');
                    end
                    base = b;                                                   										%Do next Time Window
                    timer = 0;
                end
            end
        end
    end
    counter;
    predicted_risk_average = sqrt(mean(predictedRisks,2));  %Average predicted risk by the optimization
    realized_risk_average = sqrt(mean(realizedRisks,2));		%Convert variances to risks 
    predicted_risk_average_no_short = sqrt(mean(predictedRisksNoShort,2));  %Average predicted risk by the optimization
    realized_risk_average_no_short = sqrt(mean(realizedRisksNoShort,2));		%Convert variances to risks 
    risk_averages(:,:,1) = [predicted_risk_average(1); realized_risk_average(1); predicted_risk_average_no_short(1); realized_risk_average_no_short(1)]; %and store it in an array that will be returned
    risk_averages(:,:,2) = [predicted_risk_average(2); realized_risk_average(2); predicted_risk_average_no_short(2); realized_risk_average_no_short(2)]; %and store it in an array that will be returned
    risk_averages(:,:,3) = [predicted_risk_average(3); realized_risk_average(3); predicted_risk_average_no_short(3); realized_risk_average_no_short(3)]; %and store it in an array that will be returned
    risk_averages(:,:,4) = [predicted_risk_average(4); realized_risk_average(4); predicted_risk_average_no_short(4); realized_risk_average_no_short(4)];
end


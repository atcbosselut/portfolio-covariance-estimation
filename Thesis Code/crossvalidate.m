function [ index ] = crossvalidate( subMat, numStocks, timeRange, filterLength, percentages)
%This function cross-validates our models for the specified filter and
%validation set sizes specified
    index = zeros(length(percentages),1);
    
    %For each validation set size in percentages
    for a = 1:length(percentages)
        percentage = percentages(a);
        minRisk = zeros(1/percentage,1);
        for z = 0:(1/percentage-1)
            %Set validation and training sets
            indexToRemove = z*timeRange*percentage + 2;
            validationSet = subMat(indexToRemove:(indexToRemove+timeRange*percentage-1),:);
            trainingSet = setxor(subMat, validationSet, 'rows');
            
            %Calculate sample covariance matrix and filter weights for
            %training set
            Scm = SampleCovMatrix(numStocks, trainingSet, (1-percentage)*timeRange);
            weightMatrix = MVDREstimator(Scm, numStocks, filterLength);
            
            %Calculate sample covariance matrix for validation set
            Cm = SampleCovMatrix(numStocks, [subMat(1,:);validationSet], timeRange*percentage);

            %Calculate risks for each weight in weight matrix
            crossValidRisks = diag(weightMatrix'*(Cm(2:(numStocks+1), 2:(numStocks+1)))*weightMatrix);

            %Find the index of the weight matrix that holds the minimum risk for this validation set
            minRisk(z+1) = (find(crossValidRisks==min(crossValidRisks)));

        end
        %Average the minimum risk indices for each validation set
        index(a) = mean(minRisk);

    end
end


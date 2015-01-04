function [ weights ] = RankReduction( covariance, numStocks)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    sampCov = covariance(2:end, 2:end);

    wc = ones(numStocks,1)/numStocks;
    Ws = eye(numStocks)-(wc/norm(wc))*transpose(wc/norm(wc));
    
    rxsd = Ws*covariance*wc;
    Rxs = Ws*sampCov*transpose(Ws);
    w = inv(Rxs)*rxsd;
    [U,Rp] = eig(Rxs);
    
    eigvals = diag(Rp);
    
    rpd = ctranpose(U)*rxsd;
    wN = inv(Rp)*rpd;
    
    [chooser, indices] = sort(Rp^(1/2)*wN, 'descend');
    new_U = U(:, indices);
    
    for a = 30:numStocks
        reduced_U = new_U(:,1:a);
        wM = inv(ctranspose(reduced_U)*Rxs*reduced_U)*ctranspose(reduced_U)*rxsd;
    end
        
    

end


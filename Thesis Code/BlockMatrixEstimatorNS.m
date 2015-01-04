function [ w_B_matrix ] = BlockMatrixEstimatorNS( covariance, numStocks, filterLength )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    covMat = covariance(2:end, 2:end);
    v = ones(numStocks, 1);
    v_o = v/norm(v);
    G1 = (covMat*v_o - (ctranspose(v_o)*covMat*v_o)*v_o);
    G = G1/norm(G1);
    C = (ctranspose(G)*covMat*v_o)/(ctranspose(G)*covMat*G);
    count = 1;
    while((count < filterLength))
        AuxSum = sum((v*C).*G,2);

        g_i = covMat*(v_o-AuxSum) - (ctranspose(v_o)*covMat*(v_o-AuxSum))*v_o-sum((v*(ctranspose(G)*covMat*(v_o-AuxSum))').*G,2);
        g_i_norm = g_i/norm(g_i);
        c_i = (ctranspose(g_i_norm)*covMat*(v_o-AuxSum))/(ctranspose(g_i_norm)*covMat*g_i_norm);

        G = [G g_i_norm];
        C = [C c_i];

        count = count + 1;
        
    end
    rank(G)
    R = zeros(filterLength,filterLength);
    Q = zeros(numStocks,filterLength);
    for j = 1:filterLength
        a = G(:,j);
        for i = 1:j-1
            R(i,j) = Q(:,i)'*G(:,j);
            a = a-R(i,j)*Q(:,i);
        end
        R(j,j) = norm(a);
        Q(:,j) = a/R(j,j);
    end    
    
    B = Q;

    rank(B);
    w_B_matrix = zeros(84,filterLength);
    for a = 1:filterLength
        block = B(:, 1:a);
             
        cvx_begin
            variable mew(a,1)
            minimize ((v_o - block*mew)'*covMat*(v_o - block*mew));
            subject to
                (v_o - block*mew) >= 0
                sum((v_o - block*mew)) == sqrt(numStocks)
        
        cvx_end
        
        w_B = v_o - block*mew;
        w_B_matrix(:,a) = w_B;
    end
    w_B_matrix = w_B_matrix/norm(v);
    w_B_matrix(:,2)
end


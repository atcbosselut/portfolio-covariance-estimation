m = xlsread('\\campus.mcgill.ca\EMF\ELE\abosse1\My Documents\ECSE498\9EstimatorsDaily.xlsx', 'E2:G258751');

numStocks = 1;
dayRange = 2767;
format long

for a = 1:length(m)
    for b = 1:2
         if isnan(m(a,b))
             m(a,b) = 1000;                 %If there are NaN values in data, make them equal to the identifier 1000
         elseif m(a,b) < 0                  
             m(a,b) = -1*m(a,b);            %Stock prices are always positive. If it's negative, assume it's a glitch
         end
    end
    if (a > 1) && (m(a,1) ~= m(a-1,1))
         numStocks = numStocks + 1;         %If a new stock ID is identified, increment numStocks
    end
end

prices = zeros(dayRange + 1, numStocks + 1);
discrepancies = zeros(2, numStocks)        %Instantiate a vector that identifies if there are discrepancies in the stock price data
 
datesIn = 1;
stocksIn = 1;
for a = 1:length(m)
    if ~ismember(m(a,3), prices)
        datesIn = datesIn + 1;              %If this date has not been entered yet, add it as a row
        prices(datesIn, 1) = m(a,3);     
    end
    if ~ismember(m(a,1), prices)
        discrepancies(1,stocksIn) = m(a,1);
        stocksIn = stocksIn + 1;            %If this stock has not been entered yet, add it as a column (in both prices and discrepancies)
        prices(1, stocksIn) = m(a,1);
    end
    if (a > 2) && (m(a,1) == m(a-1,1))      %If a new stock has not been reached
        if (m(a,2) ~= 1000) && (m(a-1,2) ~=1000)
            prices(find(prices == m(a,3)),stocksIn) = (m(a,2) - m(a-1,2))/m(a-1,2);
        else
            prices(find(prices == m(a,3)), stocksIn) = 1000;                           %If there's a problem, identify it as 1000 and record the discrepancy
            discrepancies(2,stocksIn-1) = 1;
        end
    end  
    a
end

prices
function sortedData = findMonthlyPayment(data,carNames,milesPerDay,gasCostPerGallon,costElectricity,leaseMonths,depreciationRate)

%% Claire + Lease Info

gasCostPerGallon = gasCostPerGallon/10;
if (costElectricity == 1)
    costElectricity = 0;
else
    costElectricity = costElectricity/100;
end



%% Basic Analysis


monthlyPaymentData = [];
 

for i = 1:length(data)

        MSRP = data(i,1);
        fuelEfficiency = data(i,2);
        EV = data(i,3);
        taxCredit = data(i,4);
        electricEfficiency = data(i,5);
        range = data(i,6);
        taxExempt = data(i,7);
        
        if (EV == 1)
            depreciation = 0.2;
        end

    %% Gas/Electricity Costs
    if (fuelEfficiency == 0)
        monthlyGasCost = 0;
        dailyElectricityCost = milesPerDay*(electricEfficiency)*costElectricity;
        monthlyElectricityCost = 30*dailyElectricityCost;
    else
        monthlyElectricityCost = 0;
        dailyGasCost = milesPerDay*(1/fuelEfficiency)*gasCostPerGallon;
        monthlyGasCost = 30*dailyGasCost;
    end
        monthlyPayment = monthlyGasCost + monthlyElectricityCost;


    %% Government Incentives
    %Emissions Testing
    emissionsTestCost = 15;
    emissionsTestYearlyFrequency = 0.5;
    emssionsYearlyCost = emissionsTestCost*emissionsTestYearlyFrequency;
    emissionsMonthlyPayment = emssionsYearlyCost/12;
    %Incentive: free emissions testing
    if (EV == 1)
        emissionsMonthlyPayment = 0;
    end

    monthlyPayment = monthlyPayment + emissionsMonthlyPayment;


    %Insurance
    insuranceYearlyPayment = 1499;
    monthlyInsurancePayment = insuranceYearlyPayment/12;
    %Incentive: 10% insurance reduction
    if (EV == 1)
        monthlyInsurancePayment = 0.95*monthlyInsurancePayment;
    end

    monthlyPayment = monthlyPayment + monthlyInsurancePayment;


    %Tax Credit
    %Spread out over 36 months
    monthlySavings = taxCredit/leaseMonths;

    monthlyPayment = monthlyPayment - monthlySavings;


    %Sales Tax Credit
    salesTax = 0.065*MSRP;
    savings = min(salesTax, 0.065*32000);
    if(taxExempt == 0)
        savings = 0;
    end
    MSRP = MSRP + salesTax - savings;

    %% Lease
    leaseYears = leaseMonths/12;
    residualValuePercentage = (1 - depreciationRate)^leaseYears;
    residualValue = MSRP * residualValuePercentage;
    %Lease has $1000 in fees
    grossCapitilizedCost = MSRP + 1000;
    %Lease requires $1500 down payment
    capitilizedCostReduction = 1500;
    %Adjust the Capitilized Cost
    adjustedCapitilizedCost = grossCapitilizedCost - capitilizedCostReduction;
    %Find Overall Depreciation
    depreciationAmount = adjustedCapitilizedCost - residualValue;
    %Assume APR financing rate of 4.4%
    APR = 0.044;
    basePayment = (depreciationAmount/leaseMonths);
    rentCharge = (APR/12)*(adjustedCapitilizedCost + residualValue);

    monthlyPayment = monthlyPayment + rentCharge + basePayment;
    
    if( (range ~= 0) && (range < milesPerDay))
        monthlyPayment = 99999;
    end

    monthlyPaymentData= [monthlyPaymentData; monthlyPayment];
    
end


%Sort the data in ascending order
[sortedData,indeces] = sort(monthlyPaymentData);
sortedCarNames = carNames(indeces);
sortedData = {sortedData sortedCarNames};

end
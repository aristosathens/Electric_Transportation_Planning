%Aristos Athens
%ME 182
%Transportation Planning Assignment

clear all
clc
close all

%% Claire + Lease Info

leaseMonths = 36;
depreciationRate = 0.15;

%% Analysis

[data,carNames] = xlsread("Vehicles_Price_Comparison.xlsx");
carNames = carNames(2:length(carNames),1);
carNames = string(carNames);
cellArray = {};

for milesPerDay = 1:150
    for gasCostPerGallon = 1:100
        for costElectricity = 1:20
        
            sortedData = findMonthlyPayment(data,carNames,milesPerDay,gasCostPerGallon,costElectricity,leaseMonths,depreciationRate);
            sortedData{1,3} = sortedData{1,1}(1);
            sortedData{1,4} = sortedData{1,2}(1);
            cellArray{milesPerDay,gasCostPerGallon,costElectricity} = sortedData;

            milesVec(milesPerDay,1) = milesPerDay;
            gasVec(gasCostPerGallon,1) = gasCostPerGallon;
            electricityVec(costElectricity,1) = costElectricity;
            costData(milesPerDay,gasCostPerGallon,costElectricity) = sortedData{1,3};
            carNameData(milesPerDay,gasCostPerGallon,costElectricity) = sortedData{1,4};
        
        end
    end
end
x = unique(carNameData);
carNameDataNissan = carNameData == "2017 Nissan Versa 1.6 S";
carNameDataVolks = carNameData == "2017 Volkswagen e-Golf EV";
carNameDataHyundaiEV = carNameData == "2017 Hyundai Ioniq EV";
%carNameDataHyundaiHybrid = carNameData == "2018 Hyundai Ioniq Hybrid";
carNameDataFordFocusEV = carNameData == "2017 Ford Focus EV";
carNameDataSmartCar = carNameData == "2017 fortwo";

n = 25;

figure
contour(squeeze(costData(:,:,1)),n);
title("Cost vs miles per day & cost of gas - Price Electricity = $0")
xlabel("Miles Driven Per Day (miles)");
ylabel("Cost of Gas ($0.1/gallon)");
legend("Contour Graph - Lighter Colors == Higher Monthly Cost");

figure
contour(squeeze(costData(:,29,:)),n);
title("Cost vs miles per day & cost electricity  - Price Gas = $3/gal")
xlabel("Cost of Electricity($0.1/kWh)");
ylabel("Miles Driven Per Day (miles)");
legend("Contour Graph - Lighter Colors == Higher Monthly Cost");

figure
contour(squeeze(costData(33,:,:)),n);
title("Cost vs cost of gas & cost electricity  - Miles per day = 33")
xlabel("Cost of Electricity($0.1/kWh)");
ylabel("Cost of Gas ($0.1/gallon)");
legend("Contour Graph - Lighter Colors == Higher Monthly Cost");



figure
spy(squeeze(carNameDataNissan(:,:,1)))
title("Plot of Nissan Versa (blue) - Free Electricity")
xlabel("Cost of Gas ($0.1/gallon)");
ylabel("Miles Driven Per Day (miles)");
set(gca,'Ydir','normal')

figure
spy(squeeze(carNameDataVolks(:,:,1)))
title("Plot of Volkswagen eGolf (blue) - Free Electricity")
xlabel("Cost of Gas ($0.1/gallon)");
ylabel("Miles Driven Per Day (miles)");
set(gca,'Ydir','normal')

figure
spy(squeeze(carNameDataHyundaiEV(:,:,1)))
title("Plot of Hyundai EV (blue) - Free Electricity")
xlabel("Cost of Gas ($0.1/gallon)");
ylabel("Miles Driven Per Day (miles)");
set(gca,'Ydir','normal')

figure
spy(squeeze(carNameDataFordFocusEV(:,:,1)))
title("Plot of Ford Focus EV (blue) - Free Electricity")
xlabel("Cost of Gas ($0.1/gallon)");
ylabel("Miles Driven Per Day (miles)");
set(gca,'Ydir','normal')

figure
spy(squeeze(carNameDataSmartCar(:,:,1)))
title("Plot of Fortwo Smartcar (blue) - Free Electricity")
xlabel("Cost of Gas ($0.1/gallon)");
ylabel("Miles Driven Per Day (miles)");
set(gca,'Ydir','normal')




figure
spy(squeeze(carNameDataNissan(:,:,10)))
title("Plot of Nissan Versa (blue) - Claires pays Electricity")
xlabel("Cost of Gas ($0.1/gallon)");
ylabel("Miles Driven Per Day (miles)");
set(gca,'Ydir','normal')

figure
spy(squeeze(carNameDataVolks(:,:,10)))
title("Plot of Volkswagen eGolf (blue) - Claires pays Electricity")
xlabel("Cost of Gas ($0.1/gallon)");
ylabel("Miles Driven Per Day (miles)");
set(gca,'Ydir','normal')

figure
spy(squeeze(carNameDataHyundaiEV(:,:,10)))
title("Plot of Hyundai EV (blue) - Claires pays Electricity")
xlabel("Cost of Gas ($0.1/gallon)");
ylabel("Miles Driven Per Day (miles)");
set(gca,'Ydir','normal')

figure
spy(squeeze(carNameDataFordFocusEV(:,:,10)))
title("Plot of Ford Focus EV (blue) - Claires pays Electricity")
xlabel("Cost of Gas ($0.1/gallon)");
ylabel("Miles Driven Per Day (miles)");
set(gca,'Ydir','normal')

figure
spy(squeeze(carNameDataSmartCar(:,:,10)))
title("Plot of Fortwo Smartcar (blue) - Claires pays Electricity")
xlabel("Cost of Gas ($0.1/gallon)");
ylabel("Miles Driven Per Day (miles)");
set(gca,'Ydir','normal')



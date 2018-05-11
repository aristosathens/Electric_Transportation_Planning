%Aristos Athens
%ME 182 - EV Economics Assignment

%Find rough estimates for the proportion of total cars that are electric in
%2030. We make the simplifying assumptions that we start in year 2015 (the
%year we have data for) and that we start with 0 EVs. We start with 260
%million cars in the US, and an EV market share of 1%. By 2030 EV market
%share will be 50%. We use a car sales rate of 6.5% of the total number of
%cars for a given year.
%We do not account for cars removed from circulation.

totalCars = 260000000;
totalElectricCars = 0;

for t = 1:15
    percentElectricCarYear = t*(0.5-0.01)/15;
   % CarsSoldYear = CarsSoldYear + 0.002*CarsSoldYear;
    CarsSoldYear = 0.065*totalCars;
    ElectricCarsSoldYear = percentElectricCarYear*CarsSoldYear;
    totalCars = totalCars + CarsSoldYear;
    totalElectricCars = totalElectricCars + ElectricCarsSoldYear;
end

ElectricRatio = totalElectricCars/totalCars
%Aristos Athens
%ME 182
%Transportation Planning Assignment - Question 2

costElectricity = 0.1408; %$/kWh
chevyVoltEfficiency = 28/100; %kWh/mi

daysDriving = 330;
weekDaysDriving = 330*(5/7);
weekendDaysDriving = 330*(2/7);
tripsToSFO = 12;
tripsToLakeTahoe = 1;
tripsToAshland = 1;

milesPerWeekDay = 16;
milesAllWeekdays = weekDaysDriving * milesPerWeekDay;
milesPerWeekendDay = 30;
milesAllWeekends = weekendDaysDriving * milesPerWeekendDay;
milesPerSFOTrip = 66;
milesAllSFO = tripsToSFO * milesPerSFOTrip;
milesPerLakeTahoeTrip = 442;
milesPerAshlandTrip = 766;

totalMiles = milesAllWeekdays + milesAllWeekends + milesAllSFO + milesPerLakeTahoeTrip + milesPerAshlandTrip;
totalElectricity = totalMiles * chevyVoltEfficiency;
totalCost = totalElectricity *costElectricity
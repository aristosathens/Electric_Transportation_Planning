%Aristos Athens
%ME 182
%Transportation Planning Assignment - Question 3

clear all
clc
close all

%% Shortest Driving Route Between Cities

[graph,cityNames] = xlsread("driving_distance_between_cities");

shortestPath = [];
currentPath = [1];
remainingNodes = 2:5;

shortestPath = findShortestPath(graph, currentPath, remainingNodes, shortestPath);
shortestPathLength = pathLength(graph,shortestPath);

cityNames = cityNames(1,2:6);
shortestPath = cityNames(shortestPath);


%% EV Rental Car

drivingSpeed = 65;
totalDrivingTime = shortestPathLength/drivingSpeed;
numberOfRelatives = 4;
daysSpentPerRelative = 3;
totalDays = (totalDrivingTime/24) + numberOfRelatives*daysSpentPerRelative;


%% Least Pollutant Path

dieselTonsCO2 = 0.000453592 * 22.4;         %tons CO2 per gallon burned
gasTonsCO2 = 0.000453592 * 19.6;            %tons CO2 per gallon burned
jetFuelTonsCO2 = 0.000453592 * 21;          %tons CO2 per gallon burned

%Using MMPG
% carPMPG = 24;
% busPMPG = 38.3;
% trainPMPG = 71.6;
% airPMPG = 42.6;
% motorPMPG = 84;

%Using MPG
carMPG = 24;
busMPG = 6.1;
trainMPG = 1;
airMPG = 0.5;
motorMPG = 84;

drivingGraph = xlsread("driving_distance_between_cities");
trainGraph = xlsread("train_distance_between_cities");
airGraph = xlsread("flying_distance_between_cities");

carGraph = gasTonsCO2 * (1/carMPG) * drivingGraph;
busGraph = dieselTonsCO2 * (1/busMPG) * drivingGraph;
trainGraph = dieselTonsCO2 * (1/trainMPG) * trainGraph;
airGraph = jetFuelTonsCO2 * (1/airMPG) * airGraph;

masterGraph = carGraph;
masterGraphString = [""];

for i = 1:5
    for j = 1:5
        masterGraphString(i,j) = "car";
        if (busGraph(i,j) < masterGraph(i,j))
            masterGraph(i,j) = busGraph(i,j);
            masterGraphString(i,j) = "bus";
        end
        if (trainGraph(i,j) < masterGraph(i,j))
            masterGraph(i,j) = trainGraph(i,j);
            masterGraphString(i,j) = "train";
        end
        if (airGraph(i,j) < masterGraph(i,j))
            masterGraph(i,j) = airGraph(i,j);
            masterGraphString(i,j) = "air";
        end       
    end
end

shortestPath = findShortestPath(masterGraph, [1], 2:5, []);
shortestPathTransportMethod = [""];

for i = 1:length(shortestPath)-1
    shortestPathTransportMethod(i) = masterGraphString(shortestPath(i),shortestPath(i+1));
end

cityNames(shortestPath)
shortestPathTransportMethod
pathLength(masterGraph,shortestPath)



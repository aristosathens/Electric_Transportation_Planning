%Model S Analysis Assignment
%ME 182
%Aristos Athens

close all
clear all

%% Questions

%Exactly what are the key points and what is needed at each?(TP1, TP2, TP3, TP4)
%Is my value for k ok?
%How do I account for battery capacity changing with discharge rate? What
%Voltage vs Capacity graph/equation to use?


%% Problem Statement

% In one of our lectures on Slow Dynamics, we analyzes the range that a car can travel given that
% the velocity is specified by repeats of the Simplified Federal Urban Driving Schedule (SFUDS).
% Recall that the lecture was based on EV-1 from General Motors.
% Please replicate the analysis for the Tesla Model S. Plot the waveforms for the key test points
% identified in lecture (TP1, TP2, TP3 and TP4). You will need to find some of the key parameters on
% the internet. Intelligent guesses are also allowed for parameters that are not in the public domain
% provided they are accompanied by a good rationale.
% Determine the distance that the Model S can travel over road that is well modeled as repeats of the SFUDS.
% Assume that the Model S begins with a full battery.
% Hint: Use MatLab or any of the other nice mathematical software packages to complete this assignment. 


%% Assumptions

%2 passengers, each weighing 80 kg.
%Passenger energy use (Photel) is 0.1 times the size of Pte.
%Model discharge graph as linear. i.e. Voltage out vs. discharge declines
%linearly

%


%% Constants

%General
g = 9.81;           %m/sec^2

%Textbook
C_D = 0.24;
A = 2.4;            %m^2
mu = 0.005;
massCar = 2108;      %kg
etaGears = 0.95;
etaMotor = 0.9;
eta = etaMotor*etaGears;

%Assumptions
passengers = 2;
passengerMass = 80; %kg
massPassengers = passengers*passengerMass;
mass = massCar + massPassengers;
%Flat road
psi = 0;            %rad

%Researched

%Using an 85 kWh rated battery
%http://www.roperld.com/science/teslamodels.htm
%http://www.fueleconomy.gov/feg/PowerSearch.do?action=noform&year1=2016&year2=2016&cbmkTesla=Tesla&minmsrpsel=0&maxmsrpsel=0&city=0&hwy=0&comb=0&YearSel=2016&make=Tesla&mclass=&vfuel=&vtype=&trany=&drive=&cyl=&MpgSel=000&sortBy=Make&Units=&url=SearchServlet&opt=new&minmsrp=0&maxmsrp=0&minmpg=&maxmpg=&rowLimit=25&tabView=0&pageno=1
%However, research shows you really have about 81 kWh usable
%https://electrek.co/2016/02/03/tesla-battery-tear-down-85-kwh/
%https://electrek.co/2016/12/14/tesla-battery-capacity/

%Battery energy at full charge
Cbat = 81;          %kWh
Cbat = 1000*Cbat;   %Wh

%Battery rated voltage
Voc = 375;          %V

%Battery internal resistance
Rin = 1;            %Ohms

%Peukert's constant for battery recharging
k = 1.12;


%% Data

data = importdata('SFUDS_Data.mat');


%% Analysis

%data
v = data(:,2);                              %km/hour
figure
plot(v)
v = (1/3600)*(1000)*v;                      %m/sec
v = repmat(v,10000,1);                       %m/sec
time = transpose(1:1:length(v));            %sec
%Take approximate derivative of velocity to find approximate acceleration
a = diff(v(:));
%Adjust a vector length
a = [0;a];

%Initialize for the loop
FteVec = [];
PVec = [];
PMotorVec = [];
PBatVec = [];
PteVec = [];
QVec = [];
VVec = [];
iVec = [];
dVec = [];
Qoc = Cbat/Voc;                             %Amp/hr
Q = Qoc;                                    %Amp/hr
V = Voc;                                    %V
t = 0;                                      %time index
d = 0;                                      %m

while (Q > 0)
    %time step
    t = t + 1;
      
    %Instantaneous load force
    Fte = mass*g*(mu + psi + (1.05*a(t))/g) + 0.626*A*C_D*(v(t)^2);     %N
    
    %Instantaneous load power draw
    Pte = Fte*v(t);                                                   %Watt
    %Power Hotel
    Photel = 0.1*Pte;
    %Instantaneous battery current
    %Initialize variables
%     Pbat1=0;
%     Pbat=0;
    if (Pte == 0)
        i = 0;
        Pbat1 = 0;
        Pbat = 0;
    elseif (Pte > 0)
        %Instantaneous power drawn from battery
        Pbat1 = Pte/eta + Photel;
        Pbat = (1/0.75)*Pbat1;
        %discharging battery (consuming energy)
        i = (V - sqrt((V^2) - 4*Rin*Pbat)) / (2*Rin);           %Amp
    else
        %Instantaneous power drawn from battery
        Pbat1 = eta*Pte + Photel;
        Pbat = (1/0.75)*Pbat1;
        %charging battery
        i = (-V + sqrt((V^2) - 8*Rin*Pbat)) / (4*Rin);          %Amp
    end
    %Instantaneous battery charge
    if(Pte > 0)
        Q = Q - i/3600;                                                 %Amp/hr
    else
        Q = Q + (i^k)/3600;
    end
    
    %Use equation from book to find distance
%     if(v(t) ~= 0)
%         Photel = 0.1*Fte*v(t);
%         deltad = Q*v(t) / ((Fte*v(t)/eta) + Photel);
%         if(deltad > 0)
%             d = d + deltad;
%         end
%     end

    %Total distance travelled. v is in 1 second increments
    d = d + v(t);
    
    %https://endless-sphere.com/forums/viewtopic.php?f=14&t=67721
    dischargeSlope = (3.5/3.8 - 1);
    discharge = 1 - (Q/Qoc);
    V = Voc*(1 + discharge*dischargeSlope);
    
    %Storage arrays
    FteVec(t) = Fte;
    PVec(t) = Pte;
    VVec(t) = V;
    QVec(t) = Q;
    iVec(t) = i;
    dVec(t) = d;
    PbatVec(t) = Pbat;
    PMotorVec(t) = Pbat1;
    PteVec(t) = Pte;
    
end
%% Plots

figure
plot(time,v);
title('Data - Velocity vs Time');
xlabel('time(s)');
ylabel('velocity(m/s)');

figure
plot(time,a);
title('Data - Acceleration vs Time');
xlabel('time(s)');
ylabel('acceleration(m/s^2)');

figure
plot(time(1:length(dVec)),dVec);
title('Calculated - Distance vs Time');
xlabel('time(s)');
ylabel('Distance(m)');

figure
plot(time(1:length(FteVec)),FteVec);
title('Calculated - Fte vs Time');
xlabel('time(s)');
ylabel('Force(N)');

figure
plot(time(1:length(QVec)),QVec);
title('Calculated - Q vs Time');
xlabel('time(s)');
ylabel('Charge(Amp hour)');

figure
plot(time(1:length(iVec)),iVec);
title('Calculated - Battery Current vs Time');
xlabel('time(s)');
ylabel('Current(Amp)');

figure
plot(time(1:length(VVec)),VVec);
title('Calculated - V vs Time');
xlabel('time(s)');
ylabel('Voltage(V)');


%% Test Point Plots

figure
plot(time(1:length(data)), v(1:length(data)), time(1:length(data)), a(1:length(data)));
title('TP1 - V and A vs Time');
xlabel('time(s)');
ylabel('Velocity(m/sec), Acceleration(m/sec^2');

figure
plot(time(1:length(data)), PteVec(1:length(data)));
title('TP2 - Power to Move Car');
xlabel('time(s)');
ylabel('Power(W)');

figure
plot(time(1:length(data)), PMotorVec(1:length(data)));
title('TP3 - Power From Motor');
xlabel('time(s)');
ylabel('Power(W)');

figure
plot(time(1:length(data)), PbatVec(1:length(data)));
title('TP4 - Power From Battery');
xlabel('time(s)');
ylabel('Power(W)');
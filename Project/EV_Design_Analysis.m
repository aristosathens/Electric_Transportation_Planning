%ME 182
%Design Analysis
%Aristos Athens

%% Constants

g = 9.8; %m/sec^2
acrylic_density = 1200; %kg/m^3   http://www.matweb.com/search/datasheet.aspx?bassnum=O1303&ckck=1
acrylic_youngs = 3e9; %Pa
masonite_density = 1100; %kg/m^3
%Low density board has about 900 kg/m^3 density
masonite_youngs = 6894*500000; %Pa   https://www.fpl.fs.fed.us/documnts/pdf1993/mcnat93a.pdf


%% Dimensions

r_wheels = 0.05; %m
t_wheels = 0.64*0.01; %m
vol_wheels = 3*(pi*(r_wheels^2))*t_wheels; %m^3


%% Weight

%All in kg
weight_bat = 0.8;
weight_motor = 1;
weight_chassis = 1;
weight_wheels = g*acrylic_density*vol_wheels;
weight_total = weight_bat + weight_motor + weight_chassis + weight_wheels;

%% Power

wire_length = 0.1; %m

%Copper wire resistance
%R = rho*l/A
%https://www.mcmaster.com/#8873k11/=19ugxvv
wire_radius =(0.064*0.0254)/2; %m.
wire_area = pi*(wire_radius^2);
%https://www.nde-ed.org/GeneralResources/MaterialProperties/ET/Conductivity_Copper.pdf
wire_resistivity = 1.72e-8; 
r_wire = wire_resistivity*wire_length/wire_area;

%Assumes a 5Volt battery with max 0.1A output
v_battery = 5;  %V
i_battery = min(0.1,v_battery/r_wire); %A
p_battery = i_battery*v_battery; %Watts
%Assume 30% electric efficiency
p_loop = 0.3*p_battery; %Watts

%rotational velocity of wire loop
w_loop = 100; %rpm
w_loop = 0.104719755*w_loop; %rad/sec

%Power = Torque*omega
%Assume 30% mechanical efficiency
T_loop = 0.3*p_loop/w_loop;

%Assuming no air/rolling resistance
%Half of the torque goes to each wheel
T_wheel = 0.5*weight_total*r_wheels;
gear_ratio = T_wheel/T_loop

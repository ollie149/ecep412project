function [baseMVA, bus, gen, branch, areas, gencost] = FinalProjectCase
% caseEagleBase    Power flow data for 17 bus, 3 generator case.
%   Please see 'help caseformat' for details on the case file format.

%%-----  Power Flow Data  -----%%
%% system MVA base
baseMVA = 10;

%%-----  VARIABLES & PER-UNIT CONVERSIONS  -----%%
% --- SYSTEM BASE VALUES ---
S_base = 10;          % 10 MVA System Base
V_base_HV = 4.16;     % 4160V zone
V_base_LV = 0.45;     % 450V zone
Z_base_HV = (V_base_HV^2) / S_base; 
Z_base_LV = (V_base_LV^2) / S_base; 

% --- 4160 CABLE SPECS (250kcmil, Converted to p.u. per 1000ft) ---
r_unit_HV = 0.053 / Z_base_HV; 
x_unit_HV = 0.038 / Z_base_HV;
b_unit = 0.0; % literally 0 here with these lengths

% --- 450V CABLE SPECS (250kcmil, Converted to p.u. per 1000ft) ---
r_unit_LV = 0.090 / Z_base_LV; 
x_unit_LV = 0.034 / Z_base_LV;
b_unit = 0.0; % literally 0 here with these lengths

% --- EQUIPMENT SPECS (Already in p.u. or converted) ---
r_trans = 0.2 / Z_base_HV;   % 0.2 Ohms converted to p.u.
x_trans = 0.0575;              % dafis gave in p.u.
x_gen   = 0.3;               % dafis gave in p.u.
r_gen   = 0.0001;            % Negligible r for gen dummy branch


%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
bus = [
    % --- ORIGINAL BUSES (Changed from type 2/3 to type 1 switchboards) ---
	1	1	0	0	0	0	1	1		0	.45		1	1.1		0.9;	%1LB
	2	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%1HB (Was type 3, now type 1)	
	3	1	0	0	0	0	1	1		0	.45		1	1.1		0.9;	%2LA
	4	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%2HA	
	5	1	0	0	0	0	1	1		0	.45		1	1.1		0.9;	%4LA
	6	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%4HA
	7	1	0	0	0	0	1	1		0	.45		1	1.1		0.9;	%4LB
	8	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%4HB
	9	1	0	0	0	0	1	1		0	.45		1	1.1		0.9;	%5LA
	10	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%5HA
	11	1	0	0	0	0	1	1		0	.45		1	1.1		0.9;	%5LB
	12	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%5HB
	13	1	0	0	0	0	1	1		0	.45		1	1.1		0.9;	%6LA
	14	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%6HA													
	15	1	0	0	0	0	1	1		0	.45		1	1.1		0.9;	%7LB
	16	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%7HB
    17	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%APS 1
    18	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%APS 2
    19	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%1SG (Switchboard only)
    20	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%2SG (Switchboard only)
    21	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%3SG (Switchboard only)
    22	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%4SG (Switchboard only)
    23	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%5SG (Switchboard only)
    24	1	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%6SG (Switchboard only)
    
    % --- NEW GENERATOR DUMMY BUSES ---
    25	3	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%DG 1 Dummy (SLACK BUS)
    26	2	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%DG 2 Dummy
    27	2	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%DG 3 Dummy
    28	2	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%DG 4 Dummy
    29	2	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%DG 5 Dummy
    30	2	0	0	0	0	1	1		0	4.16	1	1.1		0.9;	%DG 6 Dummy
];

%% generator data
% Generators moved to dummy buses 25-30
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin
gen = [
	25	4	3	3	-3	1	10	1	4	0; %DG 1
	26	4	3	3	-3	1	10	1	4	0; %DG 2
    27	4	3	3	-3	1	10	1	4	0; %DG 3
    28	4	3	3	-3	1	10	1	4	0; %DG 4
    29	4	3	3	-3	1	10	1	4	0; %DG 5
    30	4	3	3	-3	1	10	1	4	0; %DG 6
];

%% branch data
%	fbus	tbus	r	                                x	                                b	                rateA	rateB	rateC	ratio	angle	status
branch = [
    %  branches updated with  transformers and set to 200ft for now
	2	1	(r_trans + r_unit_LV*200/1000)	        (x_trans + x_unit_LV*200/1000)	        0	250	    300	    350	    1.0	    0	    1; % Trans 4160-450 + 200ft Cable
    2	8	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft
    2	19	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft
    4	3	(r_trans + r_unit_LV*200/1000)	        (x_trans + x_unit_LV*200/1000)	        0	250	    300	    350	    1.0	    0	    1; % Trans 4160-450 + 200ft Cable
    4	6	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft
    4	19	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft
   %6 to 4 skipped
    6	5	(r_trans + r_unit_LV*200/1000)	        (x_trans + x_unit_LV*200/1000)	        0	250	    300	    350	    1.0	    0	    1; % Trans 4160-450 + 200ft Cable
    6	10	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft
    6	20	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft 
    6	21	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft 
   %8 to 2 skipped
    8	7	(r_trans + r_unit_LV*200/1000)	        (x_trans + x_unit_LV*200/1000)	        0	250	    300	    350	    1.0	    0	    1; % Trans 4160-450 + 200ft Cable
    8	12	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft
    8	20	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft 
    8	21	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft 
   %10 to 6 skipped
    10	9	(r_trans + r_unit_LV*200/1000)	        (x_trans + x_unit_LV*200/1000)	        0	250	    300	    350	    1.0	    0	    1; % Trans 4160-450 + 200ft Cable
    10	14	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft
    10	22	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft 
    10	23	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft 
   %12 to 8 skipped
    12	11	(r_trans + r_unit_LV*200/1000)	        (x_trans + x_unit_LV*200/1000)	        0	250	    300	    350	    1.0	    0	    1; % Trans 4160-450 + 200ft Cable
    12	16	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft
    12	22	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft 
    12	23	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft 
   %14 to 10 skipped 
    14	13	(r_trans + r_unit_LV*200/1000)	        (x_trans + x_unit_LV*200/1000)	        0	250	    300	    350	    1.0	    0	    1; % Trans 4160-450 + 200ft Cable
    14	24	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft
   %16 to 12 skipped 
    16	15	(r_trans + r_unit_LV*200/1000)	        (x_trans + x_unit_LV*200/1000)	        0	250	    300	    350	    1.0	    0	    1; % Trans 4160-450 + 200ft Cable  
    16	24	(r_unit_HV*200/1000)	                (x_unit_HV*200/1000)	                0	250	    300	    350	    0	    0	    1; % Cable 200ft  
    
    % --- APS TRANSFORMER BRANCHES --- 
    18	20	(r_trans + r_unit_LV*200/1000)	        (x_trans + x_unit_LV*200/1000)	        0	250	    300	    350	    1.0	    0	    0; % APS Trans + 200ft Cable - Status 0
    18	21	(r_trans + r_unit_LV*200/1000)	        (x_trans + x_unit_LV*200/1000)	        0	250	    300	    350	    1.0	    0	    1; % APS Trans + 200ft Cable - Status 1
    17	22	(r_trans + r_unit_LV*200/1000)	        (x_trans + x_unit_LV*200/1000)	        0	250	    300	    350	    1.0	    0	    0; % APS Trans + 200ft Cable - Status 0
    17	23	(r_trans + r_unit_LV*200/1000)	        (x_trans + x_unit_LV*200/1000)	        0	250	    300	    350	    1.0	    0	    1; % APS Trans + 200ft Cable - Status 1

    % --- GENERATOR INTERNAL REACTANCE DUMMY BRANCHES ---
    % Connects the Dummy Generator Bus to the Physical Switchboard Bus so
    % we can include their reactance given
    25	19	r_gen	                            x_gen	                            0	                250	    300	    350	    0	    0	    1; % Gen 1 Internal Z
    26	20	r_gen	                            x_gen	                            0	                250	    300	    350	    0	    0	    1; % Gen 2 Internal Z
    27	21	r_gen	                            x_gen	                            0	                250	    300	    350	    0	    0	    1; % Gen 3 Internal Z
    28	22	r_gen	                            x_gen	                            0	                250	    300	    350	    0	    0	    1; % Gen 4 Internal Z
    29	23	r_gen	                            x_gen	                            0	                250	    300	    350	    0	    0	    1; % Gen 5 Internal Z
    30	24	r_gen	                            x_gen	                            0	                250	    300	    350	    0	    0	    1; % Gen 6 Internal Z
];

%%-----  OPF Data  -----%%
%% area data
areas = [
	1	5;
];

%% generator cost data
%	1	startup	shutdown	n	x0	y0	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
gencost = [
	2	1500	0	3	0.11	5	150;
	2	2000	0	3	0.085   1.2	600;
	2	3000	0	3	0.1225 	1	335;
    2	1500	0	3	0.11	5	150;
	2	2000	0	3	0.085   1.2	600;
	2	3000	0	3	0.1225 	1	335;
];

return;

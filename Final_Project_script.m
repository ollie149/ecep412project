%% ECEP 412 - Final Project
clear 
close all
clc

%% define named indices into bus, gen, branch matrices
[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;
[F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, RATE_C, ...
    TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST, ...
    ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;
[GEN_BUS, PG, QG, QMAX, QMIN, VG, MBASE, GEN_STATUS, PMAX, PMIN, ...
    MU_PMAX, MU_PMIN, MU_QMAX, MU_QMIN, PC1, PC2, QC1MIN, QC1MAX, ...
    QC2MIN, QC2MAX, RAMP_AGC, RAMP_10, RAMP_30, RAMP_Q, APF] = idx_gen;

%% read data
casedata = 'FinalProjectCase.m';
verbose = 0;
mpc0 = loadcase(casedata);
[nl,~] = size(mpc0.branch);
[ng,~] = size(mpc0.gen);


%% Set up options for AC Power Flow using Newton-Raphson
pffname = '';
pfsolvedcase = '';
pfsolvedcase_HWT = '';
mpopt = mpoption;
mpopt = mpoption('PF_ALG', 1, 'PF_TOL', 1e-6, 'VERBOSE', verbose);

%% Creating Binary Values for Optimal generator line up and Generator Loading
Gen_cases = flip(decimalToBinaryVector(1:63, 6), 1);

%% Load Cases and values

%   9=5LA  11=5LB  13=6LA  15=7LB  1=1LB   3=2LA    5=4LA    7=4LB   23=APS1  24=APS2
load_cases=[
    1    1    1    1    1.5    1.5    1.5    1.5    0    0;
    1    1    1    1    1.5    1.5    1.5    1.5    0.5    0.5;
    1    1    1    1    1.5    1.5    1.5    1.5    1    1;
    1    1    1    1    1.5    1.5    1.5    1.5    1.5    1.5;
    1    1    1    1    1.5    1.5    1.5    1.5    2    2;
    1    1    1    1    1.5    1.5    1.5    1.5    2.5    2.5;
    1    1    1    1    1.5    1.5    1.5    1.5    3    3;
    1    1    1    1    1.5    1.5    1.5    1.5    3.5    3.5;
    1    1    1    1    1.5    1.5    1.5    1.5    4    4;
    1    1    1    1    2    2    2    2    0    0;
    1    1    1    1    2    2    2    2    0.5    0.5;
    1    1    1    1    2    2    2    2    1    1;
    1    1    1    1    2    2    2    2    1.5    1.5;
    1    1    1    1    2    2    2    2    2    2;
    1    1    1    1    2    2    2    2    2.5    2.5;
    1    1    1    1    2    2    2    2    3    3;
    1    1    1    1    2    2    2    2    3.5    3.5;
    1    1    1    1    2    2    2    2    4    4;
    1    1    1    1    2.5    2.5    2.5    2.5    0    0;
    1    1    1    1    2.5    2.5    2.5    2.5    0.5    0.5;
    1    1    1    1    2.5    2.5    2.5    2.5    1    1;
    1    1    1    1    2.5    2.5    2.5    2.5    1.5    1.5;
    1    1    1    1    2.5    2.5    2.5    2.5    2    2;
    1    1    1    1    2.5    2.5    2.5    2.5    2.5    2.5;
    1    1    1    1    2.5    2.5    2.5    2.5    3    3;
    1    1    1    1    2.5    2.5    2.5    2.5    3.5    3.5;
    1    1    1    1    2.5    2.5    2.5    2.5    4    4;
    1.5    1.5    1.5    1.5    1.5    1.5    1.5    1.5    0    0;
    1.5    1.5    1.5    1.5    1.5    1.5    1.5    1.5    0.5    0.5;
    1.5    1.5    1.5    1.5    1.5    1.5    1.5    1.5    1    1;
    1.5    1.5    1.5    1.5    1.5    1.5    1.5    1.5    1.5    1.5;
    1.5    1.5    1.5    1.5    1.5    1.5    1.5    1.5    2    2;
    1.5    1.5    1.5    1.5    1.5    1.5    1.5    1.5    2.5    2.5;
    1.5    1.5    1.5    1.5    1.5    1.5    1.5    1.5    3    3;
    1.5    1.5    1.5    1.5    1.5    1.5    1.5    1.5    3.5    3.5;
    1.5    1.5    1.5    1.5    1.5    1.5    1.5    1.5    4    4;
    1.5    1.5    1.5    1.5    2    2    2    2    0    0;
    1.5    1.5    1.5    1.5    2    2    2    2    0.5    0.5;
    1.5    1.5    1.5    1.5    2    2    2    2    1    1;
    1.5    1.5    1.5    1.5    2    2    2    2    1.5    1.5;
    1.5    1.5    1.5    1.5    2    2    2    2    2    2;
    1.5    1.5    1.5    1.5    2    2    2    2    2.5    2.5;
    1.5    1.5    1.5    1.5    2    2    2    2    3    3;
    1.5    1.5    1.5    1.5    2    2    2    2    3.5    3.5;
    1.5    1.5    1.5    1.5    2    2    2    2    4    4;
    1.5    1.5    1.5    1.5    2.5    2.5    2.5    2.5    0    0;
    1.5    1.5    1.5    1.5    2.5    2.5    2.5    2.5    0.5    0.5;
    1.5    1.5    1.5    1.5    2.5    2.5    2.5    2.5    1    1;
    1.5    1.5    1.5    1.5    2.5    2.5    2.5    2.5    1.5    1.5;
    1.5    1.5    1.5    1.5    2.5    2.5    2.5    2.5    2    2;
    1.5    1.5    1.5    1.5    2.5    2.5    2.5    2.5    2.5    2.5;
    1.5    1.5    1.5    1.5    2.5    2.5    2.5    2.5    3    3;
    1.5    1.5    1.5    1.5    2.5    2.5    2.5    2.5    3.5    3.5;
    1.5    1.5    1.5    1.5    2.5    2.5    2.5    2.5    4    4;];


%% Part 3 a,b,c,d

%9=5LA  11=5LB  13=6LA  15=7LB  1=1LB   3=2LA    5=4LA    7=4LB   18=APS1  17=APS2
% Iterated over load_cases for variable loads (updating mpc)
load_case_rows = size(load_cases,1);
gen_cases_rows = size(Gen_cases,1);
PF=0.8; %Lagging

%Final Results Array
%Columns: # Load Case=1, # of Gen Case=2, Real Power=3-8, Reactive Power=9-14,Current=15-20, Gen Violation=21-26, Optimal Loading=27
load_gen_num = load_case_rows*gen_cases_rows;
final_results = zeros(load_gen_num,27);
i_r = 1;

buses = [9 11 13 15 1 3 5 7 18 17];

for h=1:load_case_rows
    mpc = mpc0;
    for k = 1:10
        mpc.bus(buses(k),PD) = load_cases(h,k);
        mpc.bus(buses(k),QD) = sqrt((load_cases(h,k)/PF)^2 - (load_cases(h,k))^2);
    end
    
    for g=1:gen_cases_rows
        %Changing generator status using Gen_cases and iteration variable j
        for j=1:ng
            mpc.gen(j, GEN_STATUS) = Gen_cases(g,j);
        end

        [resultsNR, successNR] = runpfLabVersion(mpc, mpopt, pffname, pfsolvedcase);
                
        final_results(i_r,1) = h;
        final_results(i_r,2) = g;
        
        if successNR == 1
            for i=1:ng
                final_results(i_r,2+i) = resultsNR.gen(i,PG);
                final_results(i_r,8+i) = resultsNR.gen(i,QG);

                if (resultsNR.gen(i,PG) >= resultsNR.gen(i,PMIN) && resultsNR.gen(i,PG) <= resultsNR.gen(i,PMAX) && resultsNR.gen(i,QG) >= resultsNR.gen(i,QMIN) && resultsNR.gen(i,QG) <= resultsNR.gen(i,QMAX))
                    final_results(i_r,20+i) = 0; % no violation
                else
                    final_results(i_r,20+i) = 1; % violation
                end
            end    
        else
            final_results(i_r,3:27) = NaN;
        end

        i_r= i_r+1; %Adds 1 to the iteration variable for the Final Results Vector
    end    
end


%Analyzing Power Flow Per Generator
        %for k=1:ng
            %Check Generator Real and Reactive Generator Ranges and if NR was successful
                %Put code here
            %Generator Power Ouput (part 3a)
                % (Put Real Power into a vector with number of Generator Case and load case)
                %put code here 
            %Generator Current (part 3b) (Buses 17-21 are the generator buses)
                %Calcuate using Gen Real/Reactive Power and Bus voltage (convert it to voltage from pu and remember the angle)
                %put into vector with number of generator case and load case
                %put code here
        %end
        %Optimal Generator Lineup (part 3d) - kind of confused where
            %put code here

%mdo = most(mdi);
%ms = most_summary(mdo);

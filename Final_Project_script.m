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

%   9=5LA  11=5LB  13=6LA  15=7LB  1=1LB   3=2LA    5=4LA    7=4LB   18=APS1  17=APS2
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
Power_Factor=0.8; %Lagging


%Final Results Array
%Columns: # Load Case=1, # of Gen Case=2, Real Power=3-8, Reactive Power=9-14,Current=15-20, Gen Violation=21-26, Optimal Loading=27
load_gen_num = load_case_rows*gen_cases_rows;
final_results = zeros(load_gen_num,27);
i_r = 1;

%vector of load buses for iteration
buses = [9 11 13 15 1 3 5 7 18 17];

for h=1:load_case_rows
    mpc = mpc0;
    
    %Goes through vector of Load Cases 
    for k = 1:10
        mpc.bus(buses(k),PD) = load_cases(h,k);
        mpc.bus(buses(k),QD) = sqrt((load_cases(h,k)/Power_Factor)^2 - (load_cases(h,k))^2);
    end
    
    %Goes through the rows of generator loading cases
    m=63; %for column 2 of final results gen case number
    for g=1:gen_cases_rows
        
        %Changing generator status using Gen_cases and iteration variable j
        for j=1:ng
            mpc.gen(j, GEN_STATUS) = Gen_cases(g,j);
        end

        %Runs Power Flow
        [resultsNR, successNR] = runpfLabVersion(mpc, mpopt, pffname, pfsolvedcase);
        
        %Puts the Load Case # and Generator Case # in vector
        final_results(i_r,1) = h;
        final_results(i_r,2) = m;
        
        %See if the power flow is a success
        if successNR == 1
            %if it is a success then it iterates through the generators
            for i=1:ng
                %Inputs the Real and Reactive Powers into the Results vector
                final_results(i_r,2+i) = resultsNR.gen(i,PG);
                final_results(i_r,8+i) = resultsNR.gen(i,QG);
                
                %current calc needs added
                bus_idx = resultsNR.gen(i, GEN_BUS);
                V_LL = resultsNR.bus(bus_idx, VM) * resultsNR.bus(bus_idx, BASE_KV); 
                S_total_VA = sqrt(resultsNR.gen(i, PG)^2 + resultsNR.gen(i, QG)^2) * 1e6;
                final_results(i_r, 14+i) = S_total_VA / (sqrt(3) * V_LL);
                
                %Checks for generator violations    
                if (resultsNR.gen(i,PG) >= resultsNR.gen(i,PMIN) && resultsNR.gen(i,PG) <= resultsNR.gen(i,PMAX) && resultsNR.gen(i,QG) >= resultsNR.gen(i,QMIN) && resultsNR.gen(i,QG) <= resultsNR.gen(i,QMAX))
                    final_results(i_r,20+i) = 0; % no violation
                else
                    final_results(i_r,20+i) = 1; % violation
                end
            end    
        %If the power flow is not a success writes Na
        else
            final_results(i_r,3:27) = 'N/a';
        end
        
        i_r= i_r+1; %Adds 1 to the iteration variable for the Final Results Vector
        m=m-1; %Makes the iteration variable go from 63-1
    end  
%---find optimal power flow for each case
    %code
    %final_results(i_r,27)=0; %Add optimal power flow case to column 27 for each load case
end



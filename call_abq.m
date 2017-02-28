function [Ut] = call_abq(E1_tilde,E2_tilde,F_star)
%CALL_ABQ Calling Abaqus to solve K_star*U=F_star.
%   Load parameters for stiffness matrix scaling.
%   Works only for 3D mesh.
%   SYNOPOSIS:  Ut = call_abq(E1_tilde,E2_tilde,F_star);
%   INPUT:   E1_title : First parameter value, scalar
%            E2_title : Second parameter value, scalar
%            F_star   : Load-like right hand side, vector
%   OUTPUT:  Ut : Displacement-like result, vector
%   Updated on: Oct. 8st, 2016
%   Author: Xi Zou
%           University of Pavia, Italy
%           Polytechnic University of Catalonia, Spain

%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.

% Generate text file for parameters
fPara = fopen('param.inp','w');

fprintf(fPara,'*MATRIX INPUT, NAME=K_1, INPUT=K_1_X1.sim, MATRIX=STIFFNESS, SCALE FACTOR=%s\n', num2str(E1_tilde));
fprintf(fPara,'*MATRIX INPUT, NAME=K_2, INPUT=K_2_X1.sim, MATRIX=STIFFNESS, SCALE FACTOR=%s\n', num2str(E2_tilde));

fclose(fPara);

% Load loads
fLoad = fopen('load.inp','w');

siz = [3,length(F_star)/3];
F = reshape(F_star,siz);
[dof,node] = ind2sub(siz,find(F));

for i=1:length(node)
    fprintf(fLoad,'%d, %d, %g\n',node(i),dof(i),F(dof(i),node(i)));
end

fclose(fLoad);

% Run analysis via system call
[~,~] = system('abaqus job=job input=template >job.log');

% Load results from output file
Ut = load_fil('job.fil');
Ut = sparse(Ut);
delete job.* param.inp load.inp
end

function F = load_fil(fName)
%LOAD_FIL Load displacement data from Abaqus .fil output.
%   Works only for 3D mesh.
%   SYNOPOSIS:  F = load_fil(fName);
%   INPUT:   fName : File name of the .fil output, including extension, string
%   OUTPUT:  F : Displacement-like result, vector
%   Updated on: Oct. 1st, 2016
%   Author: Xi Zou
%           University of Pavia, Italy
%           Polytechnic University of Catalunya, Spain

%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.

%% Load Abaqus .fil output file
fID = fopen(fName,'r');
C = textscan(fID,'%s','Delimiter','','EndOfLine','*');
fclose(fID);

C = C{1};
j = 1;
for i=1:size(C,1)
    A = C{i};
    A = A(~isspace(A));
    if strfind(A,'I16I3101I')
        st = strfind(A,'D');
        A(st(1:2:end)) = ',';
        data = textscan(A(st(1)+1:end),'%f,%f,%f');
        F(j,:) = cell2mat(data);
        j = j + 1;
    end
end

F = F';
F = F(:);
end
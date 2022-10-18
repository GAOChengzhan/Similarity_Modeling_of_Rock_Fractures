% Globals
% global variables, setting, functions, initializations etc. for ADFNE1.5
%
% Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
% Copyright (c) 2018 Alghalandis Computing @
% Author: Dr. Younes Fadakar Alghalandis
% (w) http://alghalandis.net        (e) alghalandis.net@gmail.com
% All rights reserved.
%
% License.: ADFNE1.5_License.txt and at http://alghalandis.net/products/adfne/adfne15
%
% Citations:
% Fadakar-A Y, 2017, "ADFNE: Open source software for discrete fracture network
% engineering, two and three dimensional applications", Journal of Computers &
% Geosciences, 102:1-11.
%
% Fadakar-A Y, 2018, "DFNE Practices with ADFNE", Alghalandis Computing, Toronto, 
% Ontario, Canada, http://alghalandis.net, pp61.
%
% see more at: http://alghalandis.net/products/adfne
% Updated.: 2018-01-11

clear all;

global Tolerance Colormap Segment Poly Precise Times Messages Report Details...
    Runtime Left History Labels Round Interval Debug RandomColor Silent Line

% variables
Tolerance = 1e-14;
Colormap = @jet;
Segment = 24;                                                                   % for sphere, cylinder quality
Poly = struct(...                                                               % predefined polygons
    'Left',  [0,0,0; 0,0,1; 0,1,1; 0,1,0],...
    'Right', [1,0,0; 1,0,1; 1,1,1; 1,1,0],...
    'Top',   [0,0,1; 1,0,1; 1,1,1; 0,1,1],...
    'Bottom',[0,0,0; 1,0,0; 1,1,0; 0,1,0],...
    'Front', [0,0,0; 1,0,0; 1,0,1; 0,0,1],...
    'Back',  [0,1,0; 1,1,0; 1,1,1; 0,1,1],...
    'X45',   [0,1,0; 0,0,1; 1,0,1; 1,1,0],...
    'X135',  [0,0,0; 1,0,0; 1,1,1; 0,1,1],...
    'Y45',   [0,0,0; 1,0,1; 1,1,1; 0,1,0],...
    'Y135',  [1,0,0; 0,0,1; 0,1,1; 1,1,0],...
    'Z45',   [1,0,0; 1,0,1; 0,1,1; 0,1,0],...
    'Z135',  [0,0,0; 1,1,0; 1,1,1; 0,0,1]);
Line = struct(...                                                               % predefined lines
    'Left',  [0,0,0,1],...
    'Right', [1,0,1,1],...
    'Top',   [0,1,1,1],...
    'Bottom',[0,0,1,0],...
    'D45',   [0,0,1,1],...
    'D135',  [1,0,0,1],...
    'CH',    [0,0.5,1,0.5],...
    'CV',    [0.5,0,0.5,1],...
    'Box',   Polyline([0,1;0,0;1,0;1,1]));
Times = {};                                                                     % storage for timing
Messages = {};                                                                  % storage for messages
Report = true;
Details = false;
Runtime = 10;
Left = repelem(' ',1,22);
History = {};                                                                   % storage for all timing
Labels = false;                                                                 % controls lines' labels
Interval = 0.1;                                                                 % for meshing
Debug = false;
RandomColor = false;
Silent = false;                                                                 % to prevent any message

% functions
Precise = @(x)x;                                                                % exact values
Round = @(x)round(x,16);                                                        % rounded values

% set paths
cpth = cd;                                                                      % current path
cd(fileparts(mfilename('fullpath')));                                           % ...changes it to current file path
addpath('R2015a');                                                              % updates Matlab search path
cd(cpth);                                                                       % restores original path
clear cpth;                                                                     % removes cpth

% extra cleaning
clc;                                                                            % clears command window
clf; drawnow;                                                                   % clears figure, forces to refresh
warning off;                                                                    % disables all warnings

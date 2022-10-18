function dfn = Solve(dfn,bv,kv)
% Solve
% solves graph based on boundary values "bv"
%
% Usage...:
% dfn = Solve(dfn,bv,kv);
%
% Input...: dfn       dfn,{field:grh}
%           bv        (k),boundary values
%           kv        (1),kinematic viscosity
% Output..: dfn       updated dfn
%
% Examples:
%{
dfn = Solve(dfn);
dfn = Solve(dfn,[1,0],1.787e-6);
%}
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

global Report Details
if ~isfield(dfn,'grh'); return; end                                             % if graph is ready
Ticot('Solutions');                                                             % initializes timing
if nargin < 3; kv = 1.787e-6; end                                               % default kinematic viscosity
g = dfn.grh;
if (nargin < 2) || isempty(bv); bv = 1:numel(unique([g.Node.Type]))-1; end      % default boundary values
for i = 1:g.Size(1)                                                             % loops over all nodes
    if g.Node(i).Type == 0; continue; end                                       % skips inner nodes
    value = bv(g.Node(i).Type);                                                 % selects values
    if isnan(value)                                                             % to interpolate
        b = ~isnan(bv);
        g.Node(i).Pressure = Boundary(g.Node(i).Location,g.BE(b,:),bv(b));      % interpolated values
    else
        g.Node(i).Pressure = value;                                             % boundary value
    end
end
f = ([g.Node.Type] == 0);                                                       % inners nodes
inx = find(f);
inn = sum(f);
ind(inx) = 1:inn;
A = zeros(inn,inn);                                                             % initializes matrix A
B = zeros(inn,1);                                                               % initializes vector B
for i = 1:inn                                                                   % loops over all inner nodes
    egs = g.Edge(g.Node(inx(i)).Edges);                                         % node's edges
    c = Conductance([egs.Length],[egs.Aperture],[egs.Depth],kv);                % computes conductance
    nn = setdiff([egs.Nodes],inx(i),'stable');                                  % node's neighboring nodes
    f = ([g.Node(nn).Type] == 0);                                               % inner mask
    A(i,ind(nn(f))) = c(f);                                                     % fill in the matrix A
    A(i,i) = -sum(c);
    if all(f); continue; end                                                    % if all were inner nodes
    B(i) = sum(-c(~f).*[g.Node(nn(~f)).Pressure]);                              % updates B vector
end
X = A\B;                                                                        % finds the solution
for i = 1:inn
    g.Node(inx(i)).Pressure = X(i);                                             % updates pressure values
end
for i = 1:g.Size(2)                                                             % loops over all edges
    dp = diff([g.Node(g.Edge(i).Nodes).Pressure]);                              % pressure difference
    if dp > 0                                                                   % if pressure increases
        g.Edge(i).Nodes = g.Edge(i).Nodes([2,1]);                               % reverses the edge nodes
        dp = -dp;                                                               % fixes the pressure drop
    end
    g.Edge(i).dP = dp;                                                          % updates the edges
end
H = [g.Edge.dP];                                                                % heads
lts = [g.Edge.Length];                                                          % edge lengths
Q = Conductance(lts,[g.Edge.Aperture],[g.Edge.Depth],kv).*H;                    % flow (flux)
for i = 1:numel(Q)                                                              % loops over edges
    g.Edge(i).Flow = Q(i);                                                      % updates edge flow
end
I = H./lts;                                                                     % normalized head values 
ab = [g.Edge.Aperture].*[g.Edge.Depth];                                         % cross-section area
for i = 1:g.Size(2)                                                             % loops over all edges
    g.Edge(i).dH = I(i);                                                        % hydraulic gradient
    if Q(i) == 0                                                                % if no flow
        g.Edge(i).Permeability = 0;
    else
        g.Edge(i).Permeability = abs(Q(i)*kv/(I(i)*ab(i)));                     % computes permeability
    end
    g.Edge(i).Force = -ab(i)*g.Edge(i).dP;                                      % computes force
end
g.BV = bv;                                                                      % boundary values
dfn.grh = g;                                                                    % updates graph
if Report
    Display('Inner#',inn);                                                      % displays information
    if Details
        Stats([g.Edge.Length],'L');
        Stats([g.Edge.Aperture],'a');
        Stats([g.Edge.Depth],'b');
        Stats([g.Edge.dH],'dH');
        Stats([g.Edge.dP],'dP');
        Stats([g.Edge.Flow],'Q');
        Stats([g.Edge.Force],'F');
        Stats([g.Edge.Permeability],'K');
    end
end
Ticot;
end
% internal function
function c = Conductance(l,a,b,kv)                                              % conductance
c = reshape((9.8*b.*a.^3)./(12*kv*l),1,[]);
end

%{
[ Water ]
T:Tempreture (C), DV(mu):Dynamic Viscosity[10^(-3)], KV(v):Kinematic Viscosity [10^(-6) m^2/s]
T   DV      KV
0 	1.787 	1.787
5 	1.519 	1.519
10 	1.307 	1.307
20 	1.002 	1.004
30 	0.798 	0.801
40 	0.653 	0.658
50 	0.547 	0.553
60 	0.467 	0.475
70 	0.404 	0.413
80 	0.355 	0.365
90 	0.315 	0.326
100 0.282 	0.294
ref: https://www.engineeringtoolbox.com/water-dynamic-kinematic-viscosity-d_596.html
%}

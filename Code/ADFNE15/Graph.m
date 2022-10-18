function dfn = Graph(dfn,aFun,dFun)
% Graph
% builds graph structure from DFN model
%
% Usage...:
% dfn = Graph(dfn,aFun,dFun);
%
% Input...: dfn       DFN model
%           aFun      aperture function
%           dFun      depth function
% Output..: dfn       DFN updated
%
% Examples:
%{
dfn = Graph(dfn,@(x)0.0001);
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

global Report
if ~isfield(dfn,'bbn'); return; end                                             % if no backbone, exits
Ticot('Building Graph');                                                        % initializes timing
if (nargin < 2) || isempty(aFun); aFun = @(x)0.0001; end                        % default function on aperture
if nargin < 3; dFun = nan; end                                                  % default function on depth
bbn = dfn.bbn.Backbone;                                                         % backbone
[ubn,~,ic] = uniquetol(Reshape(bbn,[],3),1e-12,'ByRows',true);                  % removing duplicated lines
bbn = Reshape(ubn(ic,:),[],6);                                                  % cleaned backbone
typ = dfn.pip.Type(dfn.bbn.B);                                                  % types inherited from pipes
dth = dfn.pip.Depth(dfn.bbn.B);                                                 % depths inherited from pipes
[m,n] = size(bbn);                                                              % size of backbone
n = floor(n/2);                                                                 % determines dimension
kys = uniquetol(Reshape(bbn,[],n),1e-12,'ByRows',true);                         % condenses points as to be keys
k = size(kys,1);                                                                % number of keys, i.e., nodes
eid = cell(k,1);                                                                % edge indices
for i = 1:size(bbn,1)                                                           % loops over all backbone
    [~,idx] = ismember(bbn(i,1:n),kys,'rows');                                  % finds index in keys for point 1
    eid{idx} = [eid{idx},i];                                                    % updates edge indices
    [~,idx] = ismember(bbn(i,n+1:end),kys,'rows');                              % finds index in keys for point 2
    eid{idx} = [eid{idx},i];                                                    % updates edge indices
end
nid = cell(m,1);                                                                % node indices
for i = 1:k                                                                     % loops over all nodes
    nn = eid{i};                                                                % edge indices for node i
    for j = 1:numel(nn)                                                         % loops over all edge indices
        nid{nn(j)} = [nid{nn(j)},i];                                            % updates node indices
    end
end
nnn = cell(k,1);                                                                % node's neighbor nodes
for i = 1:m                                                                     % loops over all edges
    nd = nid{i};                                                                % node indices for edge i
    nnn{nd(1)} = [nnn{nd(1)},nd(2)];                                            % updates nnn for node 1
    nnn{nd(2)} = [nnn{nd(2)},nd(1)];                                            % updates nnn for node 2
end
g = struct();                                                                   % initializes graph structure
for i = 1:m                                                                     % loops over all edges
    g.Edge(i).Nodes = nid{i};                                                   % edge's nodes
    g.Edge(i).Type = typ(i);                                                    % edge's type
    g.Edge(i).Depth = dth(i);                                                   % edge's depth
end
for i = 1:k                                                                     % loops over all nodes
    g.Node(i).Edges = eid{i};                                                   % node's edges
    g.Node(i).Nodes = nnn{i};                                                   % node's neighboring nodes
    g.Node(i).Location = kys(i,:);                                              % node's location
    ty = nonzeros([g.Edge(eid{i}).Type]);                                       % types
    if isempty(ty)
        d = Distance(g.Node(i).Location,dfn.pip.BE);                            % node distance from boundaries
        idx = find(d <= 1e-12);                                                 % TODO: fixed tolerance?
        if isempty(idx)                                                         % if not close enough
            g.Node(i).Type = 0;                                                 % inner
        else
            g.Node(i).Type = idx;                                               % non-inner
        end
    else
        g.Node(i).Type = ty(1);                                                 % boundary
    end
    g.Node(i).Pressure = NaN;                                                   % initial pressure
end
g.Size = [k,m];                                                                 % graph size (#nodes,#edges)
for i = 1:m                                                                     % loops over all edges
    line = [g.Node(g.Edge(i).Nodes).Location];                                  % edge's coordinates
    g.Edge(i).Length = sqrt(sum((line(4:6)-line(1:3)).^2));                     % edge's length
    g.Edge(i).Aperture = aFun(g.Edge(i).Length);                                % edge's aperture
    if isa(dFun,'function_handle')
        g.Edge(i).Depth = dFun(g.Edge(i).Length);                               % edge's depth
    end
    if CData.Almost(g.Edge(i).Length,0,1e-14)                                   % if too small edge
        g.Edge(i).Dip = 0;
        g.Edge(i).Dir = 0;
    else
        o = Orientation(line);                                                  % orientation information
        g.Edge(i).Dip = o.Dip;                                                  % dip angle
        g.Edge(i).Dir = o.Dir;                                                  % dip-direction angle
    end
end
dfn.grh = g;                                                                    % resulting graph
dfn.grh.BE = dfn.pip.BE;                                                        % boundary elements
if Report
    Display('Node#',k,'Edge#',m);                                               % displays information
end
Ticot;                                                                          % ends timing

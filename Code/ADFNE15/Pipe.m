function dfn = Pipe(be,fnm,mtd)
% Pipe
% generates 3D pipe model for given 2D|3D fracture network
%
% Usage...:
% dfn = Pipe(be,fnm,mtd);
%
% Input...: be        (k,4|cell),boundary elements,lines|polygons
%           fnm       cell:3D |lines(?,4):2D
%           mtd       {'tri','cnt'}:triangulation,center methods
% Output..: dfn       dfn,updated
%
% Examples:
%{
dfn = Pipe(be,fnm,'cnt');
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

global Report Tolerance Interval                                                % global defaults
if nargin < 3; mtd = 'cnt'; end                                                 % default method: center
Ticot('Building Pipe Model')                                                    % initializes timing
dfn.Percolate = false;
fnm = [be;fnm];                                                                 % merges boundary elements & fnm
dfn.dfn.Center = Center(fnm);                                                   % center points
if iscell(fnm)                                                                  % 3D polygons
    dfn.dfn.Poly = fnm;                                                         % stores fnm
    if length(fnm) < 2; return; end                                             % quits if only two polygons
    [xts,ids,La] = Intersect(fnm);                                              % intersection lines,indices,labels
    if La(1) ~= La(2)                                                           % if not percolating
        Ticot;                                                                  % ends timing
        disp('Not Percolating!');                                               % displays message
        return                                                                  % exits
    end
    xls = sqrt(sum((xts(:,4:6)-xts(:,1:3)).^2,2));                              % intersection lengths
    xls(xls == 0) = Tolerance;                                                  % TODO: better fixes
    La = Relabel(La);                                                           % relabels by frequencies
    if strcmpi(mtd(1:3),'tri')                                                  % 3d, triangulation method
        if length(mtd) == 3; mtd = [mtd,'r']; end                               % default random method
        gxs = Group(xts,ids,numel(La));                                         % groups indices,lines,etc.
        k = length(gxs);                                                        % number of groups
        pip = cell(k,1);                                                        % initializes pipes
        for i = 1:k                                                             % loops over all groups
            if isempty(gxs{i}); continue; end                                   % skips empty ones
            if size(gxs{i},1) == 1                                              % if only one line
                ply = Polyline(Stack(Split(gxs{i},Interval)));                  % splits at intervals
                pip{i,1} = ply(1:end-1,:);                                      % stores the pipes
            else
                pip{i,1} = Mesh(gxs{i},Interval,false,mtd(4));                  % generates mesh
            end
        end
        pn = cellfun(@numel,pip)'/6;                                            % frequencies in every cell
        pip = Stack(pip);                                                       % stacks up all pipes
        [pip,ia,~] = Unique(pip,1e-14);                                         % removes duplicates
        Pn = repelem(1:numel(pn),1,pn);
        [~,~,ic] = unique(Pn(ia));
        pn = accumarray(ic,1);                                                  % recalculates 'pn'
        if ~isempty(pip)
            n = sum(pn);                                                        % total number of pipes
            typ = zeros(n,1,'int32');                                           % initializes types
            pn = [0;pn];
            for i = 1:size(be,1)
                typ(1+pn(i):pn(i)+pn(i+1)) = i;
            end
            pLa = ones(n,1);                                                    % TODO: fix repelem(La,pn);
            pDp = ones(n,1);                                                    % TODO: fix this
        end
    else                                                                        % 3d, center method
        cxs = 0.5*(xts(:,1:3)+xts(:,4:6));
        xn = size(ids,1);
        pip = zeros(2*xn,6);                                                    % initializes pipes
        pLa = zeros(2*xn,1,'int32');                                            % pipe labels
        pDp = zeros(2*xn,1);                                                    % pipe depths
        typ = zeros(2*xn,1,'int32');                                            % pipe types
        k = -1;
        cts = dfn.dfn.Center;                                                   % centers
        bei = num2cell(1:size(be,1));                                           % boundary elements IDs
        for i = 1:xn
            id = ids(i,:);
            p1 = cts(id(1),:);                                                  % center of fracture 1
            p0 = cxs(i,:);                                                      % center of intersection line
            p2 = cts(id(2),:);                                                  % center of fracture 2
            k = k+2;
            pip(k,:) = [p1,p0];                                                 % pipes
            pip(k+1,:) = [p2,p0];
            pLa(k:k+1) = La(id(1));                                             % labels
            pDp(k:k+1) = xls(i);                                                % depths = intersection lengths
            switch id(1)
                case bei
                    typ(k) = id(1);                                             % pipe's type = be ID
            end
            switch id(2)
                case bei
                    typ(k+1) = id(2);                                           % pipe's type = be ID
            end
        end
    end
    if ~isempty(pip)
        dfn.pip.Pipe = pip;                                                     % pipes
        dfn.pip.n = size(pip,1);                                                % number of pipes
        dfn.pip.Type = typ;                                                     % pipe types
        dfn.pip.Label = pLa;                                                    % pipe labels
        dfn.pip.Depth = pDp;                                                    % pipe depths
        dfn.pip.Percolate = Percolate(La(1),La(2));                             % percolating state
        dfn.pip.BE = be;                                                        % boundary elements
    end
    dfn.dfn.Label = La;                                                         % intersection labels
    dfn.dfn.xLine = xts;                                                        % intersection lines
    dfn.dfn.xID = ids;                                                          % intersection indices
    dfn.dfn.xLength = xls;                                                      % intersection lengths
else                                                                            % 2D case
    if size(fnm,1) < 2
        dfn.dfn.Line = fnm;                                                     % no piping if only two lines
        return
    end
    [ols,jds,sn,xts,ids,La] = Split(fnm);                                       % split lines at intersections
    bc = [0;cumsum(sn(1:size(be,1)))];                                          % number of splits
    n = size(ols,1);
    dfn.dfn.Line = fnm;                                                         % stores fnm (lines)
    dfn.dfn.Label = La;                                                         % intersection labels
    dfn.dfn.xLine = xts;                                                        % intersection points
    dfn.dfn.xID = ids;                                                          % intersection indices
    dfn.dfn.xLength = Length(xts);                                              % intersection lengths
    dfn.pip.Pipe = Convert('3d',ols);                                           % makes 3D
    dfn.pip.Type = zeros(n,1);                                                  % initializes types
    for i = 1:numel(bc)-1; dfn.pip.Type(bc(i)+1:bc(i+1)) = i; end               % updates by boundary IDs
    dfn.pip.Depth = ones(n,1);                                                  % TODO:
    dfn.pip.Percolate = Percolate(La(1),La(2));                                 % updates percolating state
    dfn.pip.BE = Convert('3d',be);                                              % converts to 3d
    dfn.pip.sID = jds;                                                          % split IDs
end
if Report
    if isfield(dfn,'pip'); Display('Pipe#',size(dfn.pip.Pipe,1)); end           % displays information
end
dfn.Percolate = true;                                                           % sets percolating
Ticot;                                                                          % ends timing

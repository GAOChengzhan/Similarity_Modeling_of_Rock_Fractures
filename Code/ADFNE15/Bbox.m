function out = Bbox(in,varargin)
% Bbox
% returns bounding box|intersections for lines|polygons 'in', 2D|3D
%
% Usage...:
% out = Bbox(in,varargin);
%
% Input...: in        any,lines|polygons
%           varargin  {all|intersect|pp}
% Output..: out       any
%
% Examples:
%{
out = Bbox(rand(10,4)); % bounding box for all 2d lines
out = Bbox(rand(10,4),'pp'); % bounding box as point-to-point format
out = Bbox(rand(10,6)); % bounding box for all 3d lines
out = Bbox(rand(10,4),'all'); % bounding boxes for every 2d line
out = Bbox(rand(10,6),'all'); % bounding boxes for every 3d line
out = Bbox(rand(10,4),'intersect'); % indices of intersecting bbox for 2d lines
out = Bbox({rand(3,3)}); % bounding box for single 3d polygon
out = Bbox({rand(3,3);rand(3,3)}); % bounding box for 3d polygons
out = Bbox(plys,'intersect'); % indices of intersecting bbox for 3d polygons
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

inp = false;
if iscell(in)                                                                   % 2D|3D polygons
    mins = cell2mat(cellfun(@min,in,'UniformOutput',false));                    % mins for every polygon
    maxs = cell2mat(cellfun(@max,in,'UniformOutput',false));                    % maxs for every polygon
else
    [n,k] = size(in);
    if mod(k,2) == 0                                                            % lines 2D|3D etc.
        k = k/2;                                                                % for separation of points
        mins = cell2mat(arrayfun(@(i)min([in(i,1:k);in(i,k+1:end)],[],1),1:n,...  % all mins
            'UniformOutput',false)');
        maxs = cell2mat(arrayfun(@(i)max([in(i,1:k);in(i,k+1:end)],[],1),1:n,...  % all maxs
            'UniformOutput',false)');
    else                                                                        % so, 2D|3D points
        inp = true;
    end
end
if inp                                                                          % if points
    mins = min(in,[],1);                                                        % mins of all
    maxs = max(in,[],1);                                                        % maxs of all
elseif ~any(strcmpi(varargin,'all'))                                            % so, lines or polygons and
    mins = min(mins,[],1);                                                      %...if not 'all'; mins of all
    maxs = max(maxs,[],1);                                                      % maxs of all
end
if any(strcmpi(varargin,'intersect'))                                           % intersections
    bxs = Bbox(in,'all','pp');                                                  % bounding box of all
    n = size(in,1);
    m = n*(n-1)/2;                                                              % maximum possible intersections
    ids = zeros(m,2,'uint32');                                                  % intersection indices
    w = numel(bxs(1,:))/2;                                                      % to separate mins and maxs
    k = 0;                                                                      % intersection counter
    for i = 1:n-1                                                               % loops over all possibilities
        for j = i+1:n                                                           % skips already known possibilities
            if all(bxs(i,1:w) <= bxs(j,w+1:end)) &&...                          % intersection test
                    all(bxs(j,1:w) <= bxs(i,w+1:end))
                k = k+1;                                                        % counter adds up
                ids(k,:) = uint32([i,j]);                                       % indices are stored
            end
        end
    end
    out = ids(1:k,:);                                                           % returns indices
else
    out = [mins,maxs];                                                          % returns bounding box(s)
    if ~any(strcmpi(varargin,'pp'))                                             % reformats as point-to-point
        k = size(out(1,:),2);
        out = out(:,[1:2:k,2:2:k]);                                             % returns updated bounding box(s)
    end
end

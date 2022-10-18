function y = Scale(x,varargin)
% Scale
% scales "x" any,lines,polygons, see examples below
%
% Usage...:
% y = Scale(x,varargin);
%
% Input...: x         any,lines,polygons
%           varargin  any
% Output..: y         any
%
% Examples:
%{
y = Scale(rand(1,10)); % = scaled to [0..1]
y = Scale(rand(1,10),3,7); % = scaled to [3..7]
y = Scale([0,3,0,9],-1,1,3,7); % = [5,11,5,23]
y = Scale(rand(10,4),'lin',0.5); % = 2d lines scaled to half,centered
y = Scale(rand(10,6),'lin',0.5); % = 3d lines scaled to half,centered
y = Scale({rand(3,2)},'ply',0.5); % = 2d polygons scaled to half
y = Scale({rand(3,3);rand(3,3)},'ply',1/3); % = 3d polygons scaled to one third
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

n = length(varargin);
switch n
    case 0                                                                      % no argument provided
        x1 = min(x(:));
        x2 = max(x(:));
        if x2 > x1
            y = ((x-x1)/(x2-x1));
        else
            y = x;
        end
    case 2
        switch lower(varargin{1})
            case {'line','lin'}                                                 % scales lines
                cts = Center(x);                                                % centers
                x = x*varargin{2};                                              % applies scaling
                d = cts-Center(x);                                              % distance moved
                y = x+[d,d];                                                    % to original center
            case {'poly','ply'}                                                 % scales polygons
                [x,b] = Convert('cell',x);                                      % to cell if required
                cts = Center(x);                                                % centers
                x = cellfun(@(ply)varargin{2}*ply,x,'UniformOutput',false);     % applies scaling
                d = cts-Center(x);                                              % distance moved
                %y = arrayfun(@(i)x{i}+d(i,:),(1:length(x))','UniformOutput',...  % applies scaling
                %    false);
                y = arrayfun(@(i)bsxfun(@plus,x{i},d(i,:)),(1:length(x))',...
                    'UniformOutput',false);                                     % applies scaling
                if ~b; y = y{:}; end                                            % if input was not cell
            otherwise
                x1 = min(x(:));
                x2 = max(x(:));
                y1 = varargin{1};                                               % to, the minimum
                y2 = varargin{2};                                               % to, the maximum
                if x2 > x1
                    y = ((x-x1)/(x2-x1))*(y2-y1)+y1;
                else
                    y = 0.5*(y1+y2);                                            % if input is constant
                end
        end
    case 4
        x1 = varargin{1};                                                       % minimum for input
        x2 = varargin{2};                                                       % maximum for input
        y1 = varargin{3};                                                       % minimum for output
        y2 = varargin{4};                                                       % maximum for output
        y = ((x-x1)/(x2-x1))*(y2-y1)+y1;                                        % does scaling
    otherwise
        disp('Error: argument number mismatch (x)|(x,y1,y2)|(x,x1,x2,y1,y2)');
        y = x;
        return
end

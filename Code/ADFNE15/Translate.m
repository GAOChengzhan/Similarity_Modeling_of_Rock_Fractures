function y = Translate(x,mov)
% Translate
% translates "x" (2D|3D points,lines,polygons) by "mov"
%
% Usage...:
% y = Translate(x,mov);
%
% Input...: x         (n,2|3|4|6|cell)points,lines,polygons,2D|3D
%           mov       (2|3)
% Output..: y         any,translated
%
% Examples:
%{
pts = Translate(rand(10,2),[1,10]); % 2d points
pts = Translate(rand(10,3),[1,10,3]); % 3d points
lns = Translate(rand(10,4),[1,10]); % 2d lines
lns = Translate(rand(10,6),[1,10,3]); % 3d lines
ply = Translate({rand(3,2)},[1,10]); % 2d polygon
ply = Translate({rand(3,3)},[1,10,3]); % 3d polygon
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

if iscell(x)                                                                    % polygons
    n = length(x);
    y = arrayfun(@(i)x{i}+mov,1:n,'UniformOutput',false)';                      % moves polygons, 2D|3D
    if n == 1; y = y{1}; end
else                                                                            % moves points,lines 2D|3D
    if size(x,2) > numel(mov)
        %y = x+[mov,mov];                                                       % MR2017
        y = bsxfun(@plus,x,[mov,mov]);                                          % ...MR2015
    else
        %y = x+mov;                                                             % MR2017
        y = bsxfun(@plus,x,mov);                                                % ...MR2015
    end
end

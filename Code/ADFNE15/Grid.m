function lns = Grid(n,varargin)
% Grid
% generates grid lines, horizontal and vertical, 2D
%
% Usage...:
% lns = Grid(n,varargin);
%
% Input...: n         (1),number of lines
%           varargin  any
% Output..: lns       ((n-1)*2,4)
%
% Examples:
%{
lns = Grid(7,'ang',45);
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

opt = Option(varargin,'cnt',[0.5,0.5],'ang',0,'box',[0,0,1,1]);                 % default arguments
s = 1/n;                                                                        % separation distance
lns = Clip(Reshape(Rotate(Reshape(cell2mat([arrayfun(@(i)[0,0,0,1]+...          % clipped grid lines
    [i*s,0,i*s,0],1:n-1,'UniformOutput',false),arrayfun(@(i)[0,0,1,0]+...       % ...rotation applied
    [0,i*s,0,i*s],1:n-1,'UniformOutput',false)]'),[],2),'cnt',opt.cnt,'ang',... 
    opt.ang),[],4),opt.box);

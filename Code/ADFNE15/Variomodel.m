function out = Variomodel(mdl,lgs,draw)
% Variomodel
% creates and draws Variogram model
%
% Usage...:
% out = Variomodel(mdl,lgs,draw);
%
% Input...: mdl       sph|exp|lin
%           lgs       (n),lags
%           draw      (1),boolean
% Output..: out       model
%
% Examples:
%{
Variomodel({'name','sph','nugget',0,'sill',4,'range',40},0:0.5*max(d),true);
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

if nargin < 3; draw = false; end
if isempty(mdl); mdl = {'name','sph','nugget',0,'sill',4,'range',40}; end       % default model
mdl = struct(mdl{:});                                                           % converts to struct
switch lower(mdl.name)
    case {'spherical','sph'}                                                    % spherical model
        out = mdl.nugget+(mdl.sill*(1.5*lgs/mdl.range-0.5*...
            (lgs/mdl.range).^3).*(lgs <= mdl.range)+mdl.sill*(lgs > mdl.range));
    case {'exponential','exp'}                                                  % exponential model
        out = mdl.nugget+mdl.sill*(1-exp(-3*lgs/mdl.range));
    case {'linear','lin'}                                                       % linear model
        out = mdl.nugget+mdl.slope*lgs;
end
if draw
    plot(lgs,out);                                                              % plots variogram model
    if ~ishold
        xlabel('h'); ylabel('gamma'); axis square tight; box on;                % axes etc.
		title('Models');                                                        
        Axes(0,'p',5);                                                          % expands axes by 5%
    end
end

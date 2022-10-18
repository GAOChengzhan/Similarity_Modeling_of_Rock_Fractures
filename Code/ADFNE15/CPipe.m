classdef CPipe
% Pipe
% provides helper class for Pipe function, '.' interface
%
% Usage...:
% cpp = CPipe(varargin);
%
% Input...: varargin  same as Pipe function
% Output..: class
%
% Examples:
%{
cpp = CPipe(be,fnm,'cnt'); % = class, cpp.dfn
dfn = CPipe(be,fnm,'cnt').Backbone.Graph.Solve; % structure
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

    properties
        dfn                                                                     % public property
    end
    methods
        function self = CPipe(varargin)                                         % class constructor
            self.dfn = Pipe(varargin{:});                                       % invokes Pipe function
        end
        function self = Backbone(self,varargin)                                 % provides '.' structure
            self = CBackbone(self.dfn,varargin{:});                             % constructs CBackbone class
        end
    end
end

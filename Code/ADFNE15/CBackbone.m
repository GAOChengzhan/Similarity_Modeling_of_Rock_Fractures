classdef CBackbone
% CBackbone
% provides helper class for Backbone function, '.' interface
%
% Usage...:
% cbb = CBackbone(varargin);
%
% Input...: varargin  same as Backbone arguments
% Output..: class
%
% Examples:
%{
cbb = CBackbone(dfn,1e-12); % = class, cbb.dfn
dfn = CBackbone(dfn,1e-12).Graph.Solve; % structure
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
        dfn                                                                     % property
    end
    methods
        function self = CBackbone(varargin)                                     % class constructor
            self.dfn = Backbone(varargin{:});                                   % invokes Backbone function
        end
        function self = Graph(self,varargin)                                    % provides '.' structure
            self = CGraph(self.dfn,varargin{:});                                % constructs CGraph class
        end
    end
end

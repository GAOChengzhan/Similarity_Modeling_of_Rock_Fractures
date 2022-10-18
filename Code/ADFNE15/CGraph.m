classdef CGraph
% CGraph
% provides helper class for Graph function, '.' interface
%
% Usage...:
% cgr = CGraph(varargin);
%
% Input...: varargin  same as Graph function
% Output..: class
%
% Examples:
%{
cgr = CGraph(dfn); % = class, cgr.dfn
dfn = CGraph(dfn).Solve; % structure
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
        function self = CGraph(varargin)                                        % class constructor 
            self.dfn = Graph(varargin{:});                                      % invokes Graph function
        end
        function self = Solve(self,varargin)                                    % provides '.' structure
            self = Solve(self.dfn,varargin{:});                                 % invokes Solve function
        end
    end
end

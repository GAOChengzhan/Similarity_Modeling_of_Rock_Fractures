classdef CData
% CData
% class of functions that apply to data, see details included in each
%
% Examples:
%{
b = CData.Almost(rand(1,10),0.5,0.1);
b = CData.Almost(rand(1,10)*2*eps,0,eps);   % close to zero
[x,y] = CData.Deal(rand(3,2));
dts = CData.Discretize(rand(1,100),4);
CData.Filewrite('this.txt','This');
y = CData.Get([1,2,3,4]',1);                % = 1
y = CData.Get([1,2,3,4]',10);               % = 4
[les,equ,grt] = CData.Leg(rand(1,10),0.5,0.01);
CData.Map([1,2,3],@max,@min,@mean,@std,@var,@(x)x(end));  % = [3,1,2,1,1,3]
y = CData.Array(rand(1,4),rand(3,2));       % 2d line
y = CData.Array(rand(10,4),rand(3,2));      % 2d line sets
y = CData.Array(rand(5,3),rand(3,3));       % points, single polygon
y = CData.Array(rand(3,2),rand(3,2));       % 2d polygon sets
y = CData.Array({rand(3,2)},rand(3,2));     % single polygon
y = CData.Array({rand(3,2);rand(3,2)},rand(4,2));  % polygons
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

    methods (Static)
        function b = Almost(x,y,tol)
            % Almost
            % checks if "x" is close to "y" by "tol"
            %
            % Usage...:
            % b = Almost(x,y,tol);
            %
            % Input...: x         any
            %           y         any
            %           tol       (1),tolerance
            % Output..: b         any,boolean
            %
            % Examples:
            %{
            b = Almost(rand(1,10),0.5,0.1);
            b = Almost(rand(1,10)*2*eps,0,eps); % close to zero
            %}
            %
            % Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
            % Copyright (c) 2018 Alghalandis Computing @
            % Author: Dr. Younes Fadakar Alghalandis
            % (w) http://alghalandis.net        (e) alghalandis.net@gmail.com
            % All rights reserved.
            %
            % License.: ADFNE_License.txt and at http://alghalandis.net/products/adfne
            %
            % Citation:
            % Fadakar-A Y, 2017, "ADFNE: Open source software for discrete fracture network
            % engineering, two and three dimensional applications", Journal of Computers &
            % Geosciences, 102:1-11.
            %
            % see more at: http://alghalandis.net/products/adfne
            % Updated.: 2018-01-11
            
            global Tolerance
            if nargin < 3; tol = Tolerance; end                                 % default tolerance
            b = (abs(x-y) <= tol);
        end
        
        function varargout = Deal(x)
            % Deal
            % distributes "x" to "varargout" column-wise
            %
            % Usage...:
            % varargout = Deal(x);
            %
            % Input...: x         any,column-wise
            % Output..: varargout any
            %
            % Examples:
            %{
			[x,y] = Deal(rand(3,2));
            %}
            %
            % Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
            % Copyright (c) 2018 Alghalandis Computing @
            % Author: Dr. Younes Fadakar Alghalandis
            % (w) http://alghalandis.net        (e) alghalandis.net@gmail.com
            % All rights reserved.
            %
            % License.: ADFNE_License.txt and at http://alghalandis.net/products/adfne
            %
            % Citation:
            % Fadakar-A Y, 2017, "ADFNE: Open source software for discrete fracture network
            % engineering, two and three dimensional applications", Journal of Computers &
            % Geosciences, 102:1-11.
            %
            % see more at: http://alghalandis.net/products/adfne
            % Updated.: 2018-01-11
            
            varargout = cell(nargout,1);                                        % initializes the outputs
            for j = 1:nargout                                                   % loops over all outputs
                varargout{j} = x(:,j);                                          % assigns values to outputs
            end
        end
        
        function y = Discretize(x,n)
            % Discretize
            % discretizes "x" into "n" groups
            %
            % Usage...:
            % y = Discretize(x,n);
            %
            % Input...: x         any
            %           n         (1),number
            % Output..: y         any
            %
            % Examples:
            %{
			dts = Discretize(rand(1,100),4);
			assert(numel(unique(dts)) == 4,'Error!');
            %}
            %
            % Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
            % Copyright (c) 2018 Alghalandis Computing @
            % Author: Dr. Younes Fadakar Alghalandis
            % (w) http://alghalandis.net        (e) alghalandis.net@gmail.com
            % All rights reserved.
            %
            % License.: ADFNE_License.txt and at http://alghalandis.net/products/adfne
            %
            % Citation:
            % Fadakar-A Y, 2017, "ADFNE: Open source software for discrete fracture network
            % engineering, two and three dimensional applications", Journal of Computers &
            % Geosciences, 102:1-11.
            %
            % see more at: http://alghalandis.net/products/adfne
            % Updated.: 2018-01-11
            
            y = discretize(x,n,linspace(min(x),max(x),n));                      % discretizes based on 'x' range
        end
        
        function Filewrite(fname,txt)
            % Filewrite
            % writes text "txt" into file "fname"
            %
            % Usage...:
            % Filewrite(fname,txt);
            %
            % Input...: fname     (1),filename
            %           txt       (1),string
            %
            % Examples:
            %{
			Filewrite('this.txt','This');
            %}
            %
            % Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
            % Copyright (c) 2018 Alghalandis Computing @
            % Author: Dr. Younes Fadakar Alghalandis
            % (w) http://alghalandis.net        (e) alghalandis.net@gmail.com
            % All rights reserved.
            %
            % License.: ADFNE_License.txt and at http://alghalandis.net/products/adfne
            %
            % Citation:
            % Fadakar-A Y, 2017, "ADFNE: Open source software for discrete fracture network
            % engineering, two and three dimensional applications", Journal of Computers &
            % Geosciences, 102:1-11.
            %
            % see more at: http://alghalandis.net/products/adfne
            % Updated.: 2018-01-11
            
            fid = fopen(fname,'w');                                             % opens file for writing
            n = size(txt,1);                                                    % number of texts
            if n > 1
                for i = 1:n-1                                                   % loops over all cells in text
                    fprintf(fid,'%s\n',strip(txt{i},'right'));
                end
                if ~isempty(strip(txt{n}))                                      % takes care of the last cell
                    fprintf(fid,'%s\n',strip(txt{n},'right'));                  %...to avoid adding blank line
                end
            else                                                                % if only one text
                fwrite(fid,txt);
            end
            fclose(fid);                                                        % close the file handle
        end
        
        function y = Get(x,i)
            % Get
            % returns item "i" from "x"
            %
            % Usage...:
            % y = Get(x,i);
            %
            % Input...: x         any
            %           i         (1),number
            % Output..: y         (1),any
            %
            % Examples:
            %{
			y = Get([1,2,3,4]',1); % = 1
			y = Get([1,2,3,4]',10); % = 4
            %}
            %
            % Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
            % Copyright (c) 2018 Alghalandis Computing @
            % Author: Dr. Younes Fadakar Alghalandis
            % (w) http://alghalandis.net        (e) alghalandis.net@gmail.com
            % All rights reserved.
            %
            % License.: ADFNE_License.txt and at http://alghalandis.net/products/adfne
            %
            % Citation:
            % Fadakar-A Y, 2017, "ADFNE: Open source software for discrete fracture network
            % engineering, two and three dimensional applications", Journal of Computers &
            % Geosciences, 102:1-11.
            %
            % see more at: http://alghalandis.net/products/adfne
            % Updated.: 2018-01-11
            
            n = size(x,1);                                                      % size of input
            y = x(min(i,n),:);                                                  % chooses at corrected index
        end
        
        function [les,equ,grt] = Leg(x,ref,tol)
            % Leg
            % returns masks for "x" as less,equal and greater than ref value
            %
            % Usage...:
            % [les,equ,grt] = Leg(x,ref,tol);
            %
            % Input...: x         any,number
            %           ref       (1),reference value
            %           tol       (1),tolerance
            % Output..: les       boolean,any,less than
            %           equ       boolean,any,equal to
            %           grt       boolean,any,greater than
            %
            % Examples:
            %{
			[les,equ,grt] = Leg(rand(1,10),0.5,0.01);
            %}
            %
            % Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
            % Copyright (c) 2018 Alghalandis Computing @
            % Author: Dr. Younes Fadakar Alghalandis
            % (w) http://alghalandis.net        (e) alghalandis.net@gmail.com
            % All rights reserved.
            %
            % License.: ADFNE_License.txt and at http://alghalandis.net/products/adfne
            %
            % Citation:
            % Fadakar-A Y, 2017, "ADFNE: Open source software for discrete fracture network
            % engineering, two and three dimensional applications", Journal of Computers &
            % Geosciences, 102:1-11.
            %
            % see more at: http://alghalandis.net/products/adfne
            % Updated.: 2018-01-11
            
            global Tolerance
            if nargin < 3; tol = Tolerance; end                                 % default tolerance
            equ = abs(x-ref) <= tol;                                            % equal to
            les = (x < ref) & ~equ;                                             % less than
            grt = (x > ref) & ~equ;                                             % greater than
        end
        
        function map = Map(x,varargin)
            % Map
            % maps functions in "varargin" applying to "x"
            %
            % Usage...:
            % map = Map(x,varargin);
            %
            % Input...: x         any
            %           varargin  function handles
            % Output..: map       mapped results
            %
            % Examples:
            %{
			Map([1,2,3],@max,@min,@mean,@std,@var,@(x)x(end)); % = [3,1,2,1,1,3]
            %}
            %
            % Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
            % Copyright (c) 2018 Alghalandis Computing @
            % Author: Dr. Younes Fadakar Alghalandis
            % (w) http://alghalandis.net        (e) alghalandis.net@gmail.com
            % All rights reserved.
            %
            % License.: ADFNE_License.txt and at http://alghalandis.net/products/adfne
            %
            % Citation:
            % Fadakar-A Y, 2017, "ADFNE: Open source software for discrete fracture network
            % engineering, two and three dimensional applications", Journal of Computers &
            % Geosciences, 102:1-11.
            %
            % see more at: http://alghalandis.net/products/adfne
            % Updated.: 2018-01-11
            
            map = cellfun(@(f)f(x),varargin);                                   % maps every function in varargin
        end
        
        function y = Array(x,pts)
            % Array
            % populates copies of "x" into points "pts"
            %
            % Usage...:
            % y = Array(x,pts);
            %
            % Input...: x         any,(2D|3D),points|lines|polygons
            %           pts       (n,2|3),points
            % Output..: y         any
            %
            % Examples:
            %{
			y = Array(rand(1,4),rand(3,2)); % 2d line
			y = Array(rand(10,4),rand(3,2)); % 2d line sets
			y = Array(rand(5,3),rand(3,3)); % points,single polygon
			y = Array(rand(3,2),rand(3,2)); % 2d polygon sets
			y = Array({rand(3,2)},rand(3,2)); % single polygon
			y = Array({rand(3,2);rand(3,2)},rand(4,2)); % polygons
            %}
            %
            % Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
            % Copyright (c) 2018 Alghalandis Computing @
            % Author: Dr. Younes Fadakar Alghalandis
            % (w) http://alghalandis.net        (e) alghalandis.net@gmail.com
            % All rights reserved.
            %
            % License.: ADFNE_License.txt and at http://alghalandis.net/products/adfne
            %
            % Citation:
            % Fadakar-A Y, 2017, "ADFNE: Open source software for discrete fracture network
            % engineering, two and three dimensional applications", Journal of Computers &
            % Geosciences, 102:1-11.
            %
            % see more at: http://alghalandis.net/products/adfne
            % Updated.: 2018-01-11
            
            n = size(pts,1);                                                    % number of points
            y = cell(n,1);                                                      % prepares the output
            for i = 1:n                                                         % loops over all points
                y{i} = Translate(x,pts(i,:));                                   % translates the item
            end
        end
    end
end

function Export(in,fname,varargin)
% Export
% exports "in" as file in specific format, 3D{geo|vtk|html|xyz|txt|inp},...
%                                          2D{svg|htm},mat,png|pdf
%
% Usage...:
% Export(in,fname,varargin);
%
% Input...: in        (n,4|cell),lines,polygons,variable,figure
%           fname     filename
%           varargin  any
%
% Examples:
%{
Export(rand(10,4),'lns.htm'); % 2d htm
Export(rand(10,4),'lns.svg'); % 2d svg
Export(Field(DFN('dim',3),'Poly'),'ply.htm'); % 3d WebGL
Export(Field(DFN('dim',3),'Poly'),'ply.vtk'); % 3d vtk
Export(Field(DFN('dim',3),'Poly'),'ply.xyz'); % 3d text
Export(Field(DFN('dim',3),'Poly'),'ply.txt'); % 3d text
Export(Field(DFN('dim',3),'Poly'),'ply.geo'); % 3d geo
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

[fld,fil,ext] = fileparts(fname);                                               %file name parts
ext = lower(ext(2:end));
switch ext
    case 'geo'                                                                  % in:{ply} to GMSH .geo format
        Ticot(sprintf('Exporting as %s.%s',fil,ext));                           % initializes timing
        try err = varargin{1}; catch; err = 1e-6; end                           % default error for geo file
        pts = Stack(in);                                                        % all polygons as points
        fid = fopen(fname,'w');                                                 % prepares file for writing
        fprintf(fid,'/* (c) 2018 Alghalandis Computing @ alghalandis.net */\n');  % header
        fprintf(fid,'/* Points */\n');                                          % section header
        for i = 1:size(pts,1)                                                   % loop over all points
            fprintf(fid,'Point(%d) = {%0.6f, %0.6f, %0.6f, %0.6f};\n',i,...     % write into file
                pts(i,:),err);
        end
        fprintf(fid,'/* Lines */\n');                                           % section header
        nps = cellfun(@numel,in)/3;                                             % number of points
        k = 0;                                                                  % counter
        for i = 1:numel(nps)
            for j=1:nps(i)-1
                k = k+1;
                fprintf(fid,'Line(%d) = {%d, %d};\n',k,k,k+1);
            end
            k = k+1;
            fprintf(fid,'Line(%d) = {%d, %d};\n',k,k,k+1-nps(i));               % handles the last item
        end
        cn = [0,cumsum(nps)'];
        fprintf(fid,'/* Polylines */\n');                                       % section header
        n = length(in);                                                         % number of polygons
        for i = 1:n
            lst = sprintf(', %d',cn(i)+1:cn(i+1));
            fprintf(fid,'Line Loop(%d) = {%s};\n',i,lst(3:end));
        end
        fprintf(fid,'/* Polygons */\n');                                        % section header
        for i = 1:n
            fprintf(fid,'Plane Surface(%d) = {%d};\n',i,i);
        end
        fclose(fid);                                                            % closes the file
        Ticot;                                                                  % ends timing
    case {'htm','html'}                                                         % in:{ply}|(n,4)lines to WebGL| .html
        Ticot(sprintf('Exporting as %s.%s',fil,ext));                           % initializes timing
        if ~iscell(in)                                                          % 2d lines
            opt = Option(varargin,'width',1280,'height',960,'color',[0,0,0],'lw',1);  % default arguments
            [x1,y1,x2,y2] = CData.Deal(Bbox(in,'pp'));                          % for convenience
            rx = opt.width/(x2-x1);
            ry = opt.height/(y2-y1);
            r = min(rx,ry);
            in = in*r;                                                          % scales lines
            n = size(in,1);
            htm = {...                                                          % header
                '<!DOCTYPE html>'
                '<html>'
                '<head><title>DFN - ADFNE1.5 - Alghalandis Computing @ alghalandis.net</title></head>'
                '<body>'
                sprintf('    <canvas id=''canvas'' width=''%d'' height=''%d''></canvas>',opt.width,opt.height)
                '    <script>'
                '    var Ink = document.getElementById("canvas").getContext("2d");'
                '//#layer1'};
            for i = 1:n                                                         % loops over all lines
                line = in(i,:);                                                 % chooses a line
                htm{i*9} = sprintf('//#path%04d',i);
                htm{i*9+1} = '    Ink.beginPath();';
                htm{i*9+2} = '    Ink.lineJoin = ''miter'';';
                htm{i*9+3} = sprintf('    Ink.strokeStyle = ''rgb(%d, %d, %d)'';',...
                    color(1),color(2),color(3));
                htm{i*9+4} = '    Ink.lineCap = ''butt'';';
                htm{i*9+5} = sprintf('    Ink.lineWidth = %0.6f;',opt.lw);
                htm{i*9+6} = sprintf('    Ink.moveTo(%0.6f, %0.6f);',line(1),line(2));
                htm{i*9+7} = sprintf('    Ink.lineTo(%0.6f, %0.6f);',line(3),line(4));
                htm{i*9+8} = '    Ink.stroke();';
            end
            htm{end+1} = '    </script>';
            htm{end+1} = '</body>';
            htm{end+1} = '</html>';
            fid = fopen(fname,'w');                                             % prepares file for writing
            for i = 1:length(htm)
                fprintf(fid,'%s\n',htm{i});                                     % writes into file
            end
            fclose(fid);                                                        % closes the file
        else                                                                    % 3d polygons: WebGL
            opt = Option(varargin,'color',[],'mov',[0,0,0]);                    % default arguments
            top = {...                                                          % header
                '<!DOCTYPE html>'
                '<html lang="en">'
                '    <head>'
                '        <title>DFN - ADFNE1.5 - Alghalandis Computing @ alghalandis.net</title>'
                '        <meta charset="utf-8">'
                '        <meta name="viewport" content="width=device-width">'
                '    </head>'
                '    <body>'
                '        <div id="ctn"></div>'
                '        <script src="three.js"></script>'
                '    	 <script src="OrbitControls.js"></script>'
                '        <script>'
                '            var ctn,cam,scn,ren,rct,mouse,mesh,line;'
                '            init();'
                '            animate();'
                '            function init(){'
                '                ctn = document.getElementById("ctn");'
                '                scn = new THREE.Scene();'
                '                var axs = new THREE.AxisHelper(1);'
                '                scn.add(axs);'
                '                cam = new THREE.PerspectiveCamera(60,window.innerWidth/window.innerHeight,1,10000);'
                '                cam.position.set(0.5,0.5,1.5).setLength(3);'
                '                ren = new THREE.WebGLRenderer({antialias:true});'
                '                ren.setSize(window.innerWidth,window.innerHeight);'
                '                ctl = new THREE.OrbitControls(cam);//,ren.domElement);'
                '                grd = new THREE.GridHelper(2,10);'
                '                grd.geometry.rotateX(Math.PI/2);'
                '                grd.lookAt(new THREE.Vector3(0,0,1));'
                '                scn.add(grd);'
                '		         ctl.maxPolarAngle = Math.PI*0.5;'
                '		         ctl.minDistance = 3;'
                '		         ctl.maxDistance = 6;'
                '                cam.up.set(0,0,1);'
                '                cam.lookAt(new THREE.Vector3(0,0,0));'
                '                ctl.update();'
                '                //scn.fog = new THREE.Fog(0x050505,2000,3500);'
                '                scn.add(new THREE.AmbientLight(0x444444));'
                '                var light = new THREE.DirectionalLight(0xffffff,0.5);'
                '                light.position.set(0,1,1);'
                '                scn.add(light);'
                '                var light = new THREE.DirectionalLight(0xffffff,0.1);'
                '                light.position.set(1,1,1);'
                '                scn.add(light);'
                '                var dfn = new THREE.BufferGeometry();'
                '                var c = new THREE.Color();'};
            btm = {...
                '                dfn.addAttribute("position",new THREE.BufferAttribute(pos,3));'
                '                dfn.addAttribute("normal",new THREE.BufferAttribute(nrm,3));'
                '                dfn.addAttribute("color",new THREE.BufferAttribute(col,3));'
                '                dfn.computeBoundingSphere();'
                '                var material = new THREE.MeshPhongMaterial({'
                '                color:0xaaaaaa,specular:0x777777,shininess:15,'
                '                side:THREE.DoubleSide,vertexColors:THREE.VertexColors});'
                '                mesh = new THREE.Mesh(dfn,material);'
                '                scn.add(mesh);'
                '                rct = new THREE.Raycaster();'
                '                mus = new THREE.Vector2();'
                '                var pik = new THREE.BufferGeometry();'
                '                pik.addAttribute("position",new THREE.BufferAttribute(new Float32Array(4*3),3));'
                '                var material = new THREE.LineBasicMaterial({color:0xffffff,linewidth:1,transparent:true});'
                '                line = new THREE.Line(pik,material);'
                '                scn.add(line);'
                '                ctn.appendChild(ren.domElement);'
                '                window.addEventListener("resize",WinResize,false);'
                '                document.addEventListener("mousemove",MusMove,false);'
                '            }'
                '            function WinResize(){'
                '                cam.aspect = window.innerWidth/window.innerHeight;'
                '                cam.updateProjectionMatrix();'
                '                ren.setSize(window.innerWidth,window.innerHeight);'
                '            }'
                '            function MusMove(event){'
                '                event.preventDefault();'
                '                mus.x = (event.clientX/window.innerWidth)*2-1;'
                '                mus.y =-(event.clientY/window.innerHeight)*2+1;'
                '            }'
                '            function animate(){'
                '                requestAnimationFrame(animate);'
                '                render();'
                '            }'
                '            function render(){'
                '                rct.setFromCamera(mus,cam);'
                '                var intersects = rct.intersectObject(mesh);'
                '                if (intersects.length > 0){'
                '                    var intersect = intersects[0];'
                '                    var face = intersect.face;'
                '                    var linePosition = line.geometry.attributes.position;'
                '                    var meshPosition = mesh.geometry.attributes.position;'
                '                    linePosition.copyAt(0,meshPosition,face.a);'
                '                    linePosition.copyAt(1,meshPosition,face.b);'
                '                    linePosition.copyAt(2,meshPosition,face.c);'
                '                    linePosition.copyAt(3,meshPosition,face.a);'
                '                    mesh.updateMatrix();'
                '                    line.geometry.applyMatrix(mesh.matrix);'
                '                    line.visible = true;'
                '                } else {'
                '                    line.visible = false;'
                '                }'
                '                ctl.update();'
                '                ren.render(scn,cam);'
                '            }'
                '        </script>'
                '    </body>'
                '</html>'};
            tre = {...                                                          % triangles
                '                pos[%d] = %0.6f; pos[%d] = %0.6f; pos[%d] = %0.6f;\n'
                '                nrm[%d] = %0.6f; nrm[%d] = %0.6f; nrm[%d] = %0.6f;\n'
                '                col[%d] = %0.6f; col[%d] = %0.6f; col[%d] = %0.6f;\n'};
            fid = fopen(fname,'w');                                             % prepares file for writing
            for i = 1:length(top)
                fprintf(fid,'%s\n',top{i});                                     % writes into the file
            end
            sz = sum(cellfun(@length,in))*3*3;
            fprintf(fid,'                var pos = new Float32Array(%d);\n',sz);  % positions
            fprintf(fid,'                var nrm = new Float32Array(%d);\n',sz);  % normals
            fprintf(fid,'                var col = new Float32Array(%d);\n',sz);  % colors
            w = 0;
            n = length(in);
            if isempty(opt.color); opt.color = rand(n,3); end                   % default color
            oc = (numel(opt.color) == 3);
            rep = (n > 1000);                                                   % reporting check
            nrm = Polynorm(in);                                                 % normals of polygons
            trs = Polytri(in);                                                  % triangles from polygons
            for i = 1:n                                                         % loop over all polygons
                if oc
                    col = opt.color;                                            % fixed color
                else
                    col = opt.color(i,:);
                end
                for j = 1:length(trs{i})                                        % loop over triangles of polygon
                    tri = trs{i}{j};
                    for k = 1:3
                        pos = tri(k,:)+opt.mov;
                        fprintf(fid,tre{1},[w,pos(1),w+1,pos(2),w+2,pos(3)]);
                        fprintf(fid,tre{2},[w,nrm(i,1),w+1,nrm(i,2),w+2,nrm(i,3)]);
                        fprintf(fid,tre{3},[w,col(1),w+1,col(2),w+2,col(3)]);
                        w = w+3;
                    end
                end
                if rep && (mod(i,1000) == 0)                                    % reporting
                    fprintf(1,'% 9d/%d\n',i,n);                                 % displays on the screen
                end
            end
            for i = 1:length(btm)                                               % write ending into the file
                fprintf(fid,'%s\n',btm{i});
            end
            fclose(fid);                                                        % closes the file
        end
        Ticot;
    case 'inp'                                                                  % in:{pts,trs} to Abaqus .inp format
        Ticot(sprintf('Exporting as %s.%s',fil,ext));                           % initializes timing
        pts = in{1};                                                            % points
        trs = in{2};                                                            % triangles indices
        try header = varargin{1}; catch; header = fname; end                    % header
        fid = fopen(fname,'w');                                                 % prepares file for writing
        fprintf(fid,'*Heading\n');                                              % header
        fprintf(fid,' %s - ADFNE1.5 - Alghalandis Computing @ alghalandis.net\n',header);
        fprintf(fid,'*NODE\n');                                                 % section header
        n = size(pts,1);                                                        
        for i = 1:n                                                             % loop over all points
            fprintf(fid,'%d,%f,%f,%f\n',i,pts(i,:));
        end
        fprintf(fid,'******* E L E M E N T S *************\n');
        fprintf(fid,'*ELEMENT, type=CPS3, ELSET=Surface1\n');                   % section header
        for i = 1:n
            fprintf(fid,'%d,%d,%d,%d\n',i,trs(i,:));
        end
        fclose(fid);                                                            % closes the file
        Ticot;                                                                  % ends timing
    case 'vtk'                                                                  % in:{ply} to .vtk format
        Ticot(sprintf('Exporting as %s.%s',fil,ext));                           % initializes timing
        try colors = varargin{1}; catch; colors = []; end                       % colors
        nply = length(in);                                                      % number of polygons
        plyn = cellfun(@length,in,'UniformOutput',false);                       % vertex count of all polygons
        npnt = sum(cell2mat(plyn));                                             % total vertices' number
        fid = fopen(fname,'w');                                                 % prepares file for writing
        fprintf(fid,'# vtk DataFile Version 3.0\n');                            % header...
        fprintf(fid,'DFN - ADFNE1.5 - Alghalandis Computing @ alghalandis.net\n');
        fprintf(fid,sprintf('ASCII\nDATASET POLYDATA\nPOINTS %d float\n',npnt));
        for i = 1:nply                                                          % loops over all polygons
            ply = in{i};
            fprintf(fid,sprintf('%0.6f %0.6f %0.6f\n',ply'));
        end
        fprintf(fid,sprintf('POLYGONS %d %d\n',nply,npnt+nply));                % section header
        k = 0;
        for i = 1:nply                                                          % polygon data
            fprintf(fid,strcat(sprintf('%d ',plyn{i},k:k+plyn{i}-1),'\n'));
            k = k+plyn{i};
        end
        fprintf(fid,sprintf('POINT_DATA %d\n',npnt));                           
        fprintf(fid,'COLOR_SCALARS lut 4\n');
        if isempty(colors)
            colors = repmat([1,0,0.5,1],nply,1);
        elseif size(colors,2) == 3                                              % if no alpha,sets to 1
            colors(:,4) = 1;
        end
        for i = 1:nply
            for j = 1:plyn{i}
                fprintf(fid,strcat(sprintf('%0.3f ',colors(i,:)),'\n'));        % write into file, the colors
            end
        end
        fclose(fid);                                                            % close the file
        Ticot;                                                                  % ends timing
    case 'xyz'                                                                  % in:(m,n,o) to ASCII .xyx format
        Ticot(sprintf('Exporting as %s.%s',fil,ext));                           % initializes timing
        try index = varargin{1}; catch; index = false; end                      % index default
        if ~index                                                               % if no index required
            dlmwrite(fname,in,'delimiter',',')                                  % writes into file at once
        else                                                                    % indices are required as well
            fid = fopen(fname,'w');                                             % prepares file for writing
            [m,n,o] = size(in);
            for i = 1:m
                for j = 1:n
                    for k = 1:o
                        fprintf(fid,sprintf('%d, %d, %d, %0.6f\n',i,j,k,...     % write into file
                            in(i,j,k)));
                    end
                end
            end
            fclose(fid);                                                        % closes the file
        end
        Ticot;                                                                  % ends timing
    case 'svg'                                                                  % in:(n,4)lines to .svg format
        Ticot(sprintf('Exporting as %s.%s',fil,ext));                           % initializes timing
        opt = Option(varargin,'width',1280,'height',960,'color','000000','lw',1);  % default arguments
        [x1,y1,x2,y2] = CData.Deal(Bbox(in,'pp'));
        rx = opt.width/(x2-x1);
        ry = opt.height/(y2-y1);
        r = min(rx,ry);
        in = in*r;
        n = size(in,1);
        svg = {                                                                 % header
            '<?xml version="1.0" encoding="UTF-8" standalone="no"?>'
            '<svg'
            '   xmlns="http://alghalandis.net"'
            '   version="ADFNE1.5"'
            '   id="svg2"'};
        svg{end+1} = sprintf('   viewBox="%0.6f %0.6f %0.6f %0.6f"',x1*r,y1*r,x2*r,y2*r);
        svg{end+1} = sprintf('   height="%dmm"',opt.height);
        svg{end+1} = sprintf('   width="%dmm">',opt.width);
        svg = [svg;...
            {'  <defs'
            '     id="defs4" />'
            '  <metadata'
            '     id="metadata7">'
            '    <rdf:RDF>'
            '      <cc:Work'
            '         rdf:about="">'
            '        <dc:format>image/svg+xml</dc:format>'
            '        <dc:type'
            '           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />'
            '        <dc:title></dc:title>'
            '      </cc:Work>'
            '    </rdf:RDF>'
            '  </metadata>'
            '  <g'
            '     id="DFN">'}];
        for i = 1:n                                                             % loops over all lines
            line = in(i,:);
            svg{i*4+25} = '    <path';
            svg{i*4+26} = sprintf('       id="path%04d"',i);
            svg{i*4+27} = sprintf('       d="M %0.6f, %0.6f %0.6f, %0.6f"',line(1),...
                line(2),line(3),line(4));
            svg{i*4+28} = sprintf(['       style="fill:none;fill-rule:evenodd;stroke:#%s',...
                ';stroke-width:%dpx;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />'],...
                opt.color,opt.lw);
        end
        svg{end+1} = '  </g>';
        svg{end+1} = '</svg>';
        fid = fopen(fname,'w');                                                 % prepares file for writing
        for i = 1:length(svg)
            fprintf(fid,'%s\n',svg{i});                                         % writes into the file
        end
        fclose(fid);                                                            % closes the file
        Ticot;                                                                  % ends timing
    case 'txt'                                                                  % in:{ply} to .txt format
        Ticot(sprintf('Exporting as %s.%s',fil,ext));                           % initializes timing
        fid = fopen(fname,'w');                                                 % prepares file for writing
        n = length(in);
        fprintf(fid,'%d\n',n);
        for i = 1:n                                                             % loops over all polygons
            ply = in{i};
            m = size(ply,1);
            fprintf(fid,'%d\n',m);
            for j = 1:m
                fprintf(fid,'%g, %g, %g\n',ply(j,:));
            end
        end
        fclose(fid);                                                            % closes the file
        Ticot;                                                                  % ends timing
    case {'png','pdf'}                                                          % in:figure handle to png|pdf format
        Ticot(sprintf('Exporting as %s.%s',fil,ext));                           % initializes timing
        try res = varargin{1}; catch; res = '300'; end                          % default resolution
        if isempty(in); in = gcf; end                                           % figure handle
        set(in,'PaperPositionMode','auto');
        if strcmp(ext,'pdf')                                                    % pdf format
            set(in,'PaperUnits','points');
            set(in,'PaperSize',[1300,850]);
            fmt = '-dpdf';
        else
            fmt = '-dpng';                                                      % png format
        end
        print(fname,['-r',res],fmt);                                            % writes into the file
        Ticot;                                                                  % ends timing
    case 'mat'                                                                  % in:figure handle to png, varargin to .mat format
        Ticot(sprintf('Exporting as %s.%s',fil,ext));                           % initializes timing
        if isempty(in); in = gcf; end                                           % figure handle
        n = nargin-2;
        vars = cell(1,n);
        for i = 1:n; vars{i} = inputname(i+2); end                              % catches arguments' names
        fname = [fld,'\',fil,'_',Time,'.mat'];                                  % file name for workspace
        evalin('base',['save(''',fname,'''',sprintf(',''%s''',vars{:}),');']);  % invokes 'save' function
        if ishandle(in); saveas(1,[fld,'\',fil,'.png']); end                    % exports figure as image file
        Ticot;                                                                  % ends timing
end

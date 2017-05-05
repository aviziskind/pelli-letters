function [signal, t]=DrawLetter(t,letter, useModifiedVersion)% Draws a snake in the shape of a letter. As we trace the stroke of the letter,% we draw a mark every so often. Each mark is a gabor patch. They add.% Denis Pelli & Noah Raizman 17 July 1998if nargin < 3    useModifiedVersion = 0;end   % the basic turtle statet.position=[14 14];t.position=[10 4]; % perfect for tiny gabors (0.1 deg)t.position=[0 0];t.position=[t.signalSize-t.signalCoreSize,t.signalSize-t.signalCoreSize]/2;t.nextMark=1;if t.randSpacing	t.inkLength=floor(rand(1)*t.markSpacing/2);else	t.inkLength=0;endt.direction=[0,1];t.ink=1;t.print=0;	% each routine prints on the console each time it's calledif t.print	fprintf('DRAWLETTER "%c"\n',letter);endt.show=t.animate;	% show letter onscreen once it's computedt.newLetter=1;if t.show	r=[0 0 t.signalSize t.signalSize];	t.window=SCREEN(0,'OpenWindow',[],r);endt.canvasSize=t.signalSize+200;r=[0,0,t.signalCoreSize,t.signalCoreSize];canvasRect=[0,0,t.canvasSize,t.canvasSize];r=CenterRect(r,canvasRect);t.canvasX0=r(RectLeft);t.canvasY0=r(RectTop); % actually the bottom, using the convention that y increases upwardmag=t.signalCoreSize/100;	% Begin at the lower left corner of a 100x100 bounding box that contains the core of the strokes.switch letter    case 'C'        t.ink=0;        t=Forward(t,50*mag);        if useModifiedVersion == 2            t=Curve(t,50*mag,167 + 40);            t.ink=1;            t=Curve(t,50*mag,165+164);        else                t.ink=1;            t=Curve(t,50*mag,165);            t.ink=0;            t=Curve(t,50*mag,40);            t.ink=1;            t=Curve(t,50*mag,165);        end           	case 'D'		t.ink=1;		t=Forward(t,100*mag);		t=Turn(t,90);        %         if useModifiedVersion%            t.ink = 0; %            t=Forward(t,15*mag);%            t.ink = 1; %         end        D_mult1 = 1;        D_mult2 = 1;        if useModifiedVersion            D_mult1 = .95;            D_mult2 = .8;        end        		t=Forward(t,62*mag * D_mult1); % 10/5/98 reduced by 1 by dgp to stay withing bounding box		t=Curve(t,38*mag,90);		t=Forward(t,24*mag); % 10/5/98 reduced by 1 by dgp to stay withing bounding box		t=Curve(t,38*mag,90);		        t=Forward(t,62*mag * D_mult2); % 10/5/98 reduced by 1 by dgp to stay withing bounding box                		case 'H';		% Start at the bottom, draw left side;		t.ink=1;		t=Forward(t,100*mag);		t=Turn(t,180);		t.ink=0;		t=Forward(t,50*mag);		t=Turn(t,-90);		% Draw horizontal.;		t.ink=1;                H_mult = 1;        if useModifiedVersion            H_mult = 1.15;        end        if useModifiedVersion == 2            t.offset = -t.offset;        end        		t=Forward(t,80*mag * H_mult);		t=Turn(t,-90);		t.ink=0;		t=Forward(t,50*mag);		t=Turn(t,180);		t.ink=1;		% Draw right side.;        if useModifiedVersion == 2            t.offset = -t.offset;        end		t=Forward(t,100*mag);			case 'K';		t.ink=1;		t=Forward(t,100*mag);		t.ink=0;		t=Turn(t,180);        K_lower = 0;        if useModifiedVersion == 2            K_lower = 5;        end                		t=Forward(t,(60+K_lower)*mag);		t=Turn(t,180);		t=Turn(t,50);		t.ink=1;        K_add = 0;        if useModifiedVersion == 2            K_add = 10;        end        if useModifiedVersion == 2            t.offset = -t.offset;        end        t=Forward(t,(90+K_add)*mag);                		t.ink=0;		t=Turn(t,180);		t=Forward(t,(50+K_add)*mag);		t=Turn(t,-85);		t.ink=0;                K_mult2 = 1;        if useModifiedVersion == 2            K_mult2 = 1.15;        end        		t=Forward(t,80*mag*K_mult2);		t=Turn(t,180);		t.ink=1;		        K_mult = 1;        if useModifiedVersion            K_mult = .8;        end        t=Forward(t,80*mag*K_mult*K_mult2);        	case 'N'		t=Forward(t,100*mag);		t=Turn(t,135);		t=Forward(t,(100*sqrt(2))*mag);		t.ink=0;		t=Turn(t,-135);		t.ink=1;        if useModifiedVersion == 2            t.offset = -t.offset;        end		t=Forward(t,100*mag);        case 'O';		t.ink=0;		t=Forward(t,50*mag);                 if useModifiedVersion == 2            t=Curve(t,50*mag,167 + 40);        end                t.ink=1;        O_degrees = 360;        if useModifiedVersion >= 1            O_degrees = 350;        end		t=Curve(t,50*mag,O_degrees);        	case 'Q'		t.position=[60*mag,60*mag];		t.direction=[.5,.5]		t=Mark(t);		pause		t=Curve(t,-30*mag,90);		t=Curve(t,30*mag,90);	case 'R'		t.ink=1;		t=Forward(t,100*mag);		t=Turn(t,90);		t.ink=1;		t=Forward(t,60*mag);		t=Curve(t,25*mag,180);		t=Turn(t,-111);		t=Forward(t,55*mag);		t.ink=0;		t=Turn(t,180);		t=Forward(t,55*mag);		t=Turn(t,-69);		t.ink=1;		t=Forward(t,60*mag);        	case 'S'		t.ink=0;		t=Forward(t,25*mag); % changed by dgp 10/5/98, moving the whole letter up 5, to fit in the bounding box		t=Turn(t,180);		t.ink=1;		t=Curve(t,-25*mag,90);		t=Forward(t,40*mag);		t=Curve(t,-25*mag,180);		t=Forward(t,40*mag);		t=Curve(t,25*mag,180);		t=Forward(t,40*mag);		t=Curve(t,25*mag,90);        				case 'V';		t.ink=0;		t=Forward(t,100*mag);		t=Turn(t,157.5);		t.ink=1;		t=Forward(t,108*mag);		t.ink=0;		t.direction=[0,1];		t=Turn(t,22.5);        V_mult = 1;        if useModifiedVersion == 2            if t.pixPerDeg >= 10                V_mult = 2;            elseif t.pixPerDeg < 10                V_mult = 1.7;            end                    end        if useModifiedVersion == 2            t.offset = -t.offset;        end        t=Forward(t,10*mag*V_mult);		t.ink=1;        		t=Forward(t,98*mag);                    	case 'Z'		t.ink=0;		t=Forward(t,100*mag);		t=Turn(t,90);		t.ink=1;		t=Forward(t,100*mag);		t=Turn(t,135);		t.ink=1;		t=Forward(t,100*sqrt(2)*mag);		t.ink=0;		t=Turn(t,-135);		t.ink=1;        if useModifiedVersion == 2            t.offset = -t.offset;        end		t=Forward(t,100*mag);                	otherwise		error(sprintf('The letter "%c" (%d) is not implemented.',letter,letter));endif t.print	fprintf('\n');endglobal canvassignal=canvas(t.canvasX0+(1:t.signalSize),t.canvasY0+(1:t.signalSize));signal=flipud(signal');if t.show	s=signal;	%fprintf('signal max %.1f min %.1f\n',max(max(s)),min(min(s)));	SCREEN(t.window,'PutImage',s*127/3+128)endreturn
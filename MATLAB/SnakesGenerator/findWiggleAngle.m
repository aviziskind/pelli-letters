function w = findWiggleAngle(wiggleType, wiggleAmount)

    markSpc = 0.91;
    gabor_sigma = 0.3;
    f = 1;
    
    x_curve = linspace(0, 2*pi*4, 1000);
%     x_gabor = linspace(
    
    
    
    switch wiggleType
        case 'orientation',
            x_range = [-.1, .1];
            theta = wiggleAmount;
%             k = 
%             for i = 1:length(x)
                idx_0 = sin(x) < .1;
                
                figure(3); clf;
                plot(x, sin(x))
                3;
                
%             end
            
            
            gaborSet='ISO_alternate';
            gaborOrientation_deg = wiggleAmount;

        case 'offset',
            gaborSet='offset';
            gaborOffset_deg = wiggleAmount;
            gaborOffset = wiggleAmount * pixPerDegree;
            
        case 'phase',
            gaborSet='phase';
            gaborPhase = 180;
            
        case 'none',
            gaborSet='ISO_alternate';
            gaborOrientation_deg = 0;
            
        otherwise,
            error('Unknown wiggle type');
            
    end




end
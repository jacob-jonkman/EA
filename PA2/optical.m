function f = optical(x)
    if ismac
        
    elseif isunix
        
    elseif ispc
        %addpath(genpath('windows/'))
        cmd = ['windows\optical.exe ', num2str(x)];
        [status, cmdout] = system(cmd);
    	f = cmdout;
    else
        
    end
end
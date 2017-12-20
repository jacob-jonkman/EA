function f = optical(x)
	if ismac
		cmd = ['./mac/optical ', num2str(x)];
		[status, cmdout] = system(cmd);
		f = cmdout;
	elseif isunix
		cmd = ['./linux/optical ', num2str(x)];
		[status, cmdout] = system(cmd);
		f = cmdout;
	elseif ispc
		%addpath(genpath('windows/'))
		cmd = ['windows\\optical.exe ', num2str(x)];
		[status, cmdout] = system(cmd);
		f = cmdout;		
	end
end
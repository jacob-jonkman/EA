function tests(iters, eval)
	fileID  = fopen('tests/test3.txt', 'a');
	
	for i=1:iters
		[~, fitness] = dekkers_jonkman_es(eval, i);
		fprintf(fileID, '%5.4f\n', fitness);
	end
	fclose(fileID);
end
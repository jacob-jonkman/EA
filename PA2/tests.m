function tests(iters, eval)
    fileID  = fopen('tests/test1.txt', 'a');
    fclose(fileID2);
    
    for i=1:iters
        [~, fitness] = dekkers_jonkman_es(eval, i);
        fprintf(fileID, '%5.4f\n', fitness);
    end
    fclose(fileID);
end
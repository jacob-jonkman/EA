function tests(iters, eval)
    fileID  = fopen('tests/test1.txt', 'a');
    
    for i=1:iters
        [~, fitness] = dekkers_jonkman_es(eval);
        fprintf(fileID, '%5.4f\n', fitness);
    end
    
end
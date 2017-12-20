function tests(iters, eval)
    fileID  = fopen('res.txt', 'a');
    
    for i=1:iters
        [~, fitness] = dekkers_jonkman_es(eval);
        fprintf(fileID, 'Fitness of test %d: %5.4f\n', i, fitness);
    end
    
end
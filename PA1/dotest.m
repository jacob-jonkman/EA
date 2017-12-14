function dotest(n)
    factor = 5000;
    factor
    n
    num_iter = 1
    fopts = zeros(num_iter,1)
    for i=1:num_iter
        i,
        [xopt,fopts(i)] = dekkers_jonkman_ga(n, factor*n);
    end
    
    average = mean(fopts)
    standard_dev = std(fopts)
    
    fopts = zeros(num_iter,1)
    for i=1:num_iter
        i
        [xopt,fopts(i)] = mc(n, factor*n);
    end
    
    average = mean(fopts)
    standard_dev = std(fopts)
    
end
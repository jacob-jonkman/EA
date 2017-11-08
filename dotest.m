function dotest(n)
    factor = 5000;
    fopts = zeros(20,1)
    for i=1:20
        i,
        [xopt,fopts(i)] = dekkers_jonkman_ga(n, factor*n);
    end
    
    average = mean(fopts)
    standard_dev = std(fopts)
    
    fopts = zeros(20,1)
    for i=1:20
        [xopt,fopts(i)] = mc(n, factor*n);
    end
    
    average = mean(fopts)
    standard_dev = std(fopts)
    
end
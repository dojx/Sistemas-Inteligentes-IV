x = 0:0.1:5;
y = fun(x);
w = rand(2, 1);

eta = 0.55;
grad = 0;

for k = 1:10
    for i = 1:length(x)
        inpt = [1; x(i)];
        outpt = dot(inpt, w);
        e = y(i) - outpt;
        grad = grad + eta*e*inpt;
    end
    w = w + grad/length(x)
end

    
function y = lms_e(w, x, y)
    er = 0;
    for i = 1:length(x)
        inpt = [1; x(i)];
        outpt = dot(inpt, w);
        er = er + 0.5*(y(i) - outpt)^2;
    end
end

function y = fun(x)
    a = 3; b = 2;
    y = a*cos(b*x) + b*sin(a*x);
end
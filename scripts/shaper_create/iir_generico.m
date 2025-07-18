function [y,B,A] = iir_generico(B,A,N,Gx,Gy)

x = zeros(N,1);
x(1) = 1;
x = x * Gx;

B = floor(B*Gy);
A = floor(A*Gy);

%y[n] = Zn1(1)*x[n] + Zn1(2)*x[n-1] - Zd1(2)*y[n-1]

y = zeros(N,1);
rx = zeros(length(B),1);
ry = zeros(length(A)-1,1);

for n = 1:N
  yz = 0;

  rx(1) = x(n);
  for i = 1:length(B)
    yz = B(i)*rx(i) + yz;
  end

  if length(B) > 1
    for i = length(B):-1:2
      rx(i) = rx(i-1);
    end
  end

  yp = 0;

  if length(A) > 1
    for i = 2:length(A)
      yp = A(i)*ry(i-1) + yp;
    end
  end

  y(n) =  yz- yp;



  if length(A) > 1
    for i = length(A):-1:2
      ry(i) = ry(i-1);
    end
  end
  
  ry(1) = fix(y(n)/Gy);
  

end

end

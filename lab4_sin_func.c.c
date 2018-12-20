#include <stdio.h>
#include <stdlib.h>

double pow_series(double x, int f) {
	if(f < 1) return 1;
	else return (x / f) * pow_series(x, f-1);
}

double my_sin(double x) {
	double pi = 3.142;
	if(x > 360) x -= 360;
	x = pi * x / 180;
    double sin = 0;
    int n = 10, k = 0;
    
    while(k != n) {
        int power = 2*k + 1;
        double p_s = pow_series(x, power);
        if(k % 2 == 0) sin = sin + p_s;
        else sin = sin - p_s;
        
        k++;
    }
    return sin;
}


int main()
{
  double x;
  scanf("%lf", &x);
  printf("sin(%lf) is %lf", x, my_sin(x));
  return 0;
}


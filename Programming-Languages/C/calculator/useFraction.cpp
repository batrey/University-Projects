//
// useFraction.cpp
//

#include "Fraction.h"
#include<iostream>
using namespace std;

int main()
{
  Fraction x(2,3);
  Fraction y(6,-2);

  cout << x << endl;
  cout << y << endl;

  cin >> y;
  cout << y << endl;
  Fraction z = x + y;
  cout << x << " + " << y << " = " << z << endl;
}

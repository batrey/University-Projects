//HW 1
//programmer: Niall Smith
// Editor(s) used : Notepad ++
// compiler(s) used : VC++ 2010 Express
#ifndef Fraction_h
#define Fraction_h
#include <iostream>
using namespace std;
class Fraction
{
public:
//Functions
  Fraction();
  Fraction(int,int); 
	int getNum() const;
	int  getDem() const;
	void setNum(int num);
	void  setDem(int den);
	void reduce();
	void signs();
	friend	ostream&  operator<<(ostream &out,const Fraction &);
	friend	istream& operator>>(istream &,Fraction &);
	Fraction operator+(const Fraction );
	Fraction operator-(const Fraction );
	Fraction& operator=(const Fraction );
private: 
  int nemer;
  int denom;
};
#endif
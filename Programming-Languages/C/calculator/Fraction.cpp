#include "Fraction.h"
#include <stdexcept>
#include <iostream>
#include <cstdlib>
using namespace std;
Fraction::Fraction()
{
	setNum(0);
	setDem(0);
}
Fraction::Fraction(int nem, int dem)
{
	if (dem == 0)
	{
		throw invalid_argument("division by zero");
	}
	else
	{
		setNum(nem);
		setDem(dem);
		reduce();
	}
	
}
void Fraction::setNum(int num)
{
	nemer = num;
}
void Fraction::setDem(int den)
{
	denom = den;
}
int Fraction::getNum() const
{
	return nemer;
}
int Fraction::getDem() const
{
	
	return denom;
}
void Fraction::reduce()
{
	signs();
	int Sign = 1;
	int nem = getNum();
	int den = getDem();
	if (nem < 0)
	{
		nem *= -1;
		Sign = -1;
	}
	for (int i = (nem * den); i > 1; i--)
	{
		if ((nem % i == 0) && (den % i == 0))
		{
			nem /= i;
			den /= i;
		}
	}
	nem *= Sign;
	setNum(nem);
	setDem(den);
}
void Fraction::signs()
{
	int nem = getNum();
	int den = getDem();
	if (den < 0)
	{
		nem *= -1;
		den *= -1;
	}
	setNum(nem);
	setDem(den);
}
Fraction &Fraction::operator=(const Fraction frac)
{
	int num = frac.getNum();
	int den = frac.getDem();
	(*this).setNum(num);
	(*this).setDem(den);
	return *this;
}
istream &operator>>(istream &in, Fraction &frac)
{
	char Dum;
	int num;
	int den;
	in >> num;
	in >> Dum;
	in >> den;
	if (den == 0)
	{
		throw invalid_argument("Error: division by zero");
		exit(0);
	}
	frac.setNum(num);
	frac.setDem(den);
	frac.reduce();
	return in;
}
ostream &operator<<(ostream& out, const Fraction& frac)
{
;
	if (frac.getDem() == 1)
		out << frac.getNum();
	else
	{
		out << frac.getNum() << '/' << frac.getDem();
		
	}
	return out;
}
Fraction Fraction::operator+(const Fraction frac)
{
	int Nsum = ((*this).getNum() * frac.getDem()) + (getNum() * (*this).getDem());
	int Dsum = ((*this).getDem() * frac.getDem());
	Fraction frac2(Nsum, Dsum);
	frac2.reduce();
	return frac2;
}
Fraction Fraction::operator-(const Fraction frac)
{
	int Nsum= ((*this).getNum() * frac.getDem()) - (getNum() * (*this).getDem());
	int Dsum = ((*this).getDem() * frac.getDem());
	Fraction frac2(Nsum, Dsum );
	frac2.reduce();
	return frac2;
}
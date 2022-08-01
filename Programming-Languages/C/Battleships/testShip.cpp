//
// testShip.cpp
//

#include "Ship.h"
#include <iostream>
#include <stdexcept>
using namespace std;

int main()
{
  Ship *list[5] = { 0, 0, 0, 0, 0 };
  char ch;
  int x1,y1,x2,y2;
  int n = 0;

  cin >> ch >> x1 >> y1 >> x2 >> y2;
  while ( cin )
  {
    try
    {
      Ship *p = Ship::makeShip(ch,x1,y1,x2,y2);
      list[n++] = p;
    }
    catch ( invalid_argument &exc )
    {
      cout << exc.what() << ": " << ch << " " << x1 << " " << y1 << " "
           << x2 << " " << y2 << endl;
    }
    if ( n == 5 )
       break;
    cin >> ch >> x1 >> y1 >> x2 >> y2;
  }
  cout << "total of " << n << " ships" << endl;
  for ( int i = 0; i < n; i++ )
  {
    list[i]->print();
  }
  cout << "-----" << endl;
  Ship *p;
  p = new Cruiser(4,1,4,3);
  cout << "name: " << p->name() << " size: " << p->size() << endl;
  p->print();
  cout << "Cruiser include test 1:  "
       << ((p->includes(4,2)) ? "ok" : "fail") << endl;
  cout << "Cruiser include test 2:  "
       << ((!p->includes(1,2)) ? "ok" : "fail") << endl;
  cout << "Cruiser size test:  " << ((p->size()==3) ? "ok" : "fail") << endl;
  p->decreaseLevel();
  cout << "Cruiser level test 1: " << ((p->level()==2) ? "ok" : "fail") << endl;
  p->decreaseLevel();
  p->decreaseLevel();
  p->decreaseLevel();
  cout << "Cruiser level test 2: " << ((p->level()==0) ? "ok" : "fail") << endl;

  // perform include test on all ships in the list
  for ( int i = 0; i < 5 && list[i]; i++ )
  {
    p = list[i];
    p->print();
    for ( int k = 0; k < p->size(); k++ )
      cout << p->name() << " include test " << k << ": "
           << (( p->includes(p->getX(k),p->getY(k)) ) ? "ok" : "fail") << endl;
  }
}
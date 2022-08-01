//
// battleship.cpp
//

#include "Ship.h"
#include "Board.h"
#include <iostream>
#include <fstream>
#include <stdexcept>
using namespace std;

int main()
{
  Board board;
  // read the configuration file
  // add ships to the board as they are read
  char type;
  int x1, y1, x2, y2;
  ifstream configfile("battleship.conf");
  configfile >> type >> x1 >> y1 >> x2 >> y2;
  while ( configfile )
  {
    board.addShip(type,x1,y1,x2,y2);
    configfile >> type >> x1 >> y1 >> x2 >> y2;
  }

  // start the game
  char ch;
  int row;
  bool done = false;
  int nattempts = 0;
  cin >> ch >> row;
  while ( cin && !done )2
  {
    try
    {
      board.hit(ch,row);
      nattempts++;
      if ( board.level() == 0 )
        done = true;
      board.print();
    }
    catch ( invalid_argument &e )
    {
      cout << "Error: " << e.what() << endl;
    }
    cin >> ch >> row;
  }
  if ( board.level() == 0 )
    cout << "Game over! Your score is " << nattempts << endl;
  else
    cout << "You gave up!" << endl;
}
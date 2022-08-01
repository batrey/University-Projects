//
// Board.h
//
// Board for the battleship game

#ifndef BOARD_H
#define BOARD_H
#include "Ship.h"
#include<vector>
class Board
{
  public:
    Board(void);
    void addShip(char type, int x1, int y1, int x2, int y2);
    void print(void);
    void hit(char c, int i);
    int level(void);
  private:
    std::vector<Ship *> shipList;
    char score[10][10];
    Ship *shipAt(int x, int y);
};
#endif
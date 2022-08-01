//
// Ship.h
//

#ifndef SHIP_H
#define SHIP_H
class Ship
{
  public:
    virtual ~Ship(void) {}
    virtual const char *name(void) const = 0;
    virtual int size(void) const = 0;
    int getX(int i) const;
    int getY(int i) const;
    void print(void) const;
    bool includes(int x, int y);
    int level(void) const;
    void decreaseLevel(void);
    static Ship *makeShip(char ch, int x1, int y1, int x2, int y2);
  protected:
    void setPos(int a1, int b1, int a2, int b2);
    int lev;
  private:
    bool checkConfig(int x1, int y1, int x2, int y2);
    int x1,y1,x2,y2;
};

class AircraftCarrier : public Ship
{
  public:
    AircraftCarrier(int x1, int y1, int x2, int y2);
    virtual const char *name(void) const;
    virtual int size(void) const;
};

class BattleShip: public Ship
{
  public:
    BattleShip(int x1, int y1, int x2, int y2);
    virtual const char *name(void) const;
    virtual int size(void) const;
};

class Cruiser: public Ship
{
  public:
    Cruiser(int x1, int y1, int x2, int y2);
    virtual const char *name(void) const;
    virtual int size(void) const;
};

class Destroyer: public Ship
{
  public:
    Destroyer(int x1, int y1, int x2, int y2);
    virtual const char *name(void) const;
    virtual int size(void) const;
};
#endif
//lab 15C
//programmer: Niall Smith
// Editor(s) used : Notepad ++
// compiler(s) used : VC++ 2010 Express


#include <fstream>
#include <iostream>
#include <list>
#include <queue>
#include <stack>
#include <string>
#include <vector>
#include <utility>
using namespace std;

#include <cstdlib>

struct Vertex
{
    string name;
    bool isVisited;
    list<pair<int, double> > adjacentVertices;
    int prev;
    double cost;
};

struct Container // vertex container, for multiple ways to get to a vertex
{
    int vertex; // index in database array
    int prev; // index in database array
    double cost;
    
    bool operator<(const Container& v) const
    {
        return cost > v.cost;
    }
};

pair<stack<int>, double> getCheapestRoute(int iStart, int iEnd, vector<Vertex>& database)
{
    pair<stack<int>, double> result;
    list<pair<int, double> >::iterator it; // to iterate over adjacentVertices
    priority_queue<Container> name;
    Container wc;
    stack<int> route;
    for (int i = 0; i < database.size(); i++)
    {
        database[i].isVisited = false;
        database[i].cost = 0;
        database[i].prev = 0;
    }
    
    Container startVertex;
    startVertex.vertex = iStart;
    startVertex.cost = 0;
    startVertex.prev = -1;
    name.push(startVertex);
    
    while (!name.empty())
    {
        wc = name.top();
        name.pop();
        if (database[wc.vertex].isVisited) continue;
        database[wc.vertex].isVisited = true;
        database[wc.vertex].cost = wc.cost;
        database[wc.vertex].prev = wc.prev;
        if (wc.vertex == iEnd) break;
        for (it = database[wc.vertex].adjacentVertices.begin(); it != database[wc.vertex].adjacentVertices.end(); it++)
        {
            Container temp;
            temp.vertex = it->first;
            temp.cost = database[wc.vertex].cost + it->second;
            temp.prev = wc.vertex;
            name.push(temp);
        }
    }
    
    result.second = database[wc.vertex].cost;
    
    while (wc.vertex != iStart)
    {
        route.push(wc.vertex);
        wc.vertex = database[wc.vertex].prev;
    }
    route.push(wc.vertex);
    
    result.first = route;
    return result;
}

int main()
{
    cout << "Programmer : Niall Smith " << endl;
    cout << "lab 15A"<<endl;
    cout << "Description:"<<endl;
    cout << "_______________________________________________________"<<endl<<endl;
    
    ifstream fin;
    fin.open("cities.txt");
    if (!fin.good()) throw "I/O error";
    
    // process the input file
    vector<Vertex> database;
    while (fin.good()) // EOF loop
    {
        string fromCity, toCity, cost;
        
        // read one edge
        getline(fin, fromCity);
        getline(fin, toCity);
        getline(fin, cost);
        fin.ignore(1000, 10); // skip the separator
        
        
        fromCity.erase(remove_if(fromCity.begin(), fromCity.end(), ::isspace), fromCity.end());
        toCity.erase(remove_if(toCity.begin(), toCity.end(), ::isspace), toCity.end());
        
        // add vertices for new cities included in the edge
        int iToVertex = -1, iFromVertex = -1, i;
        for (i = 0; i < database.size(); i++) // seek "to" city
            if (database[i].name == fromCity)
                break;
        if (i == database.size()) // not in database yet
        {
            // store the vertex if it is new
            Vertex fromVertex;
            fromVertex.name = fromCity;
            database.push_back(fromVertex);
        }
        iFromVertex = i;
        
        for (i = 0; i < database.size(); i++) // seek "from" city
            if (database[i].name == toCity)
                break;
        if (i == database.size()) // not in vector yet
        {
            // store the vertex if it is new
            Vertex toVertex;
            toVertex.name = toCity;
            database.push_back(toVertex);
        }
        iToVertex = i;
        
        // store bi-directional edges
        double edgeCost = atof(cost.c_str());
        database[iFromVertex].adjacentVertices.push_back(pair<int, double>(iToVertex, edgeCost));
        database[iToVertex].adjacentVertices.push_back(pair<int, double>(iFromVertex, edgeCost));
    }
    fin.close();
    cout << "Input file processed\n\n";
    
    while (true)
    {
        string fromCity, toCity;
        cout << "\nEnter the source city [blank to exit]: ";
        getline(cin, fromCity);
        if (fromCity.length() == 0) break;
        
        // find the from city
        int iFrom;
        for (iFrom = 0; iFrom < database.size(); iFrom++)
            if (database[iFrom].name == fromCity)
                break;
        
        cout << "Enter the destination city [blank to exit]: ";
        getline(cin, toCity);
        if (toCity.length() == 0) break;
        
        // find the destination city
        int iTo;
        for (iTo = 0; iTo < database.size(); iTo++)
            if (database[iTo].name == toCity)
                break;
        
        pair<stack<int>, double> result = getCheapestRoute(iFrom, iTo, database);
        cout << "Total miles: " << result.second;
        while (!result.first.empty()){cout << '-' << database[result.first.top()].name; result.first.pop();}
        cout << endl;
    }
}
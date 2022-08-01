//lab 15B
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
using namespace std;

struct Vertex
{
    string name;
    bool isVisited;
    list<int> adjacentVertices;
    int prev;
    double cost;
};
pair<stack<int>, double> getShortestRoute(int iStart, int iEnd, vector<Vertex>& database)
{
    pair<stack<int>, double> result;
    int i;
    stack<int> route;
    queue<int> queue;
    for (int i = 0; i < database.size(); i++)
    {
        database[i].isVisited = false;
        database[i].prev = 0;
        database[i].cost = 0;
    }
    database[iStart].isVisited = true;
    queue.push(iStart);
    while (!queue.empty())
    {
        i = queue.front();
        queue.pop();
        list<int>::iterator it;
        for (it = database[i].adjacentVertices.begin(); it != database[i].adjacentVertices.end(); it++)
        {
            if (!database[*it].isVisited)
            {
                database[*it].isVisited = true;
                database[*it].cost = 1 + database[i].cost;
                database[*it].prev = i;
                queue.push(*it);
            }
            if (*it == iEnd) break;
        }
    }
    result.second = database[i].cost;
    while (i != iStart)
    {
        route.push(i);
        i = database[i].prev;
    }
    route.push(iStart);
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
        string fromCity, toCity;
        
        // read one edge
        getline(fin, fromCity);
        getline(fin, toCity);
        fin.ignore(1000, 10); // skip the line with distance
        fin.ignore(1000, 10); // skip the separator
        
        //To do
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
        database[iFromVertex].adjacentVertices.push_back(iToVertex);
        database[iToVertex].adjacentVertices.push_back(iFromVertex);
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
        
        pair<stack<int>, double> result = getShortestRoute(iFrom, iTo, database);
        cout << "Total edges: " << result.second;
        while (!result.first.empty()){cout << '-' << database[result.first.top()].name; result.first.pop();}
        cout << endl;
    }
}
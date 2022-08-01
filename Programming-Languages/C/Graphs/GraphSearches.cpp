//lab 15A
//programmer: Niall Smith
// Editor(s) used : Notepad ++
// compiler(s) used : VC++ 2010 Express

#include <fstream>
#include <iostream>
#include <list>
#include <queue>
#include <string>
#include <vector>
#include <stack>
using namespace std;

struct Vertex
{
    string name;
    bool isVisited;
    list<int> adjacentVertices;
};

queue<int> doBreadthFirstSearch(int iOriginVertex, vector<Vertex>& database)
{
    queue<int> vertexQueue; // vertices to consider, by index
    queue<int> searchOrder; // return this queue of indices
    for (int i = 0; i < database.size(); i++) database[i].isVisited = false;
    if (iOriginVertex < 0 || iOriginVertex >= database.size()) return searchOrder; // empty queue -- no such city
    database[iOriginVertex].isVisited = true;
    searchOrder.push(iOriginVertex);
    vertexQueue.push(iOriginVertex);
    while (!vertexQueue.empty())
    {
        int i = vertexQueue.front();
        vertexQueue.pop();
        list<int>::iterator it;
        for (it = database[i].adjacentVertices.begin(); it != database[i].adjacentVertices.end(); it++)
        {
            if (!database[*it].isVisited)
            {
                database[*it].isVisited = true;
                searchOrder.push(*it);
                vertexQueue.push(*it);
            }
        }
    }
    return searchOrder;
}
queue<int> doDepthFirstSearch(int iOriginVertex, vector<Vertex>& vertices)
{
    queue<int> searchOrder; // return this queue of indices
    stack<int> vertexStack; // vertices to consider, by index
    
    for (int i = 0; i < vertices.size(); i++) vertices[i].isVisited = false;
    if (iOriginVertex < 0 || iOriginVertex >= vertices.size()) return searchOrder; // empty queue -- no such city
    
    vertexStack.push(iOriginVertex); // push starting vertex onto stack
    
    while (!vertexStack.empty())
    {
        int i = vertexStack.top();
        vertexStack.pop();
        if (!vertices[i].isVisited)
        {
            vertices[i].isVisited = true;
            searchOrder.push(i);
            list<int>::reverse_iterator it;
            for (it = vertices[i].adjacentVertices.rbegin(); it != vertices[i].adjacentVertices.rend(); it++)
                if (vertices[*it].isVisited == false) vertexStack.push(*it);
        }
    }
    
    return searchOrder;
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
        // get the start city for the search
        string startCity;
        cout << "\nEnter the start city [blank to exit]: ";
        getline(cin, startCity);
        if (startCity.length() == 0) break;
        
        // find the start city
        int i;
        for (i = 0; i < database.size(); i++)
            if (database[i].name == startCity)
                break;
        
        // BFS result
        cout << "BFS";
        queue<int> q = doBreadthFirstSearch(i, database);
        while(!q.empty())
        {
            cout  << '-'<< database[q.front()].name;
            q.pop();
        }
        cout << endl;
        
        cout << "DFS";
        q = doDepthFirstSearch(i, database);
        while(!q.empty())
        {
            cout  << '-'<< database[q.front()].name;
            q.pop();
        }
        cout << endl;;
    }
}
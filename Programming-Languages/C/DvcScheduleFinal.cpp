//lab Final
//programmer: Niall Smith
// Editor(s) used : Notepad ++
// compiler(s) used : VC++ 2010 Expres
#include <fstream>
#include <iostream>
#include <string>
#include <ctime>
#include <map>
#include <set>
using namespace std;
typedef map<string, int> course;
int main()
{
    //output the objective and the programmer to the user
    cout << "Programmer : Niall Smith " << endl;
    cout << "lab final"<<endl;
    cout << "Description:"<<endl;
    cout << "_______________________________________________________"<<endl<<endl;
    // for parsing the inputfile
    char* token;
    char buf[1000];
    const char* const tab = "\t";
    map<string, course> subject; // map within map
    set<string> temp;     //check duplicates
    //start clock
    clock_t startTime = clock();
    // open the input file
    ifstream fin;
    fin.open("dvc-schedule.txt");
    if (!fin.good()) throw "I/O error";
    // read the input file
    while (fin.good())
    {
        // read the line
        string line;
        getline(fin, line);
        strcpy(buf, line.c_str());
        if (buf[0] == 0) continue;
        
        // parse the line
        const string term(token = strtok(buf, tab));
        const string section(token = strtok(0, tab));
        const string course((token = strtok(0, tab)) ? token : "");
        const string instructor((token = strtok(0, tab)) ? token : "");
        const string whenWhere((token = strtok(0, tab)) ? token : "");
        if (course.find('-') == string::npos) continue;
        const string subjectCode(course.begin(), course.begin() + course.find('-'));
        
        // check for duplicate entry is not found, add the term && ++ courses
        if (temp.find(term + section) == temp.end())
        {
            temp.insert(term + section);
            subject[subjectCode][course]++;
        }
    }
    //close file
    fin.close();
    // print the elements
    map<string,course>::iterator it;     // for the subject map
    map<string, int>::iterator inner_it; //for the course map
    for (it = subject.begin(); it != subject.end(); it++)
    {
        cout << it->first << "\n";
        cout << "------------------------------------------\n";
        for( inner_it= it->second.begin(); inner_it != it->second.end(); inner_it++)
        {
            cout << "   " << inner_it->first << ", " << inner_it->second << " class(es)" << endl;
        }
        cout << "------------------------------------------\n";
    }
    //prints the elapsed time
    double elapsedSeconds = (double)(clock() - startTime) / CLOCKS_PER_SEC; 
    cout << "\nElapsed Time: " << elapsedSeconds << " seconds" << endl;
}
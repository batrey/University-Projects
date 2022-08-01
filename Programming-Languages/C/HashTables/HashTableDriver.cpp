//lab 10A
//programmer: Niall Smith
// Editor(s) used : Notepad ++
// compiler(s) used : VC++ 2010 Expres
#include <iostream>
#include <string>
#include <fstream>
#include <cassert>
using namespace std;
#include "HashTable.h"
#include "HashTable.h"

struct Subject
{
    string course;
    string term;
    int section;
    string instructor;
    int hashCode() const;
    bool operator==(const Subject&)const;
};
int Subject::hashCode() const
{
    int sum = 0;
    for (int i = 0; i < course.size(); i++) sum += (course[i] + 101);
    for (int i = 0; i < term.size(); i++) sum += (term[i] + 23);
    sum += (section * 211);
    return sum;
}
bool Subject::operator==(const Subject& X) const
{
    return course == X.course && section == X.section && term == X.term;
}
int main()
{
    //output the objective and the programmer to the user
    cout << "Programmer : Niall Smith " << endl;
    cout << "lab 10A"<<endl;
    cout << "Description:"<<endl;
    cout << "_______________________________________________________"<<endl<<endl;
    char* token;
    char buf[1000];
    const char* const tab = "\t";
    HashTable<Subject> subjects;
    Subject temp;
    int add = 0;
    ifstream fin;
    fin.open("dvc-schedule.txt");
    if (!fin.good()) throw "I/O error";
    for (int i = 0; i < 100; i++)
    {
        string line;
        getline(fin, line);
        strcpy(buf, line.c_str());
        if (buf[0] == 0) continue;
        const string term(token = strtok(buf, tab));
        const string section(token = strtok(0, tab));
        const string course((token = strtok(0, tab)) ? token : "");
        const string instructor((token = strtok(0, tab)) ? token : "");
        const string whenWhere((token = strtok(0, tab)) ? token : "");
        if (course.find('-') == string::npos) continue; // invalid line
        const string subjectCode(course.begin(), course.begin() + course.find('-'));
        temp.term = term;
        temp.course = course;
        temp.section = atoi(section.c_str());
        temp.instructor = instructor;
        if (subjects.insert(temp)) add++;
    }
    fin.close();
    {
        HashTable<Subject> copy = subjects;
        assert(copy.length() == add);
    }
    {
        HashTable<Subject> copy;
        copy = subjects;
        assert(copy.length() == add);
    }
    fin.open("dvc-schedule.txt");
    for (int i = 0; i < 100; i++)
    {
        string line;
        getline(fin, line);
        strcpy(buf, line.c_str());
        if (buf[0] == 0) continue;
        
        const string term(token = strtok(buf, tab));
        const string section(token = strtok(0, tab));
        const string course((token = strtok(0, tab)) ? token : "");
        const string instructor((token = strtok(0, tab)) ? token : "");
        const string whenWhere((token = strtok(0, tab)) ? token : "");
        if (course.find('-') == string::npos) continue;
        const string subjectCode(course.begin(), course.begin() + course.find('-'));
        temp.term = term;
        temp.course = course;
        temp.section = atoi(section.c_str());
        temp.instructor = instructor;
        if (subjects.retrieve(temp)) subjects.remove(temp);
        assert(!subjects.retrieve(temp));
    }
    fin.close();
    return 0;
}




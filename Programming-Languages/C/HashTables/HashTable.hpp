\ //lab 10A
//programmer: Niall Smith
// Editor(s) used : Notepad ++
// compiler(s) used : VC++ 2010 Expres
#include <list>
#include <algorithm>
#include <cassert>
using namespace std;
#define HASHTABLE_CAPACITY 1009
#ifndef hashtable_h
#define hashtable_h
template <class DataType>
class HashTable
{
    int current;
    int size;
    int getWrappedIndex(const DataType&) const;
    typename list<DataType>::const_iterator itCurrent;
    list<DataType> element[HASHTABLE_CAPACITY];
public:
    HashTable(): current(-1), size(0) {}
    void clear();
    bool first(DataType&);
    bool getNext(DataType&);
    bool insert(const DataType&);
    bool remove(DataType&);
    bool retrieve(DataType&);
    bool replace(const DataType&);
    int length() const {return size;}
};

template <class DataType>
void HashTable<DataType>::clear()
{
    size = 0;
    current = -1;
    
    for(int i = 0; i < HASHTABLE_CAPACITY; i++)
        if(!element[i].empty()) element[i].clear();
}
template<class DataType>
int HashTable<DataType>::getWrappedIndex(const DataType& DI) const
{
    int WI = DI.hashCode() % HASHTABLE_CAPACITY;
    if (WI < 0) WI += HASHTABLE_CAPACITY;
    return WI;
}
template <class DataType>
bool HashTable<DataType>::getNext(DataType& P)
{
    assert(current >= -1 && current < HASHTABLE_CAPACITY);
    if (current == -1) return false;
    assert(!element[current].empty());
    if (++itCurrent == element[current].end())
    {
        for (current = current + 1; current < HASHTABLE_CAPACITY; current++)
        {
            if (!element[current].empty())
            {
                itCurrent = element[current].begin();
                break;
            }
        }
    }
    if (current == HASHTABLE_CAPACITY) current = -1;
    else P = *itCurrent;
    return current >= 0;
}

template <class DataType>
bool HashTable<DataType>::replace(const DataType& P)
{
    int index = getWrappedIndex(P);
    typename list<DataType>::iterator it;
    it = find(element[index].begin(), element[index].end(), P);
    if (it == element[index].end())
    {
        return false;
    }
    else *it = P;
    return true;
}
template <class DataType>
bool HashTable<DataType>::first(DataType& P)
{
    assert(current >= -1 && current < HASHTABLE_CAPACITY);
    for (current = 0; current < HASHTABLE_CAPACITY; current++)
    {
        if (!element[current].empty())
        {
            itCurrent = element[current].begin();
            break;
        } }
    if (current == HASHTABLE_CAPACITY) current = -1;
    if (current == -1) return false;
    P = *itCurrent;
    return true;
}
template <class DataType>
bool HashTable<DataType>::retrieve(DataType& P)
{
    int index = getWrappedIndex(P);
    typename list<DataType>::const_iterator it;
    it = find(element[index].begin(), element[index].end(), P);
    if (it == element[index].end()) return false;
    else P = *it;
    return true;
}
template <class DataType>
bool HashTable<DataType>::insert(const DataType& P)
{
    int index = getWrappedIndex(P);
    typename list<DataType>::iterator it;
    it = find(element[index].begin(), element[index].end(), P);
    if (it != element[index].end()) {*it = P; return false;}
    else {element[index].push_back(P); ++size; return true;}
}
template <class DataType>
bool HashTable<DataType>::remove(DataType& P)
{
    int index = getWrappedIndex(P);
    typename list<DataType>::iterator it;
    it = find(element[index].begin(), element[index].end(), P);
    if (it == element[index].end()) return false;
    else {element[index].erase(it); --size;}
    return true;
}
#endif
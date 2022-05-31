#ifndef SYMTAB_H
#define SYMTAB_H

#include <vector>
#include <unordered_map>

class Entry{
private:
    std::string id;
    std::string type;
    std::string dataType;
    std::string scope;
    int lineNum;
    int address;
public:
    Entry(std::string id, std::string type, std::string dataType, std::string scope, int lineNum, int address);

    std::string getID(){return this->id;};
    void setID(std::string id){this->id = id;};

    std::string getType(){return this->type;};
    void setType(std::string type){this->type = type;};

    std::string getDataType(){return this->dataType;};
    void setDataType(std::string dataType){this->dataType = dataType;};

    std::string getScope(){return this->scope;};
    void setScope(std::string id){this->id = id;};

    int getLineNum(){return this->lineNum;};
    void setLineNum(std::string id){this->id = id;};

    int getAddress(){return this->address;};
    void setAddress(int address){this->address = address;};
};

Entry::Entry(std::string id, std::string type, std::string dataType, std::string scope, int lineNum, int address){
    this->id = id;
    this->type = type;
    this->dataType = dataType;
    this->scope = scope;
    this->lineNum = lineNum;
    this->address = address;
}

class SymTab{

private:
    std::unordered_map<std::string, Entry> table;
    std::string scope;
    std::string id;
    // std::vector<Entry> entries;
public:
    SymTab();
    SymTab(std::string scope, std::string id);

    std::unordered_map<std::string, Entry> getTable(){return this->table;};

    bool add(std::string id, std::string type, std::string dataType, std::string scope, int lineNum, int address);

    Entry search(std::string id);


    void setID(std::string id){ this->id = id;};

    std::string getID(){return this->id;};
    // int hashFuntion(std::string id);
};

SymTab::SymTab(){
    this->table = std::unordered_map<std::string, Entry>();
    this->scope = "Default";
    this->id = "DefalutVariables";
}

SymTab::SymTab(std::string scope, std::string id){
    this->table = std::unordered_map<std::string, Entry>();
    this->scope = scope;
    this->id = id;
//     this->entries = new std::vector<Entry>();
}

bool SymTab::add(std::string id, std::string type, std::string dataType, std::string scope, int lineNum, int address){
    Entry newSymbol = Entry(id, type, dataType, scope, lineNum, address);
    table.insert(make_pair(id, newSymbol));
    return true;
}

Entry SymTab::search(std::string id){
    if(table.count(id) > 0){
        return (table.at(id));
    }
    return (table.at(id));
}

// int SymTab::hashFuntion(std::string id){
//     return 0;
// }Entry

#endif

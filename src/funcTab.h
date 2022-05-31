#ifndef FUNCTAB_H
#define FUNCTAB_H
#include <string>
#include <vector>
#include <unordered_map>

#include "symtab.h"

class FunctionEntry{
private:
    std::string name;
    std::string retType;
    std::string signature;
    SymTab varTable;
public:
    FunctionEntry(std::string name, std::string retType, std::string signature);

    void addToVarTab(std::string id, std::string type, std::string dataType, std::string scope, int lineNum, int address);

    SymTab getVarTab(){return this->varTable;};
    std::string getName(){return this->name;};

    void setVarTab(SymTab newVarTab){this->varTable = newVarTab;};
};

FunctionEntry::FunctionEntry(std::string name, std::string retType, std::string signature){
    this->name = name;
    this->retType = retType;
    this->signature = signature;
    this->varTable = SymTab(name, name);
}

void FunctionEntry::addToVarTab(std::string id, std::string type, std::string dataType, std::string scope, int lineNum, int address){
    this->varTable.add(id, type, dataType, scope, lineNum, address);
}

class FuncTab{
private:
    std::string name;
    std::unordered_map<std::string, FunctionEntry> funcEntries;
public:
    FuncTab();
    FuncTab(std::string name);

    void addFuncTable(std::string id, std::string retType, std::string scope);
    void addFuncTable(std::string id, FunctionEntry newEntry);

    void updateFuncTable(std::string id, SymTab newEntry);

    FunctionEntry getFunction(std::string id);
    std::unordered_map<std::string, FunctionEntry> getFunctions(){return this->funcEntries;};
};

FuncTab::FuncTab(){
    this->name = "Default";
    this->funcEntries = std::unordered_map<std::string, FunctionEntry>();
}

FuncTab::FuncTab(std::string name){
    this->name = name;
    this->funcEntries = std::unordered_map<std::string, FunctionEntry>();
}

FunctionEntry FuncTab::getFunction(std::string id){
//     std::cout << id << '\n';
    std::unordered_map<std::string, FunctionEntry>::const_iterator x = this->funcEntries.find(id);
    return x->second;
}

void FuncTab::addFuncTable(std::string id, std::string retType, std::string scope){
    FunctionEntry temp = FunctionEntry(id, retType, scope);
    funcEntries.insert(make_pair(id, temp));
}

void FuncTab::addFuncTable(std::string id, FunctionEntry newEntry){
    funcEntries.insert(make_pair(id, newEntry));
}

void FuncTab::updateFuncTable(std::string id, SymTab newEntry){
    std::unordered_map<std::string, FunctionEntry>::iterator it = this->funcEntries.find(id);
    if(it != this->funcEntries.end()){
        it->second.setVarTab(newEntry);
    }
}



#endif

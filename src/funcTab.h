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
    int quintStart;
    SymTab varTable;
public:
    FunctionEntry(std::string name, std::string retType, std::string signature, int quintStart);

    void addToVarTab(std::string id, std::string type, std::string dataType, std::string scope, int lineNum, int address);

    SymTab getVarTab(){return this->varTable;};
    std::string getName(){return this->name;};

    std::string getSignature(){return this->signature;};
    void setSignature(std::string signature){this->signature = signature;};

    void setVarTab(SymTab newVarTab){this->varTable = newVarTab;};

};

FunctionEntry::FunctionEntry(std::string name, std::string retType, std::string signature, int quintStart){
    this->name = name;
    this->retType = retType;
    this->signature = signature;
    this->quintStart = quintStart;
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

    void addFuncTable(std::string id, std::string retType, std::string signature, int quintStart);
    void addFuncTable(std::string id, FunctionEntry newEntry);

    void updateFuncTable(std::string id, SymTab newEntry);

    std::string getIdSignature(std::string funcId);
    void updateSignature(std::string funcId, std::string signature);

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

void FuncTab::addFuncTable(std::string id, std::string retType, std::string signature, int quintStart){
    FunctionEntry temp = FunctionEntry(id, retType, signature, quintStart);
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

void FuncTab::updateSignature(std::string funcId, std::string signature){
     std::unordered_map<std::string, FunctionEntry>::iterator it = this->funcEntries.find(funcId);
    if(it != this->funcEntries.end()){
        it->second.setSignature(signature);
    }
}

std::string FuncTab::getIdSignature(std::string funcId){
     std::unordered_map<std::string, FunctionEntry>::iterator it = this->funcEntries.find(funcId);
    if(it != this->funcEntries.end()){
        return it->second.getSignature();
    }
    return "";
}



#endif

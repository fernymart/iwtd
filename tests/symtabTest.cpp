#include <iostream>
#include <unordered_map>
#include <stack>


using namespace std;
#include "../src/symtab.h"
#include "../src/funcTab.h"

int main(){
    std::stack<SymTab> pilaScopes;

    SymTab global = SymTab("global", "global");
    pilaScopes.push(global);
    SymTab *currScope;
    FuncTab functions = FuncTab("Program x functions");
    SymTab st = pilaScopes.top();
    currScope = &st;
    currScope->add("id", "var", "int", "global", 18);

    FunctionEntry funcEntry1 = FunctionEntry("Func1", 'v', "1");
    SymTab temp = SymTab("Func1", "Func1");
    pilaScopes.push(temp);
    st = pilaScopes.top();
    currScope = &st;
    currScope->add("id2", "parameter", "int", "Func1 parameter", 25);
    std::string name = "Func1";
    funcEntry1.setVarTab(temp);
    functions.addFuncTable(name, funcEntry1);
    pilaScopes.pop();
//     functions.getFunction("Func1").setVarTab(temp);

    std::unordered_map<std::string, Entry> table = global.getTable();
    for(auto& it: table){
        cout << it.second.getID() << '\n';
    }

    std::unordered_map<std::string, FunctionEntry> tableFunctions = functions.getFunctions();

    for(auto& it: tableFunctions){

        std::unordered_map<std::string, Entry> funcEntries = it.second.getVarTab().getTable();

        std::cout << it.second.getVarTab().getID() << '\n';

        for(auto& it2: funcEntries){
            std::cout << it2.second.getID() << '\n';
        }
    }


//     FuncTab *funcTab = new FuncTab();
//     SymTab *symTab = new SymTab("global", "program");
//     symTab->add("hello", "var", "int", "global", 2);
//
//     Entry *en = symTab->search("hlo");
//     if(en != nullptr){
//         cout << en->getID();
//     }else{
//         cout<<"succ";
//     }

    return 0;
}

%{
    #include <cstdio>
    #include <iostream>
    #include <string>
    #include <unordered_map>
    #include <stack>

    #include "funcTab.h"
    #include "quadruples.h"
    #include "semanticCube.h"


    #define YYERROR_VERBOSE 1

    struct opTipos{
        std::string idT;
        std::string tipo;
    };

    using namespace std;

    extern int yylineno;
    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;



    std::string currentType;

    SymTab *currScope;
    SymTab global;
    SymTab constantes;

    SymTab tempScope;

    int addressIntLocal = 5000;
    int addressFltLocal = 7000;
    int addressCharLocal = 9000;

    int addressIntGlobal = 1000;
    int addressFltGlobal = 2000;
    int addressCharGlobal = 3000;

    int addressIntTemp;
    int addressFltTemp;
    int addressCharTemp;
    int addressBoolTemp;

    int addressIntCurr;
    int addressFltCurr;
    int addressCharCurr;

    int addressIntConst = 13000;
    int addressFltConst = 15000;
    int addressCharConst = 17000;

    int currAdd;

    bool isGraphical = false;

    bool canReturn = false;

    std::unordered_map<std::string, int> types = {
        {"in", 0},
        {"flt", 1},
        {"ch", 2},
        {"boo", 3},
        {"*", 0},
        {"/", 1},
        {"+", 2},
        {"-", 3},
        {">", 4},
        {">=",5},
        {"<", 6},
        {"<=",7},
        {"==",8},
        {"&&",9},
        {"||",10},

    };

    /*
    Declarar tabla de clases -- ya no es necesario
    Declarar tabla de funciones globales -- listo
    Declarar tabla de constantes -- listo
    */

    /*
    Declarar las direcciones bases para cada tipo y scope (global, local, temp y constante)
    */

    FuncTab functions;

    std::string currSignature = "";

//     std::stack<std::string> pOper;
//     std::stack<opTipos> pilaO;
    std::stack<int> pSaltos;
    std::vector<quintuple> quintuplesVect;
    /*
        Declarar pila de operadores -- listo
        Declarar pila de operandos y tipos (hacer un struct de operando y su tipo) -- listo
        Declarar pila de saltos -- listo
    */

    void yyerror(const char *s);
//     int yywrap();
%}

// %code requires{
//     struct opTipos{
//         std::string id;
//         std::string tipo;
//     };
// }

%union{
    char* id;
    int value;
    int dir;
    char* type;
    struct idObj{
        char* id;
        char* tipo;
    } expRes;
//     FunctionEntry funcScope;
}

%token PROGRAM VAR CLASS INHERIT MAIN
%token <type> INT FLOAT STRING CHAR
%token FUN VOID RETURN
%token IF ELIF ELSE
%token WHILE FOR
%token READ WRITE
%token <id> CTE_INT CTE_FLT
%token <id> CTE_CHR CTE_STR
%token <id>ID
%token DOT COMMA CLN SMCLN
%token ADD SUB MULT DIV
%token G_ET L_ET EQ NEQ GT LT ASGN
%token LP RP LCB RCB LSB RSB
%token OR AND
// %token WS

%left ADD SUB MULT DIV
%right G_ET L_ET EQ NEQ GT LT ASGN
//
%type<type> TIPO_SIMPLE;

%type<expRes> M_EXP S_EXP G_EXP TERMINO FACTOR VAR_CTE VARIABLE

%type<id> ARIT_MULT_DIV ARIT_SUM_RES COMPARATOR andor

%%
PROGRAMA: PROGRAM ID SMCLN {
    functions = FuncTab($2);
    global = SymTab("global", "global var table");
    currScope = &global;

    /*
        Declaramos que nuestras direcciones actuales son las globales
    */

    addressIntCurr = addressIntGlobal;
    addressFltCurr = addressFltGlobal;
    addressCharCurr = addressCharGlobal;

} DEC_ATRIBUTOS DEC_METODOS DEC_MAIN;

// DEC_CLASES: CLASE DEC_CLASES
// | ;
//
// CLASE: CLASS ID CLASE_HEREDA {
//     /*
//     Punto neuralgico de las clases, se encarga de:
//     -
//     -
//     */
// } LCB DEC_ATRIBUTOS DEC_METODOS RCB;
//
// CLASE_HEREDA: INHERIT ID
// | ;

DEC_ATRIBUTOS: VARIABLES DEC_ATRIBUTOS
| ;

DEC_MAIN: MAIN {

    /* Punto neuralgico de la funcion main, se encarga de:
    -
    -
    */
    functions.addFuncTable("main", "vo", "");

    tempScope = functions.getFunction("main").getVarTab();
    currScope = &tempScope;
}
LP RP LCB ESTATUTOS RCB {
    functions.updateFuncTable("main", tempScope);
    currScope = &global;
};

VARIABLES: VAR TIPO_SIMPLE ID{
    currentType = $2;
//     std::cout << $2 << '\n';

    currScope->add($3, "var", currentType, "global", yylineno, currAdd++);
} VAR_ARR VAR_MULTIPLE SMCLN
| VAR ID ID VAR_ARR VAR_MULTIPLE SMCLN;

VAR_ARR: LSB CTE_INT RSB VAR_MAT
| ;

VAR_MAT: LSB CTE_INT RSB
| ;

VAR_MULTIPLE: COMMA ID {
    currScope->add($2, "var", currentType, "global", yylineno, currAdd++);
} VAR_ARR VAR_MULTIPLE
| ;

TIPO_SIMPLE: INT {currAdd = addressIntCurr;}
|FLOAT {currAdd = addressFltCurr;}
|STRING
|CHAR {currAdd = addressCharCurr;};

DEC_METODOS: FUNCION DEC_METODOS
| ;

FUNCION: FUN TIPO_SIMPLE ID LP PARAMETROS RP {
    canReturn = true;
    functions.addFuncTable($3, $2, currSignature);
    tempScope = functions.getFunction($3).getVarTab();
    currScope = &tempScope;
    currSignature = "";
    /*

    */

} LCB DEC_ATRIBUTOS ESTATUTOS RCB{
    functions.updateFuncTable($3, tempScope);
    currScope = &global;
    canReturn = false;
}
| FUN VOID ID LP PARAMETROS RP {
    functions.addFuncTable($3, "vo", currSignature);

    tempScope = functions.getFunction($3).getVarTab();
    currScope = &tempScope;

     currSignature = "";
} LCB DEC_ATRIBUTOS ESTATUTOS RCB{
    functions.updateFuncTable($3, tempScope);
    currScope = &global;
};

PARAMETROS: TIPO_SIMPLE ID {
    currScope->add($2, "parametro", $1, "funcion", yylineno, currAdd++);
    currSignature+=to_string(types[$1]);
//     std::cout << "CURR SIGNATURE " << currSignature << " PARAM TYPE " << types[$1] << '\n';
} PARAMETROS_MULTIPLE
| ;

PARAMETROS_MULTIPLE: COMMA PARAMETROS
| ;

ESTATUTOS: ESTATUTO ESTATUTOS
| ;

ESTATUTO: VARIABLES
| ASIGNA SMCLN
| LLAMADA SMCLN
| LEE SMCLN
| ESCRIBE SMCLN
| CONDICIONAL
| CICLO_WH
| CICLO_FOR
| RT SMCLN;

RT: RETURN M_EXP {
    if(!canReturn){
        yyerror("Cannot use a return in a void or main function");
//         throw std::invalid_argument("Incorrect file type, make sure the file extension is .fml");
    } else{

    }
};

ASIGNA: VARIABLE ASGN M_EXP {std::cout << "=" << " " << $3.id << " " << $1.id << '\n';};

LLAMADA: FUNC_ID LP PONER_PARAM RP;

FUNC_ID: ID
| ID DOT ID;

PONER_PARAM: M_EXP {
//     cout<<"parametro 1 encontrado " ;
} LLAMADA_MULTIPLE
| ;

LLAMADA_MULTIPLE: COMMA M_EXP LLAMADA_MULTIPLE
| ;

LEE: READ LP VARIABLE RP;

ESCRIBE: WRITE LP M_EXP ESCRIBE_MULTIPLE RP
| WRITE LP CTE_STR ESCRIBE_MULTIPLE RP;

ESCRIBE_MULTIPLE: COMMA M_EXP ESCRIBE_MULTIPLE
| COMMA CTE_STR ESCRIBE_MULTIPLE
| ;

CONDICIONAL: IF LP M_EXP RP LCB ESTATUTOS RCB COND_ELIF COND_ELSE;

COND_ELIF: ELIF LP M_EXP RP LCB ESTATUTOS RCB COND_ELIF
| ;

COND_ELSE: ELSE LCB ESTATUTOS RCB
| ;

CICLO_WH: WHILE LP M_EXP RP LCB ESTATUTOS RCB ;

CICLO_FOR: FOR LP INIT SMCLN M_EXP SMCLN STEP RP LCB ESTATUTOS RCB ;

INIT: VARIABLE ASGN M_EXP
| VARIABLE ;

STEP: VARIABLE ASGN M_EXP;

VARIABLE: ID VARIABLE_COMP {
pilaO.push({$1, "try"});
$$ = {$1, "PORMIENTRAS"};
};

VARIABLE_COMP: LSB G_EXP RSB VARIABLE_MAT
| DOT ID
| ;

VARIABLE_MAT: LSB G_EXP RSB
| ;

andor: AND {$$ = "&&";}
| OR {$$ = "||";};

COMPARATOR: G_ET {$$ = ">=";}
|L_ET {$$ = "<=";}
|EQ {$$ = "==";}
|NEQ {$$ = "!=";}
|GT {$$ = ">";}
|LT {$$ = "<";};

ARIT_SUM_RES: ADD {$$ = "+";}
| SUB {$$ = "-";};

ARIT_MULT_DIV: MULT {$$ = "*";}
| DIV {$$ = "/";};

M_EXP: M_EXP andor M_EXP {
std::cout << $2 << " " << $1.id << " " << $3.id << '\n';
$$ = {"temp", "in"};
}
| S_EXP;

S_EXP: S_EXP COMPARATOR S_EXP {
std::cout << $2 << " " << $1.id << " " << $3.id << '\n';
$$ = {"temp", "in"};
}
| G_EXP;

G_EXP: G_EXP ARIT_SUM_RES G_EXP {
std::cout << $2 << " " << $1.id << " " << $3.id << '\n';
$$ = {"temp", "in"};
}
| TERMINO;

TERMINO: TERMINO ARIT_MULT_DIV TERMINO {
std::cout << $2 << " " << $1.id << " " << $3.id << '\n';
$$ = {"temp", "in"};}
| FACTOR;

// EXP: EXP_AND EXP_1;
// EXP_1: OR EXP
// | ;
//
// EXP_AND: EXP_OPREL EXP_AND_1;
// EXP_AND_1: AND EXP_AND
// | ;
//
// EXP_OPREL: EXP_ARIT EXP_OPREL_1;
// EXP_OPREL_1: COMPARATOR EXP_OPREL
// | ;
//
// EXP_ARIT: TERMINO EXP_ARIT_1;
// EXP_ARIT_1: ARIT_SUM_RES TERMINO //EXP_ARIT_1
// | ;
//
// TERMINO: FACTOR TERMINO_1;
// TERMINO_1: ARIT_MULT_DIV FACTOR //TERMINO_1
// | ;

FACTOR: LP M_EXP RP {$$ = $2;}
| VAR_CTE
| SIGNO VARIABLE {$$ = $2;}
| SIGNO LLAMADA {$$ = {"LLAM", "FUNC"};};

VAR_CTE: CTE_INT {constantes.add($1, "const", "in", "global", yylineno, addressIntConst++); $$ = {$1, "in"};}
| CTE_FLT {constantes.add($1, "const", "flt", "global", yylineno, addressFltConst++); $$ = {$1, "flt"};}
| CTE_CHR {constantes.add($1, "const", "ch", "global", yylineno, addressCharConst++); $$ = {$1, "ch"};};

SIGNO: SUB
| ;
%%

int main(int, char** c){
//     cout << c[1] << endl;
    std::string fileName = c[1];
    if(fileName.substr(fileName.find_last_of(".")+1) != "fml"){
        throw std::invalid_argument("Incorrect file type, make sure the file extension is .fml");
    }

    FILE *myfile = fopen(c[1], "r");
    if(!myfile){
        cout << "Can't open file" << endl;
        return -1;
    }

//     global.getTable();

    yyin = myfile;
    yyparse();

    cout << types["i"] << '\t' << types["i"] << '\t' << types["+"] << '\n';

    std::cout << "SHEEESH " << checkCube(types["+"], types["i"], types["i"]) << '\n';
    std::cout << "SHEEESH " << checkCube(2, 0, 0) << '\n';

    std::unordered_map<std::string, Entry> table = global.getTable();
    for(auto& it: table){
        cout << it.second.getID() << " " << it.second.getDataType() << " " << it.second.getAddress() << '\n';
    }

    std::unordered_map<std::string, FunctionEntry> functionEntries = functions.getFunctions();

    for(auto& it: functionEntries){
//         std::cout << it.first << " " << it.second.getVarTab().getID() << '\n';
        std::cout << "Function name: " << it.second.getName() << " Signature: " << it.second.getSignature() << '\n';

         std::unordered_map<std::string, Entry> funcEntries = it.second.getVarTab().getTable();

        for(auto& it2: funcEntries){
            std::cout << it2.second.getID() << " " << it2.second.getDataType() << " " << it2.second.getAddress() << '\n';
        }
    }
    std::cout << "CONSTANTES \n";
    std::unordered_map<std::string, Entry> tableConst = constantes.getTable();
    for(auto& it: tableConst){
        cout << it.second.getID() << " " << it.second.getDataType() << " " << it.second.getAddress() << '\n';
    }

    std::cout << "Inicia pilaO\n";

    while(!pilaO.empty()){
        std::cout << pilaO.top().idT << '\t' << pilaO.top().tipo << '\n';
        pilaO.pop();

    }
    return 0;
}

void yyerror(const char *s){
    cout << "parsing error: " << s << " on line: " << yylineno << endl;

    exit(-1);
}

void createQuint(std::string command, std::string op1, std::string op2, std::string res, int graphRes){
    cout << command << " " << op1 << " " << op2 << " " << res << '\n';
}

bool checkExists(std::string id){

}

int getAddress(std::string id){

}

int checkResultType(std::string operation, std::string lOper, std::string rOper){
    return checkCube(types[lOper], types[rOper], types[operation]);
}

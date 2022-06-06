%{
    #include <cstdio>
    #include <iostream>
    #include <string>
    #include <unordered_map>
    #include <stack>
    #include <fstream>

    #include "funcTab.h"
    #include "quadruples.h"
    #include "semanticCube.h"

    /*
        TODO:
            - actualizar correctamente las direcciones virtuales de las vars
            - verificar que existan las variables
            - sacar la direccion dependiendo del scope
    */

    /*
        Definir las direcciones bases para cada tipo de dato en cada scope
    */

    #define BASE_GLOBAL_IN 5000 // 5000 - 5999
    #define BASE_GLOBAL_FLT 6000 // 6000 - 6999
    #define BASE_GLOBAL_CHAR 7000 // 7000 - 7999

    #define BASE_LOCAL_IN 8000 // 8000 - 9999
    #define BASE_LOCAL_FLT 10000 // 10000 - 11999
    #define BASE_LOCAL_CHAR 12000 //12000 - 12999

    #define BASE_TEMP_IN 13000 // 13000 - 14999
    #define BASE_TEMP_FLT 15000 // 15000 - 16999
    #define BASE_TEMP_BIN 17000 // 17000 - 18999

    #define BASE_CTE_IN 19000 // 19000 - 20999
    #define BASE_CTE_FLT 21000 // 21000 - 23499
    #define BASE_CTE_CHAR 23500 // 23500 - 23999
    #define BASE_CTE_STR 24000 // 24000 - 25999



    #define YYERROR_VERBOSE 1

    bool checkExists(std::string id);
    int getAddress(std::string id);
    std::string getDataType(std::string id);
    void createQuint(std::string command, int op1, int op2, int res, int graphRes);
    void updateCurrTypeAddress(int tipo, int currAdd);
    void fill(int quintNum, int quintJumpTo);
    bool constExists(std::string id);
    std::string getTypeFromNum(int tipo);
    bool checkCurrParam(std::string currCallSign, int currCallPos,  std::string currParamSign);

    struct opTipos{
        std::string idT;
        std::string tipo;
    };

    using namespace std;

    extern int yylineno;
    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;

    int contQuints = 0;

    std::string currentType;

    SymTab *currScope;
    SymTab global;
    SymTab constantes;

    SymTab tempScope;

    int addressIntLocal = BASE_LOCAL_IN;
    int addressFltLocal = BASE_LOCAL_FLT;
    int addressCharLocal = BASE_LOCAL_CHAR;

    int addressIntGlobal = BASE_GLOBAL_IN;
    int addressFltGlobal = BASE_GLOBAL_FLT;
    int addressCharGlobal = BASE_GLOBAL_CHAR;

    int addressIntTemp = BASE_TEMP_IN;
    int addressFltTemp = BASE_TEMP_FLT;
    int addressBoolTemp = BASE_TEMP_BIN;

    int addressIntCurr;
    int addressFltCurr;
    int addressCharCurr;

    int addressIntConst = BASE_CTE_IN;
    int addressFltConst = BASE_CTE_FLT;
    int addressCharConst = BASE_CTE_CHAR;
    int addressStrConst = BASE_CTE_STR;

    int currAdd;

    std::string currCallSign;
    std::string currParamSign;
    int currCallPos;
    int currCallSize;

    bool isGraphical = false;

    bool canReturn = false;
    bool hasReturn = false;

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
        {"=", 11}
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
        int dir;
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
%token <id> G_ET L_ET EQ NEQ GT LT ASGN
%token LP RP LCB RCB LSB RSB
%token OR AND
// %token WS

%left ADD SUB
%left MULT DIV
%left G_ET L_ET EQ NEQ GT LT
%right ASGN
//
%type<type> TIPO_SIMPLE;

%type<expRes> M_EXP S_EXP G_EXP TERMINO FACTOR VAR_CTE VARIABLE

%type<id> ARIT_MULT_DIV ARIT_SUM_RES COMPARATOR andor

%type<id> FUNC_ID
%%
PROGRAMA: PROGRAM ID SMCLN {
    createQuint("GOTOMAIN", -1, -1, -1, -1);
    contQuints++;
    functions = FuncTab($2);
    global = SymTab("global", "global var table");
    currScope = &global;

    /*
        Declaramos que nuestras direcciones actuales son las globales
    */

    addressIntCurr = addressIntGlobal;
    addressFltCurr = addressFltGlobal;
    addressCharCurr = addressCharGlobal;

} DEC_ATRIBUTOS DEC_METODOS DEC_MAIN {createQuint("END_FILE", -1, -1, -1, -1);};


DEC_ATRIBUTOS: VARIABLES DEC_ATRIBUTOS
| ;

DEC_MAIN: MAIN {

    /* Punto neuralgico de la funcion main, se encarga de:
    -
    -
    */
    functions.addFuncTable("main", "vo", "", contQuints);

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
    if(currScope->exists($3)){
        yyerror("Variable already declared.");
    }
    currScope->add($3, "var", currentType, "global", yylineno, currAdd++);

} VAR_ARR VAR_MULTIPLE SMCLN {
    if(currentType == "in"){
        addressIntCurr = currAdd;
    }else if(currentType == "flt"){
        addressFltCurr = currAdd;
    }else{
        addressCharCurr = currAdd;
    }
};

VAR_ARR: LSB CTE_INT RSB VAR_MAT
| ;

VAR_MAT: LSB CTE_INT RSB
| ;

VAR_MULTIPLE: COMMA ID {
    currScope->add($2, "var", currentType, "global", yylineno, currAdd++);
} VAR_ARR VAR_MULTIPLE
| ;

TIPO_SIMPLE: INT {
    currAdd = addressIntCurr;
}
|FLOAT {
    currAdd = addressFltCurr;
}
|STRING
|CHAR {
    currAdd = addressCharCurr;
};

DEC_METODOS: FUNCION DEC_METODOS
| ;

FUNCION: FUN TIPO_SIMPLE ID{
    //Aqui creamos la funcion y actualizamos la base de memoria
    global.add($3, "varFuncRet", $2, "global", yylineno, currAdd++);

    canReturn = true;
    addressIntCurr = addressIntLocal;
    addressFltCurr = addressFltLocal;
    addressCharCurr = addressCharLocal;

    functions.addFuncTable($3, $2, currSignature, contQuints);
    tempScope = functions.getFunction($3).getVarTab();
    currScope = &tempScope;

}LP PARAMETROS RP {

    functions.updateSignature($3, currSignature);
    currSignature = "";

} LCB DEC_ATRIBUTOS ESTATUTOS RCB{

    if(!hasReturn){
        yyerror("Non void function must have a return statement");
    }

    hasReturn = false;

    functions.updateFuncTable($3, tempScope);
    currScope = &global;
    canReturn = false;

    addressIntCurr = addressIntLocal;
    addressFltCurr = addressFltLocal;
    addressCharCurr = addressCharLocal;

}
| FUN VOID ID{

        functions.addFuncTable($3, "vo", currSignature, contQuints);
        tempScope = functions.getFunction($3).getVarTab();
        currScope = &tempScope;

}LP PARAMETROS RP {

    functions.updateSignature($3, currSignature);
    currSignature = "";

} LCB DEC_ATRIBUTOS ESTATUTOS RCB{

    functions.updateFuncTable($3, tempScope);
    currScope = &global;

    addressIntCurr = addressIntLocal;
    addressFltCurr = addressFltLocal;
    addressCharCurr = addressCharLocal;
};

PARAMETROS: TIPO_SIMPLE ID {
    currScope->add($2, "parametro", $1, "funcion", yylineno, currAdd++);
    cout << currScope->getID() << " " << currAdd << '\n';
    currSignature+=to_string(types[$1]);
    updateCurrTypeAddress(types[$1], currAdd);
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
| RT SMCLN;

RT: RETURN M_EXP {
    if(!canReturn){
        yyerror("Cannot use a return in a void or main function");
//         throw std::invalid_argument("Incorrect file type, make sure the file extension is .fml");
    }
    createQuint("RET", -1, -1, $2.dir, -1);
    contQuints++;
    hasReturn = true;
};

ASIGNA: VARIABLE ASGN M_EXP {
    if(checkCube(types[$2], types[$1.tipo], types[$3.tipo]) == -1){
        yyerror("cannot assign value to variable due to type-mismatch");
    }
    createQuint($2, $3.dir, -1, $1.dir, -1);
    contQuints++;
//     $$ = {"temp", "boo", addressBoolTemp++};

//     std::cout << "=" << " " << $3.id << " " << $1.id << '\n';
};

LLAMADA: FUNC_ID {
    currCallSign = functions.getIdSignature($1);
    currCallSize = currCallSign.length();
    currCallPos = 0;
} LP PONER_PARAM RP{

};

FUNC_ID: ID {$$ = $1;};

PONER_PARAM: M_EXP {
    if(checkCurrParam(currCallSign, currCallPos, $1.tipo)){
        createQuint("PARAM", $1.dir, -1, -1, -1);
        contQuints++;
        currCallPos++;
    }
} LLAMADA_MULTIPLE
| ;

LLAMADA_MULTIPLE: COMMA M_EXP{
     if(checkCurrParam(currCallSign, currCallPos, $2.tipo)){
        createQuint("PARAM", $2.dir, -1, -1, -1);
        contQuints++;
        currCallPos++;
    }
} LLAMADA_MULTIPLE
| ;

LEE: READ LP VARIABLE RP {
    createQuint("READ", $3.dir, -1, -1, -1);
    contQuints++;
};

ESCRIBE: WRITE LP M_EXP {
     createQuint("WRITE", $3.dir, -1, -1, -1);
     contQuints++;
} ESCRIBE_MULTIPLE RP
| WRITE LP CTE_STR{
    int add;
    if(!constantes.exists($3)){
        constantes.add($3, "const", "str", "global", yylineno, addressStrConst);
        addressStrConst++;
        add = addressStrConst-1;
    }else{
        add = constantes.getIdAddress($3);
    }
    createQuint("WRITE", add, -1, -1, -1);
    contQuints++;

//     if(){
//
//     }
} ESCRIBE_MULTIPLE RP;

ESCRIBE_MULTIPLE: COMMA M_EXP {
    createQuint("WRITE", $2.dir, -1, -1, -1);
    contQuints++;
} ESCRIBE_MULTIPLE
| COMMA CTE_STR{
    int add;
    if(!constantes.exists($2)){
        constantes.add($2, "const", "str", "global", yylineno, addressStrConst);
        addressStrConst++;
        add = addressStrConst-1;
    }else{
        add = constantes.getIdAddress($2);
    }
    createQuint("WRITE", add, -1, -1, -1);
    contQuints++;
}ESCRIBE_MULTIPLE
| ;

CONDICIONAL: IF LP M_EXP RP {
    if(types[$3.tipo] != 3){
        yyerror("EXPRESSION IS NOT BOOLEAN TYPE");
    }
    createQuint("GOTOF", $3.dir, -1, -1, -1);
    contQuints++;
    pSaltos.push(contQuints-1);

} LCB ESTATUTOS RCB COND_ELIF_ELSE{
    int fal = pSaltos.top();
    pSaltos.pop();
    fill(fal, contQuints);
};

COND_ELIF_ELSE: ELIF{
    createQuint("GOTO", -1, -1, -1, -1);
    contQuints++;
//     quintuplesVect[pSaltos.top()].result = contQuints + 1;
    int fal = pSaltos.top();
    pSaltos.pop();

    fill(fal, contQuints);
    pSaltos.push(contQuints-1);
//     contQuints++;
} LP M_EXP RP{
//     cout << $3 <<  '\n';
    if(types[$4.tipo] != 3){
        yyerror("EXPRESSION IS NOT BOOLEAN TYPE");
    }
    createQuint("GOTOF", $4.dir, -1, -1, -1);
    contQuints++;
    pSaltos.push(contQuints-1);

} LCB ESTATUTOS RCB COND_ELIF_ELSE{
    int fal = pSaltos.top();
    pSaltos.pop();
    fill(fal, contQuints);
}
|  ELSE{
    createQuint("GOTO", -1, -1, -1, -1);
    contQuints++;
//     quintuplesVect[pSaltos.top()].result = contQuints + 1;
    int fal = pSaltos.top();
    pSaltos.pop();

    fill(fal, contQuints);
    pSaltos.push(contQuints-1);
}LCB ESTATUTOS RCB
|;

// CONDICIONAL: IF LP M_EXP RP {
//     if(types[$3.tipo] != 3){
//         yyerror("EXPRESSION IS NOT BOOLEAN TYPE");
//     }
//     createQuint("GOTOF", $3.dir, -1, -1, -1);
//     contQuints++;
//     pSaltos.push(contQuints-1);
//
// } LCB ESTATUTOS RCB{
//     int fal = pSaltos.top();
//     pSaltos.pop();
//     fill(fal, contQuints);
// } COND_1{
//     int fal = pSaltos.top();
//     pSaltos.pop();
//     fill(fal, contQuints);
// };

// COND_1: ELIF{
//     createQuint("GOTO", -1, -1, -1, -1);
//     contQuints++;
// //     quintuplesVect[pSaltos.top()].result = contQuints + 1;
//     int fal = pSaltos.top();
//     pSaltos.pop();
//     fill(fal, contQuints);
// //     pSaltos.pop();
//     pSaltos.push(contQuints - 1);
// //     contQuints++;
// } LP M_EXP RP{
// //     cout << $3 <<  '\n';
//     if(types[$4.tipo] != 3){
//         yyerror("EXPRESSION IS NOT BOOLEAN TYPE");
//     }
//     createQuint("GOTOF", $4.dir, -1, -1, -1);
//     contQuints++;
//     pSaltos.push(contQuints - 1);
//
// } LCB ESTATUTOS RCB {
// //     quintuplesVect[pSaltos.top()].result = contQuints + 1;
// //     pSaltos.pop();
// //     createQuint("GOTO", -1, -1, -1, -1);
// //     contQuints++;
//     int fal = pSaltos.top();
//     pSaltos.pop();
//     fill(fal, contQuints);
//
// }
// | ELSE{
//     createQuint("GOTO", -1, -1, -1, -1);
//     contQuints++;
// //     quintuplesVect[pSaltos.top()].result = contQuints + 1;
//     int fal = pSaltos.top();
//     pSaltos.pop();
//
//     fill(fal, contQuints);
//     pSaltos.push(contQuints-1);
// }LCB ESTATUTOS RCB{
// //     quintuplesVect[pSaltos.top()].result = contQuints + 1;
// //     pSaltos.pop();
// //     int fal = pSaltos.top();
// //     pSaltos.pop();
// //     fill(fal, contQuints);
// }
// | ;

// COND_ELIF: ELIF{
//     createQuint("GOTO", -1, -1, -1, -1);
//     contQuints++;
// //     quintuplesVect[pSaltos.top()].result = contQuints + 1;
//     int fal = pSaltos.top();
//     pSaltos.pop();
//
//     fill(fal, contQuints);
//     pSaltos.push(contQuints-1);
// //     contQuints++;
// } LP M_EXP RP{
// //     cout << $3 <<  '\n';
//     if(types[$3.tipo] != 3){
//         yyerror("EXPRESSION IS NOT BOOLEAN TYPE");
//     }
//     createQuint("GOTOF", $3.dir, -1, -1, -1);
//     contQuints++;
//     pSaltos.push(contQuints-1);
//
// } LCB ESTATUTOS RCB {
// //     quintuplesVect[pSaltos.top()].result = contQuints + 1;
// //     pSaltos.pop();
// //     createQuint("GOTO", -1, -1, -1, -1);
// //     contQuints++;
// //     int fal = pSaltos.top();
// //     pSaltos.pop();
// //     fill(fal, contQuints);
//
// }COND_ELIF{
// //     int fal = pSaltos.top();
// //     pSaltos.pop();
// //     fill(fal, contQuints+1);
// }
// | ;

COND_ELSE: ELSE{
    createQuint("GOTO", -1, -1, -1, -1);
    contQuints++;
    int fal = pSaltos.top();
    pSaltos.pop();

    fill(fal, contQuints);
    pSaltos.push(contQuints-1);
}LCB ESTATUTOS RCB
| ;

CICLO_WH: WHILE {
    pSaltos.push(contQuints);
}LP M_EXP RP {
     if(types[$4.tipo] != 3){
        yyerror("EXPRESSION IS NOT BOOLEAN TYPE");
    }
    createQuint("GOTOF", $4.dir, -1, -1, -1);
    contQuints++;
    pSaltos.push(contQuints-1);
}LCB ESTATUTOS RCB{
    int end = pSaltos.top();
    pSaltos.pop();

    int ret = pSaltos.top();
    pSaltos.pop();
    createQuint("GOTO", -1, -1, ret, -1);
    contQuints++;

     fill(end, contQuints);
};

VARIABLE: ID VARIABLE_COMP {
    if(!checkExists($1)){
        std::string newStr = "Variable " + (std::string)($1) + " was not declared in this scope.";
        yyerror(const_cast<char*>(newStr.c_str()));
    }
    
    int add = getAddress($1);
    std::string type = getDataType($1);

//     pilaO.push({$1, "try"});

    $$ = {$1, const_cast<char*>(type.c_str()), add};
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
    if(checkCube(types[$2], types[$1.tipo], types[$3.tipo]) == -1){
        yyerror("Logic expression incorrect due to conflicting data types. when and or");
    }

//     std::cout << $2 << " " << $1.id << " " << $3.id << '\n';
    createQuint($2, $1.dir, $3.dir, addressBoolTemp, -1);
    $$ = {"temp", "boo", addressBoolTemp++};
    contQuints++;
}
| S_EXP {$$ = $1;};

S_EXP: S_EXP COMPARATOR S_EXP {
    if(checkCube(types[$2], types[$1.tipo], types[$3.tipo]) == -1){
        yyerror("Logic expression incorrect due to conflicting data types. when relop");
    }
//     std::cout << $2 << " " << $1.id << " " << $3.id << '\n';
    createQuint($2, $1.dir, $3.dir, addressBoolTemp, -1);
    contQuints++;
    $$ = {"temp", "boo", addressBoolTemp++};
}
| G_EXP {$$ = $1;};

G_EXP: G_EXP ARIT_SUM_RES G_EXP {
    int retAdd = 0;
    std::string retType;
    if(checkCube(types[$2], types[$1.tipo], types[$3.tipo]) == -1){
//         cout << $1.id << " de tipo " << $1.tipo << " intentando " << $2 << " con " << $1.id << " de tipo " << $3.tipo << '\n';
//         cout << checkCube(types[$1.tipo], types[$3.tipo], types[$2]);
        yyerror("Logic expression incorrect due to conflicting data types. when add or sub");
    }

    if(checkCube(types[$2], types[$1.tipo], types[$3.tipo]) == 0){
        retAdd = addressIntTemp;
        createQuint($2, $1.dir, $3.dir, addressIntTemp++, -1);

        retType = "in";
    }else if(checkCube(types[$2], types[$1.tipo], types[$3.tipo]) == 1){
        retAdd = addressFltTemp;
        createQuint($2, $1.dir, $3.dir, addressFltTemp++, -1);

        retType = "flt";
    }
    contQuints++;
//     std::cout << $2 << " " << $1.id << " " << $3.id << " " << retAdd << " " << -1 << '\n';
    $$ = {"temp", const_cast<char*>(retType.c_str()), retAdd};
}
| TERMINO {$$ = $1;};

TERMINO: TERMINO ARIT_MULT_DIV TERMINO {
    int retAdd = 0;
    std::string retType;
    if(checkCube(types[$2], types[$1.tipo], types[$3.tipo]) == -1){
        yyerror("Logic expression incorrect due to conflicting data types. when mult or div");
    }
    if(checkCube(types[$2], types[$1.tipo], types[$3.tipo]) == 0){
        std::cout << "ADDRESS DEL FLOAT TEMP ACTUAL " << addressFltTemp << " ids: " << $1.id << " " << $3.id << '\n';
        retAdd = addressIntTemp;
        createQuint($2, $1.dir, $3.dir, addressIntTemp++, -1);
        std::cout << "ADDRESS DEL FLOAT TEMP NUEVA " << addressFltTemp << " ids: " << $1.id << " " << $3.id << '\n';
        retType = "in";
//         $$ = {"tempmultdiv", "int", retAdd};
    }else if(checkCube(types[$2], types[$1.tipo], types[$3.tipo]) == 1){
        std::cout << "ADDRESS DEL FLOAT TEMP ACTUAL" << addressFltTemp << '\n';
        retAdd = addressFltTemp;
        createQuint($2, $1.dir, $3.dir, addressFltTemp++, -1);
        std::cout << "ADDRESS DEL FLOAT TEMP NUEVA" << addressFltTemp << '\n';
        retType = "flt";
//         $$ = {"tempmultdiv", "flt", retAdd};
    }

    contQuints++;
//     std::cout << "esto debe de dar" << retType << "esto es lo que da" <<  const_cast<char*>(retType.c_str()) << "wet" << '\n';
//     std::cout << $2 << " " << $1.id << " " << $3.id << " " << retAdd << " " << -1 << '\n';
    $$ = {"tempmultdiv", const_cast<char*>(retType.c_str()), retAdd};
}
| FACTOR {$$ = $1;};

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

FACTOR: LP M_EXP RP {
    $$ = $2;
}
| VAR_CTE
| SIGNO VARIABLE {
    $$ = $2;
}
| SIGNO LLAMADA {
    $$ = {"LLAM", "FUNC"};
};

VAR_CTE: CTE_INT {
    if(!constExists($1)){
        constantes.add($1, "const", "in", "global", yylineno, addressIntConst);
        addressIntConst++;
    }
    $$ = {$1, "in", constantes.getIdAddress($1)};
}
| CTE_FLT {
    constantes.add($1, "const", "flt", "global", yylineno, addressFltConst);
    $$ = {$1, "flt", addressFltConst};
    addressFltConst++;
}
| CTE_CHR{
    constantes.add($1, "const", "ch", "global", yylineno, addressCharConst);
    $$ = {$1, "ch", addressCharConst};
    addressCharConst++;
};

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

//     std::cout << "SHEEESH " << checkCube(types["+"], types["i"], types["i"]) << '\n';
//     std::cout << "SHEEESH " << checkCube(2, 0, 0) << '\n';

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

//     std::cout << "Inicia pilaO\n";
    int quadNum = 0;
    for(auto& it:quintuplesVect){
        cout << "QUAD NUMBER: " << quadNum << '\n';
        cout << it.opCode << " " << it.dirOp1 << " " << it.dirOp2 << " " << it.result << " " << it.graphicalReserve << '\n';
        quadNum++;
    }
//     while(!pilaO.empty()){
//         std::cout << pilaO.top().idT << '\t' << pilaO.top().tipo << '\n';
//         pilaO.pop();
//
//     }

    ofstream outfile("OVEJOTA.ovejota");
    for(auto& it: tableConst){
        if(it.second.getDataType() == "str"){
            outfile << it.second.getAddress() << "\0" << it.second.getID() << "\0" << it.second.getDataType()  << '\n';
        }else{
            outfile << it.second.getAddress() << "\"" << it.second.getID() << "\"" << it.second.getDataType()  << '\n';
        }
    }

    outfile << "~~~~~~~~~~\n";

    outfile << "~~~~~~~~~~\n";
//     int quadNum = 0;
    for(auto& it:quintuplesVect){
//         cout << "QUAD NUMBER: " << quadNum << '\n';
        outfile << it.opCode << " " << it.dirOp1 << " " << it.dirOp2 << " " << it.result << " " << it.graphicalReserve << '\n';
//         quadNum++;
    }
    outfile.close();

    return 0;
}

void yyerror(const char *s){
    cout << "parsing error: " << s << " on line: " << yylineno << endl;

    exit(-1);
}

void createQuint(std::string command, int op1, int op2, int res, int graphRes){
//     cout << command << " " << op1 << " " << op2 << " " << res << " " << graphRes << '\n';
    quintuplesVect.push_back({command, op1, op2, res, graphRes});
}

bool checkExists(std::string id){
    if(currScope->exists(id) || global.exists(id)){
        return true;
    }
    return false;
}

int getAddress(std::string id){
    if(currScope->exists(id)){
        return currScope->getIdAddress(id);
    }else if(global.exists(id)){
        return global.getIdAddress(id);
    }
    return -1;
}

std::string getDataType(std::string id){
    if(currScope->exists(id)){
        return currScope->getIdDataType(id);
    }else if(global.exists(id)){
        return global.getIdDataType(id);
    }
    return "0";
}

int checkResultType(std::string operation, std::string lOper, std::string rOper){
    return checkCube(types[lOper], types[rOper], types[operation]);
}

void fill(int quintNum, int quintJumpTo){
    quintuplesVect[quintNum].result = quintJumpTo;
}

void updateCurrTypeAddress(int tipo, int currAdd){
    switch(tipo){
        case 0:
            addressIntCurr = currAdd;
        break;

        case 1:
            addressFltCurr = currAdd;
        break;

        case 2:
            addressCharConst = currAdd;
        break;
    }
}

bool checkCurrParam(std::string currCallSign, int currCallPos, std::string currParamSign){
    if(currCallPos >= currCallSign.length()){
        yyerror("unexpected parameter amout for function call");
    }
    if(currParamSign != getTypeFromNum(currCallSign[currCallPos] - '0')){
        std::string errorMsg = "Found parameter of type " + currParamSign + " expected type " + getTypeFromNum(currCallSign[currCallPos] - '0');
        yyerror(const_cast<char*>(errorMsg.c_str()));
    }

    return true;
}

std::string getTypeFromNum(int tipo){
    switch(tipo){
        case 0:
            return "in";
        break;

        case 1:
            return "flt";
        break;

        case 2:
            return "char";
        break;

        default:
            return "";
        break;
    }
}

bool constExists(std::string id){
    return constantes.exists(id);
}


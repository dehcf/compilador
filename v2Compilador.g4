grammar v2Compilador ;

@header{
   import java.util.HashMap;
}

@parser::members{
   HashMap<String, String> tabSimbolos = new HashMap<>();
}

init : programa (variavel | atrib)+ (cmd)+ fimprograma
;

programa : 'programaInit' {System.out.println("\npackage compilador;" + "\npublic static void main(String[] args) { \n" + "\nScanner entrada = new Scanner(System.in); \n");} ;

variavel : ID ':' 
tipo {tabSimbolos.put($ID.text, $tipo.t);} {System.out.print($tipo.t + " " + $ID.text);}
fim {System.out.print("\n");}
;

tipo returns [String t]
: 'real'    {$t = "int";}
| 'integer' {$t = "float";}
| 'decimal' {$t = "double";} 
; 

atrib : 
ID '=' 
({System.out.print($ID.text + " = " );} ID {System.out.print($ID.text);}  
| NUM {System.out.print($ID.text + " = " + $NUM.text);} ) 
fim 
{if(tabSimbolos.get($ID.text) == null) {System.out.print("\n error: Variavel nao declarada: " + "'" + $ID.text + "'" + ";");}}
{System.out.print("\n");}
;

ID  : [a-z]+ ;
NUM : ('+' | '-')?[0-9]+ | [0-9]+ '.' [0-9]* ;

cmd : cmdEscreva | cmdLeia | cmdIf | cmdWhile ; 

cmdEscreva : 'escreva' '(' 
( ID {System.out.println("System.out.println(" + $ID.text + ")" );} | TEXTO {System.out.println("System.out.println(" + $TEXTO.text + ")" );} )
')'
fim {System.out.print("\n");}
;

TEXTO : '"' ([0-9] | [a-z] | [A-Z] | ' ')+ '"' ;

cmdLeia : 'leia' '(' ID ')' {System.out.print($ID.text + " = entrada.nextLine()");} 
fim {System.out.print("\n");};

cmdIf : 'if' '(' expr op_rel expr ')' '{' cmd+ '}' ('else' '{' cmd+ '}')? 
{System.out.print("if(" + $op_rel.op + ")" + "{" + "\n}" );}
fim {System.out.print("\n");}
;

cmdWhile : 'while' '(' expr op_rel expr ')' '{' cmd+ '}' ;

op_rel returns [String op]
: '<' {$op = "<";} | '>' {$op = ">";}| '<' '=' {$op = "<=";} | '>' '=' {$op = ">=";} | '!' '=' {$op = "!=";} | '=' '=' {$op = "==";} 
;

expr : termo exprLinha ;

exprLinha : '+' termo exprLinha | '-' termo exprLinha | ;

termo : fator termoLinha ;

termoLinha : '*' fator termoLinha | '/' fator termoLinha | ;

fator : NUM | ID | '(' expr ')' ;


fimprograma : '!' {System.out.print("\n" + "}" + "\n");} ;

fim : ',' {System.out.print(";");};

WS : [ \t\r\n]+ -> skip ;

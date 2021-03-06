%{
# include <stdio.h>
#include <ctype.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>
#include "y.tab.h"

int lineNo = 1;
extern int globalLevel;
//#define YY_DECL extern "C" int yylex()

%}

letter			[a-zA-Z]
digit	 		[0-9]
logical_value		"true"|"false"
logical_operator	"|"|"&"|"!"
arithmetic_operator	"+"|"-"|"*"|"/"|"**"
relational_operator	"<"|"<="|"="|">"|">="|"<>"
sequential_operator	"goto"|"if"|"then"|"else"|"for"|"do"
separator		","|"."|"\'10\'"|":"|";"|":="|" "|"step"|"until"|"while"|"comment"

bracket			"("|")"|"["|"]"|"`"|"'"|"begin"|"end"

declarator		"own"|"Boolean"|"integer"|"real"|"array"|"switch"|"procedure"

specificator		"string"|"label"|"value"

operator		{logical_operator}|{arithmetic_operator}|{relational_operator}|{sequential_operator}
delimiter		{operator}|{separator}|{bracket}|{declarator}|{specificator}
basic_symbol		{letter}|{digit}|{logical_value}|{delimiter}
identifier		{letter}({letter}|{digit})*

unsigned_integer	{digit}+
integer			{unsigned_integer}
decimal_fraction	"."{unsigned_integer}
exponential_part	"\'10\'"{integer}
decimal_number		{unsigned_integer}|{decimal_fraction}|{unsigned_integer}{decimal_fraction}
unsigned_number		{decimal_number}|{exponential_part}|{decimal_number}{exponential_part}
real_number		{unsigned_number}

white			" "|"\t"
newline			"\n"
library			"sin"|"cos"|"tan"|"abs"|"sign"|"sqrt"|"ln"|"exp"|"arctan"|"arcsin"|"arccos"
%%
{newline}		{lineNo++;}
			
COMMENT[^.;]*;		{char *tempString = (char *)yytext;
			 int i = 0;
			 while(tempString != NULL){
				if (tempString[0]=='\n') {lineNo++;}
				tempString++;
			 }
			 printf(" COMMENT FOUND ");
			}

			
"'begin'"		{printf("begin reached, global level=%d\n",globalLevel);
			 push(globalLevel);
			 return TOKEN_BEGIN ;}
			
"'end'"			{printf("end reached\n");
			 pop(globalLevel);
			 return TOKEN_END;}


{white}*		{}
			

{logical_value}		{return TOKEN_LOGICAL_VALUE;}

"+"			{return TOKEN_PLUS ;}
"-"			{return TOKEN_MINUS;}
"/"			{return TOKEN_DIVIDE;}
"*"			{return TOKEN_MULTIPLY;}
"**"			{return TOKEN_POWER;}

{relational_operator}	{return TOKEN_REL_OP;}
"<"			{return TOKEN_LESS ;}
"<="			{return TOKEN_LESS_EQUAL ;}
"="			{return TOKEN_EQUAL ;}
">"			{return TOKEN_GREATER ;}
">="			{return TOKEN_GREATER_EQUAL ;}
"<>"			{return TOKEN_NOTEQUAL ;}

","			{return TOKEN_COMMA ;}
";"			{printf("semicolon reached\n");return TOKEN_SEMICOLON ;}
":="			{printf("assign reached\n");return TOKEN_ASSIGN ;}
":"			{return TOKEN_COLON ;}
"_"			{return TOKEN_UNDERSCORE ;}

"!"			{return TOKEN_NOT_OP ;}
"|"			{return TOKEN_OR_OP ;}
"&"			{return TOKEN_AND_OP ;}
"=>"			{return TOKEN_IMPLY ;}
"==" 			{return TOKEN_EQUIV;}

"goto"			{return TOKEN_GOTO ;}
"if"			{return TOKEN_IF ;}
"then"			{return TOKEN_THEN ;}
"else"			{return TOKEN_ELSE ;}
"for"			{return TOKEN_FOR ;}
"do"			{return TOKEN_DO ;}
"return"		{return TOKEN_RETURN ;}

"step"			{return TOKEN_STEP ;}
"until"			{return TOKEN_UNTIL;}
"while"			{return TOKEN_WHILE;}

"("			{return TOKEN_OPEN_BRACKET;}
")"			{return TOKEN_CLOSE_BRACKET;}
"["			{return TOKEN_OPEN_SQUARE_BRACKET;}
"]"			{return TOKEN_CLOSE_SQUARE_BRACKET;}
{bracket}		{return TOKEN_BRACKET;}

"own"			{return TOKEN_TYPE_OWN;}
"boolean"		{return TOKEN_TYPE_BOOLEAN;}
"integer"		{printf("type integer reached\n");return TOKEN_TYPE_INTEGER;}
"real"			{return TOKEN_TYPE_REAL;}
"array"			{return TOKEN_ARRAY;}
"switch"		{return TOKEN_TYPE_SWITCH;}
"procedure"		{return TOKEN_TYPE_PROCEDURE;}

"label"			{printf("labelu reached\n"); return TOKEN_TYPE_LABEL;}
"value"			{return TOKEN_TYPE_VALUE;}

{specificator}		{return TOKEN_SPECIFIER;}

{library}		{return TOKEN_LIBRARY;}


{identifier}		{printf("identifier reached\n"); return TOKEN_IDENTIFIER;}

{integer}		{return TOKEN_INTEGER;}

{real_number}		{return TOKEN_REAL_NUM;}


%%
// "."			{}
//[a-zA-Z]+":="		{return TOKEN_ASSIGN_IDENTIFIER;}
//[a-zA-Z]+":"		{printf("labelu identifier reached\n");return TOKEN_LABEL_IDENTIFIER;}
//"bool_"{identifier}	{return TOKEN_BOOL_IDENTIFIER;}

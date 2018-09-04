#ifndef CALC_H
#define CALC_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>

bool dbgOn = false;

// Store variable
char* variableNames[100]; 
int variableSet[100];
int variableCounter = 0; 
double variableValues[100];


int add_variable(char* varName) {
	int x;
	for (x = 0; x < variableCounter; x++) 
    {
		if (strcmp(varName, variableNames[x]) == 0) 
        {
            return x;
		}
	}	
	variableCounter++;
	variableNames[x] = strdup(varName);
	return x;
}

void set_variable(int index, double value) {
	variableValues[index] = value;
	variableSet[index] = 1;	
}

void Exit() {
    //printf("\e[1;1H\e[2J");
    printf("\n\tBye bye!!!\n\n");
    exit(1);
}
 
void yyerror(char *s) {
    fprintf(stderr, "\t%s", s);
}

bool isPowerOfTwo (int x) {
    while (((x % 2) == 0) && x > 1) 
    x /= 2;
    if (x == 1)
    {
        return true;
    }
    else
    {
        return false;
    }
}

char* ToFraction(float num)
{
    char *output = malloc(sizeof(char*) * 20);
    int temp, i, cf[50], n = 0, d = 1;
    double prec = 1e-6;

    if (roundf(num) != num)// && !isPowerOfTwo((float)num))
    {
        /*if (dbgOn)
        {
            printf("\t[DBG] [clean] [%0.2f]\n", num);
            printf("\t[DBG] [roundf] [%0.2f]\n", roundf(num));
        }*/
        memset(cf, 0, sizeof(memset));

        for (i = 0; i < 10000 && prec < 1; i++) {
            cf[i] = num;        
            num = 1 / (num - cf[i]);
            prec*=num;
        }

        for ( ; i >= 0; i--) {
            temp = n;
            n = n * cf[i] + d;
            d = temp;
        }
        if (cf[0] == 0) 
        {   
            sprintf(output, "[%i/%i]", n, d);
        }
        else 
        {     
            sprintf(output, "(%i/%i)", n, d);
        }        
    }
    else if (isPowerOfTwo(num)) 
    {
        sprintf(output, "%i", (int)num);
    }
    else 
    {
        /*if (d == 1)        
        {
            sprintf(output, "%i", n);
            //printf("\tResult:: %i\n", (int)num);
        }
        else
        {
            //sprintf(output, "%i/%i", n, d);    
            sprintf(output, "%i/%i", (int)num, d);
        }*/
        sprintf(output, "%i/%i", (int)num, d);
    }
    return output; 
}

void DbgOutput1(float num1) {    
    if (dbgOn)
    {
        printf("\t[DBG] Got: %s\n", ToFraction(num1));
    }
}

void DbgOutput2(char* op, float num1) {
    if (dbgOn)
    {
        printf("\t[DBG] Got: %s%s\n", op, ToFraction(num1));
    }
}

void DbgOutput3(float num1, char* op, float num2) {
    if (dbgOn)
    {
        printf("\t[DBG] Got: %s %s %s\n", ToFraction(num1), op, ToFraction(num2));
    }
}

void DbgOutput4(char* op1, float num1, char* op2) {
    if (dbgOn)
    {
        printf("\t[DBG] Got: %s%s%s\n", op1, ToFraction(num1), op2);
    }
}

void DbgOutResult(float num1, char* op, float num2, float result) {
    if (dbgOn)
    {
        printf("\t[DBG] Got: %s %s %s = %s\n", ToFraction(num1), op, ToFraction(num2), ToFraction(result));
    }
}

#endif
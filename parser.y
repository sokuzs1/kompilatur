%{
             #include <iostream>
             #include <vector>
             #include <stack>
             #include <fstream>
             #include <string>

             using namespace std;

             stuct variable
             {
                          string name;
                          long long index;
             }

             void acc(string s);
	void get();
	void put();
             void load(int i);
             void loadi(int i);
             void store(int i);
             void storei(int i);
             void add(int i);
             void addi(int i);
             void sub(int i);
             void subi(int i);
             void shr();
             void shl();
             void inc();
             void dec();
             void zero();
             void jump(int i);
             void jzero(int i);
             void jodd(int i);
             void halt();
             void add(string a, string b);
             void subt(string a, string b);
             void mult(string a, string b);
             void div(string a, string b);
             void mod(string a, string b);
             void eq(string a, string b);
             void diff(string a, string b);
             void lt(string a, string b);
             void gt(string a, string b);
             void le(string a, string b);
             void ge(string a, string b);
             void assign(string a);

             bool isNumber(const &string);
             int findVar(string a);
             void loadToReg(int i);
             void storeInMem(int i);
             void flush();


%}
//C and parser declarations
%token VAR BEGIN END
%token ID
%token NUM
%token READ WRITE
%token IF THEN ELSE ENDIF
%token WHILE DO ENDWHILE
%token FOR FROM TO DOWNTO DO ENDFOR
%token ASSIGN
%token ADD SUBT MULT DIV MOD
%token EQ DIFF LT GT LE GE
%token TAB

vector<variable> var;
vector<string> mem;
vector<string> com;
stack<int> jumpJ;
stack<int> expB;
stack<int> elseB;
string reg = "-1";
long long k = 0;
long long pi=0;

%%
//Grammar rules and actions
program : VAR vdeclarations BEGIN commands END {flush(); halt();}

vdeclarations:  vdeclarations ID /*?*/
{
             if(findVar($2)==-1)
             {
                          variable var;
                          var.name = $2;
                          var.index=pi;
                          pi++;
                          //dalej inicjacja o ile trzeba
             }
             else
             {
                          cout<<"Error, second declaration of a variable "<< $2<<endl;
                          return 0;
             }
}
;
| vdeclarations ID[NUM]
{
             //jeśli mamy taką talbicę to jebać
             //jak nie mamy to inicjujemy
}
|
;

commands : /* empty */
| commands command
;

command: ID ASSIGN expression {assign($1)};
| IF condition THEN commands ELSE commands ENDIF
| IF condition THEN commands ENDIF
| WHILE condition DO commands {
             //początek
             //jzero
             //robimy
             //jump początek
} ENDWHILE
| FOR ID FROM value TO value DO commands ENDFOR
| FOR ID FROM value DOWNTO value DO commands ENDFOR
| READ ID {read($2)};
| WRITE value {write($2)};//komendy
;

expression: value {/*val*/}
| value ADD value {add($1,$3);}
| value SUBT value {sub($1,$3);}
| value MULT value {mult($1,$3);}
| value DIV value {div($1,$3);}
| value MOD value {mod($1,$3);}
;

condition: value EQ value {eq($1,$3);}
| value DIFF value {diff($1,$3);}
| value LT value {lt($1,$3);}
| value GT value {gt($1,$3);}
| value LE value {le($1,$3);}
| value GE value {ge($1,$3);}
;

value: NUM {/*lecimy z tematem*/}
| identifier
;

identifier: ID {
             //jak jest taki to lecimy, jak nie to błąd
}
| ID[ID] {
             //jak jest taka tablica i taki id to lecimy, chyba że id ma wartość większą niż długość tablicy
}
| ID[NUM] {
             //sprawdzamy czy jest taka tablica i jak długosć jest mniejsza niż num to lecim
}
;

%%
//C subroutines

///dla interpretera
void get(){
	stringstream ss;
	ss << "GET";
	k++;
	komendy.push_back(ss.str());
}
void put(){
	stringstream ss;
	ss << "PUT";
	k++;
	komendy.push_back(ss.str());
}
void load(int i)
{
	stringstream ss;
	ss << "LOAD " << i;
	k++;
	komendy.push_back(ss.str());
}
void loadi(int i)
{
	stringstream ss;
	ss << "LOADI " << i;
	k++;
	komendy.push_back(ss.str());
}
void store(int i)
{
	stringstream ss;
	ss << "STORE " << i;
	k++;
	komendy.push_back(ss.str());
}
void storei(int i)
{
	stringstream ss;
	ss << "STOREI " << i;
	k++;
	komendy.push_back(ss.str());
}
void add(int i)
{
	stringstream ss;
	ss << "ADD " << i;
	k++;
	komendy.push_back(ss.str());
}
void addi(int i)
{
	stringstream ss;
	ss << "ADDI " << i;
	k++;
	komendy.push_back(ss.str());
}
void sub(int i)
{
	stringstream ss;
	ss << "SUB " << i;
	k++;
	komendy.push_back(ss.str());
}
void subi(int i)
{
	stringstream ss;
	ss << "SUBI " << i;
	k++;
	komendy.push_back(ss.str());
}
void inc()
{
	stringstream ss;
	ss << "INC";
	k++;
	com.push_back(ss.str());
}
void dec()
{
	stringstream ss;
	ss << "DEC";
	k++;
	com.push_back(ss.str());
}
void zero()
{
	stringstream ss;
	ss << "ZERO";
	k++;
	com.push_back(ss.str());
}
void shl()
{
	stringstream ss;
	ss << "SHL";
	k++;
	com.push_back(ss.str());
}
void shr()
{
	stringstream ss;
	ss << "SHR";
	k++;
	com.push_back(ss.str());
}
void jump(int i)
{
             stringstream ss;
             ss << "JUMP " << i;
             k++;
             komendy.push_back(ss.str());
}
void jodd(int i)
{
              stringstream ss;
              ss << "JODD " << i;
              k++;
              komendy.push_back(ss.str());
}
void jzero(int i)
{
               stringstream ss;
               ss << "JZERO " << i;
               k++;
               komendy.push_back(ss.str());
}
void halt()
{
                cout << "HALT" << endl;
                k++;
}

///operacje

void add(string a, string b)
{
             if(isNumber(a) && isNumber(b))
             {
                          long long x = stoll(a);
                          long long y = stoll(b);
                          if(x>y)
                          {
                                       int i=0;
                                       //loadToReg(a); do poprawy
                                       while(i<y)
                                       {
                                                    inc();
                                                    i++;
                                       }
                          }
                          else
                          {
                                       int i=0;
                                       //loadToReg(b); do poprawy
                                       while(i<x)
                                       {
                                                    inc();
                                                    i++;
                                       }

                          }
                          //dokończyć
             }
             else if(isNumber(a))
             {
                          long long x = stoll(a);
                          int index = findVar(b);
                          loadToReg(index);
                          long long y = stoll(reg);

                          //operacje
             }
             else if(isNumber(b))
             {
                          int index = findVar(a);
                          loadToReg(index);
                          long long x = stoll(reg);
                          long long y = stoll(b);
                          //operacje
             }
             else
             {

             }
}
void subt(string a, string b)
{
             if(isNumber(a) && isNumber(b))
             {
                          long long x = std::stoll(a);
                          long long y = std::stoll(b);
                          if(x>y)
                          {
                                       int i=0;
                                       //loadToReg(a); do poprawy
                                       while(i<y)
                                       {
                                                    dec();
                                                    i++;
                                       }
                          }
                          else
                          {
                                       int i=0;
                                       //loadToReg(b); do poprawy
                                       while(i<x)
                                       {
                                                    dec();
                                                    i++;
                                       }

                          }
                          //operacje
             }
             else if(isNumber(a))
             {
                          //operacje
             }
             else if(isNumber(b))
             {
                          //operacje
             }
             else
             {

             }
}
void mult(string a, string b)
{
             if(isNumber(a) && isNumber(b))
             {
                          long long x = std::stoll(a);
                          long long y = std::stoll(b);
                          //operacje
             }
             else if(isNumber(a))
             {
                          //operacje
             }
             else if(isNumber(b))
             {
                          //operacje
             }
             else
             {

             }
}
void div(string a, string b)
{
             if(isNumber(a) && isNumber(b))
             {
                          long long x = std::stoll(a);
                          long long y = std::stoll(b);
                          //operacje
             }
             else if(isNumber(a))
             {
                          //operacje
             }
             else if(isNumber(b))
             {
                          //operacje
             }
             else
             {

             }
}
void mod(string a, string b)
{
             if(isNumber(a) && isNumber(b))
             {
                          long long x = std::stoll(a);
                          long long y = std::stoll(b);
                          //operacje
             }
             else if(isNumber(a))
             {
                          //operacje
             }
             else if(isNumber(b))
             {
                          //operacje
             }
             else
             {

             }
}
void eq(string a, string b)
{
             if(isNumber(a) && isNumber(b))
             {
                          long long x = std::stoll(a);
                          long long y = std::stoll(b);
                          //operacje
             }
             else if(isNumber(a))
             {
                          //operacje
             }
             else if(isNumber(b))
             {
                          //operacje
             }
             else
             {

             }
             //load(a)
             //store(a)
             //load(b)
             //sub(a)
             //skok
}
void diff(string a, string b)
{
             if(isNumber(a) && isNumber(b))
             {
                          long long x = std::stoll(a);
                          long long y = std::stoll(b);
                          //operacje
             }
             else if(isNumber(a))
             {
                          //operacje
             }
             else if(isNumber(b))
             {
                          //operacje
             }
             else
             {

             }
             //load(a)
             //store(a)
             //load(b)
             //sub(a)
             //skok
}
void lt(string a, string b)
{
             if(isNumber(a) && isNumber(b))
             {
                          long long x = std::stoll(a);
                          long long y = std::stoll(b);
                          //operacje
             }
             else if(isNumber(a))
             {
                          //operacje
             }
             else if(isNumber(b))
             {
                          //operacje
             }
             else
             {

             }
             //load(a)
             //store(a)
             //load(b)
             //sub(a)
             //skok
}
void gt(string a, string b)
{
             if(isNumber(a) && isNumber(b))
             {
                          long long x = std::stoll(a);
                          long long y = std::stoll(b);
                          //operacje
             }
             else if(isNumber(a))
             {
                          //operacje
             }
             else if(isNumber(b))
             {
                          //operacje
             }
             else
             {

             }
             //load(a)
             //store(a)
             //load(b)
             //sub(a)
             //skok
}
void le(string a, string b)
{
             if(isNumber(a) && isNumber(b))
             {
                          long long x = std::stoll(a);
                          long long y = std::stoll(b);
                          //operacje
             }
             else if(isNumber(a))
             {
                          //operacje
             }
             else if(isNumber(b))
             {
                          //operacje
             }
             else
             {

             }
             //load(a)
             //store(a)
             //load(b)
             //sub(a)
             //skok
}
void ge(string a, string b)
{
             if(isNumber(a) && isNumber(b))
             {
                          long long x = std::stoll(a);
                          long long y = std::stoll(b);
                          //operacje
             }
             else if(isNumber(a))
             {
                          //operacje
             }
             else if(isNumber(b))
             {
                          //operacje
             }
             else
             {

             }
             //load(a)
             //store(a)
             //load(b)
             //sub(a)
             //skok
}
void assign(string a)
{
             if(findVar(a)==-1)
             {
                          cout<<"Error, cannot assign value to uninitialised variable"<<endl;
                          return 0;
             }
             else
             {

             }
             //przypisywanko
}
void read(string id)
{
             get();
             //index i przechowywanie w pamięci
             int index =  findVar(id);
             storeInMem(index);
}
void write(string id)
{
             put();
             //index i ładowanie do rejestru
             sint index =  findVar(id);
             loadToReg(index);
}

/// dodatkowe funkcje

bool isNumber(const string& s)
{
    string::const_iterator it = s.begin();
    while (it != s.end() && isdigit(*it)) ++it;
    return !s.empty() && it == s.end();
}

void loadToReg(int i)
{
             load(i);
             reg = mem[i];
             //dla tablicy
             //poprawność
}
void storeInMem(int i)
{
             store(i);
             if(mem[i]!=null)
                          mem[i]=reg;
             else
                          mem.push_back(reg);
             //dla tablicy
             //poprawność
}
int findVar(string name){
	int n = variables.size();
	for(int i = 0; i < n; i++){
		if(variables[i].name == name)
			return i;
	}
	return -1;
}
void flush(){
	for (int i = 0; i < com.size(); i++)
		cout << com[i] << endl;
}

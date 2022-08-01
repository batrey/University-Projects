

import java.util.*;


public class Parser {
    //tok is global to all these parsing methods;
    //scan just calls the scanner's scan method and saves the result in tok.
    private Token tok; // the current token
    
    //initializes a list of lists
    ArrayList<ArrayList<String>> symbolTable = new ArrayList<ArrayList<String>>();
    int insertLevel = -1;    //current index of symbolTable;
    Boolean typeDec = false; //used to determine if an id has already been declared

    private void scan() {
	tok = scanner.scan(); 
    }
    private Scan scanner;
    Parser(Scan scanner) {
	this.scanner = scanner;
	scan();
	program();
	if( tok.kind != TK.EOF )
	    parse_error("junk after logical end of program");
    }
    
    //inserts a string into an array at the current scope level
    private void insert(String insertString){
      symbolTable.get(insertLevel).add(insertString);
    }
    
    //checks if a certain level has a string in it
    private Boolean checkDeclaration(String findString, int level)
    {
      if(symbolTable.get(level).contains(findString))
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    
    //GLOBALSCOPE is used for ~ with no number   ex:~k
    private Boolean GLOBALSCOPE(String findString)
    {
      if(symbolTable.get(0).contains(findString))
      {
        return true;
      }
      System.err.println("no such variable ~" + tok.string
                  + " on line " + tok.lineNumber);
      System.exit(1);
      return false;
    }
    
    //scopedFind is used for ~ with a number     ex:~0k or ~313k
    private Boolean scopedFind(String findString, int level)
    {
      if(insertLevel-level >= 0)
      {
        if(symbolTable.get(insertLevel-level).contains(findString))
        {
          return true;
        }
      }
      System.err.println("no such variable ~" + level + tok.string
                  + " on line " + tok.lineNumber);
      System.exit(1);
      return false;
    }
    
    //finds if there is a certain string in the symbol table
    private Boolean find(String findString){
      for(int i = insertLevel; i >= 0; i--)
      {
        if(symbolTable.get(i).contains(findString))
        {
          return true;
        }
      }
      return false;
    }
    
    //finds the level general variables
    private int findLevel(String findString){
      for(int i = insertLevel; i >= 0; i--)
      {
        if(symbolTable.get(i).contains(findString))
        {
          return i;
        }
      }
      return -1;
    }
    
    //increases scope by 1 and adds new array to arrayList
    private void increaseInsertLevel() {
      symbolTable.add(new ArrayList<String>());
      ++insertLevel;
    }
    
    //decreases the scope by 1
    private void decreaseInsertLevel() {
      symbolTable.remove(insertLevel--);
    }
    
    //PROGRAM ::= block
    private void program() {
      System.out.print("#include <stdio.h>\n" + "main() \n");
      if(is(TK.none) || is(TK.EOF))  //output main
      {
        System.out.print("{ }\n");
        return;
      }
      symbolTable.add(new ArrayList<String>());
      block();
    }
  
    //BLOCK ::= declaration_list statement_list
    private void block() {
      System.out.println("{");
      increaseInsertLevel();  //scope level++
	    declaration_list();
	    statement_list();
	    decreaseInsertLevel();  //scope level--
	    System.out.println("}");
    }

    //DECLARATION_LIST ::= {declaration}
    private void declaration_list() { 
	    while( is(TK.DECLARE) ) 
	    {
	        declaration();
	    }
    }

    //DECLARATION ::= '@' id { ',' id }
    private void declaration() {
	    mustbe(TK.DECLARE);
	    if(is(TK.ID))
	    {
	      if(checkDeclaration(tok.string,insertLevel))
	      {
	         redeclaredError();
	      }
	      else
	      {
	        System.out.print("int x_" + insertLevel + tok.string);
	        typeDec = true;
	        insert(tok.string);
	        scan();
	      }
	      while(is(TK.COMMA) ) 
  	    {
  	        scan();
  	        if(is(TK.ID))
      	    {
      	      if(checkDeclaration(tok.string,insertLevel))
  	          {
  	            redeclaredError();
  	          }
  	          else
  	          {
  	            if(typeDec) 
  	            {
  	              System.out.print(", ");
  	              System.out.print("x_" + insertLevel + tok.string);
  	              insert(tok.string);
  	              scan();
  	            }
  	            else
  	            {
  	              System.out.print("int x_" + insertLevel + tok.string);
	                typeDec = true;
	                insert(tok.string);
	                scan();
  	            }
  	          }
      	    }
  	    }
  	    System.out.print(";\n");
  	    typeDec = false;
	    }
	    else
	    {
	      mustbe(TK.ID);
	    }
    }

    //STATEMENT_LIST ::= {statement}
    private void statement_list() {
      while(is(TK.PRINT) || is(TK.DO) || is(TK.IF) || is(TK.ID) || is(TK.TILDE) || is(TK.FOR))
	    {
        statement();
	    }
    }
    
    //STATEMENT ::= assignment | print | do | if | for
    private void statement() {
      if(is(TK.PRINT))
      {
        printstuff();  //print
      }
      else if(is(TK.DO)) 
      {
        whileblock();  //do
      }
      else if(is(TK.IF))
      {
        ifstatement(); //if
      }
      else if(is(TK.FOR))
      {
        forblock();    //for
      }
      else if(is(TK.ID) || is(TK.TILDE))
      {
        assignment();  //deal with assigning values
      }
      else
      {
        parse_error("junk after logical end of file");
      }
    }
    
    //ASSIGNMENT ::= ref_id '=' expr
    //REF_ID ::= [ '~' [ number ] ] id
    private void assignment() {
      if(is(TK.TILDE))  //if it deals with the scoping operator
      {
        scan();
        if(is(TK.NUM))  //if the scope to check is specified
        {
          int temp = Integer.parseInt(tok.string);
          scan();       //check the scope for tok.string
          if(!scopedFind(tok.string,temp))
          {             //if tok.string is not found, error
            undeclaredError(); 
          }
          System.out.print("x_" + (insertLevel - temp) + tok.string);
        }
        else
        {
          if(!GLOBALSCOPE(tok.string))
          {
            undeclaredError();
          }
          System.out.print("x_0" + tok.string);
        }
      }
      else
      {
        if(!find(tok.string))
        {
          undeclaredError();
        } 
        System.out.print("x_" + findLevel(tok.string) + tok.string);
      }
      scan();
      mustbe(TK.ASSIGN);
      System.out.print(" = ");
      expr();
      System.out.print(";\n");
    }
    
    //PRINT ::= '!' expr
    private void printstuff() {
      scan();
      System.out.print("printf(\"%d\\n\", ");
      expr();
      System.out.print(");\n");
    }
    
    //DO ::= '<' guarded_command '>'
    private void whileblock() {
      scan();
      System.out.print("while(");
      guardedCommand();
      mustbe(TK.ENDDO);
    }
    
    //IF ::= '[' guarded_command { '|' guarded_command } [ '%' block ] ']'
    private void ifstatement() {
      scan();
      System.out.print("if(");
      guardedCommand();
      while(is(TK.ELSEIF))  //handles else ifs
      {
        scan();
        System.out.print("else if(");
        guardedCommand();
      }
      if(is(TK.ELSE))       //handles elses
      {
        scan();
        System.out.print("else ");
        block();
      }
      mustbe(TK.ENDIF);     //makes sure the if statement ended
    }
    
    //FOR::= '$' assignment '$' expr '$' inc : block '?'
    private void forblock() {
      scan();
      System.out.print("for(");
      assignment();
      mustbe(TK.FOR);
      expr();
      mustbe(TK.FOR);
      System.out.print(" <= 0; ");
      factor();
      System.out.print("++");
      mustbe(TK.THEN);
      System.out.println(")");
      block();
      mustbe(TK.ENDFOR);
    }
    
    //GUARDED_COMMAND ::= expr ':' block
    private void guardedCommand() {
      expr();
      mustbe(TK.THEN);
      System.out.print(" <= 0) ");
      block();
    }
    
    //EXPR ::= term { addop term }
    private void expr() {
      term();
      while(is(addop())) 
      {
        if(is(TK.PLUS))
        {
          System.out.print(tok.string);
          scan();
          term();
        }
        else
        {
          System.out.print(tok.string);
          scan();
          term();
        }
      }
    }
    
    //TERM ::=  factor { multop factor }
    private void term() {
      factor();
      while(is(multop())) 
      {
        if(is(TK.TIMES))
        {
          System.out.print(tok.string);
          scan();
          factor();
        }
        else
        {
          System.out.print(tok.string);
          scan();
          factor();
        }
      }
    }
    
    //FACTOR ::= '(' expr ')' | number | variable
    private void factor() {
      if(is(TK.LPAREN))
      {
        System.out.print("(");
        scan();
        expr();
        mustbe(TK.RPAREN);
        System.out.print(")");
      }
      else if(is(TK.NUM))
      {
        System.out.print(tok.string);
        scan();
      } 
      else
      {
        if(is(TK.TILDE))  //if it deals with the scoping operator
        {
          scan();
          if(is(TK.NUM))  //if there is a number before the variable
          {
            int temp = Integer.parseInt(tok.string); //is equal to the level 
            scan();       //check to make sure it has been previously declared
            if(!scopedFind(tok.string,temp))
            {
              undeclaredError(); 
            }
            System.out.print("x_" + (insertLevel - temp) + tok.string);
          }
          else
          {
            if(!GLOBALSCOPE(tok.string))
            {
              undeclaredError();
            }
            System.out.print("x_0" + tok.string);
          }
        }
        else
        {
          if(!find(tok.string))
          {
            undeclaredError();
          } 
          System.out.print("x_" + findLevel(tok.string) + tok.string);
        }
        scan();
      }
    }
    
    //ADDOP ::= '+' | '-'
    private TK addop() {
      if(is(TK.PLUS))
      {
        return TK.PLUS;
      }
      else if(is(TK.MINUS))
      {
        return TK.MINUS;
      }
      else
      {
        return TK.ERROR; //return if error
      }
    }
    
    //MULTOP ::= '*' | '/'
    private TK multop() {
      if(is(TK.TIMES)) 
      {
        return TK.TIMES;
      }
      else if(is(TK.DIVIDE)) 
      {
        return TK.DIVIDE;
      }
      else 
      {
        return TK.ERROR; //return if error
      }
    }
    
    // is current token what we want? no skip
    private boolean is(TK tk) {
        return tk == tok.kind;
    }

    // ensure current token is tk and skip over it.
    private void mustbe(TK tk) {
	if( tok.kind != tk ) {
	    System.err.println( "mustbe: want " + tk + ", got " +
				    tok);
	    parse_error( "missing token (mustbe)" );
	} 
	scan();
    }
    
    //current token doesn't fit language grammar
    private void parse_error(String msg) {
	System.err.println( "can't parse: line "
			    + tok.lineNumber + " " + msg );
	System.exit(1);
    }
    
    //Outputs error when called
    private void undeclaredError()
    {
    	System.err.println( tok.string + " is an undeclared variable on line "
		    + tok.lineNumber);
      System.exit(1);
    }
    
    //call if variable redeclares, no system exit
    private void redeclaredError()
    {
      System.err.println( "redeclaration of variable " + tok.string);
      scan();
    }
}
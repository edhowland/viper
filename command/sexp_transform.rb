# sexp_transform.rb - Parse transform that returns S-expressions as PairType
# TODO: Remove this file from git repo

def mksexp(k, v)
  PairType.new(key: k, value: v)
end

# make a list form a variety of objects or collections
def list_from(object)
  if list?(object)
    object
  elsif (object.respond_to?(:empty?) and object.empty?) or object.nil?
    NullType.new
  elsif object.instance_of?(Array)
    mklist(*object)
  else
    mklist(object)
  end
end

def sbool(bool)
  mklist(:boolean, bool)
end
# identifier
def sident(x)
  mklist(:ident, x)
end

# deref
def sderef(ident)
  mklist(:deref, ident)
end

# deref a list  ... :a[0]
def sdereflist(deref, list)
  mklist(:dereflist, deref, list)
end
# deref a list for assignment as lvalue: a[2] = 3
def svectorid(deref, index)
  mklist(:vectorid, deref, index)
end

# integer
def sint(number)
  mklist(:integer, number)
end
# sstrlit - StringLiteral
def sstrlit(x)
  mklist(:string, x)
end
# string interpolation
def sstr_intp(list)
  mklist(:string_intp, *list)
end
# symb ol
def ssymbol(x)
  mklist(:symbol, x)
end
# make a pair: of s:symbol, e:expression
def spair(s, e)
  mklist(:pair, s, e)
end
# Vector
def svector(args)
  mklist(:vector, *(args).reject(&:nil?))
end
# objects: dics or Ruby hash
def sobject(arglist)
  mklist(:object, *(arglist).reject(&:nil?))
end
# parameter list
def sparmlist(list)
  mklist(:parmlist, *(list.reject(&:nil?)))
end
# Functions
# function return
def sreturn(expr)
  mksexp(:_return, expr)
end
def slambda(parms, block)
  mklist(:lambda, sparmlist(parms), block)
end
# Function calls
def sfuncall(name, args)
  mklist(:lambdacall, name, *(args.reject(&:nil?)))
end

def slambdacall(name, args)
  mklist(:lambdacall, name, *(args.reject(&:nil?)))
end

# The empty set
def signore()
  PairType.new(key: :ignore, value: NullType.new)
end

def shalt()
  mklist(:halt, :_)
end

# utility
def mklist(*args)
  Builtins.list(*args)
end
# mkargs - helper function for wierd Parslet:: wway to deal with optionally empty
#arrays
def mkargs(array)
  mklist(*(array.reject(&:nil?)))
end
def binop(op, l, r)
  mklist(op, l, r)
end

def add(l, r)
  Builtins.list(:add, l, r)
end
def sub(l, r)
  Builtins.list(:sub, l, r)
end
def mult(l, r)
  Builtins.list(:mult, l, r)
end
def div(l, r)
  Builtins.list(:div, l, r)
end
def modulo(l, r)
  mklist(:modulo, l, r)
end
def exponent(l, r)
  mklist(:exp, l, r)
end
# control flow
def pipe(l, r)
  mklist(:pipe, l, r)
end
# logical and and or. Shortcircuits
def logical_and(l, r)
  mklist(:logical_and, l, r)
end
def logical_or(l, r)
  mklist(:logical_or, l, r)
end
# logical
def bool_and(l, r)
  mklist(:and, l, r)
end
def bool_or(l, r)
  mklist(:or, l, r)
end
# assignment
def assign(l, r)
  mklist(:assign, l, r)
end
# equality
def eq(l, r )
  mklist(:eq, l, r)
end
def neq(l, r)
  mklist(:neq, l, r)
end

# mkarith - Make arithmetic subexpression
def mkarith(o, l, r)
  msgs = {
    '=' => :assign, 
    '|' => :pipe,
    '&&' => :logical_and,
    '||' => :logical_or,
    'and' => :and,
    'or' => :or,
    "**" => :exp,
    "%" => :modulo,
    "+" => :add,
    "-" => :sub,
    "*" => :mult,
    "/" => :div,
    "==" => :eq,
    "!=" => :neq,
    ">" => :greater,
    "<" => :less,
    ">=" => :gte,
    "<=" => :lte
  }
  m = msgs[o.to_s.strip]
  if m.nil?
    raise CompileError.new 'Unknown arithmetic expression type'
  else
#    self.send m, l, r
  binop(m, l, r)
  end
end

# Statement lists
def sstatements(list)
  mklist(*list)
end

# Blocks
def sblock(list)
  mksexp(:block, list)
end
  # Quote: Un-emitted AST nodes - The emitter will just return this subtree
  def squote(sexp)
    mksexp(:quote, sexp)
  end

# The root of the program
def sroot tree
  mklist(:program, tree)
end
class SexpTransform < Parslet::Transform
  # promote :{ statements ... } into lambda closure
  rule(block_lambda: simple(:block_lambda)) { slambda([], block_lambda) }
  # method call %p.foo; %p.foo(0); %p.foo(1,2,3)
  # This is different from indexed objects like %a[foo:] due to VishParser stuff
  rule(lambda_call: simple(:deref), execute_index: simple(:execute_index), index: simple(:arglist)) { mksexp(:lambdacall_index, sdereflist(sderef(deref), ssymbol(arglist))) }
  rule(lambda_call: simple(:deref), execute_index: simple(:execute_index), index: simple(:arglist), arglist: simple(:lambda_args)) {mklist(:lambdacall_args, mkargs([lambda_args]),sdereflist(sderef(deref), ssymbol(arglist))) }
  rule(lambda_call: simple(:deref), execute_index: simple(:execute_index), index: simple(:arglist), arglist: sequence(:lambda_args)) {mklist(:lambdacall_args, mkargs(lambda_args),sdereflist(sderef(deref), ssymbol(arglist))) } 

  # Call lambda from index of object: %a[foo:], %a[foo:](), %a[foo:](1,2,...)
  rule(lambda_call: simple(:deref),list: simple(:list), arglist: simple(:arglist)) { mksexp(:lambdacall_index, sdereflist(sderef(deref), arglist)) }
  rule(lambda_call: simple(:deref),list: simple(:list), arglist: simple(:arglist), lambda_args: simple(:lambda_args)) { mklist(:lambdacall_args, mkargs([lambda_args]),sdereflist(sderef(deref), arglist)) } 
  rule(lambda_call: simple(:deref),list: simple(:list), arglist: simple(:arglist), lambda_args: sequence(:lambda_args)) { mklist(:lambdacall_args, mkargs(lambda_args),sdereflist(sderef(deref), arglist)) }


  # double quoted strings: string interpolations
  rule(strtok: simple(:strtok)) { mklist(:strtok, strtok) }
  rule(escape_seq: simple(:escape_seq)) { mklist(:escape_seq, escape_seq) }
  rule(string_expr: simple(:string_expr)) { mksexp(:str_expr, string_expr) }  
  # Bring it all together
  rule(string_interpolation: sequence(:string_interpolation)) { sstr_intp(string_interpolation) }

  rule(block_exec: simple(:block)) { block }
  rule(block_exec: sequence(:block)) { block }

  # Unary operators
  rule(op: simple(:op), negation: simple(:negation)) { mksexp(:unary_inversion, negation) } 
  rule(op: simple(:op), negative: simple(:negative)) { mksexp(:unary_negation, negative) } 

  # loop stuff
  rule(loop: simple(:loop)) { mksexp(:loop, loop) }
  # keywords: return, break and exit
  rule(return: simple(:return_expr)) { sreturn(return_expr) }  
  rule(exit: simple(:_exit)) { mklist(:_exit) }
  rule(break: simple(:_break)) { mklist(:_break) }
  rule(_icall: simple(:fn)) { mksexp(:_icall, fn) }
  # parameter : as in a parmlist to a function/lambda definition
  rule(parm: simple(:parm)) { sident(parm) }  
  # lambdas
  rule(parmlist: simple(:parmlist), _lambda: simple(:_lambda)) { slambda([parmlist],_lambda) }  
  rule(parmlist: sequence(:parmlist), _lambda: simple(:_lambda)) { slambda(parmlist, _lambda) } 

# Functions
  rule(fname: simple(:fname), block: simple(:fbody), parmlist: simple(:parmlist)) { mkarith('=', sident(fname), slambda([parmlist], fbody)) }  
  rule(fname: simple(:fname), block: simple(:fbody), parmlist: sequence(:parmlist)) { mkarith('=', sident(fname), slambda(parmlist, fbody)) }  


  rule(vector: subtree(:lvalue), eq: simple(:eq), rvalue: simple(:rvalue)) { mkarith(eq,lvalue, rvalue)  } 
  rule(vector_id: simple(:id), list: simple(:list), index: simple(:index))  { svectorid(sderef(id),index)  } 

  rule(deref: simple(:deref), list: simple(:list), symbol: simple(:symbol)) { sdereflist(sderef(deref), ssymbol(symbol)) }
  rule(deref: simple(:deref), list: simple(:list), arglist: simple(:arglist)) { sdereflist(sderef(deref), arglist) }  

  rule(deref: simple(:deref)) { sderef(deref) }  

  rule(block: simple(:block)) { sblock(sstatements([block])) }  
  rule(block: sequence(:block)) {sblock(sstatements(block)) }    

  # Lambda call - %l;%l();%l(1,2,3)
  rule(lambda_call: simple(:name)) { slambdacall(name, [])  } 
  rule(lambda_call: simple(:name), arglist: simple(:arglist)) { slambdacall(name, [arglist]) } 
  rule(lambda_call: simple(:name), arglist: sequence(:arglist)) { slambdacall(name, arglist) }  

  # Function calls
  rule(funcall: simple(:name), arglist: simple(:arg)) { sfuncall(name, [arg]) }  
  rule(funcall: simple(:name), arglist: sequence(:arglist)) { sfuncall(name, arglist) }  

  rule(lvalue: simple(:lvalue), eq: simple(:eq), rvalue: simple(:rvalue)) { mkarith(eq, sident(lvalue), rvalue) }  

  # Objects
  rule(object: simple(:object), arglist: simple(:arglist)) { sobject([arglist]) }   
  rule(object: simple(:object), arglist: sequence(:arglist)) {sobject(arglist) }   
  # vectors
  rule(list: simple(:list), arglist: simple(:arg)) { svector([arg]) }   
  rule(list: simple(:list), arglist: sequence(:args)) { svector(args) }  
  rule(symbol: simple(:symbol), expr: subtree(:expr)) { spair(ssymbol(symbol),expr) }     

  rule(symbol: simple(:symbol)) {ssymbol(symbol) }   

  rule(sq_string: simple(:sq_string)) { sstrlit(sq_string) }  
  rule(sq_string: sequence(:sq_string)) { sstrlit('') }   
  rule(boolean: simple(:boolean)) { sbool(boolean) }

  rule(int: simple(:int)) { sint(int) }
  rule(l: simple(:lvalue), o: simple(:op), r: simple(:rvalue)) { mkarith(op, lvalue, rvalue) }


  rule(empty: simple(:empty)) { signore }

  # Quotation - :< expr ... >: returns the AST un-emitted into bytecode
  rule(quote: simple(:quote)) {squote(quote) }

  # The root of the AST
  rule(program: simple(:program)) { sroot(sstatements([program])) }
  rule(program: sequence(:program)) { sroot(sstatements(program)) }
end

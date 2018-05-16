# command_transform.rb - Parse transform that returns S-expressions as PairType

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
class CommandTransform < Parslet::Transform
  # The root
  rule(program: simple(:program)) { sroot(sstatements([program])) }
  rule(program: sequence(:program)) { sroot(sstatements(program)) }
  # commands
  rule(command: simple(:name)) { slambdacall(name, []) }
  rule(command: simple(:name), arglist: simple(:args)) { slambdacall(name, [args]) } 
  rule(command: simple(:name), arglist: sequence(:args)) { slambdacall(name, args) } 

#  rule(arglist: simple(:arglist), arg: simple(:arg)) { mksexp(:arg, arg) }
  rule(arg: simple(:arg)) { mksexp(:arg, arg) }
  # pipes, logical and, or
  rule(l: simple(:lvalue), o: simple(:op), r: simple(:rvalue)) { mkarith(op, lvalue, rvalue) }

end

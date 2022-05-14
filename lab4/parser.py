import sys

# returns grammar rules and start symbol
def read_grammar():
    S = ''
    GrammarRules = {}
    flag = True
    n = len(sys.argv)

    # read grammar from text file and append in GrammarRules
    if n >= 2:
        with open(sys.argv[1], "r") as file:
            for line in file:
                line = line.strip()
                
                if line == '':
                    break
                s1 = [x.strip() for x in line.split('->')]
                if len(s1[0]) != 1 or not s1[0].isupper():
                    return None, None
                s2 = [x.strip().split()
                      for x in s1[1].split('|') if x.strip() != s1[0]]
                if flag:
                    flag = False
                    S = s1[0]
                
                GrammarRules.setdefault(s1[0], list()).extend(s2)

    return S, GrammarRules



#removes left recursion from grammar
def eliminateLR(Grammar):
    hasLeftRecursion = False

    for NonTerminal in list(Grammar):
        flag = False
        removable = False
        for rule in Grammar[NonTerminal]:
            if rule[0] == NonTerminal:
                flag = True
                hasLeftRecursion = True
                print("> Non-terminal", NonTerminal, "has Left recursion !")
                TempNT = NonTerminal+"'"
                Grammar.setdefault(TempNT, list()).append(['@'])
                break
        if flag:
            
            rules_list = Grammar[NonTerminal]
            for val in rules_list[:]:
                if val[0] == NonTerminal:
                    Grammar.setdefault(TempNT, list()).append(val[1:]+[TempNT])
                else:
                    removable = True
                    if val[0] == "@":
                        Grammar.setdefault(
                            NonTerminal, list()).append([TempNT])
                    else:
                        Grammar.setdefault(
                            NonTerminal, list()).append(val+[TempNT])
                Grammar[NonTerminal].remove(val)
            if removable is False:
                return None

    return hasLeftRecursion



#print the grammar
def print_grammar(dct):

    for key, value in dct.items():
        print(key+' -> '+' | '.join(''.join(map(str, sub)) for sub in value))
    print()



#computes first
def find_first(Grammar):
    FIRST = dict()
    for key in Grammar:
        FIRST[key] = first_set(key, Grammar)
    return FIRST


def first_set(s, Grammar):
    if not isinstance(s, list):
        s = [s]
    sym = s[0]
    ans = set()
    if sym.isupper():
        for rule in Grammar[sym]:
            if rule[0] == '@':
                if len(s) != 1:
                    ans = ans.union(first_set(s[1:], Grammar))
                else:
                    ans = ans.union('@')
            else:
                f = first_set(rule, Grammar)
                ans = ans.union(x for x in f)
    else:
        ans.add(sym)
    return ans



#computes follow
def find_follow(s, Grammar):
    FOLLOW = dict()
    for key in Grammar:
        FOLLOW[key] = set()

    FOLLOW[s] = FOLLOW[s].union('$')

    for key in Grammar:
        FOLLOW = follow_set(key, Grammar, FOLLOW)
    for key in Grammar:
        FOLLOW = follow_set(key, Grammar, FOLLOW)

    return FOLLOW


def follow_set(s, Grammar, ans):
    for key in Grammar:
        for value in Grammar[key]:
            try:
                f = value.index(s)
                if f == (len(value)-1):
                    if key != s:
                        if key in ans:
                            temp = ans[key]
                        else:
                            ans = follow_set(key, Grammar, ans)
                            temp = ans[key]
                        ans[s] = ans[s] | temp
                else:
                    first_of_next = first_set(value[f+1:], Grammar)
                    if '@' in first_of_next:
                        if key != s:
                            if key in ans:
                                temp = ans[key]
                            else:
                                ans = follow_set(key, Grammar, ans)
                                temp = ans[key]
                            ans[s] = ans[s] | temp
                            ans[s] = ans[s] | (first_of_next - {'@'})
                    else:
                        ans[s] = ans[s] | first_of_next
            except ValueError:
                pass

    return ans



#prints first and follow
def print_first_follow(First_set, Follow_set):
    line = '|'.join("{:^30}".format(x)
                    for x in ["NonTerminal", "FIRST", "FOLLOW"])
    print(line, '\n', '-'*len(line))
    for key in First_set:
        line = "{:^30}".format(key) + '|' + \
            "{:^30}".format(', '.join(First_set[key])) + '|' + \
            "{:^30}".format(', '.join(Follow_set[key]))
        print(line)




#generates parsing table
def LL1_parsing_table(follow, Grammar):
    table = dict()
    NT = set()
    T = set()

    for key in Grammar:
        NT.add(key)
        for rule in Grammar[key]:
            #computes first set of rule
            first = first_set(rule, Grammar)
            #iterate over first set elements except @
            for element in first - {'@'}:
                if (key, element) in table:
                    print("\nNot an LL1 Grammar as more than 1 rules for {} to {} are found"
                          .format(key, element))
                    return None
                else:
                    T.add(element)
                    table[(key, element)] = rule
            #if @ present in first set
            if '@' in first:
                for element in follow[key]:
                    T.add(element)
                    table[(key, element)] = rule

    print_table(NT, T, table)
    return table



#print parsing table
def print_table(NTset, Tset, Table):

    print("\nLL1 Parsing Table\n")
    Table1 = Table.copy()
    #fill the table with "" if no production rules are present from NT->T
    for x in NTset:
        for y in Tset:
            if (x, y) not in Table1:
                Table1[(x, y)] = ""

    #prints
    line = "{:^8}".format('') + '|' + \
        '|'.join("{:^8}".format(x) for x in Tset)
    print(line)
    print('-' * len(line))
    for x in NTset:
        line = "{:^8}".format(x) + '|' + \
            '|'.join('{:^8}'.format(''.join(Table1[(x, y)])) for y in Tset)
        print(line)
        print('-' * len(line))




#parse the expressions
def parse_expressions(start_symbol, parsingTable):
    n = len(sys.argv)

    if n >= 3:
        with open(sys.argv[2], "r") as file:
            for line in file:
                line = line.strip()
                if line == '':
                    break
                print("\n>> INPUT : {}".format(line))
                parser(line.split(), start_symbol, parsingTable)



def parser(user_input, start_symbol, parsingTable):
    flag = True
    stack = ["$", start_symbol]

    line = '|'.join("{:^30}".format(x)
                    for x in ["Stack", "Input"])
    print(line, '\n', '-'*len(line))
    try:
        while len(stack) > 0:
            print("{:^30}".format(' '.join(stack)), end='')

            top = stack.pop()

            print("|{:^30}".format(' '.join(user_input)), end='')

            if top == user_input[0]:
                user_input.pop(0)
                print("|{:^30}".format(""), end='\n')
            else:
                if (top, user_input[0]) not in parsingTable:
                    flag = False
                    break

                value = parsingTable[(top, user_input[0])]
                print("|{:^30}".format(""), end='\n')
        
                if value[0] != '@':
                    stack.extend(value[::-1])
    except IndexError:
        flag = False
        print()

    if flag:
        print(">>String accepted!!<<".center(93, '-'))
    else:
        print('\n', ">>String not accepted!!<<".center(93, '-'))



def main():
    #read the grammar and checking the grammar
    start, productions = read_grammar()
    if start is None or productions is None:
        print("Invalid Grammar !!")
        return

    print("\nEarlier Grammar :")
    print_grammar(productions)
    
    
    #eliminate left recursion if present and check if we are able to remove left recursion 
    isRecursion = eliminateLR(productions)
    if isRecursion is None:
        print("> Cannot Remove this Left Recursion !")
        return
    if isRecursion:
        print("\nModified Grammar are:")
        print_grammar(productions)

    #computes first and follow 
    first_dict = find_first(productions)
    follow_dict = find_follow(start, productions)
    print_first_follow(first_dict, follow_dict)

    #generate ll1 parsing table for valid ll1 grammar
    ll1Table = LL1_parsing_table(follow_dict, productions)
    if ll1Table is None:
        print("Give a valid LL1 grammar !")
        return

    #parse the expressions
    parse_expressions(start, ll1Table)


if __name__ == "__main__":
    main()

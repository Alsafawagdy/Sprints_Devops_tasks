
open_list = ["[", "{", "("]
close_list = ["]", "}", ")"]

def check_balance(string):
    container = []
    for c in string:
        if c in open_list:
            container.append(c)
        elif c in close_list:
            if len(container) == 0:
                return False
            if open_list[close_list.index(c)] == container[len(container)-1]:
                container.pop()
            else:
                return False
    if len(container) != 0:
        return False
    return True


string = input()
print(check_balance(string))

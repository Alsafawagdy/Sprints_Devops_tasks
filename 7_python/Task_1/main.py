# This func replace postion in the string with another replace
# Please try the three ways

'''
2st way
1) changed the string to list
2) change the char by using index
3) join the list with no spaces with it
'''
# def change_char(string, position, character):
#     # Use a breakpoint in the code line below to debug your script.
#     l = list(string)
#     l[position] = character
#     return ''.join(l)

'''
2nd way 
slice the string to the index and then put the char between them 
'''
# def change_char(string, position, character):
#     string = string[:position] + character + string[position + 1:]
#     return string

'''
3rd way 
1) create an empty string
2) make a for  enumerate on the string 
3) check if the index is the required index append the old char
4) else append the old char 
'''
def change_char(string, position, character):
    str=""
    for index, ch in enumerate(string):
        if index == position:
            str += character
        else:
            str += ch
    return str




if __name__ == '__main__':
    print(change_char("HelloWorld ",4,"0"))

'''
1)
Sample Input
"abracadabra",5,"k"
Sample Output
abrackdabra
2)
Sample Input
"i am love codeing ",7,"4"
Sample Output
i am lo4e codeing
3)
Sample Input
"HelloWorld ",4,"0"
Sample Output
Hell0World 
'''


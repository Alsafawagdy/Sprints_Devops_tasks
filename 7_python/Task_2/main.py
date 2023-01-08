
while True:

    year = (input("Please, Enter the year: (q to quit)  "))
    if year.lower() == 'q':
        break
    year = int(year)
    if ((year % 4 == 0) and (year % 100 != 0)) or ((year % 400 == 0) and (year % 100 == 0)):
        print("{0} is a leap year".format(year))
    else:
        print("{0} is not a leap year".format(year))
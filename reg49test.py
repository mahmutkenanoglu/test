# I want to print something like this:

print('hello\n"world"')
print("hello\"world")
def my_function():
    print('hello')
    print('world')

    # I want to get output like this:
    my_function()

def getAreaOfCircle(radius):
    return 3.14 * radius * radius

print(getAreaOfCircle(15))

def getCapitalCityFromCountry(country):
    if country == 'England':
        return 'London'
    elif country == 'France':
        return 'Paris'
    elif country == 'Germany':
        return 'Berlin'
    else:
        return 'Unknown'

print(getCapitalCityFromCountry('England'))

def findPersonFromJobId(jobId):
    if jobId == 1:
        return 'John'
    elif jobId == 2:
        return 'Jane'
    elif jobId == 3:
        return 'Jack'
    else:
        return 'Unknown'


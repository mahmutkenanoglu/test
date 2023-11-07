# Define a dictionary with country-capital pairs
capital_cities = {
    "USA": "Washington, D.C.",
    "Canada": "Ottawa",
    "France": "Paris",
    "Germany": "Berlin",
    "Spain": "Madrid",
    # Add more countries and their capital cities as needed
}

# Function to find capital city based on user input
def find_capital():
    country = input("Enter the name of a country: ")
    capital = capital_cities.get(country, "Capital not found")
    return capital

# Main part of the script

if __name__ == "__main__":
    capital = find_capital()
    print(f"The capital city is: {capital}")
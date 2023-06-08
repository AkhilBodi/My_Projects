import requests
import json
api_key = "your_api_key_here"                     # Our api key from OpenWeatherMap

api_url = "https://api.openweathermap.org/data/2.5/weather?"    # OpenWeatherMap URL

location = input('Enter the name of the location : ')                     # City name

url = api_url + "q="  + location + "&appid=" + api_key         # Complete URL

response = requests.get(url)                                    # Checking the status code

if response.status_code == 200:
    a = response.json()                                         # Storing data in json format
    b = a["main"]
    current_temperature = b["temp"]                             # Temperature
    current_pressure = b["pressure"]                            # Pressure
    current_humidity = b["humidity"]                            # Humidity
    weather_description = a["weather"]                          # Description of weather
    user_input = input("Enter the Unit of temperature : Celsius or Fahrenheit or Kelvin - ")           # Select the unit of temperature
    if user_input == "celsius":
        celsius = current_temperature - 273.15                  # Kelvin to celsius conversion
        print(f"Temperature in celsius units : {celsius}")

    elif user_input == "fahrenheit":
        fahrenheit = ((current_temperature - 273.15) * (9/5) + 32) # Kelvin to fahrenheit conversion
        print(f"Temperature in fahrenheit units : {fahrenheit}")

    elif user_input == "kelvin":
        print(f"Temperature in Kelvin units : {current_temperature}")  # Temperature in kelvin

    else:
        print("Enter correct Unit of Temperature")

    print(f"Pressure in hPa Unit : {current_pressure}")
    print(f"Humidity in percentage : {current_humidity}")
    print(f"Weather Report : {weather_description[0]['description']}")
else:
    print(f"{location} : Please do check the name of the location or Error in the HTTP request. Sorry!")

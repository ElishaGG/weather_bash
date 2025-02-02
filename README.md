# Weather Script

A simple bash script to check the weather by IP address. Uses `ipinfo.io` for location data and `openweathermap.org` for weather data.

## Usage
1. Make sure you have `jq` installed on your system for JSON parsing.
2. Fill in the API keys:
   - `TOKEN` for ipinfo.io (optional)
   - `APPID` for openweathermap.org (required)
3. Run the script to see current weather with an emoji representation.

## Code

```bash
#!/bin/bash

# Parse IP
IP=$(curl -s ifconfig.me)

# API_Keys
TOKEN= # ipinfo.io token
APPID= # openweathermap.org API ID

# Parse city and location by IP
JSON=$(curl -s "https://ipinfo.io/$IP?token=$TOKEN")

LON=$(echo "$JSON" | jq -r '.loc' | cut -d',' -f1)
LAT=$(echo "$JSON" | jq -r '.loc' | cut -d',' -f2)
CITY=$(echo "$JSON" | jq -r '.city')
COUNTRY=$(echo "$JSON" | jq -r '.country')

# [units=metric] Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit
WEATHER_DATA=$(curl -s "https://api.openweathermap.org/data/2.5/weather?lat=$LAT&lon=$LON&units=metric&appid=$APPID")

# JSON with emoji dictionary
EMOJI_JSON='{"emojis":{"01d":"☀️","01n":"🌙","02d":"⛅","02n":"☁️","03d":"🌥️","03n":"🌥️","04d":"☁️","04n":"☁️","09d":"🌧️","09n":"🌧️","10d":"🌦️","10n":"🌦️","11d":"⛈️","11n":"⛈️","13d":"❄️","13n":"❄️","50d":"🌫️","50n":"🌫️"}}'

# Parse temperature and icon
temp=$(echo "$WEATHER_DATA" | jq -r '.main.temp | round')
icon=$(echo "$WEATHER_DATA" | jq -r '.weather[0].icon')

# Emoji selection from dictionary
emoji=$(echo "$EMOJI_JSON" | jq -r ".emojis[\"$icon\"]" || echo "❓")

# Outputting a message
echo "Weather in $CITY: $emoji ${temp}°C"
```

## Example output

```
Weather in Moscow: ☀️ 4°C
```

## Reminder
Don't forget to register the rights: 
``` 
chmod +x weather.sh
```
Run:
``` 
./weather.sh
```

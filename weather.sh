#!/bin/bash

# Parse IP
IP=$(curl -s ifconfig.me)
# This string can be used for remote servers instead of the default string
# Just comment out the line above and uncomment the line below
# IP=$(echo $SSH_CLIENT | awk '{print $1}')

# API_Keys
APPID= # openweathermap.org API ID

# Parse city and location by IP
JSON=$(curl -s -k "http://ip-api.com/json/$IP")

LAT=$(echo "$JSON" | jq -r '.lat')
LON=$(echo "$JSON" | jq -r '.lon')
CITY=$(echo "$JSON" | jq -r '.city')
COUNTRY=$(echo "$JSON" | jq -r '.countryCode')

# [units=metric] Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit
WEATHER_DATA=$(curl -s "https://api.openweathermap.org/data/2.5/weather?lat=$LAT&lon=$LON&units=metric&appid=$APPID")

# JSON with emoji dictionary
EMOJI_JSON='{"emojis":{"01d":"☀️","01n":"🌙","02d":"⛅","02n":"☁️","03d":"🌥️","03n":"🌥️","04d":"☁️","04n":"☁️","09d":"🌧️","09n":"🌧️","10d":"🌦️","10n":"🌦️","11d":"⛈️","11n":"⛈️","13d":"❄️","13n":"❄️","50d":"🌫️","50n":"🌫️"}}'

# Parse temperature and icon
temp=$(echo "$WEATHER_DATA" | jq -r '.main.temp | tonumber | (. * 10 | round / 10)')
icon=$(echo "$WEATHER_DATA" | jq -r '.weather[0].icon')

# Emoji selection from dictionary
emoji=$(echo "$EMOJI_JSON" | jq -r ".emojis[\"$icon\"]" || echo "❓")

# Outputting a message
echo "Weather in $CITY: $emoji ${temp}°C"

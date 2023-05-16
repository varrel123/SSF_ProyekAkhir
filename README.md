# ❄❄ THERMOSMART ❄❄

## Introduction to the problem and the solution

---

This repository contains the source code for a Smart Thermostat created using assembly language and executed on the Arduino platform. The system uses a temperature sensor (DHT 11) and a water level sensor to control room temperature and activate or deactivate the air conditioner according to temperature and the height of the air conditioning discharge water (useful for rooms with temporary water drainage like a Mosque and Student Corner due to location constraints).

## Hardware design and implementation details

---

Components schematic :
![Schematic](https://cdn.discordapp.com/attachments/1050082669553266799/1106106409055166534/messageImage_1683364176773.jpg)

1. Arduino Uno or equivalent
2. Temperature sensor or DHT11
3. Water level sensor
4. Relay or transistor for heating or air conditioning control
5. Buzzer
6. Seven Segment Display
7. Jumper Cables
8. Wi-Fi module ESP8266 or ESP32 (optional)

## Software implementation details

---

The temperature sensor will periodically read the room temperature. If the temperature is above a certain threshold, the system will activate the relay to turn on the air conditioning. Similarly, if the temperature is below a certain threshold, the system will turn off the relay to turn off the air conditioning.

In addition, the water level sensor will periodically read the height of the air conditioning discharge water in the drainage tank. If the water level has reached the maximum level, the system will turn off the relay to turn off the air conditioning.

The system is also equipped with a temperature display that can display the temperature in two modes, Celsius and Fahrenheit. Additionally, the system has a buzzer to provide notification if abnormal conditions occur such as high temperature or if the water level has reached the maximum level.

## Test results and performance evaluation

---

### For Operations

1. Prepare all required components such as temperature sensor (DHT 11), water level sensor, Arduino Uno, relay, buzzer, 7-segment display, and jumper cables.
2. Connect the temperature sensor to pin A0 on the Arduino Uno using a jumper cable.
3. Connect the water level sensor to a digital pin on the Arduino Uno using a jumper cable.
4. Connect the relay to a digital pin on the Arduino Uno using a jumper cable.
5. Connect the buzzer to a digital pin on the Arduino Uno using a jumper cable.
6. Connect the 7-segment display to a digital pin on the Arduino Uno using a jumper cable.
7. Create a circuit according to the diagram in the README section.
8. Open the Arduino IDE software and create a program according to the code in the README section.
9. Upload the program to the Arduino Uno using a USB cable.
10. Install the temperature sensor and water level sensor in the room where the temperature is to be controlled.
11. Connect the air conditioner to the relay in the circuit.
12. Turn on the Arduino Uno and the system is ready to use.
13. If using the Wi-Fi module, connect the module to the serial pin on the Arduino and make sure the module is connected to the desired Wi-Fi network.

### For Usage

1. Download or clone this repository to your computer.
2. Open the program file in the Arduino IDE software or a text editor that supports assembly language.
3. Adjust the desired temperature threshold values in the program code.
4. Upload the program code to the Arduino board using a USB cable or a programmer module.
5. Wait for the Arduino board to finish processing the program and it is ready to use.

## Conclusion and future work
Thermosmart offers a comprehensive solution for air conditioner temperature and condensate water management. By evaluating and refining the system's logic, incorporating advanced algorithms, Thermosmart could achieves enhanced efficiency and effectiveness in maintaining optimal temperature control. This ensures a comfortable environment for occupants while maximizing energy efficiency. Additionally, the implementation of a mechanism to display the water level in percentage using assembly language enhances usability and facilitates timely management of condensate water. With Thermosmart, users can easily monitor the water level and take appropriate actions to prevent overflow or potential damage.
Moreover, the integration of an enhanced interrupt button empowers users to have more control over the air conditioner. This allows for immediate cooling when needed, regardless of the system's predefined thresholds. Adjusting the system settings to allow the AC to continue operating even when the storage container reaches maximum capacity ensures uninterrupted cooling and mitigates the risk of unnecessary interruptions or potential flooding. With Thermosmart, users can enjoy a comfortable and controlled environment, customized to their preferences, while ensuring efficient management of condensate water. In conclusion, Thermosmart provides a user-centric and intelligent solution that enhances comfort, energy efficiency, and safety within the environment.


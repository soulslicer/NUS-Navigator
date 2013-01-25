# NUS Navigator #

## Overview ##

[NUS Navigator](https://www.facebook.com/NusNavigator), is an application that aims to allow you to find any place that can be possibly listed in NUS, everything  down to the actual Room of a building itself, and tells you how to get there. It is currently the most comprehensive list of locations out there now, with the latest Bus-Stop, Carpark, and Building Information.

![ScreenShot](http://www.a-iats.com/App/logo.jpg)

I apologize for the slightly disorganized code quality since this was rushed in 1 month for a competition (which i got 4th :D) but suffered poor coding practices as a result :(

### Why NUS Navigator ###

NUS Navigator has a very intuitive interface. You can easily add multiple locations to the map, tap and hold to select a point, see the actual NUS Map within Google Maps itself (meaning more accuracy). You can even find the route between any two points, whether you are driving or taking the shuttle Bus.

### What can I get ###

You can find out F&B Opening hours and numbers, Bus Timings (WIP) and Routes, Carpark Details and Rates, Rooms in an Office/Building, IVLE Information that you have linked. You can also tap Select to see a whole List of Phone numbers listed by Departments and Descriptions.

Feature    | Description
---------- | ----------- 
1. | IVLE Integration and Linking    
2. | Search for Rooms, Locations, Busstops and Carparks
3. | NUS Maps overlay onto Maps
4. | Tap and hold on Map to select a location
5. | Detailed Information on Locations
6. | Find Driving Route from your location or between any two locations
7. | NUS Bus Router, tells you mutiple bus routes between any two locations
8. | Code written such that if you need to add new Carparks, Bus-stops or new Locations, NOTHING in the code needs to be changed.

### Routing Algorithm ###

The algorithm for calculating a password can be summarized as follows:

1. Get the nearest bus stops between two locations
2. Get both opposite and correct sided bus stops
3. Attempt to check for matching buses
4. If match exists, draw route lines
5. If common bus not found, backtrack to a bus-stop that has a common bus
6. Handle lack of loop for D1 and D2
7. With this algorithm, you do not need to worry about adding new bus-stops

![ScreenShot](http://www.a-iats.com/App/finalogo.png)


## Running ##

To run NUS Navigator, simply open NUSApp.project in XCode 4 and above.

IVLE Features will not be available because I cannot release my API Key for security purposes


## License ##

Copyright (C) 2012 by Raaj

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

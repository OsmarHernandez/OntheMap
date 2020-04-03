# OntheMap
### Udacity Project

## Project Overview
This application shows information posted by other students from the iOS Developer program from Udacity. 
It has a map that contain pins that show the location where other students have reported studying. 
By tapping on the pin users can see a URL for something the student finds interesting. 
The user will be able to add their own data by posting a string that can be reverse geocoded to a location, and a URL.

## Description
The On The Map app allows users to share their location and a URL with their fellow students. 
To visualize this data, On The Map uses a map with pins for location and pin annotations for student names and URLs, 
allowing students to place themselves “on the map,” so to speak. 

First, the user logs in to the app using their Udacity username and password. 
After login, the app downloads locations and links previously posted by other students. 
These links can point to any URL that a student chooses. 

After viewing the information posted by other students, a user can post their own location and link. 
The locations are specified with a string and forward geocoded. 
They can be as specific as a full street address or as generic as “Costa Rica” or “Seattle, WA.”

The app has three view controller scenes:
* Login View: Allows the user to log in using their Udacity credentials, or (as an extra credit exercise) using their Facebook account
* Map and Table Tabbed View: Allows users to see the locations of other students in two formats.  
* Information Posting View: Allows the users specify their own locations and links.

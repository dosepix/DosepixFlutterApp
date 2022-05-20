# Dosepix Flutter App
Author: Sebastian Schmidt  
E-Mail: schm.seb@gmail.com  

## Functions
- Program is divided into two separate main modes: Measure and Analyze
- Program can be executed with two different database approaches:
  - A local database stored on the device. In the future, all data will be stored encrypted while decryption is performed via user-specific tokens. 
  - A SQL database which is running on a remote server. For a implementation of the server, check out: 
- A separation between users and admins is made. Admins share the same privileges as users while they additionally can modify entries in the database

### Measure mode
- Select a user
- Connect to a dosemeter via bluetooth
- Start measurement and view data acquisition in a live view
- Add additional users and measurements and show statistics in an overview

### Analyze mode
- Similar to measurement mode
- View already taken data by loading them from the database

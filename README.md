# domus
Home Automation 

The main goal of this project is to create a system for the automation of my home and at the same time have some fun and pass the time on weekends.

I will in parallel integrate the devices on Home Assistant.

## Some libraries I will use: </h2>

https://github.com/jramsgz/pico-w-home-assistant - For Raspberry Pi Pico integration on Home Assistant

---

## Considerations on the relationships between the elements:

### Database Model

![Database Model](https://github.com/marcotcal/domus/blob/main/database_model.png?raw=true)

### Considerations

* Switches and Outlets are virtual devices. They are implemented in a daemon called virtdev.py.
* The virtdev.py script will connect to the database and mqtt server
* This swiches and outlets must be registered at Home Assistant and will be related to the relay blocks on the database and then this associations will be loaded and handled by assoc.py script
* The relay blocks will not be referenced by the home assistant
* The relay blocks will receive commands and statuses from the association daemon

 ### Association 

The association script and GUI will handle the correspondence between the switches and outlets and the relays

 #### Association GUI

 This is a PyGTK3 application. It can be installed in a linux PC.
 The application is used to manage the relations between switches and outlets. 

 #### Association Daemon

 This is a daemon running as a service and it will distribute the events between the devices and relays.
 

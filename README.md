# dbrady_trainline_api

Ruby Version: 3.0.0

Rails Version: 7.0.1

dbrady_trainline_api a Ruby on Rails application that interacts with the Trainline API to find and parse travel options, allowing users to search for and retrieve information about train journeys.

```
 here in this project, instead of calling real API, i used the POST https://www.thetrainline.com/api/journey-search/ response

 TrainlineService.read_journey_data_from_file
```

### Key files

    
    app
    ├── controller
    │      └── api                             
    │           └── v1                        
    │               └── travel_controller  
    │                   (responsible for handling travel-related API requests)
    │      
    ├── services                    
    │      ├── trainline_service
    │      │   (responsible for interacting with the Trainline API to fetch and process travel data)
    │      │
    │      └── trainline_data_parser 
    │          (responsible for parsing and structuring data obtained from the Trainline API into a more usable format)
    │
    │
    └── spec
          ├── contriller 
          │     └── api               
          │          └── v1                        
          │               └── travel_controller_spec
          │
          └── services
                 ├── trainline_service_spec
                 │
                 └── trainline_data_parser_spec


***
**Setup**

* first clone the directory 
                      ```
                      git clone git@github.com:sajjadmurtaza/dbrady_trainline_api.git
                      ```
 *  ```cd dbrady_trainline_api```

 *  ```bundle install ```

 *  ```rails s ```

 
 ***


### Specs

run ``` bundle exe rspec   ``` to run the tests

#### Note
I used the sample data ``` public/data.json``` to get the expected result as requirements were bit unclear to me.

![alt text](https://raw.githubusercontent.com/sajjadmurtaza/SchedulyBridge/master/app/assets/images/bot.png "bot Screenshot")


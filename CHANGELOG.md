07.14.2023
## Architecture overhaul and CHANGELOG.md implementation
- decided to be verbose and change up the architecture, ran into freeze and crash issues with the old design
- this design will implement SOLID and DRY principles as well as be practice in those areas, additionally to isolate
  the application, will run in a docker enviroment with a compose file with a Redis instance

#### Classes Implemented:
- Under the BackgroundJobber Module
  - Runner
    : responsible for creating the jobs, by calling the job class, which then add a serializes job to the cache
    : also calls the Worker class, which polls the cache for any job that has been pushed to the 'default' queue
  - Job
    : responsible for serializing and pushing the job to the cache
  - Worker
    : responsible for polling the cache for jobs, if yes, then picking them up and calling perform on them
  - Cache
    : interface for interacting with Redis

#### TODO:
- add a better README.md, 
- isolate background job processing 
- add threads for job processing
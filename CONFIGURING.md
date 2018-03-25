# Configuring ruborobo
ruborobo has 2 ways of reading configuration: JSON and YAML.  

## YAML
Copy `config.yml.example` to `config.yml`.  
Change the values in `owner` and `invokers` to:  
- A valid list of User IDs to be used as owners
- A valid list of invokers in the format `["type", "invoker"]`. Valid invoker types are `prefix`, `suffix`, `dual` and `regex`.

## JSON
### JSON configuration is deprecated! Please migrate to YAML as soon as possible!
Copy `config.json.example` to `config.json`.  
Change the values in `owner` and `invokers` to:
- A valid list of User IDs to be used as owners (in integer format)
- A valid list of invokers in the format `["type", "invoker"]`. Valid invoker types are `prefix`, `suffix`, `dual` and `regex`.
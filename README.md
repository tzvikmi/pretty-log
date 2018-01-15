# pretty-log
This add on for Ruby to log to console.

## info
to call to this function, you need this paramaters:
```
  PrettyLog.log(Hash,Array,String)
  Hash - Data to print (required)
  Array - Array of strings with the keys that wanted. (optional)
  String - Header to print (optional)
```
  Examples:
   
  ```ruby
    PrettyLog.log({key_1: "Test value", key_2: "Another test value"},nil,"This is test")
    PrettyLog.log(User.last(10).as_json,["id","email"],"Last 10 users")
  ```
    
## Usage
require this file inside your project with 
```ruby
require 'pretty_log.rb'
```
or put inside the _/lib_ folder.

put this line wherever you want to log:
```ruby
PrettyLog.log({key_1: "Test value", key_2: "Another test value"},nil,"This is test")
```
this exemple will print this:
```
| =============================== |
|          This is test           |
| =============================== |
| ------------------------------- |
| key_1      | key_2              |
| ------------------------------- |
| Test value | Another test value |
| ------------------------------- |
```

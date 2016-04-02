# File Sharer

Secure File Storage and Sharing

##Install
  $ bundle Install

##Execute
  $ ruby app.rb


###Doing Requests
Use curl in your terminal for the POST requests
```
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST \
-d "{\"owner\": \"user1\", \"file_name\": \"README.md\"}" \
http://localhost:4567/api/v1/files/
```

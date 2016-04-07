# File Sharer

Secure File Storage and Sharing

### Routes

- Use curl in your terminal for the POST requests

```
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST \
-d "{\"owner\": \"user1\", \"file_name\": \"README.md\"}" \
http://localhost:4567/api/v1/files/
```

## Install

Install this API required gems

```
$ bundle Install
```

## Execute

Run this API by using:

```
$ rackup
```

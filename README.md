# File Sharer

Secure File Storage and Sharing

### Routes

#### Application Routes

- GET `/`: root route

#### User Routes

- GET api/v1/users/: returns a json list of all users
- GET api/v1/users/[ID]: returns a json of all information about a user
- POST api/v1/users/: creates a new user

#### File Routes

- GET `api/v1/users/:username/files`: returns a json of all files for a user
- GET `api/v1/users/:username/files/:id.json`: returns a json of all information about a file
- GET `api/v1/users/:username/files/:id/document`: returns a base64 document with a file document
- POST `api/v1/users/:username/files`: creates a new file for a user


## Install

Install this API required gems

```
$ bundle Install
```

## Testing

Test this API by running:

```
$ bundle exec rake spec
```

## Execute

Run this API during deployment:

```
$ bundle exec rackup
```

or use autoloading during development:

```
$ bundle exec rerun rackup
```

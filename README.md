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

- GET `api/v1/files`: returns a json of all file IDs.
- GET `api/v1/files/:id.json`: returns a json of all information about a file with given ID.
- POST `api/v1/files`: create a new file information with given json information about it.


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

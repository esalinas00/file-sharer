# File Sharer

Secure File Storage and Sharing

### Routes

#### Application Routes

- GET `/`: root route


#### files Routes

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

# Endpoints

All endpoints with /api/v1 prefix.

## Register geolocation

Accepts ip or url as a parameter, fetches geolocation data from external API,
and saves it into the database.

```
Request: POST /geolocations
{
    "ip": "123.123.123.123"
}
Request: POST /geolocations
{
    "url": "https://google.com"
}
Response: 201 - Created
{
  geolocation: {
    "id": "1"
    "ip": "123.123.123.123",
    "url": null,
    ...
  }
}
Response: 422 - Unprocessable Entity
{
  error: "Invalid api function"
}
```
## Get geolocation

Returns geolocation by url or ip

```
Request: GET /geolocations?ip || url
Response: 200 - OK
{
    "ip": "123.123.123.123",
    "url": null,
    ...
}
Response: 422 - Unprocessable Entity

```
## Get geolocation

Returns geolocation by id

```
Request: GET /geolocations/{id}
Response: 200 - OK
{
    "ip": "123.123.123.123",
    "url": null,
    ...
}
Response: 404 - Not Found
```

## Delete geolocation

Delete geolocations by id

```
Request: DELETE /geolocations/{id}
Response: 204 - No Content
{
  geolocation: "Geolocation deleted"
}

Response: 422 - No Content
{
  error: "There have been problems with deleting record"
}
```

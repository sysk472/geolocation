# Endpoints

All endpoints with /api/v1 prefix.

## Register geolocation

Accepts ip or url as a parameter, fetches geolocation data from external API,
and saves it into the database.

```
Request: POST /geolocations/register
{
    "ip": "123.123.123.123"
}
Request: POST /geolocations/register
{
    "url": "https://google.com"
}
Response: 201 - Created
{
    "id": "b4a5ccc2-4dc0-4f17-bee2-9389d5fad538"
    "ip": "123.123.123.123",
    "url": null,
    ...
}
Response: 422 - Unprocessable Entity (or other code)
{
    "error": "GeolocationAlreadyExistsError",
    "description": "Geolocation with ip 123.123.123.123 already exists"
}
```

## Update/Refresh geolocation

Accepts ip or url as a parameter, fetches geolocation data from ... API,
and updates existing geolocation.

```
Request: POST /geolocations/{id}/refresh
{}
Response: 200 - OK
{
    "ip": "123.123.123.123",
    "url": null,
    ...
}
Response: 404 - Not Found
{
    "error": "GeolocationNotFoundError",
    "description": "Geolocation with ip 123.123.123.123 does not exist"
}
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
{
    "error": "GeolocationNotFoundError",
    "description": "Geolocation with ip 123.123.123.123 does not exist"
}
```

## Get geolocations

Returns geolocations by ip or url

```
Request: GET /geolocations?ip=...&url=...
Response: 200 - OK
{
    "items": [
        {
            "ip": "123.123.123.123",
            "url": null,
            ...
        }
    ],
    "total": 1,
    // Pagination?
}
```

## Delete geolocation

Delete geolocations by id

```
Request: DELETE /geolocations/{id}
Response: 204 - No Content
```

## Generic errors

```
Response: 503 - Service Unavailable
{
    "error": "DatabaseError",
    "description": "Database is down, try again later"
}
Response: 503 - Service Unavailable
{
    "error": "ApiError",
    "description": "Api is down, try again later"
}
```

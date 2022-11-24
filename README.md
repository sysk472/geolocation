# README

Run application

To access external API:
```
  1. Create .env file in project root directory
  2. Add your IP_STACK_ACCESS_KEY=VALUE
  3. Add
      DATABASE_HOST=database
      POSTGRES_USER=postgres
      POSTGRES_PASSWORD=mypassword
      POSTGRES_DB=myapp

```

```
  docker-compose up
```
There should be 2 services running - db postgres and api

You can access api via url:
```
  http://localhost:3010/api/v1
```
Lists of endpoints is defined in spec.md
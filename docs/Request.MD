# Docs

## Request Object
- The `Request` object represents the incoming HTTP request in a Luon route or middleware.
- It is created by parsing the raw HTTP request string and provides access to HTTP method, URL path, headers, query parameters, cookies, body, and route parameters.

```lua
    App:Get("/", function(req, res)
        --- `req` is Request object
    end)
```

## Properties

### `Request.Method`
- Type: `string`
- The HTTP method of the request (e.g. `"GET"`, `"POST"`).

### `Request.Path`
- Type: `string`
- The URL path without the query string (e.g. `"/search"`).

### `Request.Query`
- Type: `table<string, string>`
- Parsed query parameters from the URL.

### `Request.Headers`
- Type: `table<string, string>`
- Parsed headers from the request.

### `Request.Cookies`
- Type: `table<string, string>`
- Parsed cookies from the request.

### `Request.Body`
- Type: `string`
- The body of the request as a string.

### `Request:Json()`
- Type: `function`
- Returns the body of the request as a JSON object.
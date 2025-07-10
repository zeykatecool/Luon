# Docs

## Response Object
- The `Response` object represents the outgoing HTTP response in a Luon route or middleware.
- It is created by parsing the raw HTTP response string and provides access to HTTP status code, headers, and body.

```lua
    App:Get("/", function(req, res)
        --- `res` is Response object
    end)
```

## Properties

### `Response:Json(data)`
- Type: `function`
- Sends a JSON response with the specified data.

### `Response.headers`
- Type: `table`
- The headers of the response.

### `Response.cookies`
- Type: `table`
- The cookies of the response.

### `Response:SetHeader(key, value)`
- Type: `function`
- Sets a header with the specified key and value in the response.

### `Response:GetHeader(key)`
- Type: `function`
- Returns the value of the header with the specified key in the response.

### `Response:ClearHeader(key)`
- Type: `function`
- Clears the header with the specified key in the response.

### `Response:SetCookie(name, value, options)`
- Type: `function`
- Sets a cookie with the specified name, value, and options in the response.

### `Response:GetCookie(name)`
- Type: `function`
- Returns the value of the cookie with the specified name in the response.

### `Response:ClearCookie(name, options)`
- Type: `function`
- Clears the cookie with the specified name in the response.

### `Response:Redirect(location)`
- Type: `function`
- Redirects the client to the specified location in the response.

### `Response:send(body,contentType,statusCode,statusMessage)`
- Type: `function`
- Sends the specified body with the specified content type and status code in the response.

### `Response:sendFile(filePath,contentType,statusCode,statusMessage)`
- Type: `function`
- Sends the file at the specified path with the specified content type and status code in the response.
> If the file is not found, sends a 404 Not Found response with the specified status message.




# Docs

## Sending Web Requests with Luon Http
```lua
require("luon.http")
Http:get("https://example.com", function(client, response)
    print(response.body)
end)

Http:post("https://example.com", [[{"key": "value"}]], function(client, response)
    print(response.body)
end)

Http:put("https://example.com", [[{"key": "value"}]], function(client, response)
    print(response.body)
end)

Http:delete("https://example.com", function(client, response)
    print(response.body)
end)

Http:patch("https://example.com", [[{"key": "value"}]], function(client, response)
    print(response.body)
end)

--It's literally that simple.
```

## More Objects
### `Http:setHeaders(HeadersTable)`
- Sets the headers for the next request.

### `Http:clearHeader(key)`
- Clears the header with the specified key.

### `Http:setCookies(CookiesTable)`
- Sets the cookies for the next request.

### `Http:clearCookie(key)`
- Clears the cookie with the specified key.

### `Http.cookiesWillBeSent`
- Table of cookies to be sent with the next request.

### `Http.headersWillBeSent`
- Table of headers to be sent with the next request.
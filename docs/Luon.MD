# Docs

## Creating a Luon Server
- You can create a Luon server with `Luon.Server(HOST, PORT)`.
- It does not return the socket but we connect two tables together with metatable.
- It will run Luon function if it exists,if not it will search in the LuaRT Net Socket functions.
- Anyways,if you are going to work with LuaRT Net Socket functions,then you can use `App.Socket`,it will return the socket object of the Luon server working on.
- You can see all LuaRT Net Socket functions and properties [here](https://luart.org/doc/net/Socket.html).
```lua
require("luon.luon")
local App = Luon.Server("127.0.0.1", 5000) -- Returns Luon server control table that delegates socket calls via metatable

--[[
    local App = Luon.Server("smtp.gmail.com", 587, {tls = {cert = "PATH_FOR_PFX", password = "PASSWORD"}})
    -- You can use TLS by adding the `tls` table to the options.
    -- If tls table exists but it's empty,it will use the certificate from the server.
]]

local Socket = App.Socket -- Returns the socket object of the Luon server working on

print(App.blocking) -- Control Table does not have blocking property,so it connects to LuaRT Net Socket functions and gets blocking property.

App:Use(function(req, res, next) -- Adding middleware
    print("[REQ]", req.Method, req.Path)
    next()
end)

App:Get("/hello", function(req, res) -- Adding route
    res:send("Hello World!", "text/plain")
end)

App:Get("/hello/:name", function(req, res) -- Adding route with params
    res:send("Hello " .. req.Params.name .. "!", "text/plain")
end)

App:Get("/search", function(req, res) -- Adding route with query
    local term = req.Query["term"]
    local page = req.Query["page"]
    res:Json({ term = term, page = page })
end)

--[[
routes = {
            GET = {};
            POST = {};
            PUT = {};
            DELETE = {};
            PATCH = {};
        };
]] -- All the routes Luon supports,comes with LuaRT

App:Listen()
```

## More Objects
### `Luon:parseUrl(Url)`
- Parse the URL and return the scheme, hostname, path, and parameters.

### `Luon:getMime(FileName)`
- Get the MIME type of a file based on its extension.

### `Luon:getAdapters()`
- Get a list of available network adapters.

### `Luon:getLatestError()`
- Get the latest error message.

### `App.Socket`
- The socket object of the Luon server working on.
- It's a LuaRT Net Socket Object,you can use the functions and properties of [LuaRT Net Socket](https://luart.org/doc/net/Socket.html).
- If you are not going to work with specially Socket Object,you can just call it from `App` directly,it's connected to the socket object of the Luon server working on via metatable.

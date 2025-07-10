# Luon Network Package for LuaRT
- Luon is a network package for LuaRT.
- Making TCP and HTTP usage easier.

# Installation
- You can download the `luon` folder and require it from your main script.

# Usage Example
- Check [docs](https://github.com/zeykatecool/Luon/tree/main/docs/) to see how to use Luon.
- Usage example for adding and clearing cookies.
```lua
require("luon.luon")
local App = Luon.Server("127.0.0.1", 5000)

App:Use(function(req, res, next)
    print("[REQ]", req.Method, req.Path)
    next()
end)

App:Get("/set", function(req, res)
    res:SetCookie("foo", "bar", { path = "/" })
    res:send("Cookie set", "text/plain")
end)

App:Get("/clear", function(req, res)
    res:ClearCookie("foo")
    res:send("Cookie cleared", "text/plain")
end)


App:Listen()
```

## License
- [MIT](https://github.com/zeykatecool/Luon/blob/main/LICENSE)
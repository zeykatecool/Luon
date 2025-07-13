_G.Luon = {
    version = "0.0.1";
    author = "zeykatecool";
    license = "MIT";
}

local Net = require "net"
local Response = require("luon.response")
local Request = require("luon.request")

function Luon:getLatestError()
    return Net.error
end

function Luon:parseUrl(Url)
    local scheme, hostname, path, parameters = Net.urlparse(Url)
    return scheme, hostname, path, parameters
end

function Luon:getMime(FileName)
    return Net.getmime(FileName)
end

function Luon:getAdapters()
    local Adapters = {}
    for name,ip in Net.adapters do
        Adapters[name] = ip
    end
    return Adapters
end

local function splitPath(path)
    local parts = {}
    for part in string.gmatch(path, "[^/]+") do
        table.insert(parts, part)
    end
    return parts
end

local function findMatchingRoute(routes, method, reqPath)
    local routeTable = routes[method]
    if not routeTable then return nil end

    for definedPath, handler in pairs(routeTable) do
        local definedParts = splitPath(definedPath)
        local reqParts = splitPath(reqPath)

        if #definedParts == #reqParts then
            local params = {}
            local matched = true
            for i = 1, #definedParts do
                if definedParts[i]:sub(1,1) == ":" then
                    local paramName = definedParts[i]:sub(2)
                    params[paramName] = reqParts[i]
                elseif definedParts[i] ~= reqParts[i] then
                    matched = false
                    break
                end
            end
            if matched then
                return handler, params
            end
        end
    end
    return nil
end


local function receiveFullRequest(client)
    local data = ""
    local headerEnd = nil
    local contentLength = 0

    while not headerEnd do
        local available = client:peek()
        if available == 0 then
            sleep(100)
        end

        local chunk = client:recv()
        if not chunk then break end
        data = data .. chunk
        headerEnd = data:find("\r\n\r\n")
    end

    if not headerEnd then
        return data
    end

    local headerPart = data:sub(1, headerEnd + 3)
    local bodyPart = data:sub(headerEnd + 4)

    contentLength = tonumber(string.match(headerPart, "Content%-Length:%s*(%d+)")) or 0

    while #bodyPart < contentLength do
        local chunk = client:recv()
        if not chunk then break end
        bodyPart = bodyPart .. chunk
    end

    return headerPart .. bodyPart
end

local function handleRequestWithMiddleware(server, req, res, handler)
    local i = 0
    local function next()
        i = i + 1
        local mw = server.middlewares[i]
        if mw then
            mw(req, res, next)
        else
            handler(req, res)
        end
    end
    next()
end

function Luon.Server(Host, Port,Options)
    if not Net.isalive then
        error("Could not connect to network.")
    end
    assert(Host, "No host provided.")
    assert(Port, "No port provided.")
    Options = Options or {}
    local serverSocket = Net.Socket(Host, Port)
    local server = {
        routes = {
            GET = {};
            POST = {};
            PUT = {};
            DELETE = {};
            PATCH = {};
        };
        Run = true;
        middlewares = {};
        tls = Options.tls;
        isSecure = false;
    }

    function server:Use(middlewareFn)
        table.insert(self.middlewares, middlewareFn)
    end

    function server:Get(path, handler)
        assert(path, "No path provided.")
        assert(handler, "No handler provided.")
        self.routes.GET[path] = handler
    end

    function server:Post(path, handler)
        assert(path, "No path provided.")
        assert(handler, "No handler provided.")
        self.routes.POST[path] = handler
    end

    function server:Put(path, handler)
        assert(path, "No path provided.")
        assert(handler, "No handler provided.")
        self.routes.PUT[path] = handler
    end

    function server:Delete(path, handler)
        assert(path, "No path provided.")
        assert(handler, "No handler provided.")
        self.routes.DELETE[path] = handler
    end

    function server:Patch(path, handler)
        assert(path, "No path provided.")
        assert(handler, "No handler provided.")
        self.routes.PATCH[path] = handler
    end

    function server:Kill()
        self.isRunning = false
    end

   function server:Listen()
    serverSocket:bind()
    local protocol = server.tls and "https" or "http"
    print("Listening on " .. protocol .. "://" .. Host .. ":" .. Port)

    while server.Run do
        local client = serverSocket:accept()
        if client then
            if server.tls then
                local cert = server.tls.cert
                local password = server.tls.password
                if not cert then
                    cert = nil
                    password = nil
                end
                local ok = client:starttls(cert, password)
                server.isSecure = true
                if not ok then
                    print("TLS Handshake Failed.")
                    print("NetError: "..Net.error)
                    client:send("HTTP/1.1 495 TLS Handshake Failed\r\n\r\nTLS Error")
                    --client:close()
                    server.isSecure = false
                    goto continue
                end
            end

            local rawRequest = receiveFullRequest(client)
            if rawRequest then
                local req = Request.new(rawRequest)
                local handler, urlParams = findMatchingRoute(self.routes, req.Method, req.Path)

                if handler then
                    req.Params = urlParams or {}
                    local res = Response.new(client)
                    handleRequestWithMiddleware(self, req, res, handler)
                else
                    client:send("HTTP/1.1 404 Not Found\r\n\r\n404 Not Found")
                end
            end
            client:close()
        end
        ::continue::
    end
end

    setmetatable(server, {
        __index = serverSocket
    })
    server.Socket = serverSocket
    return server
end

return Luon

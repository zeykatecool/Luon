local Response = {}
Response.__index = Response
local JSON = require("json")
local Cookie = require("luon.cookie")

function Response.new(client)
    local self = setmetatable({}, Response)
    self.client = client
    self.headers = {}
    self.cookies = {}
    return self
end

function Response:Json(data)
    local jsonStr = JSON.encode(data)
    self:SetHeader("Content-Type", "application/json")
    self:send(jsonStr, "application/json")
end

function Response:SetHeader(key, value)
    self.headers[key] = value
end

function Response:GetHeader(key)
    return self.headers[key]
end

function Response:SetCookie(name, value, options)
    self.cookies[name] = {value = value, options = options}
end

function Response:GetCookie(name)
    return self.cookies[name]
end

function Response:ClearCookie(name, options)
    options = options or {}
    options.expires = 0
    options.path = options.path or "/"
    self.cookies[name] = { value = "", options = options }
end

function Response:Redirect(url)
    self:SetHeader("Location", url)
    self:send(nil, nil, 302, "Found")
end

function Response:ClearHeader(key)
    self.headers[key] = nil
end



function Response:send(body, contentType, statusCode, statusMessage)
    statusCode = statusCode or 200
    statusMessage = statusMessage or "OK"
    contentType = contentType or "text/html"
    self:SetHeader("Content-Type", contentType)

    local headersString = ""
    for k, v in pairs(self.headers) do
        headersString = headersString .. k .. ": " .. v .. "\r\n"
    end

    for name, info in pairs(self.cookies) do
        local cookieStr = Cookie.build({ [name] = info.value }, info.options)
        headersString = headersString .. "Set-Cookie: " .. cookieStr .. "\r\n"
    end

    local resp = string.format("HTTP/1.1 %d %s\r\n%s\r\n%s",
        statusCode, statusMessage, headersString, body or "")

    self.client:send(resp)
end


function Response:sendFile(path, contentType, statusCode, statusMessage)
    local file = io.open(path, "rb")
    if not file then
        self:SetHeader("Content-Type", "text/plain")
        self:send("404 Not Found", "text/plain", statusCode or 404, statusMessage or "Not Found")
        return
    end

    local body = file:read("*a")
    file:close()

    self:send(body, contentType, statusCode or 200, statusMessage or "OK")
end

return Response

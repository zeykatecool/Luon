local Request = {}
Request.__index = Request
local JSON = require("json")
local Cookie = require("luon.cookie")

local function parseQueryString(query)
    local t = {}
    for key, val in string.gmatch(query or "", "([^&=?]+)=([^&=?]+)") do
        t[key] = val
    end
    return t
end

local function parseHeaders(headerPart)
    local headers = {}
    for key, value in string.gmatch(headerPart or "", "([%w%-]+):%s*([^\r\n]+)") do
        headers[key:lower()] = value
    end
    return headers
end

local function parseCookies(cookieHeader)
    if not cookieHeader then
        return {}
    end
    return Cookie.parse(cookieHeader)
end

function Request.new(raw)
    local self = setmetatable({}, Request)

    self.Method = string.match(raw, "^(%u+)")
    local fullPath = string.match(raw, "%u+%s+([^%s]+)")

    local path, query = fullPath:match("([^%?]+)%??(.*)")
    self.Path = path
    self.Query = parseQueryString(query)

    local headerPart = raw:match("^[^\r\n]+\r\n(.-)\r\n\r\n")
    self.Headers = parseHeaders(headerPart)

    self.Cookies = parseCookies(self.Headers["cookie"])

    local _, _, body = string.find(raw, "\r\n\r\n(.*)")
    self.Body = body or ""

    self.Params = {}

    return self
end

function Request:Json()
    if not self.Body or self.Body == "" then
        return nil
    end

    local ok, decoded = pcall(JSON.decode, self.Body)
    if ok then
        return decoded
    else
        return nil, "Invalid JSON"
    end
end

return Request
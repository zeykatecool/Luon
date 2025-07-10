_G.Http = {
    cookiesWillBeSent = {};
    headersWillBeSent = {};
}
local Net = require "net"

function Http:setCookies(CookiesTable)
    Http.cookiesWillBeSent = CookiesTable
end

function Http:setHeaders(HeadersTable)
    Http.headersWillBeSent = HeadersTable
end

function Http:clearCookie(name)
    for key, _ in pairs(Http.cookiesWillBeSent) do
        if key == name then
            Http.cookiesWillBeSent[key] = nil
        end
    end
end

function Http:clearHeader(name)
    for key, _ in pairs(Http.headersWillBeSent) do
        if key == name then
            Http.headersWillBeSent[key] = nil
        end
    end
end


function Http:get(url, handler)
    local scheme, hostname, path = Net.urlparse(url)
    if not path or path == "" then
        path = "/"
    end

    local baseUrl = scheme .. "://" .. hostname
    local client = Net.Http(baseUrl)
    client.cookies = Http.cookiesWillBeSent
    for key, value in pairs(Http.headersWillBeSent) do
        client.headers[key] = value
    end
    local Task = client:get(path)

    function Task:after(response)
        handler(client, response)
        return 0
    end

    Task:wait()
end

function Http:post(url, data, handler)
    local scheme, hostname, path = Net.urlparse(url)
    if not path or path == "" then
        path = "/"
    end

    local baseUrl = scheme .. "://" .. hostname
    local client = Net.Http(baseUrl)
    client.cookies = Http.cookiesWillBeSent
    for key, value in pairs(Http.headersWillBeSent) do
        client.headers[key] = value
    end
    local Task = client:post(path, data)

    function Task:after(response)
        handler(client, response)
        return 0
    end

    Task:wait()
end

function Http:put(url, data, handler)
    local scheme, hostname, path = Net.urlparse(url)
    if not path or path == "" then
        path = "/"
    end

    local baseUrl = scheme .. "://" .. hostname
    local client = Net.Http(baseUrl)
    client.cookies = Http.cookiesWillBeSent
    for key, value in pairs(Http.headersWillBeSent) do
        client.headers[key] = value
    end
    local Task = client:put(path, data)

    function Task:after(response)
        handler(client, response)
        return 0
    end

    Task:wait()
end

function Http:delete(url, handler)
    local scheme, hostname, path = Net.urlparse(url)
    if not path or path == "" then
        path = "/"
    end

    local baseUrl = scheme .. "://" .. hostname
    local client = Net.Http(baseUrl)
    client.cookies = Http.cookiesWillBeSent
    for key, value in pairs(Http.headersWillBeSent) do
        client.headers[key] = value
    end
    local Task = client:delete(path)

    function Task:after(response)
        handler(client, response)
        return 0
    end

    Task:wait()
end

function Http:patch(url, data, handler)
    local scheme, hostname, path = Net.urlparse(url)
    if not path or path == "" then
        path = "/"
    end

    local baseUrl = scheme .. "://" .. hostname
    local client = Net.Http(baseUrl)
    client.cookies = Http.cookiesWillBeSent
    for key, value in pairs(Http.headersWillBeSent) do
        client.headers[key] = value
    end
    local Task = client:patch(path, data)

    function Task:after(response)
        handler(client, response)
        return 0
    end

    Task:wait()
end


return Http
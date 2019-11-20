urimap = {
    "/around-api/common/upload/pic",
}

methodmap = {
    "POST", 
}

params = {
      --[[{"spu_id":2,"type":1}]]
      --[[{"id":2,"sku_id":7}]] -- 双中括号里面不转译
      "&type=1"
      --"",
      --"",
}

math.randomseed(os.time())

function read_txt_file(path)
    local file, errorMessage = io.open(path, "r")
    if not file then
        error("Could not read the file:" .. errorMessage .. "\n")
    end

    local content = file:read "*all"
    file:close()
    return content
end

local Boundary = "----WebKitFormBoundaryePkpFF7tjBAqx29L"
local BodyBoundary = "--" .. Boundary
local LastBoundary = "--" .. Boundary .. "--"

local CRLF = "\r\n"

local FileBody = read_txt_file("/Users/root1/Documents/pic/_thumb_P_15537977900253.jpg")

local Filename = "wrk-lua.jpg"

local ContentDisposition = "Content-Disposition: form-data; name=\"file\"; filename=\"" .. Filename .. "\""


init = function()
    local r = {}
    local path = ""   -- 局部变量（不加local 是全局变量）
    local method = "get" -- 默认get

    -- header 头
    wrk.headers["Hash"]= "85280aa135bbd0108dd6aa424565a"
    wrk.headers["Token"]= "" 
    wrk.headers["user_id"]= "2" 
    wrk.headers["longitude"]= "121.610704"
    wrk.headers["latitude"]= "31.214563"

    for i, v in ipairs(urimap) do -- 键从1 开始 非 0
        path = v    -- 路径
        method = methodmap[i]  -- method

        if method == "POST" then
            wrk.headers["Content-Type"] = "multipart/form-data; boundary=" .. Boundary 
            --wrk.body = params[i]
            wrk.body = BodyBoundary .. CRLF .. ContentDisposition .. CRLF .. CRLF .. FileBody .. CRLF .. LastBoundary .. CRLF
			--wrk.body = "type=1"
        end

        if method == "GET" and  params[i] ~= "" then
            path = v .. "?" ..params[i]
        end

        io.write(method, "---", params[i], "----", path, "\n") -- 打印请求方式（1个线程会打印一次），参数，路径（不含域名）
        r[i] =  wrk.format(method, path)    
    end 

    req = table.concat(r)
end

request = function()
      return req
end
    
response = function(status, headers, body)  
    if status ~= 200 then
        print("status:", status)
        print("error:", body)
        wrk.thread:stop()
    else 
       -- print("body:", body)   
    end
end  

done = function(summary, latency, requests)

    local durations=summary.duration / 1000000    -- 执行时间，单位是秒
    local errors=summary.errors.status            -- http status不是200，300开头的
    local requests=summary.requests               -- 总的请求数
    local valid=requests-errors                   -- 有效请求数=总请求数-error请求数
  
    io.write("Durations:       "..string.format("%.2f",durations).."s".."\n")
    io.write("Requests:        "..summary.requests.."\n")
    io.write("Avg RT:          "..string.format("%.2f",latency.mean / 1000).."ms".."\n")
    io.write("Max RT:          "..(latency.max / 1000).."ms".."\n")
    io.write("Min RT:          "..(latency.min / 1000).."ms".."\n")
    io.write("Error requests:  "..errors.."\n")
    io.write("Valid requests:  "..valid.."\n")
    io.write("QPS:             "..string.format("%.2f",valid / durations).."\n")
    io.write("--------------------------\n")
  
end

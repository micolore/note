urimap = {
    "/around-api/content/index",
}

methodmap = {
    "POST", 
}

params = {
      [[{"id":2}]], 
      [[{"spu_id":2,"type":1}]],
      [[{"id":2,"sku_id":7}]], -- 双中括号里面不转译
      "page=1&size=100",  
      "",
      "",
}

math.randomseed(os.time())

init = function()
    local r = {}
    local path = ""   -- 局部变量（不加local 是全局变量）
    local method = "get" -- 默认get

    -- header 头
    wrk.headers["Hash"]= "85280aa135bbd0108dd6aa424565a"
    wrk.headers["Token"]= "" 
    wrk.headers["longitude"]= "121.610704"
    wrk.headers["latitude"]= "31.214563"
    for i, v in ipairs(urimap) do -- 键从1 开始 非 0
        path = v    -- 路径
        method = methodmap[i]  -- method

        if method == "POST" then
            wrk.headers["content-type"]= "application/json" --POST 参数json格式
            wrk.body = params[i]
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

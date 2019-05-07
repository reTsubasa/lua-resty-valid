--- a library for openresty data format validation
-- support validation type:
-- single data validation
    -- string length
    -- number range
    -- boolean
    -- ipv4
    -- uuid format
    -- choice a table contain the selects
-- muti-validation

local s_len = string.len
local s_fmt = string.format
local s_find = string.find

local _M = {_VERSION = "0.0.1"}

-- valid input arg is a string
-- @string arg the arg will be validate
-- @table opts options for validate the string lengths.
-- ex:
-- {len = 8} if the string length == 8
-- {min = 1,max=10} if the string 1<= length <= 10 
function _M.string(arg,opts)
    opts = opts or {}
    -- input opts valid
    if type(opts) ~= "table" then
        return nil,"opts type must be a table"
    end
    if opts.len then
        if type(opts.len) ~= "number" then
            return nil,"len type must be a number"
        end
    end

    if opts.min and opts.max then
        if type(opts.min) ~= "number" or type(opts.max) ~= "number" then
            return nil,"min or max type must be a number"
        end
        if opts.max < opts.min then
          return nil,"min must lt than max"
        end
    elseif opts.min or opts.max then
        return nil,"min and max must be given together"
    end

    -- main valid
    if type(arg) ~= "string" then
        return nil,"not a string"
    else
        
        if opts.len then
            if s_len(arg) == opts.len then
                return true
            else
                return nil,s_fmt("arg length must at %s",opts.len)
            end
        end

        if opts.min and opts.max then
            if opts.min <= s_len(arg) and s_len(arg) <= opts.max then
                return true
            else
                return nil,s_fmt("arg length must at %s-%s",opts.min,opts.max)
            end
        end
      
    --without length valid
        return true
    end
    
end

-- valid the type of input arg as the "number"
-- return true will type of arg is the number,else return nil
-- optional:opts,a table for validate the number range
-- ex:opts = {min=0,max = 100} as the arg should be at 0-100
function _M.number(arg,opts)
    opts = opts or {}
    -- input opts valid
    if type(opts) ~= "table" then
        return nil,"opts type must be a table"
    end

    if opts.min and opts.max then
        if type(opts.min) ~= "number" or type(opts.max) ~= "number" then
            return nil,"min or max type must be a number"
        end
        if opts.max < opts.min then
          return nil,"min must lt than max"
        end
    elseif opts.min or opts.max then
        return nil,"min and max must be given together"
    end

    -- main valid
    if type(arg) ~= "number" then
        return nil
    elseif opts.min and opts.max then
        if opts.min <= arg and arg <= opts.max then
            return true
        else
            return nil,s_fmt("arg must at %s-%s",opts.min,opts.max)
        end
    else
        return true
    end
end


-- valid the input arg as the ipv4 format
-- return true if a ipv4 format ,else return nil
-- optional: opts,a table for valid extra limits
-- ex:
-- {regex = "pcre"/"orig"} 
-- use openresty's PCRE regex(default) or lua origial regex system
-- when use PCRE system the match operation options will set to "jo"
-- see more at https://github.com/openresty/lua-nginx-module#ngxrematch

-- {priv = true/false}
-- recognize the ip is in the Private IP Range (Class A,B,C)
-- default:false
-- only worked use "PCRE" regex system
function _M.ipv4(arg,opts)
    opts = opts or {}
    -- input opts valid
    if type(opts) ~= "table" then
        return nil,"opts type must be a table"
    end

    if opts.regex then
        if opts.regex ~= "pcre" or opts.regex ~= "orig" then
            return nil,"regex system choice miss"
        end
    end

    if opts.private and type(opts.private) ~= "boolean" and opts.regex ~= "pcre" then
        return nil,"IP private must a boolean arg and regex system must be the PCRE"
    end

    -- main valid
    if opts.regex and opts.regex == "orig" then
        -- orignal lua regex
        local reg = "^%d%d%d%.%d%d%d%.%d%d%d%.%d%d%d$"
        if s_find(arg,reg) then
            return true
        else
            return nil
        end
    else
        -- PCRE regex
        local match_options = "jo"
        local find = ngx.re.find
        local ipv4_reg = [[^((25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(25[0-5]|2[0-4]\d|[01]?\d\d?)$]]
        local ipv4_private_reg = [[^1(((0|27)(.(([1-9]?|1[0-9])[0-9]|2([0-4][0-9]|5[0-5])))|(72.(1[6-9]|2[0-9]|3[01])|92.168))(.(([1-9]?|1[0-9])[0-9]|2([0-4][0-9]|5[0-5]))){2})$]]

        if opts.priv then
            -- ip private
            if find(arg,ipv4_private_reg,match_options) then
                return true
            else
                return nil
            end
        else
            
            if find(arg,ipv4_reg,match_options) then
                return true
            else
                return nil
            end
        end

    end
end


return _M
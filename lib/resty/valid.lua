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
    
    
--    return true
end


return _M
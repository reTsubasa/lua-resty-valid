local va = require("resty.valid")
local fmt = string.format
-- 测试pcre系统时，应该通过openresty环境调用，原生的lua没有pcre支持

-- 用例
local t = {
   {2,{1,2,3},true},
   {"apple",{"banana","perl","apple"},true},
   {"apple",{"banana","perl","apple1"},false},
}
-- 实际测试轮数
local test_round = 0
--测试通过轮数
local test_pass = 0
--用例数
local test_ex = #t
--失败信息
local fails = {}

for i, v in ipairs(t) do
    local s,err,re
    s,err = va.choice(v[1],v[2])
    if not s then
      if not v[3] then
        re = true
        -- print(re,v[1],err)
      else
        re = false
        table.insert(fails,{i,v[1],err})
        -- print(re,v[1],err)
      end
      
    else
        if v[3] then
            re = true
            -- print(re,v[1],err)
        else
            re = false
            table.insert(fails,{i,v[1],err})
        end
    end
    test_round =  test_round +1
    if re then
    test_pass = test_pass +1
    end
end
  
-- 总结
print(fmt("Total tested: %s/%s,Passed：%s",test_round,test_ex,test_pass))
if test_pass == test_round then
    print("All test passed")
else
    print("Failed detail:")
    for index, value in ipairs(fails) do
        print(value[1],value[2],value[3])
    end
end
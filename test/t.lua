local va = require("lua-resty-valid.lib.resty.valid")
local fmt = string.format

local t = {
  {"a", nil ,true},
  {"b",{len=4},false},
  {"c",{len = 1},true},
  {"asdf1",{min = 1,max =5},true},
  {"asdf2",{min = 5,max = 10},true},
  {"asdf3",{min = 1,max = 3},false},
  {"asdf4",{min = 1},false},
  {"asdf5",{min = 7,max = 5},false},
}
--for k,v in pairs (t)do
--  local s,err
--  s,err = va.string(k,v)
--  print(k,s,err)
--end
-- 实际测试轮数
local test_round = 0
--测试通过轮数
local test_pass = 0
--用例数
local test_ex = #t

for i,v in ipairs(t) do
  local s,err,re
--  if v[1] == "a" then print(v[2]) end
  s,err = va.string(v[1],v[2])
  if not s then
    if not v[3] then
      re = true
      print(re,v[1],err)
    else
      re = false
      print(re,v[1],err)
    end
    
  else
    if v[3] then
      re = true
      print(re,v[1],err)
    else
      re = false
      print(re,v[1],err)
    end
  end
  test_round =  test_round +1
  if re then
    test_pass = test_pass +1
  end
end
print(fmt("Total tested: %s/%s,Passed：%s",test_round,test_ex,test_pass))
if test_pass == test_round then
  print("All test passed")
end
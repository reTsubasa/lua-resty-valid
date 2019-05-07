local va =  require("resty.valid")
local fmt = string.format

-- 用例
local t = {
    {1,nil,true},
    {"a",nil,false},
    {123,{min = 3,max = 100},false},
    {321,{min =500 ,max =570 },false},
    {2,{min =100 ,max =2 },false},
    {{1,2,3},nil,false},
    {true,{min = 1,max = 3},false},
    {123,{min =1 ,max = 222},true},
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
    s,err = va.number(v[1],v[2])
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

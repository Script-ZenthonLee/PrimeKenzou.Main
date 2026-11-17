                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
          -- Keyauth V3, made by alexyearsforu and winzetim
          -- this fetchs keyforge protected scripts and checks your enviroment 
          -- keyforge.win         
          
          
          -- TIM SUCKS!!!!!!!!!!
--[=[
                       %#########****##                **+            *                             
                        @++++=======---              +++++*************#########*                   
                          %++=========-            ++++++++************########                     
                            +++========          :++++++++*************#######                      
                              -+++=====        -+++++++++=                                          
                               +++++++=      @++++++++++                                            
                               ++++++++    @++++++++++                                              
                               *+++++++%  =*+++++++++    :*************####@                        
                               ***+++++%+*******++=    ++**************** @                         
                               *****************+    @*****************@                            
                               ****************@    @*******+=++++++++                              
                               **************#@     @******#                                        
                               ###*********:-=      @******#                                        
                               #######***+:---=@    @#####*#                                        
                               ########*------===@   +######                                        
                              %########@@=========:   @#####                                        
                               ########@   =======++-    ###                                        
                               ########@     ====+++++%  @##                                        
                               ########@      -+++++++++@                                           
                               #%%%####@       @-+++++++++                                          
                                 %%%%%#@        -++++++****-                                        
                                   %%%%@      =++++++-=******                                       
                                     %%@     %****       =***+                                      
                                      %@     ****         +***-                                     
                                             +***          ***:                                     
                                             -***         +**+                                      
                                             @+**#*      *****                                      
                                              @-***##******+                                        
                                                @*#####**=                                          
                                                  *#@@#**@                                          
                                                  *#@@##*@                                          
                                                  ##@@##*@                                          
                                                  ##@@##*@                                          
                                                  ##@@###==-*                                       
                                                  #%@@######*                                       
                                                  #%@@%##                                           
                                                  %%@@%%%                                           
                                                 @%%@@%%%#*+*                                       
                                                 @%%@@%%%%%%#                                       
                                                  %%@@%%%                                           
                                                   %@@%%%                                           
                                                     @                                              
                                                                                                    
                                                                                                    
                                                                                                                                                                                            
                                                                                                    
                                                                                                    
]=]
-- start
















-- super skidded code down here

local type, typeof, error, pcall = type, typeof, error, pcall
local xpcall, traceback = xpcall, type(debug)=="table" and debug.traceback
local base, scriptId, runtimeVersion, executionFormat = "https://keyforge.win", "9034ee41-a34a-44fe-8383-6aa119477053", "kfvm:isa2:fmt2:compiler:kfvm-r3:cfg:e78ccd295d7613e2db50ac8cd2d2b38dfeed7cc87a5a449ab5da3357be727eed", "vm"
local nativeCompile
local compiler, clone = loadstring, clonefunction
local isC, isHooked = iscclosure, isfunctionhooked
local sourceOf = type(debug) == "table" and debug.info
local pairs, ipairs, next, tonumber, tostring, select = pairs, ipairs, next, tonumber, tostring, select
local getfenv, setfenv, getgenv, getrenv, setmetatable, warn = getfenv, setfenv, getgenv, getrenv, setmetatable, warn
local rawget, rawset, globals = rawget, rawset, _G
local freeze = type(table) == "table" and table.freeze
if type(freeze) ~= "function" then error("Keyforge: table freezing unavailable", 0) end
local http = (type(request) == "function" and request)
    or (type(http) == "table" and type(http.request) == "function" and http.request)
    or (type(http_request) == "function" and http_request)
local identify = identifyexecutor
local teleportQueue = queue_on_teleport or queueonteleport or (type(syn)=="table" and syn.queue_on_teleport)
local hwfn = type(gethwid) == "function" and gethwid
local function snapshot(t)
    local out = {}
    if type(t) == "table" then for k, v in pairs(t) do out[k] = v end end
    return freeze(out)
end
local string, table, math, bit32, buffer = snapshot(string), snapshot(table), snapshot(math), snapshot(bit32), snapshot(buffer)
local task, os, coroutine = snapshot(task), snapshot(os), snapshot(coroutine)
local function compilerClean(fn)
    if type(fn) ~= "function" or type(isC) ~= "function" or type(isHooked) ~= "function" or type(sourceOf) ~= "function" then return false end
    local c, native = pcall(isC, fn)
    local h, hooked = pcall(isHooked, fn)
    local d, source, line = pcall(sourceOf, fn, "sl")
    return c and native == true and h and hooked == false and d and source == "[C]" and line == -1
end
local function compilerCheck(fn, dependency)
    if not compilerClean(sourceOf) or not compilerClean(isC) or not compilerClean(isHooked) or not compilerClean(fn) then
        error("Keyforge: " .. (dependency or "compiler") .. " integrity check failed", 0)
    end
end
if type(http) ~= "function" or type(buffer.fromstring) ~= "function" or type(bit32.bxor) ~= "function"
    or type(task.wait) ~= "function" or type(task.spawn) ~= "function" or type(os.clock) ~= "function" or type(os.time) ~= "function" then
    error("Keyforge: unsupported environment", 0)
end
-- Executor classifiers are best-effort checks; signed server grants remain the trust boundary.
local function dependencyCheck()
    compilerCheck(http, "request")
    compilerCheck(os.clock, "os.clock")
    compilerCheck(os.time, "os.time")
    compilerCheck(task.wait, "task.wait")
    compilerCheck(task.spawn, "task.spawn")
    compilerCheck(buffer.fromstring, "buffer.fromstring")
end
dependencyCheck()
local function wait(...)
    compilerCheck(task.wait, "task.wait")
    local elapsed = task.wait(...)
    compilerCheck(task.wait, "task.wait")
    return elapsed
end
local function checkedHttp(options)
    dependencyCheck()
    local ok, result = pcall(http, options)
    dependencyCheck()
    return ok, result
end
if executionFormat == "source" then
    if type(compiler) ~= "function" or type(clone) ~= "function" then error("Keyforge: compiler cloning unavailable", 0) end
    if type(table.freeze) ~= "function" then error("Keyforge: protected environment unavailable", 0) end
    compilerCheck(compiler)
    compilerCheck(clone)
    local ok, fn = pcall(clone, compiler)
    if not ok or type(fn) ~= "function" or fn == compiler then error("Keyforge: compiler cloning unavailable", 0) end
    compilerCheck(fn)
    local compiled, probe = pcall(fn, "return true", "@Keyforge-check")
    if not compiled or type(probe) ~= "function" then error("Keyforge: compiler cloning unavailable", 0) end
    local ran, valid = pcall(probe)
    if not ran or valid ~= true then error("Keyforge: compiler cloning unavailable", 0) end
    compilerCheck(fn)
    nativeCompile = fn
end
-- Keyforge runtime initialization.
-- ui preview thing
local function _kf_create_gui_module()
    local M = {}
    local function rgb(value)
        return Color3.fromRGB(tonumber(string.sub(value,2,3),16) or 0,tonumber(string.sub(value,4,5),16) or 0,tonumber(string.sub(value,6,7),16) or 0)
    end
    -- Template fonts map to built-in Roblox fonts: {regular, bold}.
    local FONTS={Arial={"Arial","ArialBold"},Gotham={"Gotham","GothamBold"},Arcade={"Arcade","Arcade"},Fredoka={"FredokaOne","FredokaOne"},Mono={"RobotoMono","RobotoMono"},Michroma={"Michroma","Michroma"},Bangers={"Bangers","Bangers"},Oswald={"Oswald","Oswald"}}
    local function font(name,bold)
        local pair=FONTS[name or "Arial"] or FONTS.Arial
        local ok,value=pcall(function() return Enum.Font[bold and pair[2] or pair[1]] end)
        if ok and value then return value end
        return bold and Enum.Font.ArialBold or Enum.Font.Arial
    end
    M.Font=font
    function M.Build(scene, parent, constructors)
        local new = constructors and constructors.new or Instance.new
        local root = new("CanvasGroup")
        root.Name="KeyforgeWindow"; root.Size=UDim2.fromOffset(scene.width,scene.height)
        root.BackgroundColor3=rgb(scene.fill);root.BackgroundTransparency=1-scene.opacity;root.BorderSizePixel=0
        root.ClipsDescendants=true;root.GroupTransparency=0;root.Parent=parent
        local corner=new("UICorner");corner.CornerRadius=UDim.new(0,scene.radius);corner.Parent=root
        local stroke=new("UIStroke");stroke.Color=rgb(scene.border);stroke.Transparency=1-scene.borderOpacity;stroke.Thickness=scene.borderWidth or 1;stroke.Parent=root
        if scene.gradient and ColorSequence then local g=new("UIGradient");g.Color=ColorSequence.new(rgb(scene.fill),rgb(scene.gradient));g.Rotation=90;g.Parent=root end
        local refs={}
        for index,node in ipairs(scene.nodes) do
            local class=({text="TextLabel",button="TextButton",input="TextBox",frame="Frame",image="ImageLabel"})[node.kind]
            local item=new(class)
            item.Name=node.id;item.Position=UDim2.fromOffset(node.x,node.y);item.Size=UDim2.fromOffset(node.width,node.height)
            item.BorderSizePixel=0;item.ZIndex=index+2;item.BackgroundTransparency=1
            if node.fill and node.fill~="transparent" then item.BackgroundColor3=rgb(node.fill);item.BackgroundTransparency=1-(node.fillOpacity or 1) end
            if node.rotation then item.Rotation=node.rotation end
            if node.radius and node.radius>0 then local c=new("UICorner");c.CornerRadius=UDim.new(0,node.radius);c.Parent=item end
            if node.border then local b=new("UIStroke");b.Color=rgb(node.border);b.Transparency=1-(node.borderOpacity or 1);b.Thickness=node.borderWidth or 1;b.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;b.Parent=item end
            if node.kind=="text" or node.kind=="button" or node.kind=="input" then
                item.Text=node.text or "";item.TextColor3=rgb(node.color or "#ffffff");item.TextSize=node.fontSize or 13
                item.Font=font(scene.font,node.bold)
                item.TextScaled=false;item.TextWrapped=false;item.RichText=false
                item.TextXAlignment=node.align=="center" and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
                item.TextYAlignment=Enum.TextYAlignment.Center
            end
            if node.kind=="input" then
                item.PlaceholderText=node.placeholder or "";item.PlaceholderColor3=rgb(node.placeholderColor or scene.border);item.ClearTextOnFocus=false
                local padding=new("UIPadding");padding.PaddingLeft=UDim.new(0,12);padding.PaddingRight=UDim.new(0,12);padding.Parent=item
            elseif node.kind=="button" then item.AutoButtonColor=false
            elseif node.kind=="image" then item.Image="rbxassetid://"..node.assetId;item.ScaleType=Enum.ScaleType.Fit end
            item.Parent=root;refs[node.id]=item
        end
        local particles=scene.particles
        if particles and particles.preset~="None" then
            refs._particles={}
            for i=0,math.clamp(math.floor(particles.amount or 20),4,48)-1 do
                local size=particles.size*(.65+(i*17%11)/20)
                local item=new("Frame");item.Name="Particle"..i;item.BorderSizePixel=0;item.Active=false
                item.Size=UDim2.fromOffset(size,size);item.BackgroundColor3=rgb(particles.color)
                item.BackgroundTransparency=1-particles.opacity;item.ZIndex=2;item.Parent=root
                local c=new("UICorner");c.CornerRadius=UDim.new(0,particles.preset=="Confetti" and 1 or size/2);c.Parent=item
                table.insert(refs._particles,{item=item,size=size,x=(i*67%97)/100*math.max(0,scene.width-size),phase=(i*37%100)/100,duration=(scene.height+size*2)/particles.speed*(.8+(i*13%9)/20)})
            end
            M.UpdateParticles(scene,refs,0)
        end
        return root,refs
    end
    -- One bounded, deterministic 2D particle layer. No external assets or background tasks.
    function M.UpdateParticles(scene, refs, elapsed)
        for _,p in ipairs(refs._particles or {}) do
            local phase=(p.phase+elapsed/p.duration)%1
            if scene.particles.preset=="Fireflies" then phase=1-phase end
            p.item.Position=UDim2.fromOffset(p.x,-p.size+phase*(scene.height+p.size*2))
        end
    end
    function M.Create(config, callbacks, explicitParent, initialKind)
        callbacks=callbacks or {}
        if not Instance or not game or not game.GetService then return nil end
        local players=game:GetService("Players")
        local player=players.LocalPlayer
        if not player and not explicitParent then return nil end
        local parent=explicitParent or player:WaitForChild("PlayerGui",10)
        if not parent then return nil end
        local tween=game:GetService("TweenService")
        local screen=Instance.new("ScreenGui");screen.Name="Keyforge";screen.ResetOnSpawn=false;screen.IgnoreGuiInset=false;screen.DisplayOrder=100;screen.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
        local viewport=Instance.new("Frame");viewport.Size=UDim2.fromScale(1,1);viewport.BackgroundTransparency=1;viewport.Parent=screen
        screen.Parent=parent
        if viewport.AbsoluteSize.X<1 then game:GetService("RunService").RenderStepped:Wait() end
        local root,refs,scale,scene,currentKind,closed,connection,blur
        local clickConnections={}
        local function clear()
            for _,c in ipairs(clickConnections) do c:Disconnect() end;clickConnections={}
            if refs and refs["key-input"] then refs["key-input"].Text="" end
            refs=nil
            if root then root:Destroy();root=nil end
            local old=viewport:FindFirstChild("Backdrop");if old then old:Destroy() end
            if blur then blur:Destroy();blur=nil end
        end
        local function animate(object, duration, props, style, direction)
            local ti=TweenInfo.new(duration,style or Enum.EasingStyle.Quad,direction or Enum.EasingDirection.Out)
            local animation=tween:Create(object,ti,props);animation:Play();return animation
        end
        local handle={}
        function handle:Destroy()
            if closed then return end;closed=true;clear();if connection then connection:Disconnect() end;screen:Destroy()
        end
        local function choose(kind)
            local variants=config[kind];if not variants then return nil end
            local w=viewport.AbsoluteSize.X
            return w<360 and variants.narrow or w<540 and variants.mobile or variants.desktop
        end
        local function fit()
            if not root or closed then return end
            local sizing=scene.scaling or {}
            local preferred=sizing.mode=="Manual" and math.clamp(tonumber(sizing.percent) or 100,50,200)/100 or 1
            scale.Scale=math.max(.01,math.min(preferred,(viewport.AbsoluteSize.X-32)/scene.width,(viewport.AbsoluteSize.Y-32)/scene.height))
        end
        local function show(kind)
            if closed then return end
            local nextScene=choose(kind);if not nextScene then return end
            if currentKind==kind and scene==nextScene and root then fit();return end
            currentKind,scene=kind,nextScene
            clear()
            if scene.backdrop.enabled then
                local bg=Instance.new("Frame");bg.Name="Backdrop";bg.Size=UDim2.fromScale(1,1);bg.BackgroundColor3=rgb(scene.backdrop.color);bg.BackgroundTransparency=1-scene.backdrop.opacity;bg.BorderSizePixel=0;bg.Parent=viewport
            end
            -- Glass templates soften the game behind the window (local to this player).
            if (tonumber(scene.blur) or 0)>0 then
                local ok,effect=pcall(function() local b=Instance.new("BlurEffect");b.Name="KeyforgeBlur";b.Size=math.clamp(tonumber(scene.blur),1,24);b.Parent=game:GetService("Lighting");return b end)
                if ok then blur=effect end
            end
            root,refs=M.Build(scene,viewport)
            root.AnchorPoint=Vector2.new(.5,.5);root.Position=UDim2.fromScale(.5,.5)
            scale=Instance.new("UIScale");scale.Parent=root;fit()
            local motion=scene.animation
            if refs._particles and motion.enabled then
                local elapsed=0
                table.insert(clickConnections,game:GetService("RunService").RenderStepped:Connect(function(dt)
                    if closed or not root then return end
                    elapsed=(elapsed+dt)%3600;M.UpdateParticles(scene,refs,elapsed)
                end))
            end
            if motion.enabled and motion.enter~="None" then
                local duration=motion.duration/1000
                local style=motion.easing=="Linear" and Enum.EasingStyle.Linear or Enum.EasingStyle.Quad
                local direction=motion.easing=="Ease in out" and Enum.EasingDirection.InOut or Enum.EasingDirection.Out
                root.GroupTransparency=1
                if motion.enter=="Slide" then root.Position=UDim2.new(.5,0,.5,16) end
                if motion.enter=="Scale" then local target=scale.Scale;scale.Scale=target*.94;animate(scale,duration,{Scale=target},style,direction) end
                animate(root,duration,{GroupTransparency=0,Position=UDim2.fromScale(.5,.5)},style,direction)
            end
            for _,node in ipairs(scene.nodes) do
                if node.kind=="button" then
                    local button,basePosition,baseColor=refs[node.id],UDim2.fromOffset(node.x,node.y),refs[node.id].BackgroundColor3
                    local baseText=button.TextColor3
                    local buttonScale=Instance.new("UIScale");buttonScale.Parent=button
                    local function restore() if not closed and button.Parent then animate(buttonScale,.12,{Scale=1});animate(button,.12,{Position=basePosition,BackgroundColor3=baseColor,TextColor3=baseText}) end end
                    if motion.enabled then
                        table.insert(clickConnections,button.MouseEnter:Connect(function()
                            if motion.hover=="Scale" then animate(buttonScale,.12,{Scale=1.025});animate(button,.12,{Position=UDim2.fromOffset(node.x-node.width*.0125,node.y-node.height*.0125)})
                            elseif motion.hover=="Lift" then animate(button,.12,{Position=UDim2.fromOffset(node.x,node.y-2)})
                            elseif motion.hover=="Tint" then animate(button,.12,{BackgroundColor3=Color3.new(math.min(1,baseColor.R*1.15),math.min(1,baseColor.G*1.15),math.min(1,baseColor.B*1.15)),TextColor3=Color3.new(math.min(1,baseText.R*1.15),math.min(1,baseText.G*1.15),math.min(1,baseText.B*1.15))}) end
                        end))
                        table.insert(clickConnections,button.MouseLeave:Connect(restore))
                        if motion.press=="Shrink" then
                            table.insert(clickConnections,button.InputBegan:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then animate(buttonScale,.08,{Scale=.97});animate(button,.08,{Position=UDim2.fromOffset(node.x+node.width*.015,node.y+node.height*.015)}) end end))
                            table.insert(clickConnections,button.InputEnded:Connect(restore))
                        end
                    end
                    table.insert(clickConnections,button.Activated:Connect(function()
                        if node.action=="close" then if callbacks.onClose then callbacks.onClose() end;handle:Destroy()
                        elseif node.action=="check-key" then if callbacks.onSubmit then callbacks.onSubmit(refs["key-input"].Text,handle) end
                        elseif callbacks.onAction then callbacks.onAction(node.action) end
                    end))
                end
            end
            if refs["key-input"] then table.insert(clickConnections,refs["key-input"].FocusLost:Connect(function(enter)if enter and callbacks.onSubmit then callbacks.onSubmit(refs["key-input"].Text,handle) end end)) end
        end
        function handle:Show(kind)show(kind)end
        function handle:Status(message, failed)
            if closed then return end
            local target=refs and (refs.validation or refs.subtitle);if target then target.Text=message;target.TextColor3=rgb(failed and "#ef9ca7" or (scene.mutedColor or "#a1abba")) end
        end
        function handle:Progress(amount,message)
            if closed then return end
            if not refs then return end
            local variants=config.loading
            for _,v in pairs(variants or {}) do
                for _,node in ipairs(v.nodes) do
                    if node.id=="progress-fill" then
                        for _,track in ipairs(v.nodes) do if track.id=="progress-track" then node.width=track.width*math.clamp(amount,0,100)/100 end end
                    elseif node.id=="percent" then node.text=tostring(math.floor(amount)).."%"
                    elseif node.id=="subtitle" and message then node.text=message
                    elseif string.match(node.id,"^step%-%d+$") then local index=tonumber(string.sub(node.id,6));node.fill=amount>index/3*100 and v.accent or v.trackColor
                    elseif string.sub(node.id,1,5)=="ring-" then local index=tonumber(string.sub(node.id,6));node.fill=index/24<amount/100 and (v.accent or "#5b9bff") or (v.trackColor or "#10141c") end
                end
            end
            if currentKind~="loading" then show("loading") else
                local fill,track=refs["progress-fill"],refs["progress-track"]
                if fill and track then local target=UDim2.fromOffset(track.Size.X.Offset*math.clamp(amount,0,100)/100,fill.Size.Y.Offset);if scene.animation.enabled then animate(fill,scene.animation.duration/1000,{Size=target}) else fill.Size=target end end
                if refs.percent then refs.percent.Text=tostring(math.floor(amount)).."%" end
                if message and refs.subtitle then refs.subtitle.Text=message end
                if scene.layout=="Ring" or scene.layout=="Steps" then for _,node in ipairs(scene.nodes) do if string.match(node.id,"^ring%-%d+$") or string.match(node.id,"^step%-%d+$") then refs[node.id].BackgroundColor3=rgb(node.fill) end end end
            end
        end
        function handle:Fail()
            if closed then return end
            if refs and refs.title then refs.title.Text="Could not start" end
            if root and not refs.close then
                local button=Instance.new("TextButton");button.Name="Close";button.Size=UDim2.fromOffset(20,20);button.Position=UDim2.fromOffset(scene.width-28,8);button.BackgroundTransparency=1;button.Text="×";button.TextSize=18;button.Font=Enum.Font.Arial;button.TextColor3=rgb(scene.border);button.ZIndex=1000;button.Parent=root
                refs.close=button;table.insert(clickConnections,button.Activated:Connect(function()handle:Destroy()end))
            end
            if refs and refs.subtitle then refs.subtitle.Text="Run the loader again." end
        end
        connection=viewport:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            if closed or not currentKind then return end
            if choose(currentKind)~=scene then local input=refs and refs["key-input"] and refs["key-input"].Text;show(currentKind);if input and refs["key-input"] then refs["key-input"].Text=input end else fit() end
        end)
        local firstKind=initialKind or (config.keygui and "keygui" or "loading")
        if not choose(firstKind) then firstKind=config.keygui and "keygui" or "loading" end
        show(firstKind)
        return handle
    end
    return M
end

local _kf_ui_config = {["links"]={["key"]="https://keyforge.win/key.html?script=9034ee41-a34a-44fe-8383-6aa119477053",["discord"]=""},["keygui"]={["desktop"]={["version"]=1,["surface"]="keygui",["layout"]="Window",["scaling"]={["mode"]="Auto",["percent"]=100},["accent"]="#5b9bff",["mutedColor"]="#a1abba",["trackColor"]="#10141c",["width"]=360,["height"]=265,["radius"]=12,["fill"]="#171b24",["opacity"]=0.96,["border"]="#9bb2d0",["borderOpacity"]=0.22,["font"]="Arial",["gradient"]=nil,["borderWidth"]=1,["blur"]=0,["nodes"]={{["id"]="icon-tile",["kind"]="frame",["x"]=24,["y"]=24,["width"]=38,["height"]=38,["fill"]="#5b9bff",["radius"]=10},{["id"]="icon",["kind"]="text",["x"]=24,["y"]=24,["width"]=38,["height"]=38,["text"]="KF",["fontSize"]=16,["bold"]=true,["color"]="#ffffff",["align"]="center"},{["id"]="title",["kind"]="text",["x"]=74,["y"]=24,["width"]=242,["height"]=22,["text"]="Keyforge",["fontSize"]=16,["color"]="#eef1f7",["align"]="left",["bold"]=true},{["id"]="subtitle",["kind"]="text",["x"]=74,["y"]=49,["width"]=242,["height"]=18,["text"]="Enter your key to continue",["fontSize"]=13,["color"]="#a1abba",["align"]="left",["bold"]=false},{["id"]="key-input",["kind"]="input",["x"]=24,["y"]=87,["width"]=312,["height"]=38,["text"]="",["placeholder"]="Paste your key…",["placeholderColor"]="#a1abba",["fontSize"]=13,["color"]="#eef1f7",["fill"]="#10141c",["fillOpacity"]=1,["border"]="#9bb2d0",["borderOpacity"]=0.22,["borderWidth"]=1,["radius"]=8},{["id"]="validation",["kind"]="text",["x"]=24,["y"]=131,["width"]=312,["height"]=18,["text"]="",["fontSize"]=13,["color"]="#ef9ca7",["align"]="left"},{["id"]="check-key",["kind"]="button",["x"]=24,["y"]=157,["width"]=312,["height"]=38,["text"]="Check key",["fontSize"]=13,["bold"]=true,["align"]="center",["fill"]="#5b9bff",["fillOpacity"]=1,["color"]="#ffffff",["border"]="#5b9bff",["borderOpacity"]=1,["borderWidth"]=1,["radius"]=8,["action"]="check-key"},{["id"]="get-key",["kind"]="button",["x"]=24,["y"]=203,["width"]=152,["height"]=38,["text"]="Get key",["fontSize"]=13,["bold"]=true,["align"]="center",["fill"]="#10141c",["fillOpacity"]=1,["color"]="#eef1f7",["border"]="#9bb2d0",["borderOpacity"]=0.22,["borderWidth"]=1,["radius"]=8,["action"]="get-key"},{["id"]="discord",["kind"]="button",["x"]=184,["y"]=203,["width"]=152,["height"]=38,["text"]="Join Discord",["fontSize"]=13,["bold"]=true,["align"]="center",["fill"]="#10141c",["fillOpacity"]=1,["color"]="#eef1f7",["border"]="#9bb2d0",["borderOpacity"]=0.22,["borderWidth"]=1,["radius"]=8,["action"]="discord"},{["id"]="close",["kind"]="button",["x"]=330,["y"]=10,["width"]=20,["height"]=22,["text"]="×",["fontSize"]=18,["color"]="#a1abba",["fill"]="transparent",["radius"]=4,["action"]="close"}},["particles"]={["preset"]="None",["amount"]=20,["size"]=3,["speed"]=30,["opacity"]=0.35,["color"]="#5b9bff"},["animation"]={["enabled"]=true,["enter"]="Fade",["duration"]=220,["easing"]="Ease out",["hover"]="Tint",["press"]="Shrink"},["backdrop"]={["enabled"]=false,["color"]="#080e18",["opacity"]=0.65},["progress"]=65},["mobile"]={["version"]=1,["surface"]="keygui",["layout"]="Window",["scaling"]={["mode"]="Auto",["percent"]=100},["accent"]="#5b9bff",["mutedColor"]="#a1abba",["trackColor"]="#10141c",["width"]=358,["height"]=265,["radius"]=12,["fill"]="#171b24",["opacity"]=0.96,["border"]="#9bb2d0",["borderOpacity"]=0.22,["font"]="Arial",["gradient"]=nil,["borderWidth"]=1,["blur"]=0,["nodes"]={{["id"]="icon-tile",["kind"]="frame",["x"]=24,["y"]=24,["width"]=38,["height"]=38,["fill"]="#5b9bff",["radius"]=10},{["id"]="icon",["kind"]="text",["x"]=24,["y"]=24,["width"]=38,["height"]=38,["text"]="KF",["fontSize"]=16,["bold"]=true,["color"]="#ffffff",["align"]="center"},{["id"]="title",["kind"]="text",["x"]=74,["y"]=24,["width"]=240,["height"]=22,["text"]="Keyforge",["fontSize"]=16,["color"]="#eef1f7",["align"]="left",["bold"]=true},{["id"]="subtitle",["kind"]="text",["x"]=74,["y"]=49,["width"]=240,["height"]=18,["text"]="Enter your key to continue",["fontSize"]=13,["color"]="#a1abba",["align"]="left",["bold"]=false},{["id"]="key-input",["kind"]="input",["x"]=24,["y"]=87,["width"]=310,["height"]=38,["text"]="",["placeholder"]="Paste your key…",["placeholderColor"]="#a1abba",["fontSize"]=13,["color"]="#eef1f7",["fill"]="#10141c",["fillOpacity"]=1,["border"]="#9bb2d0",["borderOpacity"]=0.22,["borderWidth"]=1,["radius"]=8},{["id"]="validation",["kind"]="text",["x"]=24,["y"]=131,["width"]=310,["height"]=18,["text"]="",["fontSize"]=13,["color"]="#ef9ca7",["align"]="left"},{["id"]="check-key",["kind"]="button",["x"]=24,["y"]=157,["width"]=310,["height"]=38,["text"]="Check key",["fontSize"]=13,["bold"]=true,["align"]="center",["fill"]="#5b9bff",["fillOpacity"]=1,["color"]="#ffffff",["border"]="#5b9bff",["borderOpacity"]=1,["borderWidth"]=1,["radius"]=8,["action"]="check-key"},{["id"]="get-key",["kind"]="button",["x"]=24,["y"]=203,["width"]=151,["height"]=38,["text"]="Get key",["fontSize"]=13,["bold"]=true,["align"]="center",["fill"]="#10141c",["fillOpacity"]=1,["color"]="#eef1f7",["border"]="#9bb2d0",["borderOpacity"]=0.22,["borderWidth"]=1,["radius"]=8,["action"]="get-key"},{["id"]="discord",["kind"]="button",["x"]=183,["y"]=203,["width"]=151,["height"]=38,["text"]="Join Discord",["fontSize"]=13,["bold"]=true,["align"]="center",["fill"]="#10141c",["fillOpacity"]=1,["color"]="#eef1f7",["border"]="#9bb2d0",["borderOpacity"]=0.22,["borderWidth"]=1,["radius"]=8,["action"]="discord"},{["id"]="close",["kind"]="button",["x"]=328,["y"]=10,["width"]=20,["height"]=22,["text"]="×",["fontSize"]=18,["color"]="#a1abba",["fill"]="transparent",["radius"]=4,["action"]="close"}},["particles"]={["preset"]="None",["amount"]=20,["size"]=3,["speed"]=30,["opacity"]=0.35,["color"]="#5b9bff"},["animation"]={["enabled"]=true,["enter"]="Fade",["duration"]=220,["easing"]="Ease out",["hover"]="Tint",["press"]="Shrink"},["backdrop"]={["enabled"]=false,["color"]="#080e18",["opacity"]=0.65},["progress"]=65},["narrow"]={["version"]=1,["surface"]="keygui",["layout"]="Window",["scaling"]={["mode"]="Auto",["percent"]=100},["accent"]="#5b9bff",["mutedColor"]="#a1abba",["trackColor"]="#10141c",["width"]=288,["height"]=265,["radius"]=12,["fill"]="#171b24",["opacity"]=0.96,["border"]="#9bb2d0",["borderOpacity"]=0.22,["font"]="Arial",["gradient"]=nil,["borderWidth"]=1,["blur"]=0,["nodes"]={{["id"]="icon-tile",["kind"]="frame",["x"]=24,["y"]=24,["width"]=38,["height"]=38,["fill"]="#5b9bff",["radius"]=10},{["id"]="icon",["kind"]="text",["x"]=24,["y"]=24,["width"]=38,["height"]=38,["text"]="KF",["fontSize"]=16,["bold"]=true,["color"]="#ffffff",["align"]="center"},{["id"]="title",["kind"]="text",["x"]=74,["y"]=24,["width"]=170,["height"]=22,["text"]="Keyforge",["fontSize"]=16,["color"]="#eef1f7",["align"]="left",["bold"]=true},{["id"]="subtitle",["kind"]="text",["x"]=74,["y"]=49,["width"]=170,["height"]=18,["text"]="Enter your key to continue",["fontSize"]=13,["color"]="#a1abba",["align"]="left",["bold"]=false},{["id"]="key-input",["kind"]="input",["x"]=24,["y"]=87,["width"]=240,["height"]=38,["text"]="",["placeholder"]="Paste your key…",["placeholderColor"]="#a1abba",["fontSize"]=13,["color"]="#eef1f7",["fill"]="#10141c",["fillOpacity"]=1,["border"]="#9bb2d0",["borderOpacity"]=0.22,["borderWidth"]=1,["radius"]=8},{["id"]="validation",["kind"]="text",["x"]=24,["y"]=131,["width"]=240,["height"]=18,["text"]="",["fontSize"]=13,["color"]="#ef9ca7",["align"]="left"},{["id"]="check-key",["kind"]="button",["x"]=24,["y"]=157,["width"]=240,["height"]=38,["text"]="Check key",["fontSize"]=13,["bold"]=true,["align"]="center",["fill"]="#5b9bff",["fillOpacity"]=1,["color"]="#ffffff",["border"]="#5b9bff",["borderOpacity"]=1,["borderWidth"]=1,["radius"]=8,["action"]="check-key"},{["id"]="get-key",["kind"]="button",["x"]=24,["y"]=203,["width"]=116,["height"]=38,["text"]="Get key",["fontSize"]=13,["bold"]=true,["align"]="center",["fill"]="#10141c",["fillOpacity"]=1,["color"]="#eef1f7",["border"]="#9bb2d0",["borderOpacity"]=0.22,["borderWidth"]=1,["radius"]=8,["action"]="get-key"},{["id"]="discord",["kind"]="button",["x"]=148,["y"]=203,["width"]=116,["height"]=38,["text"]="Join Discord",["fontSize"]=13,["bold"]=true,["align"]="center",["fill"]="#10141c",["fillOpacity"]=1,["color"]="#eef1f7",["border"]="#9bb2d0",["borderOpacity"]=0.22,["borderWidth"]=1,["radius"]=8,["action"]="discord"},{["id"]="close",["kind"]="button",["x"]=258,["y"]=10,["width"]=20,["height"]=22,["text"]="×",["fontSize"]=18,["color"]="#a1abba",["fill"]="transparent",["radius"]=4,["action"]="close"}},["particles"]={["preset"]="None",["amount"]=20,["size"]=3,["speed"]=30,["opacity"]=0.35,["color"]="#5b9bff"},["animation"]={["enabled"]=true,["enter"]="Fade",["duration"]=220,["easing"]="Ease out",["hover"]="Tint",["press"]="Shrink"},["backdrop"]={["enabled"]=false,["color"]="#080e18",["opacity"]=0.65},["progress"]=65}},["loading"]={["desktop"]={["version"]=1,["surface"]="loading",["layout"]="Bar",["scaling"]={["mode"]="Auto",["percent"]=100},["accent"]="#5b9bff",["mutedColor"]="#a1abba",["trackColor"]="#10141c",["width"]=360,["height"]=195,["radius"]=12,["fill"]="#171b24",["opacity"]=0.96,["border"]="#9bb2d0",["borderOpacity"]=0.22,["font"]="Arial",["gradient"]=nil,["borderWidth"]=1,["blur"]=0,["nodes"]={{["id"]="icon-tile",["kind"]="frame",["x"]=161,["y"]=24,["width"]=38,["height"]=38,["fill"]="#5b9bff",["radius"]=10},{["id"]="icon",["kind"]="text",["x"]=161,["y"]=24,["width"]=38,["height"]=38,["text"]="KF",["fontSize"]=16,["bold"]=true,["color"]="#ffffff",["align"]="center"},{["id"]="title",["kind"]="text",["x"]=24,["y"]=74,["width"]=312,["height"]=22,["text"]="Loading script",["fontSize"]=16,["color"]="#eef1f7",["align"]="center",["bold"]=true},{["id"]="subtitle",["kind"]="text",["x"]=24,["y"]=100,["width"]=312,["height"]=18,["text"]="Getting things ready.",["fontSize"]=13,["color"]="#a1abba",["align"]="center",["bold"]=false},{["id"]="progress-track",["kind"]="frame",["x"]=24,["y"]=136,["width"]=312,["height"]=6,["fill"]="#10141c",["radius"]=3},{["id"]="progress-fill",["kind"]="frame",["x"]=24,["y"]=136,["width"]=203,["height"]=6,["fill"]="#5b9bff",["radius"]=3},{["id"]="progress-label",["kind"]="text",["x"]=24,["y"]=154,["width"]=312,["height"]=17,["text"]="Loading",["fontSize"]=12,["color"]="#a1abba",["align"]="center",["bold"]=false}},["particles"]={["preset"]="None",["amount"]=20,["size"]=3,["speed"]=30,["opacity"]=0.35,["color"]="#5b9bff"},["animation"]={["enabled"]=true,["enter"]="Fade",["duration"]=220,["easing"]="Ease out",["hover"]="Tint",["press"]="Shrink"},["backdrop"]={["enabled"]=false,["color"]="#080e18",["opacity"]=0.65},["progress"]=65},["mobile"]={["version"]=1,["surface"]="loading",["layout"]="Bar",["scaling"]={["mode"]="Auto",["percent"]=100},["accent"]="#5b9bff",["mutedColor"]="#a1abba",["trackColor"]="#10141c",["width"]=358,["height"]=195,["radius"]=12,["fill"]="#171b24",["opacity"]=0.96,["border"]="#9bb2d0",["borderOpacity"]=0.22,["font"]="Arial",["gradient"]=nil,["borderWidth"]=1,["blur"]=0,["nodes"]={{["id"]="icon-tile",["kind"]="frame",["x"]=160,["y"]=24,["width"]=38,["height"]=38,["fill"]="#5b9bff",["radius"]=10},{["id"]="icon",["kind"]="text",["x"]=160,["y"]=24,["width"]=38,["height"]=38,["text"]="KF",["fontSize"]=16,["bold"]=true,["color"]="#ffffff",["align"]="center"},{["id"]="title",["kind"]="text",["x"]=24,["y"]=74,["width"]=310,["height"]=22,["text"]="Loading script",["fontSize"]=16,["color"]="#eef1f7",["align"]="center",["bold"]=true},{["id"]="subtitle",["kind"]="text",["x"]=24,["y"]=100,["width"]=310,["height"]=18,["text"]="Getting things ready.",["fontSize"]=13,["color"]="#a1abba",["align"]="center",["bold"]=false},{["id"]="progress-track",["kind"]="frame",["x"]=24,["y"]=136,["width"]=310,["height"]=6,["fill"]="#10141c",["radius"]=3},{["id"]="progress-fill",["kind"]="frame",["x"]=24,["y"]=136,["width"]=202,["height"]=6,["fill"]="#5b9bff",["radius"]=3},{["id"]="progress-label",["kind"]="text",["x"]=24,["y"]=154,["width"]=310,["height"]=17,["text"]="Loading",["fontSize"]=12,["color"]="#a1abba",["align"]="center",["bold"]=false}},["particles"]={["preset"]="None",["amount"]=20,["size"]=3,["speed"]=30,["opacity"]=0.35,["color"]="#5b9bff"},["animation"]={["enabled"]=true,["enter"]="Fade",["duration"]=220,["easing"]="Ease out",["hover"]="Tint",["press"]="Shrink"},["backdrop"]={["enabled"]=false,["color"]="#080e18",["opacity"]=0.65},["progress"]=65},["narrow"]={["version"]=1,["surface"]="loading",["layout"]="Bar",["scaling"]={["mode"]="Auto",["percent"]=100},["accent"]="#5b9bff",["mutedColor"]="#a1abba",["trackColor"]="#10141c",["width"]=288,["height"]=195,["radius"]=12,["fill"]="#171b24",["opacity"]=0.96,["border"]="#9bb2d0",["borderOpacity"]=0.22,["font"]="Arial",["gradient"]=nil,["borderWidth"]=1,["blur"]=0,["nodes"]={{["id"]="icon-tile",["kind"]="frame",["x"]=125,["y"]=24,["width"]=38,["height"]=38,["fill"]="#5b9bff",["radius"]=10},{["id"]="icon",["kind"]="text",["x"]=125,["y"]=24,["width"]=38,["height"]=38,["text"]="KF",["fontSize"]=16,["bold"]=true,["color"]="#ffffff",["align"]="center"},{["id"]="title",["kind"]="text",["x"]=24,["y"]=74,["width"]=240,["height"]=22,["text"]="Loading script",["fontSize"]=16,["color"]="#eef1f7",["align"]="center",["bold"]=true},{["id"]="subtitle",["kind"]="text",["x"]=24,["y"]=100,["width"]=240,["height"]=18,["text"]="Getting things ready.",["fontSize"]=13,["color"]="#a1abba",["align"]="center",["bold"]=false},{["id"]="progress-track",["kind"]="frame",["x"]=24,["y"]=136,["width"]=240,["height"]=6,["fill"]="#10141c",["radius"]=3},{["id"]="progress-fill",["kind"]="frame",["x"]=24,["y"]=136,["width"]=156,["height"]=6,["fill"]="#5b9bff",["radius"]=3},{["id"]="progress-label",["kind"]="text",["x"]=24,["y"]=154,["width"]=240,["height"]=17,["text"]="Loading",["fontSize"]=12,["color"]="#a1abba",["align"]="center",["bold"]=false}},["particles"]={["preset"]="None",["amount"]=20,["size"]=3,["speed"]=30,["opacity"]=0.35,["color"]="#5b9bff"},["animation"]={["enabled"]=true,["enter"]="Fade",["duration"]=220,["easing"]="Ease out",["hover"]="Tint",["press"]="Shrink"},["backdrop"]={["enabled"]=false,["color"]="#080e18",["opacity"]=0.65},["progress"]=65}}}

local parent = (type(getfenv) == "function" and getfenv()) or globals
local ui, submitted, cancelled, sessionCloser
local chosen = _kf_ui_config
local customOK, custom = pcall(function() return type(getgenv)=="function" and getgenv().keyforge_ui end)
if customOK and type(custom)=="table" then chosen=custom end
local function showUI(kind)
    if ui then ui:Show(kind); return end
    local callbacks={
        onSubmit=function(value)submitted=value end,
        onClose=function()cancelled=true;if sessionCloser then pcall(sessionCloser) end end,
        onAction=function(action)
            local value=type(chosen.links)=="table" and chosen.links[action=="get-key" and "key" or "discord"]
            if type(value)=="string" and (string.match(value,"^https://[^%s<>]+$") or string.match(value,"^http://localhost[:/]") or string.match(value,"^http://127%.0%.0%.1[:/]")) and type(setclipboard)=="function" then
                local ok=pcall(setclipboard,value);if ui then ui:Status(ok and "Link copied. Open it in your browser." or "Could not copy the link.",not ok) end
            elseif ui then ui:Status("This link has not been configured.",true) end
        end,
    }
    local ok,value=pcall(function()return _kf_create_gui_module().Create(chosen,callbacks,nil,kind)end)
    if ok then ui=value end
end
local resumeToken
local key = "YOUR_LICENSE_KEY"
if key == "YOUR_LICENSE_KEY" then
    local supplied = ...
    if type(supplied)=="table" and type(supplied.resume)=="string" then resumeToken=supplied.resume;key=nil
    elseif type(supplied) == "string" then key = supplied
    else
        local ok, env = pcall(function() return type(getgenv) == "function" and getgenv() or globals end)
        key = ok and type(env) == "table" and env.script_key or nil
    end
end
local function begin(key)
dependencyCheck()
if not resumeToken and type(key) ~= "string" then error("Keyforge: set script_key to your license key", 0) end
-- Empty keys ask the server for keyless access.
if not resumeToken and key ~= "" then
key = string.match(key, "^%s*(.-)%s*$")
local validLicense = (#key==43 and not string.find(key,"[^A-Za-z0-9_-]")) or (#key>=50 and #key<=65 and string.match(string.sub(key,1,#key-49),"^[A-Z0-9]+$") and string.sub(key,#key-48,#key-48)=="_" and not string.find(string.sub(key,#key-47),"[^A-Za-z0-9_-]"))
if not validLicense then error("Keyforge: invalid license key", 0) end
end
local releaseId, clientChallenge
local pinned = {["v3-launch-1"]="867b1f7a27c86211c22f491c9aa4ce3edbb3831031901415608a6ca352863cc7"}
freeze(pinned)
--[[
MIT License

Copyright (c) 2026 daily3014

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]
local function _kf_create_ed25519_verifier()
local MultiPrecision = (function()
--[=[
	Cryptography library: Multi-Precision Arithmetic (264-bit integers)

	Return type: varies by function
	Example usage:
		local MultiPrecision = require("MultiPrecision")

		--------Usage Case 1: Basic arithmetic--------
		local NumberA = MultiPrecision.Num(42)
		local NumberB = MultiPrecision.Num(17)
		local Sum = MultiPrecision.Add(NumberA, NumberB)
		local Product = MultiPrecision.Mul(NumberA, NumberB)

		--------Usage Case 2: Carry operations--------
		local LargeSum = MultiPrecision.Add(Sum, Product)
		local Normalized = MultiPrecision.Carry(LargeSum)
--]=]

--!strict
--!optimize 2
--!native

local CARRY = 88
local SIZE = 96

local MultiPrecision = {}

function MultiPrecision.CarryWeak(LargeNumber, Storage)
	local A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10 =
		buffer.readf64(LargeNumber, 0), buffer.readf64(LargeNumber, 8),
		buffer.readf64(LargeNumber, 16), buffer.readf64(LargeNumber, 24),
		buffer.readf64(LargeNumber, 32), buffer.readf64(LargeNumber, 40),
		buffer.readf64(LargeNumber, 48), buffer.readf64(LargeNumber, 56),
		buffer.readf64(LargeNumber, 64), buffer.readf64(LargeNumber, 72),
		buffer.readf64(LargeNumber, 80)

	local Carry00 = A00 + 3 * 2 ^ 75 - 3 * 2 ^ 75; A01 = A01 + (Carry00 * 2 ^ -24)
	local Carry01 = A01 + 3 * 2 ^ 75 - 3 * 2 ^ 75; A02 = A02 + (Carry01 * 2 ^ -24)
	local Carry02 = A02 + 3 * 2 ^ 75 - 3 * 2 ^ 75; A03 = A03 + (Carry02 * 2 ^ -24)
	local Carry03 = A03 + 3 * 2 ^ 75 - 3 * 2 ^ 75; A04 = A04 + (Carry03 * 2 ^ -24)
	local Carry04 = A04 + 3 * 2 ^ 75 - 3 * 2 ^ 75; A05 = A05 + (Carry04 * 2 ^ -24)
	local Carry05 = A05 + 3 * 2 ^ 75 - 3 * 2 ^ 75; A06 = A06 + (Carry05 * 2 ^ -24)
	local Carry06 = A06 + 3 * 2 ^ 75 - 3 * 2 ^ 75; A07 = A07 + (Carry06 * 2 ^ -24)
	local Carry07 = A07 + 3 * 2 ^ 75 - 3 * 2 ^ 75; A08 = A08 + (Carry07 * 2 ^ -24)
	local Carry08 = A08 + 3 * 2 ^ 75 - 3 * 2 ^ 75; A09 = A09 + (Carry08 * 2 ^ -24)
	local Carry09 = A09 + 3 * 2 ^ 75 - 3 * 2 ^ 75; A10 = A10 + (Carry09 * 2 ^ -24)
	local Carry10 = A10 + 3 * 2 ^ 75 - 3 * 2 ^ 75

	local Buf = Storage or buffer.create(SIZE)

	buffer.writef64(Buf, 0, A00 - Carry00)
	buffer.writef64(Buf, 8, A01 - Carry01)
	buffer.writef64(Buf, 16, A02 - Carry02)
	buffer.writef64(Buf, 24, A03 - Carry03)
	buffer.writef64(Buf, 32, A04 - Carry04)
	buffer.writef64(Buf, 40, A05 - Carry05)
	buffer.writef64(Buf, 48, A06 - Carry06)
	buffer.writef64(Buf, 56, A07 - Carry07)
	buffer.writef64(Buf, 64, A08 - Carry08)
	buffer.writef64(Buf, 72, A09 - Carry09)
	buffer.writef64(Buf, 80, A10 - Carry10)
	buffer.writef64(Buf, 88, Carry10 * 2 ^ -24)

	return Buf
end

function MultiPrecision.Carry(LargeNumber, Storage)
	local A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10 =
		buffer.readf64(LargeNumber, 0), buffer.readf64(LargeNumber, 8),
		buffer.readf64(LargeNumber, 16), buffer.readf64(LargeNumber, 24),
		buffer.readf64(LargeNumber, 32), buffer.readf64(LargeNumber, 40),
		buffer.readf64(LargeNumber, 48), buffer.readf64(LargeNumber, 56),
		buffer.readf64(LargeNumber, 64), buffer.readf64(LargeNumber, 72),
		buffer.readf64(LargeNumber, 80)

	local Low00 = A00 % 2 ^ 24; A01 = A01 + ((A00 - Low00) * 2 ^ -24)
	local Low01 = A01 % 2 ^ 24; A02 = A02 + ((A01 - Low01) * 2 ^ -24)
	local Low02 = A02 % 2 ^ 24; A03 = A03 + ((A02 - Low02) * 2 ^ -24)
	local Low03 = A03 % 2 ^ 24; A04 = A04 + ((A03 - Low03) * 2 ^ -24)
	local Low04 = A04 % 2 ^ 24; A05 = A05 + ((A04 - Low04) * 2 ^ -24)
	local Low05 = A05 % 2 ^ 24; A06 = A06 + ((A05 - Low05) * 2 ^ -24)
	local Low06 = A06 % 2 ^ 24; A07 = A07 + ((A06 - Low06) * 2 ^ -24)
	local Low07 = A07 % 2 ^ 24; A08 = A08 + ((A07 - Low07) * 2 ^ -24)
	local Low08 = A08 % 2 ^ 24; A09 = A09 + ((A08 - Low08) * 2 ^ -24)
	local Low09 = A09 % 2 ^ 24; A10 = A10 + ((A09 - Low09) * 2 ^ -24)
	local Low10 = A10 % 2 ^ 24

	local Buf = Storage or buffer.create(SIZE)

	buffer.writef64(Buf, 0, Low00)
	buffer.writef64(Buf, 8, Low01)
	buffer.writef64(Buf, 16, Low02)
	buffer.writef64(Buf, 24, Low03)
	buffer.writef64(Buf, 32, Low04)
	buffer.writef64(Buf, 40, Low05)
	buffer.writef64(Buf, 48, Low06)
	buffer.writef64(Buf, 56, Low07)
	buffer.writef64(Buf, 64, Low08)
	buffer.writef64(Buf, 72, Low09)
	buffer.writef64(Buf, 80, Low10)
	buffer.writef64(Buf, 88, (A10 - Low10) * 2 ^ -24)

	return Buf
end

function MultiPrecision.Add(NumberA, NumberB, Storage)
	local A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10 =
		buffer.readf64(NumberA, 0), buffer.readf64(NumberA, 8),
		buffer.readf64(NumberA, 16), buffer.readf64(NumberA, 24),
		buffer.readf64(NumberA, 32), buffer.readf64(NumberA, 40),
		buffer.readf64(NumberA, 48), buffer.readf64(NumberA, 56),
		buffer.readf64(NumberA, 64), buffer.readf64(NumberA, 72),
		buffer.readf64(NumberA, 80)

	local B00, B01, B02, B03, B04, B05, B06, B07, B08, B09, B10 =
		buffer.readf64(NumberB, 0), buffer.readf64(NumberB, 8),
		buffer.readf64(NumberB, 16), buffer.readf64(NumberB, 24),
		buffer.readf64(NumberB, 32), buffer.readf64(NumberB, 40),
		buffer.readf64(NumberB, 48), buffer.readf64(NumberB, 56),
		buffer.readf64(NumberB, 64), buffer.readf64(NumberB, 72),
		buffer.readf64(NumberB, 80)

	local Buf = Storage or buffer.create(SIZE)

	buffer.writef64(Buf, 0, A00 + B00)
	buffer.writef64(Buf, 8, A01 + B01)
	buffer.writef64(Buf, 16, A02 + B02)
	buffer.writef64(Buf, 24, A03 + B03)
	buffer.writef64(Buf, 32, A04 + B04)
	buffer.writef64(Buf, 40, A05 + B05)
	buffer.writef64(Buf, 48, A06 + B06)
	buffer.writef64(Buf, 56, A07 + B07)
	buffer.writef64(Buf, 64, A08 + B08)
	buffer.writef64(Buf, 72, A09 + B09)
	buffer.writef64(Buf, 80, A10 + B10)

	return Buf
end

function MultiPrecision.Sub(NumberA, NumberB, Storage)
	local A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10 =
		buffer.readf64(NumberA, 0), buffer.readf64(NumberA, 8),
		buffer.readf64(NumberA, 16), buffer.readf64(NumberA, 24),
		buffer.readf64(NumberA, 32), buffer.readf64(NumberA, 40),
		buffer.readf64(NumberA, 48), buffer.readf64(NumberA, 56),
		buffer.readf64(NumberA, 64), buffer.readf64(NumberA, 72),
		buffer.readf64(NumberA, 80)

	local B00, B01, B02, B03, B04, B05, B06, B07, B08, B09, B10 =
		buffer.readf64(NumberB, 0), buffer.readf64(NumberB, 8),
		buffer.readf64(NumberB, 16), buffer.readf64(NumberB, 24),
		buffer.readf64(NumberB, 32), buffer.readf64(NumberB, 40),
		buffer.readf64(NumberB, 48), buffer.readf64(NumberB, 56),
		buffer.readf64(NumberB, 64), buffer.readf64(NumberB, 72),
		buffer.readf64(NumberB, 80)

	local Buf = Storage or buffer.create(SIZE)

	buffer.writef64(Buf, 0, A00 - B00)
	buffer.writef64(Buf, 8, A01 - B01)
	buffer.writef64(Buf, 16, A02 - B02)
	buffer.writef64(Buf, 24, A03 - B03)
	buffer.writef64(Buf, 32, A04 - B04)
	buffer.writef64(Buf, 40, A05 - B05)
	buffer.writef64(Buf, 48, A06 - B06)
	buffer.writef64(Buf, 56, A07 - B07)
	buffer.writef64(Buf, 64, A08 - B08)
	buffer.writef64(Buf, 72, A09 - B09)
	buffer.writef64(Buf, 80, A10 - B10)

	return Buf
end

function MultiPrecision.LMul(NumberA, NumberB, Storage)
	local A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10 =
		buffer.readf64(NumberA, 0), buffer.readf64(NumberA, 8),
		buffer.readf64(NumberA, 16), buffer.readf64(NumberA, 24),
		buffer.readf64(NumberA, 32), buffer.readf64(NumberA, 40),
		buffer.readf64(NumberA, 48), buffer.readf64(NumberA, 56),
		buffer.readf64(NumberA, 64), buffer.readf64(NumberA, 72),
		buffer.readf64(NumberA, 80)

	local B00, B01, B02, B03, B04, B05, B06, B07, B08, B09, B10 =
		buffer.readf64(NumberB, 0), buffer.readf64(NumberB, 8),
		buffer.readf64(NumberB, 16), buffer.readf64(NumberB, 24),
		buffer.readf64(NumberB, 32), buffer.readf64(NumberB, 40),
		buffer.readf64(NumberB, 48), buffer.readf64(NumberB, 56),
		buffer.readf64(NumberB, 64), buffer.readf64(NumberB, 72),
		buffer.readf64(NumberB, 80)

	local Buf = Storage or buffer.create(SIZE)

	buffer.writef64(Buf, 0, A00 * B00)
	buffer.writef64(Buf, 8, A01 * B00 + A00 * B01)
	buffer.writef64(Buf, 16, A02 * B00 + A01 * B01 + A00 * B02)
	buffer.writef64(Buf, 24, A03 * B00 + A02 * B01 + A01 * B02 + A00 * B03)
	buffer.writef64(Buf, 32, A04 * B00 + A03 * B01 + A02 * B02 + A01 * B03 + A00 * B04)
	buffer.writef64(Buf, 40, A05 * B00 + A04 * B01 + A03 * B02 + A02 * B03 + A01 * B04 + A00 * B05)
	buffer.writef64(Buf, 48, A06 * B00 + A05 * B01 + A04 * B02 + A03 * B03 + A02 * B04 + A01 * B05 + A00 * B06)
	buffer.writef64(Buf, 56, A07 * B00 + A06 * B01 + A05 * B02 + A04 * B03 + A03 * B04 + A02 * B05 + A01 * B06 + A00 * B07)
	buffer.writef64(Buf, 64, A08 * B00 + A07 * B01 + A06 * B02 + A05 * B03 + A04 * B04 + A03 * B05 + A02 * B06 + A01 * B07 + A00 * B08)
	buffer.writef64(Buf, 72, A09 * B00 + A08 * B01 + A07 * B02 + A06 * B03 + A05 * B04 + A04 * B05 + A03 * B06 + A02 * B07 + A01 * B08 + A00 * B09)
	buffer.writef64(Buf, 80, A10 * B00 + A09 * B01 + A08 * B02 + A07 * B03 + A06 * B04 + A05 * B05 + A04 * B06 + A03 * B07 + A02 * B08 + A01 * B09 + A00 * B10)

	return MultiPrecision.Carry(Buf, Buf)
end

function MultiPrecision.Mul(NumberA, NumberB, LowStorage, HighStorage)
	local LowResult = MultiPrecision.LMul(NumberA, NumberB, LowStorage)
	local Overflow = buffer.readf64(LowResult, CARRY)

	local A01, A02, A03, A04, A05, A06, A07, A08, A09, A10 =
		buffer.readf64(NumberA, 8), buffer.readf64(NumberA, 16),
		buffer.readf64(NumberA, 24), buffer.readf64(NumberA, 32),
		buffer.readf64(NumberA, 40), buffer.readf64(NumberA, 48),
		buffer.readf64(NumberA, 56), buffer.readf64(NumberA, 64),
		buffer.readf64(NumberA, 72), buffer.readf64(NumberA, 80)

	local B01, B02, B03, B04, B05, B06, B07, B08, B09, B10 =
		buffer.readf64(NumberB, 8), buffer.readf64(NumberB, 16),
		buffer.readf64(NumberB, 24), buffer.readf64(NumberB, 32),
		buffer.readf64(NumberB, 40), buffer.readf64(NumberB, 48),
		buffer.readf64(NumberB, 56), buffer.readf64(NumberB, 64),
		buffer.readf64(NumberB, 72), buffer.readf64(NumberB, 80)

	local Buf = HighStorage or buffer.create(SIZE)

	buffer.writef64(Buf, 0, Overflow + A10 * B01 + A09 * B02 + A08 * B03 + A07 * B04 + A06 * B05 + A05 * B06 + A04 * B07 + A03 * B08 + A02 * B09 + A01 * B10)
	buffer.writef64(Buf, 8, A10 * B02 + A09 * B03 + A08 * B04 + A07 * B05 + A06 * B06 + A05 * B07 + A04 * B08 + A03 * B09 + A02 * B10)
	buffer.writef64(Buf, 16, A10 * B03 + A09 * B04 + A08 * B05 + A07 * B06 + A06 * B07 + A05 * B08 + A04 * B09 + A03 * B10)
	buffer.writef64(Buf, 24, A10 * B04 + A09 * B05 + A08 * B06 + A07 * B07 + A06 * B08 + A05 * B09 + A04 * B10)
	buffer.writef64(Buf, 32, A10 * B05 + A09 * B06 + A08 * B07 + A07 * B08 + A06 * B09 + A05 * B10)
	buffer.writef64(Buf, 40, A10 * B06 + A09 * B07 + A08 * B08 + A07 * B09 + A06 * B10)
	buffer.writef64(Buf, 48, A10 * B07 + A09 * B08 + A08 * B09 + A07 * B10)
	buffer.writef64(Buf, 56, A10 * B08 + A09 * B09 + A08 * B10)
	buffer.writef64(Buf, 64, A10 * B09 + A09 * B10)
	buffer.writef64(Buf, 72, A10 * B10)
	buffer.writef64(Buf, 80, 0)

	return LowResult, MultiPrecision.Carry(Buf, Buf)
end

function MultiPrecision.DWAdd(NumberA0, NumberA1, NumberB0, NumberB1, LowStorage, HighStorage)
	local LowSum = MultiPrecision.Carry(MultiPrecision.Add(NumberA0, NumberB0, LowStorage), LowStorage)
	local CarryOut = buffer.readf64(LowSum, CARRY)

	local HighSum = MultiPrecision.Add(NumberA1, NumberB1, HighStorage)
	buffer.writef64(HighSum, 0, buffer.readf64(HighSum, 0) + CarryOut)
	local Carried = MultiPrecision.Carry(HighSum, HighSum)

	return LowSum, Carried, buffer.readf64(Carried, CARRY)
end

function MultiPrecision.Half(NumberA, Storage)
	local A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10 =
		buffer.readf64(NumberA, 0),
		buffer.readf64(NumberA, 8),
		buffer.readf64(NumberA, 16),
		buffer.readf64(NumberA, 24),
		buffer.readf64(NumberA, 32),
		buffer.readf64(NumberA, 40),
		buffer.readf64(NumberA, 48),
		buffer.readf64(NumberA, 56),
		buffer.readf64(NumberA, 64),
		buffer.readf64(NumberA, 72),
		buffer.readf64(NumberA, 80)

	local Buf = Storage or buffer.create(SIZE)

	buffer.writef64(Buf, 0, A00 * 0.5 + A01 * 2 ^ 23)
	buffer.writef64(Buf, 8, A02 * 2 ^ 23)
	buffer.writef64(Buf, 16, A03 * 2 ^ 23)
	buffer.writef64(Buf, 24, A04 * 2 ^ 23)
	buffer.writef64(Buf, 32, A05 * 2 ^ 23)
	buffer.writef64(Buf, 40, A06 * 2 ^ 23)
	buffer.writef64(Buf, 48, A07 * 2 ^ 23)
	buffer.writef64(Buf, 56, A08 * 2 ^ 23)
	buffer.writef64(Buf, 64, A09 * 2 ^ 23)
	buffer.writef64(Buf, 72, A10 * 2 ^ 23)
	buffer.writef64(Buf, 80, 0)

	return MultiPrecision.CarryWeak(Buf, Buf)
end

function MultiPrecision.Third(NumberA, Storage)
	local A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10 =
		buffer.readf64(NumberA, 0),
		buffer.readf64(NumberA, 8),
		buffer.readf64(NumberA, 16),
		buffer.readf64(NumberA, 24),
		buffer.readf64(NumberA, 32),
		buffer.readf64(NumberA, 40),
		buffer.readf64(NumberA, 48),
		buffer.readf64(NumberA, 56),
		buffer.readf64(NumberA, 64),
		buffer.readf64(NumberA, 72),
		buffer.readf64(NumberA, 80)

	local Division00 = A00 * 0xaaaaaa
	local Division01 = A01 * 0xaaaaaa + Division00
	local Division02 = A02 * 0xaaaaaa + Division01
	local Division03 = A03 * 0xaaaaaa + Division02
	local Division04 = A04 * 0xaaaaaa + Division03
	local Division05 = A05 * 0xaaaaaa + Division04
	local Division06 = A06 * 0xaaaaaa + Division05
	local Division07 = A07 * 0xaaaaaa + Division06
	local Division08 = A08 * 0xaaaaaa + Division07
	local Division09 = A09 * 0xaaaaaa + Division08
	local Division10 = A10 * 0xaaaaaa + Division09

	local Buf = Storage or buffer.create(SIZE)

	buffer.writef64(Buf, 0, A00 + Division00)
	buffer.writef64(Buf, 8, A01 + Division01)
	buffer.writef64(Buf, 16, A02 + Division02)
	buffer.writef64(Buf, 24, A03 + Division03)
	buffer.writef64(Buf, 32, A04 + Division04)
	buffer.writef64(Buf, 40, A05 + Division05)
	buffer.writef64(Buf, 48, A06 + Division06)
	buffer.writef64(Buf, 56, A07 + Division07)
	buffer.writef64(Buf, 64, A08 + Division08)
	buffer.writef64(Buf, 72, A09 + Division09)
	buffer.writef64(Buf, 80, A10 + Division10)

	return MultiPrecision.CarryWeak(Buf, Buf)
end

function MultiPrecision.Mod2(NumberA)
	return buffer.readf64(NumberA, 0) % 2
end

function MultiPrecision.Mod3(NumberA)
	return (
		buffer.readf64(NumberA, 0) +
			buffer.readf64(NumberA, 8) +
			buffer.readf64(NumberA, 16) +
			buffer.readf64(NumberA, 24) +
			buffer.readf64(NumberA, 32) +
			buffer.readf64(NumberA, 40) +
			buffer.readf64(NumberA, 48) +
			buffer.readf64(NumberA, 56) +
			buffer.readf64(NumberA, 64) +
			buffer.readf64(NumberA, 72) +
			buffer.readf64(NumberA, 80)
	) % 3
end

function MultiPrecision.Approx(NumberA)
	return buffer.readf64(NumberA, 0)
		+ buffer.readf64(NumberA, 8) * 2 ^ 24
		+ buffer.readf64(NumberA, 16) * 2 ^ 48
		+ buffer.readf64(NumberA, 24) * 2 ^ 72
		+ buffer.readf64(NumberA, 32) * 2 ^ 96
		+ buffer.readf64(NumberA, 40) * 2 ^ 120
		+ buffer.readf64(NumberA, 48) * 2 ^ 144
		+ buffer.readf64(NumberA, 56) * 2 ^ 168
		+ buffer.readf64(NumberA, 64) * 2 ^ 192
		+ buffer.readf64(NumberA, 72) * 2 ^ 216
		+ buffer.readf64(NumberA, 80) * 2 ^ 240
end

function MultiPrecision.Cmp(NumberA, NumberB)
	return MultiPrecision.Approx(MultiPrecision.Sub(NumberA, NumberB))
end

function MultiPrecision.Num(RegularNumber)
	local Buf = buffer.create(SIZE)
	buffer.writef64(Buf, 0, RegularNumber)

	return Buf
end

return MultiPrecision

end)()
local FieldPrime = (function()
--[=[
	Cryptography library: Field Prime (Curve25519 Base Field)

	Return type: varies by function
	Example usage:
		local FieldPrime = require("FieldPrime")

		--------Usage Case 1: Basic arithmetic--------
		local ElementA = FieldPrime.Num(42)
		local ElementB = FieldPrime.Num(17)
		local Sum = FieldPrime.Add(ElementA, ElementB)
		local Product = FieldPrime.Mul(ElementA, ElementB)

		--------Usage Case 2: Encoding/decoding--------
		local Encoded = FieldPrime.Encode(ElementA)
		local Decoded = FieldPrime.Decode(Encoded)
--]=]

--!strict
--!optimize 2
--!native

local SIZE = 104
local COMPOUND_V = (19 / 2 ^ 255)
local SQUARES = buffer.create(SIZE) do
	local Tbl = {
		0958640 * 2 ^ 0,
		0826664 * 2 ^ 22,
		1613251 * 2 ^ 43,
		1041528 * 2 ^ 64,
		0013673 * 2 ^ 85,
		0387171 * 2 ^ 107,
		1824679 * 2 ^ 128,
		0313839 * 2 ^ 149,
		0709440 * 2 ^ 170,
		0122635 * 2 ^ 192,
		0262782 * 2 ^ 213,
		0712905 * 2 ^ 234,
	}

	for Index = 1, 12 do
		buffer.writef64(SQUARES, (Index - 1) * 8, Tbl[Index])
	end
end

local FieldPrime = {}

function FieldPrime.Num(Number)
	local Buf = buffer.create(SIZE)
	buffer.writef64(Buf, 0, Number)

	return Buf
end

function FieldPrime.Neg(ElementA)
	local A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11 =
		buffer.readf64(ElementA, 0), buffer.readf64(ElementA, 8),
		buffer.readf64(ElementA, 16), buffer.readf64(ElementA, 24),
		buffer.readf64(ElementA, 32), buffer.readf64(ElementA, 40),
		buffer.readf64(ElementA, 48), buffer.readf64(ElementA, 56),
		buffer.readf64(ElementA, 64), buffer.readf64(ElementA, 72),
		buffer.readf64(ElementA, 80), buffer.readf64(ElementA, 88)

	local Buf = buffer.create(SIZE)

	buffer.writef64(Buf, 0, -A00)
	buffer.writef64(Buf, 8, -A01)
	buffer.writef64(Buf, 16, -A02)
	buffer.writef64(Buf, 24, -A03)
	buffer.writef64(Buf, 32, -A04)
	buffer.writef64(Buf, 40, -A05)
	buffer.writef64(Buf, 48, -A06)
	buffer.writef64(Buf, 56, -A07)
	buffer.writef64(Buf, 64, -A08)
	buffer.writef64(Buf, 72, -A09)
	buffer.writef64(Buf, 80, -A10)
	buffer.writef64(Buf, 88, -A11)

	return Buf
end

function FieldPrime.Add(ElementA, ElementB, Storage)
	local A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11 =
		buffer.readf64(ElementA, 0), buffer.readf64(ElementA, 8),
		buffer.readf64(ElementA, 16), buffer.readf64(ElementA, 24),
		buffer.readf64(ElementA, 32), buffer.readf64(ElementA, 40),
		buffer.readf64(ElementA, 48), buffer.readf64(ElementA, 56),
		buffer.readf64(ElementA, 64), buffer.readf64(ElementA, 72),
		buffer.readf64(ElementA, 80), buffer.readf64(ElementA, 88)

	local B00, B01, B02, B03, B04, B05, B06, B07, B08, B09, B10, B11 =
		buffer.readf64(ElementB, 0), buffer.readf64(ElementB, 8),
		buffer.readf64(ElementB, 16), buffer.readf64(ElementB, 24),
		buffer.readf64(ElementB, 32), buffer.readf64(ElementB, 40),
		buffer.readf64(ElementB, 48), buffer.readf64(ElementB, 56),
		buffer.readf64(ElementB, 64), buffer.readf64(ElementB, 72),
		buffer.readf64(ElementB, 80), buffer.readf64(ElementB, 88)

	local Buf = Storage or buffer.create(SIZE)

	buffer.writef64(Buf, 0, A00 + B00)
	buffer.writef64(Buf, 8, A01 + B01)
	buffer.writef64(Buf, 16, A02 + B02)
	buffer.writef64(Buf, 24, A03 + B03)
	buffer.writef64(Buf, 32, A04 + B04)
	buffer.writef64(Buf, 40, A05 + B05)
	buffer.writef64(Buf, 48, A06 + B06)
	buffer.writef64(Buf, 56, A07 + B07)
	buffer.writef64(Buf, 64, A08 + B08)
	buffer.writef64(Buf, 72, A09 + B09)
	buffer.writef64(Buf, 80, A10 + B10)
	buffer.writef64(Buf, 88, A11 + B11)

	return Buf
end

function FieldPrime.Sub(ElementA, ElementB, Storage)
	local A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11 =
		buffer.readf64(ElementA, 0), buffer.readf64(ElementA, 8),
		buffer.readf64(ElementA, 16), buffer.readf64(ElementA, 24),
		buffer.readf64(ElementA, 32), buffer.readf64(ElementA, 40),
		buffer.readf64(ElementA, 48), buffer.readf64(ElementA, 56),
		buffer.readf64(ElementA, 64), buffer.readf64(ElementA, 72),
		buffer.readf64(ElementA, 80), buffer.readf64(ElementA, 88)

	local B00, B01, B02, B03, B04, B05, B06, B07, B08, B09, B10, B11 =
		buffer.readf64(ElementB, 0), buffer.readf64(ElementB, 8),
		buffer.readf64(ElementB, 16), buffer.readf64(ElementB, 24),
		buffer.readf64(ElementB, 32), buffer.readf64(ElementB, 40),
		buffer.readf64(ElementB, 48), buffer.readf64(ElementB, 56),
		buffer.readf64(ElementB, 64), buffer.readf64(ElementB, 72),
		buffer.readf64(ElementB, 80), buffer.readf64(ElementB, 88)

	local Buf = Storage or buffer.create(SIZE)

	buffer.writef64(Buf, 0, A00 - B00)
	buffer.writef64(Buf, 8, A01 - B01)
	buffer.writef64(Buf, 16, A02 - B02)
	buffer.writef64(Buf, 24, A03 - B03)
	buffer.writef64(Buf, 32, A04 - B04)
	buffer.writef64(Buf, 40, A05 - B05)
	buffer.writef64(Buf, 48, A06 - B06)
	buffer.writef64(Buf, 56, A07 - B07)
	buffer.writef64(Buf, 64, A08 - B08)
	buffer.writef64(Buf, 72, A09 - B09)
	buffer.writef64(Buf, 80, A10 - B10)
	buffer.writef64(Buf, 88, A11 - B11)

	return Buf
end

function FieldPrime.Carry(ElementA, Storage)
	local A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11 =
		buffer.readf64(ElementA, 0), buffer.readf64(ElementA, 8),
		buffer.readf64(ElementA, 16), buffer.readf64(ElementA, 24),
		buffer.readf64(ElementA, 32), buffer.readf64(ElementA, 40),
		buffer.readf64(ElementA, 48), buffer.readf64(ElementA, 56),
		buffer.readf64(ElementA, 64), buffer.readf64(ElementA, 72),
		buffer.readf64(ElementA, 80), buffer.readf64(ElementA, 88)

	local C00, C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11

	C11 = A11 + 3 * 2 ^ 306 - 3 * 2 ^ 306
	A00 = A00 + (19 / 2 ^ 255 * C11)

	C00 = A00 + 3 * 2 ^ 73 - 3 * 2 ^ 73
	A01 = A01 + (C00)
	C01 = A01 + 3 * 2 ^ 94 - 3 * 2 ^ 94
	A02 = A02 + (C01)
	C02 = A02 + 3 * 2 ^ 115 - 3 * 2 ^ 115
	A03 = A03 + (C02)
	C03 = A03 + 3 * 2 ^ 136 - 3 * 2 ^ 136
	A04 = A04 + (C03)
	C04 = A04 + 3 * 2 ^ 158 - 3 * 2 ^ 158
	A05 = A05 + (C04)
	C05 = A05 + 3 * 2 ^ 179 - 3 * 2 ^ 179
	A06 = A06 + (C05)
	C06 = A06 + 3 * 2 ^ 200 - 3 * 2 ^ 200
	A07 = A07 + (C06)
	C07 = A07 + 3 * 2 ^ 221 - 3 * 2 ^ 221
	A08 = A08 + (C07)
	C08 = A08 + 3 * 2 ^ 243 - 3 * 2 ^ 243
	A09 = A09 + (C08)
	C09 = A09 + 3 * 2 ^ 264 - 3 * 2 ^ 264
	A10 = A10 + (C09)
	C10 = A10 + 3 * 2 ^ 285 - 3 * 2 ^ 285
	A11 = A11 - C11 + C10

	C11 = A11 + 3 * 2 ^ 306 - 3 * 2 ^ 306

	local Buf = Storage or buffer.create(SIZE)

	buffer.writef64(Buf, 0, A00 - C00 + 19 / 2 ^ 255 * C11)
	buffer.writef64(Buf, 8, A01 - C01)
	buffer.writef64(Buf, 16, A02 - C02)
	buffer.writef64(Buf, 24, A03 - C03)
	buffer.writef64(Buf, 32, A04 - C04)
	buffer.writef64(Buf, 40, A05 - C05)
	buffer.writef64(Buf, 48, A06 - C06)
	buffer.writef64(Buf, 56, A07 - C07)
	buffer.writef64(Buf, 64, A08 - C08)
	buffer.writef64(Buf, 72, A09 - C09)
	buffer.writef64(Buf, 80, A10 - C10)
	buffer.writef64(Buf, 88, A11 - C11)

	return Buf
end

function FieldPrime.Canonicalize(ElementA, Storage)
	local A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11 =
		buffer.readf64(ElementA, 0), buffer.readf64(ElementA, 8),
		buffer.readf64(ElementA, 16), buffer.readf64(ElementA, 24),
		buffer.readf64(ElementA, 32), buffer.readf64(ElementA, 40),
		buffer.readf64(ElementA, 48), buffer.readf64(ElementA, 56),
		buffer.readf64(ElementA, 64), buffer.readf64(ElementA, 72),
		buffer.readf64(ElementA, 80), buffer.readf64(ElementA, 88)

	local C00, C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11

	C00 = A00 % 2 ^ 22
	A01 = A01 + (A00 - C00)
	C01 = A01 % 2 ^ 43
	A02 = A02 + (A01 - C01)
	C02 = A02 % 2 ^ 64
	A03 = A03 + (A02 - C02)
	C03 = A03 % 2 ^ 85
	A04 = A04 + (A03 - C03)
	C04 = A04 % 2 ^ 107
	A05 = A05 + (A04 - C04)
	C05 = A05 % 2 ^ 128
	A06 = A06 + (A05 - C05)
	C06 = A06 % 2 ^ 149
	A07 = A07 + (A06 - C06)
	C07 = A07 % 2 ^ 170
	A08 = A08 + (A07 - C07)
	C08 = A08 % 2 ^ 192
	A09 = A09 + (A08 - C08)
	C09 = A09 % 2 ^ 213
	A10 = A10 + (A09 - C09)
	C10 = A10 % 2 ^ 234
	A11 = A11 + (A10 - C10)
	C11 = A11 % 2 ^ 255
	C00 = C00 + (19 / 2 ^ 255 * (A11 - C11))

	local Buf = Storage or buffer.create(SIZE)
	if C11 / 2 ^ 234 == 2 ^ 21 - 1
		and C10 / 2 ^ 213 == 2 ^ 21 - 1
		and C09 / 2 ^ 192 == 2 ^ 21 - 1
		and C08 / 2 ^ 170 == 2 ^ 22 - 1
		and C07 / 2 ^ 149 == 2 ^ 21 - 1
		and C06 / 2 ^ 128 == 2 ^ 21 - 1
		and C05 / 2 ^ 107 == 2 ^ 21 - 1
		and C04 / 2 ^ 85 == 2 ^ 22 - 1
		and C03 / 2 ^ 64 == 2 ^ 21 - 1
		and C02 / 2 ^ 43 == 2 ^ 21 - 1
		and C01 / 2 ^ 22 == 2 ^ 21 - 1
		and C00 >= 2 ^ 22 - 19
	then
		buffer.writef64(Buf, 0, 19 - 2 ^ 22 + C00)
		for Index = 8, 88, 8 do
			buffer.writef64(Buf, Index, 0)
		end
	else
		buffer.writef64(Buf, 0, C00)
		buffer.writef64(Buf, 8, C01)
		buffer.writef64(Buf, 16, C02)
		buffer.writef64(Buf, 24, C03)
		buffer.writef64(Buf, 32, C04)
		buffer.writef64(Buf, 40, C05)
		buffer.writef64(Buf, 48, C06)
		buffer.writef64(Buf, 56, C07)
		buffer.writef64(Buf, 64, C08)
		buffer.writef64(Buf, 72, C09)
		buffer.writef64(Buf, 80, C10)
		buffer.writef64(Buf, 88, C11)
	end

	return Buf
end

function FieldPrime.Eq(ElementA, ElementB)
	local Difference = FieldPrime.Canonicalize(FieldPrime.Sub(ElementA, ElementB))
	local DifferenceAccumulator = 0
	for LimbIndex = 0, 88, 8 do
		local LimbLow = buffer.readu32(Difference, LimbIndex)
		local LimbHigh = buffer.readu32(Difference, LimbIndex + 4)
		DifferenceAccumulator = bit32.bor(DifferenceAccumulator, LimbLow, LimbHigh)
	end

	return DifferenceAccumulator == 0
end

local A00, A01, A02, A03, A04, A05, A06,
A07, A08, A09, A10, A11
local B00, B01, B02, B03, B04, B05, B06,
B07, B08, B09, B10, B11

function FieldPrime.Mul(ElementA, ElementB, Storage)
	local CompoundV = COMPOUND_V
	A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11 =
		buffer.readf64(ElementA, 0), buffer.readf64(ElementA, 8),
		buffer.readf64(ElementA, 16), buffer.readf64(ElementA, 24),
		buffer.readf64(ElementA, 32), buffer.readf64(ElementA, 40),
		buffer.readf64(ElementA, 48), buffer.readf64(ElementA, 56),
		buffer.readf64(ElementA, 64), buffer.readf64(ElementA, 72),
		buffer.readf64(ElementA, 80), buffer.readf64(ElementA, 88)

	B00, B01, B02, B03, B04, B05, B06, B07, B08, B09, B10, B11 =
		buffer.readf64(ElementB, 0), buffer.readf64(ElementB, 8),
		buffer.readf64(ElementB, 16), buffer.readf64(ElementB, 24),
		buffer.readf64(ElementB, 32), buffer.readf64(ElementB, 40),
		buffer.readf64(ElementB, 48), buffer.readf64(ElementB, 56),
		buffer.readf64(ElementB, 64), buffer.readf64(ElementB, 72),
		buffer.readf64(ElementB, 80), buffer.readf64(ElementB, 88)

	local T00, T01, T02, T03, T04, T05, T06,
	T07, T08, T09, T10, T11 =
		A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11

	local U00, U01, U02, U03, U04, U05, U06,
	U07, U08, U09, U10, U11 =
		B00, B01, B02, B03, B04, B05, B06, B07, B08, B09, B10, B11

	local C00 = T11 * U01
		+ T10 * U02
		+ T09 * U03
		+ T08 * U04
		+ T07 * U05
		+ T06 * U06
		+ T05 * U07
		+ T04 * U08
		+ T03 * U09
		+ T02 * U10
		+ T01 * U11

	local C01 = T11 * U02
		+ T10 * U03
		+ T09 * U04
		+ T08 * U05
		+ T07 * U06
		+ T06 * U07
		+ T05 * U08
		+ T04 * U09
		+ T03 * U10
		+ T02 * U11

	local C02 = T11 * U03
		+ T10 * U04
		+ T09 * U05
		+ T08 * U06
		+ T07 * U07
		+ T06 * U08
		+ T05 * U09
		+ T04 * U10
		+ T03 * U11

	local C03 = T11 * U04
		+ T10 * U05
		+ T09 * U06
		+ T08 * U07
		+ T07 * U08
		+ T06 * U09
		+ T05 * U10
		+ T04 * U11

	local C04 = T11 * U05
		+ T10 * U06
		+ T09 * U07
		+ T08 * U08
		+ T07 * U09
		+ T06 * U10
		+ T05 * U11

	local C05 = T11 * U06
		+ T10 * U07
		+ T09 * U08
		+ T08 * U09
		+ T07 * U10
		+ T06 * U11

	local C06 = T11 * U07
		+ T10 * U08
		+ T09 * U09
		+ T08 * U10
		+ T07 * U11

	local C07 = T11 * U08
		+ T10 * U09
		+ T09 * U10
		+ T08 * U11

	local C08 = T11 * U09
		+ T10 * U10
		+ T09 * U11

	local C09 = T11 * U10 + T10 * U11
	local C10 = T11 * U11

	C00 = C00 * (CompoundV)
	C00 = C00 + (T00 * U00)

	C01 = C01 * (CompoundV)
	C01 = C01 + (T01 * U00)
		+ T00 * U01

	C02 = C02 * (CompoundV)
	C02 = C02 + (T02 * U00)
		+ T01 * U01
		+ T00 * U02

	C03 = C03 * (CompoundV)
	C03 = C03 + (T03 * U00)
		+ T02 * U01
		+ T01 * U02
		+ T00 * U03

	C04 = C04 * (CompoundV)
	C04 = C04 + (T04 * U00)
		+ T03 * U01
		+ T02 * U02
		+ T01 * U03
		+ T00 * U04

	C05 = C05 * (CompoundV)
	C05 = C05 + (T05 * U00)
		+ T04 * U01
		+ T03 * U02
		+ T02 * U03
		+ T01 * U04
		+ T00 * U05

	C06 = C06 * (CompoundV)
	C06 = C06 + (T06 * U00)
		+ T05 * U01
		+ T04 * U02
		+ T03 * U03
		+ T02 * U04
		+ T01 * U05
		+ T00 * U06

	C07 = C07 * (CompoundV)
	C07 = C07 + (T07 * U00)
		+ T06 * U01
		+ T05 * U02
		+ T04 * U03
		+ T03 * U04
		+ T02 * U05
		+ T01 * U06
		+ T00 * U07

	C08 = C08 * (CompoundV)
	C08 = C08 + (T08 * U00)
		+ T07 * U01
		+ T06 * U02
		+ T05 * U03
		+ T04 * U04
		+ T03 * U05
		+ T02 * U06
		+ T01 * U07
		+ T00 * U08

	C09 = C09 * (CompoundV)
	C09 = C09 + (T09 * U00)
		+ T08 * U01
		+ T07 * U02
		+ T06 * U03
		+ T05 * U04
		+ T04 * U05
		+ T03 * U06
		+ T02 * U07
		+ T01 * U08
		+ T00 * U09

	C10 = C10 * (CompoundV)
	C10 = C10 + (T10 * U00)
		+ T09 * U01
		+ T08 * U02
		+ T07 * U03
		+ T06 * U04
		+ T05 * U05
		+ T04 * U06
		+ T03 * U07
		+ T02 * U08
		+ T01 * U09
		+ T00 * U10

	local C11 = T11 * U00
		+ T10 * U01
		+ T09 * U02
		+ T08 * U03
		+ T07 * U04
		+ T06 * U05
		+ T05 * U06
		+ T04 * U07
		+ T03 * U08
		+ T02 * U09
		+ T01 * U10
		+ T00 * U11

	T10 = C10 + 3 * 2 ^ 285 - 3 * 2 ^ 285
	C11 = C11 + (T10)
	T11 = C11 + 3 * 2 ^ 306 - 3 * 2 ^ 306
	C00 = C00 + (CompoundV * T11)

	T00 = C00 + 3 * 2 ^ 73 - 3 * 2 ^ 73
	C01 = C01 + (T00)
	T01 = C01 + 3 * 2 ^ 94 - 3 * 2 ^ 94
	C02 = C02 + (T01)
	T02 = C02 + 3 * 2 ^ 115 - 3 * 2 ^ 115
	C03 = C03 + (T02)
	T03 = C03 + 3 * 2 ^ 136 - 3 * 2 ^ 136
	C04 = C04 + (T03)
	T04 = C04 + 3 * 2 ^ 158 - 3 * 2 ^ 158
	C05 = C05 + (T04)
	T05 = C05 + 3 * 2 ^ 179 - 3 * 2 ^ 179
	C06 = C06 + (T05)
	T06 = C06 + 3 * 2 ^ 200 - 3 * 2 ^ 200
	C07 = C07 + (T06)
	T07 = C07 + 3 * 2 ^ 221 - 3 * 2 ^ 221
	C08 = C08 + (T07)
	T08 = C08 + 3 * 2 ^ 243 - 3 * 2 ^ 243
	C09 = C09 + (T08)
	T09 = C09 + 3 * 2 ^ 264 - 3 * 2 ^ 264
	C10 = C10 - T10 + T09
	T10 = C10 + 3 * 2 ^ 285 - 3 * 2 ^ 285
	C11 = C11 - T11 + T10

	T11 = C11 + 3 * 2 ^ 306 - 3 * 2 ^ 306

	local Buf = Storage or buffer.create(SIZE)

	buffer.writef64(Buf, 0, C00 - T00 + CompoundV * T11)
	buffer.writef64(Buf, 8, C01 - T01)
	buffer.writef64(Buf, 16, C02 - T02)
	buffer.writef64(Buf, 24, C03 - T03)
	buffer.writef64(Buf, 32, C04 - T04)
	buffer.writef64(Buf, 40, C05 - T05)
	buffer.writef64(Buf, 48, C06 - T06)
	buffer.writef64(Buf, 56, C07 - T07)
	buffer.writef64(Buf, 64, C08 - T08)
	buffer.writef64(Buf, 72, C09 - T09)
	buffer.writef64(Buf, 80, C10 - T10)
	buffer.writef64(Buf, 88, C11 - T11)

	return Buf
end

function FieldPrime.Square(ElementA, Storage)
	local A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11 =
		buffer.readf64(ElementA, 0), buffer.readf64(ElementA, 8),
		buffer.readf64(ElementA, 16), buffer.readf64(ElementA, 24),
		buffer.readf64(ElementA, 32), buffer.readf64(ElementA, 40),
		buffer.readf64(ElementA, 48), buffer.readf64(ElementA, 56),
		buffer.readf64(ElementA, 64), buffer.readf64(ElementA, 72),
		buffer.readf64(ElementA, 80), buffer.readf64(ElementA, 88)

	local D00 = A00 * 2
	local D01 = A01 * 2
	local D02 = A02 * 2
	local D03 = A03 * 2
	local D04 = A04 * 2
	local D05 = A05 * 2
	local D06 = A06 * 2
	local D07 = A07 * 2
	local D08 = A08 * 2
	local D09 = A09 * 2
	local D10 = A10 * 2

	local ReductionFactor = 19 / 2 ^ 255

	local H00 = A11 * D01 + A10 * D02 + A09 * D03 + A08 * D04 + A07 * D05 + A06 * A06
	local H01 = A11 * D02 + A10 * D03 + A09 * D04 + A08 * D05 + A07 * D06
	local H02 = A11 * D03 + A10 * D04 + A09 * D05 + A08 * D06 + A07 * A07
	local H03 = A11 * D04 + A10 * D05 + A09 * D06 + A08 * D07
	local H04 = A11 * D05 + A10 * D06 + A09 * D07 + A08 * A08
	local H05 = A11 * D06 + A10 * D07 + A09 * D08
	local H06 = A11 * D07 + A10 * D08 + A09 * A09
	local H07 = A11 * D08 + A10 * D09
	local H08 = A11 * D09 + A10 * A10
	local H09 = A11 * D10
	local H10 = A11 * A11

	local L00 = A00 * A00
	local L01 = A01 * D00
	local L02 = A02 * D00 + A01 * A01
	local L03 = A03 * D00 + A02 * D01
	local L04 = A04 * D00 + A03 * D01 + A02 * A02
	local L05 = A05 * D00 + A04 * D01 + A03 * D02
	local L06 = A06 * D00 + A05 * D01 + A04 * D02 + A03 * A03
	local L07 = A07 * D00 + A06 * D01 + A05 * D02 + A04 * D03
	local L08 = A08 * D00 + A07 * D01 + A06 * D02 + A05 * D03 + A04 * A04
	local L09 = A09 * D00 + A08 * D01 + A07 * D02 + A06 * D03 + A05 * D04
	local L10 = A10 * D00 + A09 * D01 + A08 * D02 + A07 * D03 + A06 * D04 + A05 * A05
	local L11 = A11 * D00 + A10 * D01 + A09 * D02 + A08 * D03 + A07 * D04 + A06 * D05

	local Result = Storage or buffer.create(SIZE)
	buffer.writef64(Result, 0, H00 * ReductionFactor + L00)
	buffer.writef64(Result, 8, H01 * ReductionFactor + L01)
	buffer.writef64(Result, 16, H02 * ReductionFactor + L02)
	buffer.writef64(Result, 24, H03 * ReductionFactor + L03)
	buffer.writef64(Result, 32, H04 * ReductionFactor + L04)
	buffer.writef64(Result, 40, H05 * ReductionFactor + L05)
	buffer.writef64(Result, 48, H06 * ReductionFactor + L06)
	buffer.writef64(Result, 56, H07 * ReductionFactor + L07)
	buffer.writef64(Result, 64, H08 * ReductionFactor + L08)
	buffer.writef64(Result, 72, H09 * ReductionFactor + L09)
	buffer.writef64(Result, 80, H10 * ReductionFactor + L10)
	buffer.writef64(Result, 88, L11)

	return FieldPrime.Carry(Result, Result)
end

function FieldPrime.KMul(ElementA, SmallK, Storage)
	local A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11 =
		buffer.readf64(ElementA, 0), buffer.readf64(ElementA, 8),
		buffer.readf64(ElementA, 16), buffer.readf64(ElementA, 24),
		buffer.readf64(ElementA, 32), buffer.readf64(ElementA, 40),
		buffer.readf64(ElementA, 48), buffer.readf64(ElementA, 56),
		buffer.readf64(ElementA, 64), buffer.readf64(ElementA, 72),
		buffer.readf64(ElementA, 80), buffer.readf64(ElementA, 88)

	local C00, C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11

	A00 = A00 * (SmallK)
	A01 = A01 * (SmallK)
	A02 = A02 * (SmallK)
	A03 = A03 * (SmallK)
	A04 = A04 * (SmallK)
	A05 = A05 * (SmallK)
	A06 = A06 * (SmallK)
	A07 = A07 * (SmallK)
	A08 = A08 * (SmallK)
	A09 = A09 * (SmallK)
	A10 = A10 * (SmallK)
	A11 = A11 * (SmallK)

	C11 = A11 + 3 * 2 ^ 306 - 3 * 2 ^ 306
	A00 = A00 + (19 / 2 ^ 255 * C11)

	C00 = A00 + 3 * 2 ^ 73 - 3 * 2 ^ 73
	A01 = A01 + (C00)
	C01 = A01 + 3 * 2 ^ 94 - 3 * 2 ^ 94
	A02 = A02 + (C01)
	C02 = A02 + 3 * 2 ^ 115 - 3 * 2 ^ 115
	A03 = A03 + (C02)
	C03 = A03 + 3 * 2 ^ 136 - 3 * 2 ^ 136
	A04 = A04 + (C03)
	C04 = A04 + 3 * 2 ^ 158 - 3 * 2 ^ 158
	A05 = A05 + (C04)
	C05 = A05 + 3 * 2 ^ 179 - 3 * 2 ^ 179
	A06 = A06 + (C05)
	C06 = A06 + 3 * 2 ^ 200 - 3 * 2 ^ 200
	A07 = A07 + (C06)
	C07 = A07 + 3 * 2 ^ 221 - 3 * 2 ^ 221
	A08 = A08 + (C07)
	C08 = A08 + 3 * 2 ^ 243 - 3 * 2 ^ 243
	A09 = A09 + (C08)
	C09 = A09 + 3 * 2 ^ 264 - 3 * 2 ^ 264
	A10 = A10 + (C09)
	C10 = A10 + 3 * 2 ^ 285 - 3 * 2 ^ 285
	A11 = A11 - C11 + C10

	C11 = A11 + 3 * 2 ^ 306 - 3 * 2 ^ 306

	local Buf = Storage or buffer.create(SIZE)

	buffer.writef64(Buf, 0, A00 - C00 + 19 / 2 ^ 255 * C11)
	buffer.writef64(Buf, 8, A01 - C01)
	buffer.writef64(Buf, 16, A02 - C02)
	buffer.writef64(Buf, 24, A03 - C03)
	buffer.writef64(Buf, 32, A04 - C04)
	buffer.writef64(Buf, 40, A05 - C05)
	buffer.writef64(Buf, 48, A06 - C06)
	buffer.writef64(Buf, 56, A07 - C07)
	buffer.writef64(Buf, 64, A08 - C08)
	buffer.writef64(Buf, 72, A09 - C09)
	buffer.writef64(Buf, 80, A10 - C10)
	buffer.writef64(Buf, 88, A11 - C11)

	return Buf
end

function FieldPrime.NSquare(ElementA, SquareCount, StoreInBuffer)
	local Square = FieldPrime.Square
	if StoreInBuffer then
		for _ = 1, SquareCount do
			Square(ElementA, ElementA)
		end

		return ElementA
	else
		for _ = 1, SquareCount do
			ElementA = Square(ElementA)
		end

		return ElementA
	end
end

function FieldPrime.Invert(ElementA, Storage)
	local Mul = FieldPrime.Mul

	local A2 = FieldPrime.Square(ElementA)
	local A9 = Mul(ElementA, FieldPrime.NSquare(A2, 2))
	local A11 = Mul(A9, A2)

	local X5 = Mul(FieldPrime.Square(A11), A9)
	local X10 = Mul(FieldPrime.NSquare(X5, 5), X5)
	local X20 = Mul(FieldPrime.NSquare(X10, 10), X10)
	local X40 = Mul(FieldPrime.NSquare(X20, 20), X20)
	local X50 = Mul(FieldPrime.NSquare(X40, 10), X10)
	local X100 = Mul(FieldPrime.NSquare(X50, 50), X50)
	local X200 = Mul(FieldPrime.NSquare(X100, 100), X100)
	local X250 = Mul(FieldPrime.NSquare(X200, 50), X50)

	return Mul(FieldPrime.NSquare(X250, 5), A11, Storage)
end

function FieldPrime.SqrtDiv(ElementU, ElementV)
	local Mul = FieldPrime.Mul
	local Square = FieldPrime.Square
	local Carry = FieldPrime.Carry

	Carry(ElementU, ElementU)

	local V2 = Square(ElementV)
	local V3 = Mul(ElementV, V2)
	local UV3 = Mul(ElementU, V3)
	local V4 = Square(V2)
	local UV7 = Mul(UV3, V4)

	local X2 = Mul(Square(UV7), UV7)
	local X4 = Mul(FieldPrime.NSquare(X2, 2), X2)
	local X8 = Mul(FieldPrime.NSquare(X4, 4), X4)
	local X16 = Mul(FieldPrime.NSquare(X8, 8), X8)
	local X18 = Mul(FieldPrime.NSquare(X16, 2), X2)
	local X32 = Mul(FieldPrime.NSquare(X16, 16), X16)
	local X50 = Mul(FieldPrime.NSquare(X32, 18), X18)
	local X100 = Mul(FieldPrime.NSquare(X50, 50), X50)
	local X200 = Mul(FieldPrime.NSquare(X100, 100), X100)
	local X250 = Mul(FieldPrime.NSquare(X200, 50), X50)
	local PowerResult = Mul(FieldPrime.NSquare(X250, 2), UV7)

	local CandidateB = Mul(UV3, PowerResult)
	local B2 = Square(CandidateB)
	local VB2 = Mul(ElementV, B2)

	if not FieldPrime.Eq(VB2, ElementU) then
		CandidateB = Mul(CandidateB, SQUARES)
		B2 = Square(CandidateB)
		VB2 = Mul(ElementV, B2)
	end

	if FieldPrime.Eq(VB2, ElementU) then
		return CandidateB
	else
		return nil
	end
end

function FieldPrime.Encode(ElementA)
	ElementA = FieldPrime.Canonicalize(ElementA)
	local A00, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11 =
		buffer.readf64(ElementA, 0), buffer.readf64(ElementA, 8),
		buffer.readf64(ElementA, 16), buffer.readf64(ElementA, 24),
		buffer.readf64(ElementA, 32), buffer.readf64(ElementA, 40),
		buffer.readf64(ElementA, 48), buffer.readf64(ElementA, 56),
		buffer.readf64(ElementA, 64), buffer.readf64(ElementA, 72),
		buffer.readf64(ElementA, 80), buffer.readf64(ElementA, 88)

	local Buf = buffer.create(32)
	local ByteIndex = 0
	local Accumulator = A00

	local Byte0 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte0)
	Accumulator = (Accumulator - Byte0) / 256
	ByteIndex = ByteIndex + (1)

	local Byte1 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte1)
	Accumulator = (Accumulator - Byte1) / 256
	ByteIndex = ByteIndex + (1)

	Accumulator = Accumulator + (A01 / 2 ^ 16)

	Byte0 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte0)
	Accumulator = (Accumulator - Byte0) / 256
	ByteIndex = ByteIndex + (1)

	Byte1 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte1)
	Accumulator = (Accumulator - Byte1) / 256
	ByteIndex = ByteIndex + (1)

	local Byte2 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte2)
	Accumulator = (Accumulator - Byte2) / 256
	ByteIndex = ByteIndex + (1)

	Accumulator = Accumulator + (A02 / 2 ^ 40)

	Byte0 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte0)
	Accumulator = (Accumulator - Byte0) / 256
	ByteIndex = ByteIndex + (1)

	Byte1 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte1)
	Accumulator = (Accumulator - Byte1) / 256
	ByteIndex = ByteIndex + (1)

	Byte2 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte2)
	Accumulator = (Accumulator - Byte2) / 256
	ByteIndex = ByteIndex + (1)

	Accumulator = Accumulator + (A03 / 2 ^ 64)

	Byte0 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte0)
	Accumulator = (Accumulator - Byte0) / 256
	ByteIndex = ByteIndex + (1)

	Byte1 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte1)
	Accumulator = (Accumulator - Byte1) / 256
	ByteIndex = ByteIndex + (1)

	Accumulator = Accumulator + (A04 / 2 ^ 80)

	Byte0 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte0)
	Accumulator = (Accumulator - Byte0) / 256
	ByteIndex = ByteIndex + (1)

	Byte1 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte1)
	Accumulator = (Accumulator - Byte1) / 256
	ByteIndex = ByteIndex + (1)

	Byte2 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte2)
	Accumulator = (Accumulator - Byte2) / 256
	ByteIndex = ByteIndex + (1)

	Accumulator = Accumulator + (A05 / 2 ^ 104)

	Byte0 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte0)
	Accumulator = (Accumulator - Byte0) / 256
	ByteIndex = ByteIndex + (1)

	Byte1 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte1)
	Accumulator = (Accumulator - Byte1) / 256
	ByteIndex = ByteIndex + (1)

	Byte2 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte2)
	Accumulator = (Accumulator - Byte2) / 256
	ByteIndex = ByteIndex + (1)

	Accumulator = Accumulator + (A06 / 2 ^ 128)

	Byte0 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte0)
	Accumulator = (Accumulator - Byte0) / 256
	ByteIndex = ByteIndex + (1)

	Byte1 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte1)
	Accumulator = (Accumulator - Byte1) / 256
	ByteIndex = ByteIndex + (1)

	Accumulator = Accumulator + (A07 / 2 ^ 144)

	Byte0 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte0)
	Accumulator = (Accumulator - Byte0) / 256
	ByteIndex = ByteIndex + (1)

	Byte1 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte1)
	Accumulator = (Accumulator - Byte1) / 256
	ByteIndex = ByteIndex + (1)

	Byte2 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte2)
	Accumulator = (Accumulator - Byte2) / 256
	ByteIndex = ByteIndex + (1)

	Accumulator = Accumulator + (A08 / 2 ^ 168)

	Byte0 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte0)
	Accumulator = (Accumulator - Byte0) / 256
	ByteIndex = ByteIndex + (1)

	Byte1 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte1)
	Accumulator = (Accumulator - Byte1) / 256
	ByteIndex = ByteIndex + (1)

	Byte2 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte2)
	Accumulator = (Accumulator - Byte2) / 256
	ByteIndex = ByteIndex + (1)

	Accumulator = Accumulator + (A09 / 2 ^ 192)

	Byte0 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte0)
	Accumulator = (Accumulator - Byte0) / 256
	ByteIndex = ByteIndex + (1)

	Byte1 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte1)
	Accumulator = (Accumulator - Byte1) / 256
	ByteIndex = ByteIndex + (1)

	Accumulator = Accumulator + (A10 / 2 ^ 208)

	Byte0 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte0)
	Accumulator = (Accumulator - Byte0) / 256
	ByteIndex = ByteIndex + (1)

	Byte1 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte1)
	Accumulator = (Accumulator - Byte1) / 256
	ByteIndex = ByteIndex + (1)

	Byte2 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte2)
	Accumulator = (Accumulator - Byte2) / 256
	ByteIndex = ByteIndex + (1)

	Accumulator = Accumulator + (A11 / 2 ^ 232)

	Byte0 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte0)
	Accumulator = (Accumulator - Byte0) / 256
	ByteIndex = ByteIndex + (1)

	Byte1 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte1)
	Accumulator = (Accumulator - Byte1) / 256
	ByteIndex = ByteIndex + (1)

	Byte2 = Accumulator % 256
	buffer.writeu8(Buf, ByteIndex, Byte2)

	return Buf
end

function FieldPrime.Decode(EncodedBytes)
	local B0, B1, B2 = buffer.readu8(EncodedBytes, 0), buffer.readu8(EncodedBytes, 1), buffer.readu8(EncodedBytes, 2)
	local W00 = B0 + B1 * 256 + B2 * 65536

	B0, B1, B2 = buffer.readu8(EncodedBytes, 3), buffer.readu8(EncodedBytes, 4), buffer.readu8(EncodedBytes, 5)
	local W01 = B0 + B1 * 256 + B2 * 65536

	local W02 = buffer.readu16(EncodedBytes, 6)

	B0, B1, B2 = buffer.readu8(EncodedBytes, 8), buffer.readu8(EncodedBytes, 9), buffer.readu8(EncodedBytes, 10)
	local W03 = B0 + B1 * 256 + B2 * 65536

	B0, B1, B2 = buffer.readu8(EncodedBytes, 11), buffer.readu8(EncodedBytes, 12), buffer.readu8(EncodedBytes, 13)
	local W04 = B0 + B1 * 256 + B2 * 65536

	local W05 = buffer.readu16(EncodedBytes, 14)

	B0, B1, B2 = buffer.readu8(EncodedBytes, 16), buffer.readu8(EncodedBytes, 17), buffer.readu8(EncodedBytes, 18)
	local W06 = B0 + B1 * 256 + B2 * 65536

	B0, B1, B2 = buffer.readu8(EncodedBytes, 19), buffer.readu8(EncodedBytes, 20), buffer.readu8(EncodedBytes, 21)
	local W07 = B0 + B1 * 256 + B2 * 65536

	local W08 = buffer.readu16(EncodedBytes, 22)

	B0, B1, B2 = buffer.readu8(EncodedBytes, 24), buffer.readu8(EncodedBytes, 25), buffer.readu8(EncodedBytes, 26)
	local W09 = B0 + B1 * 256 + B2 * 65536

	B0, B1, B2 = buffer.readu8(EncodedBytes, 27), buffer.readu8(EncodedBytes, 28), buffer.readu8(EncodedBytes, 29)
	local W10 = B0 + B1 * 256 + B2 * 65536

	local W11 = buffer.readu16(EncodedBytes, 30) % 32768

	local Buf = buffer.create(SIZE)

	buffer.writef64(Buf, 0, W00)
	buffer.writef64(Buf, 8, W01 * 2 ^ 24)
	buffer.writef64(Buf, 16, W02 * 2 ^ 48)
	buffer.writef64(Buf, 24, W03 * 2 ^ 64)
	buffer.writef64(Buf, 32, W04 * 2 ^ 88)
	buffer.writef64(Buf, 40, W05 * 2 ^ 112)
	buffer.writef64(Buf, 48, W06 * 2 ^ 128)
	buffer.writef64(Buf, 56, W07 * 2 ^ 152)
	buffer.writef64(Buf, 64, W08 * 2 ^ 176)
	buffer.writef64(Buf, 72, W09 * 2 ^ 192)
	buffer.writef64(Buf, 80, W10 * 2 ^ 216)
	buffer.writef64(Buf, 88, W11 * 2 ^ 240)

	return FieldPrime.Carry(Buf, Buf)
end

function FieldPrime.Eqz(ElementA)
	local Canonical = FieldPrime.Canonicalize(ElementA)
	local C00, C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11 =
		buffer.readf64(Canonical, 0), buffer.readf64(Canonical, 8),
		buffer.readf64(Canonical, 16), buffer.readf64(Canonical, 24),
		buffer.readf64(Canonical, 32), buffer.readf64(Canonical, 40),
		buffer.readf64(Canonical, 48), buffer.readf64(Canonical, 56),
		buffer.readf64(Canonical, 64), buffer.readf64(Canonical, 72),
		buffer.readf64(Canonical, 80), buffer.readf64(Canonical, 88)

	return C00 + C01 + C02 + C03 + C04 + C05 + C06 + C07 + C08 + C09 + C10 + C11 == 0
end

return FieldPrime
end)()
local FieldQuadratic = (function()
--[=[
	Cryptography library: Field Quadratic (Curve25519 Scalar Field)

	Return type: varies by function
	Example usage:
		local FieldQuadratic = require("FieldQuadratic")

		--------Usage Case 1: Basic scalar arithmetic--------
		local ScalarA = FieldQuadratic.Decode(SomeBytes)
		local ScalarB = FieldQuadratic.Decode(OtherBytes)
		local Sum = FieldQuadratic.Add(ScalarA, ScalarB)
		local Product = FieldQuadratic.Mul(ScalarA, ScalarB)

		--------Usage Case 2: Convert to bits for scalar multiplication--------
		local ScalarBits = FieldQuadratic.Bits(ScalarA)
		local EncodedResult = FieldQuadratic.Encode(Product)
--]=]

--!strict
--!optimize 2
--!native


local CONSTANT_ZERO = MultiPrecision.Num(0)

local OUTPUT_BUFFER = buffer.create(8192)
local RULE_BUFFER = buffer.create(8192)
local DECODE_WIDE_LOW = buffer.create(96)
local DECODE_WIDE_HIGH = buffer.create(96)
local DECODE_BUFFER = buffer.create(96)
local CLAMPED_BUFFER = buffer.create(32)

local FIELD_ORDER_BYTES = buffer.create(32) do
	local Bytes = {
		0xed, 0xd3, 0xf5, 0x5c, 0x1a, 0x63, 0x12, 0x58,
		0xd6, 0x9c, 0xf7, 0xa2, 0xde, 0xf9, 0xde, 0x14,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10
	}
	for Index = 1, 32 do
		buffer.writeu8(FIELD_ORDER_BYTES, Index - 1, Bytes[Index])
	end
end

local FIELD_ORDER = buffer.create(96) do
	local ByteIndex = 0

	for LimbIndex = 0, 9 do
		local Value = buffer.readu8(FIELD_ORDER_BYTES, ByteIndex)
			+ buffer.readu8(FIELD_ORDER_BYTES, ByteIndex + 1) * 256
			+ buffer.readu8(FIELD_ORDER_BYTES, ByteIndex + 2) * 65536

		buffer.writef64(FIELD_ORDER, LimbIndex * 8, Value)
		ByteIndex = ByteIndex + (3)
	end

	local LastValue = buffer.readu8(FIELD_ORDER_BYTES, 30)
		+ buffer.readu8(FIELD_ORDER_BYTES, 31) * 256
	buffer.writef64(FIELD_ORDER, 10 * 8, LastValue)
end

local MONTGOMERY_T0 = buffer.create(96) do
	local Values = {
		05537307, 01942290, 16765621, 16628356, 10618610,
		07072433, 03735459, 01369940, 15276086, 13038191,
		13409718
	}
	for Index = 1, 11 do
		buffer.writef64(MONTGOMERY_T0, (Index - 1) * 8, Values[Index])
	end
end

local MONTGOMERY_T1 = buffer.create(96) do
	local Values = {
		11711996, 01747860, 08326961, 03814718, 01859974,
		13327461, 16105061, 07590423, 04050668, 08138906,
		00000283
	}
	for Index = 1, 11 do
		buffer.writef64(MONTGOMERY_T1, (Index - 1) * 8, Values[Index])
	end
end

local DIVIDE_8 = buffer.create(96) do
	local Values = {
		5110253, 3039345, 2503500, 11779568, 15416472,
		16766550, 16777215, 16777215, 16777215, 16777215,
		4095
	}
	for Index = 1, 11 do
		buffer.writef64(DIVIDE_8, (Index - 1) * 8, Values[Index])
	end
end

local function Reduce(LargeNumber)
	local Difference = MultiPrecision.Sub(LargeNumber, FIELD_ORDER)

	if MultiPrecision.Approx(Difference) < 0 then
		return MultiPrecision.Carry(LargeNumber)
	end

	return MultiPrecision.Carry(Difference)
end

local function Demontgomery(MontgomeryScalar)
	local ReductionLow, ReductionHigh = MultiPrecision.Mul(MultiPrecision.LMul(MontgomeryScalar, MONTGOMERY_T0), FIELD_ORDER)
	local _, ResultHigh = MultiPrecision.DWAdd(MontgomeryScalar, CONSTANT_ZERO, ReductionLow, ReductionHigh)

	return Reduce(ResultHigh)
end

local function RebaseLE(InputBuffer, InputLength, FromBase, ToBase)
	local OutputLength = 0
	local Accumulator = 0
	local Multiplier = 1

	for Index = 0, InputLength - 1 do
		Accumulator = Accumulator + (buffer.readf64(InputBuffer, Index * 8) * Multiplier)
		Multiplier = Multiplier * (FromBase)
		while Multiplier >= ToBase do
			local Remainder = Accumulator % ToBase
			Accumulator = (Accumulator - Remainder) / ToBase
			Multiplier = Multiplier / (ToBase)
			buffer.writef64(OUTPUT_BUFFER, OutputLength * 8, Remainder)
			OutputLength = OutputLength + (1)
		end
	end

	if Multiplier > 0 then
		buffer.writef64(OUTPUT_BUFFER, OutputLength * 8, Accumulator)
		OutputLength = OutputLength + (1)
	end

	return OUTPUT_BUFFER, OutputLength
end

local FieldQuadratic = {}

function FieldQuadratic.IsValidScalar(ScalarBytes)
	local FieldOrder = FIELD_ORDER_BYTES
	local Borrow = 0

	for Index = 0, 31 do
		local ScalarByte = buffer.readu8(ScalarBytes, Index)
		local OrderByte = buffer.readu8(FieldOrder, Index)
		local Diff = ScalarByte - OrderByte - Borrow
		Borrow = 1 - bit32.rshift(Diff + 256, 8)
	end

	return Borrow == 1
end

function FieldQuadratic.Montgomery(RegularScalar)
	return FieldQuadratic.Mul(RegularScalar, MONTGOMERY_T1)
end

function FieldQuadratic.Add(ScalarA, ScalarB)
	return Reduce(MultiPrecision.Add(ScalarA, ScalarB))
end

function FieldQuadratic.Neg(ScalarA)
	return Reduce(MultiPrecision.Sub(FIELD_ORDER, ScalarA))
end

function FieldQuadratic.Sub(ScalarA, ScalarB)
	return FieldQuadratic.Add(ScalarA, FieldQuadratic.Neg(ScalarB))
end

function FieldQuadratic.Mul(ScalarA, ScalarB)
	local ProductLow, ProductHigh = MultiPrecision.Mul(ScalarA, ScalarB)
	local ReductionLow, ReductionHigh = MultiPrecision.Mul(MultiPrecision.LMul(ProductLow, MONTGOMERY_T0), FIELD_ORDER)
	local _, ResultHigh = MultiPrecision.DWAdd(ProductLow, ProductHigh, ReductionLow, ReductionHigh)

	return Reduce(ResultHigh)
end

function FieldQuadratic.Encode(MontgomeryScalar)
	local DemontResult = Demontgomery(MontgomeryScalar)
	local EncodedBuffer = buffer.create(32)
	local ByteIndex = 0
	for LimbIndex = 0, 9 do
		local Value = buffer.readf64(DemontResult, LimbIndex * 8)
		buffer.writeu8(EncodedBuffer, ByteIndex, Value % 256)
		Value = Value // 256
		buffer.writeu8(EncodedBuffer, ByteIndex + 1, Value % 256)
		Value = Value // 256
		buffer.writeu8(EncodedBuffer, ByteIndex + 2, Value % 256)
		ByteIndex = ByteIndex + (3)
	end

	local LastValue = buffer.readf64(DemontResult, 10 * 8)
	buffer.writeu8(EncodedBuffer, 30, LastValue % 256)
	LastValue = LastValue // 256
	buffer.writeu8(EncodedBuffer, 31, LastValue % 256)

	return EncodedBuffer
end

function FieldQuadratic.Decode(EncodedBuffer)
	local DecodedBuffer = DECODE_BUFFER
	local ByteIndex = 0

	for LimbIndex = 0, 9 do
		local Value = buffer.readu8(EncodedBuffer, ByteIndex)
			+ buffer.readu8(EncodedBuffer, ByteIndex + 1) * 256
			+ buffer.readu8(EncodedBuffer, ByteIndex + 2) * 65536

		buffer.writef64(DecodedBuffer, LimbIndex * 8, Value)
		ByteIndex = ByteIndex + (3)
	end

	local LastValue = buffer.readu8(EncodedBuffer, 30)
		+ buffer.readu8(EncodedBuffer, 31) * 256
	buffer.writef64(DecodedBuffer, 10 * 8, LastValue)

	return FieldQuadratic.Montgomery(DecodedBuffer)
end

function FieldQuadratic.DecodeWide(WideBuffer)
	local LowPart = DECODE_WIDE_LOW
	local HighPart = DECODE_WIDE_HIGH

	for LimbIndex = 0, 10 do
		local ByteIndex = LimbIndex * 3
		local Value = buffer.readu8(WideBuffer, ByteIndex)
			+ buffer.readu8(WideBuffer, ByteIndex + 1) * 256
			+ buffer.readu8(WideBuffer, ByteIndex + 2) * 65536
		buffer.writef64(LowPart, LimbIndex * 8, Value)
	end

	for LimbIndex = 0, 9 do
		local ByteIndex = 33 + LimbIndex * 3
		local Value = buffer.readu8(WideBuffer, ByteIndex)
			+ buffer.readu8(WideBuffer, ByteIndex + 1) * 256
			+ buffer.readu8(WideBuffer, ByteIndex + 2) * 65536
		buffer.writef64(HighPart, LimbIndex * 8, Value)
	end
	buffer.writef64(HighPart, 10 * 8, buffer.readu8(WideBuffer, 63))

	local MontLow = FieldQuadratic.Montgomery(LowPart)
	local MontHigh = FieldQuadratic.Montgomery(HighPart)
	local MontMontHigh = FieldQuadratic.Montgomery(MontHigh)

	return FieldQuadratic.Add(MontLow, MontMontHigh)
end

function FieldQuadratic.DecodeClamped(ClampedBuffer)
	local ClampedCopy = CLAMPED_BUFFER
	buffer.copy(ClampedCopy, 0, ClampedBuffer, 0, 32)

	local FirstByte = buffer.readu8(ClampedCopy, 0)
	buffer.writeu8(ClampedCopy, 0, bit32.band(FirstByte, 0xF8))

	local LastByte = buffer.readu8(ClampedCopy, 31)
	buffer.writeu8(ClampedCopy, 31, bit32.bor(bit32.band(LastByte, 0x7F), 0x40))

	return FieldQuadratic.Decode(ClampedCopy)
end

function FieldQuadratic.Eighth(MontgomeryScalar)
	return FieldQuadratic.Mul(MontgomeryScalar, DIVIDE_8)
end

function FieldQuadratic.Bits(MontgomeryScalar)
	local DemontResult = Demontgomery(MontgomeryScalar)
	local BitOutput, BitCount = RebaseLE(DemontResult, 11, 2 ^ 24, 2)

	if BitCount > 253 then
		BitCount = 253
	end

	return BitOutput, BitCount
end

function FieldQuadratic.MakeRuleset(ScalarA, ScalarB)
	local DTable = Demontgomery(ScalarA)
	local ETable = Demontgomery(ScalarB)
	local FTable = MultiPrecision.Sub(DTable, ETable)

	local DMod2 = MultiPrecision.Mod2(DTable)
	local EMod2 = MultiPrecision.Mod2(ETable)

	local DMod3 = MultiPrecision.Mod3(DTable)
	local EMod3 = MultiPrecision.Mod3(ETable)

	local EFloat = MultiPrecision.Approx(ETable)
	local FFloat = MultiPrecision.Approx(FTable)

	local Mod3Lut = {[0] = 0, 2, 1}

	local RuleBuffer = RULE_BUFFER
	local RuleCount = 0

	while FFloat ~= 0 do
		local Rule = -1

		if FFloat < 0 then
			Rule = 0
			DTable, ETable = ETable, DTable
			DMod2, EMod2 = EMod2, DMod2
			DMod3, EMod3 = EMod3, DMod3
			EFloat = MultiPrecision.Approx(ETable)
			FTable = MultiPrecision.Sub(DTable, ETable)
			FFloat = -FFloat
		elseif 4 * FFloat < EFloat and DMod3 == Mod3Lut[EMod3] then
			Rule = 1
			DTable, ETable = MultiPrecision.Third(MultiPrecision.Add(DTable, FTable)), MultiPrecision.Third(MultiPrecision.Sub(ETable, FTable))
			DMod2, EMod2 = EMod2, DMod2
			DMod3, EMod3 = MultiPrecision.Mod3(DTable), MultiPrecision.Mod3(ETable)
			EFloat = MultiPrecision.Approx(ETable)
		elseif 4 * FFloat < EFloat and DMod2 == EMod2 and DMod3 == EMod3 then
			Rule = 2
			DTable = MultiPrecision.Half(FTable)
			DMod2 = MultiPrecision.Mod2(DTable)
			DMod3 = Mod3Lut[(DMod3 - EMod3) % 3]
			FTable = MultiPrecision.Sub(DTable, ETable)
			FFloat = MultiPrecision.Approx(FTable)
		elseif FFloat < 3 * EFloat then
			Rule = 3
			DTable = MultiPrecision.CarryWeak(FTable)
			DMod2 = (DMod2 - EMod2) % 2
			DMod3 = (DMod3 - EMod3) % 3
			FTable = MultiPrecision.Sub(DTable, ETable)
			FFloat = MultiPrecision.Approx(FTable)
		elseif DMod2 == EMod2 then
			Rule = 2
			DTable = MultiPrecision.Half(FTable)
			DMod2 = MultiPrecision.Mod2(DTable)
			DMod3 = Mod3Lut[(DMod3 - EMod3) % 3]
			FTable = MultiPrecision.Sub(DTable, ETable)
			FFloat = MultiPrecision.Approx(FTable)
		elseif DMod2 == 0 then
			Rule = 5
			DTable = MultiPrecision.Half(DTable)
			DMod2 = MultiPrecision.Mod2(DTable)
			DMod3 = Mod3Lut[DMod3]
			FTable = MultiPrecision.Sub(DTable, ETable)
			FFloat = MultiPrecision.Approx(FTable)
		elseif DMod3 == 0 then
			Rule = 6
			DTable = MultiPrecision.CarryWeak(MultiPrecision.Sub(MultiPrecision.Third(DTable), ETable))
			DMod2 = (DMod2 - EMod2) % 2
			DMod3 = MultiPrecision.Mod3(DTable)
			FTable = MultiPrecision.Sub(DTable, ETable)
			FFloat = MultiPrecision.Approx(FTable)
		elseif DMod3 == Mod3Lut[EMod3] then
			Rule = 7
			DTable = MultiPrecision.Third(MultiPrecision.Sub(FTable, ETable))
			DMod3 = MultiPrecision.Mod3(DTable)
			FTable = MultiPrecision.Sub(DTable, ETable)
			FFloat = MultiPrecision.Approx(FTable)
		elseif DMod3 == EMod3 then
			Rule = 8
			DTable = MultiPrecision.Third(FTable)
			DMod2 = (DMod2 - EMod2) % 2
			DMod3 = MultiPrecision.Mod3(DTable)
			FTable = MultiPrecision.Sub(DTable, ETable)
			FFloat = MultiPrecision.Approx(FTable)
		else
			Rule = 9
			ETable = MultiPrecision.Half(ETable)
			EMod2 = MultiPrecision.Mod2(ETable)
			EMod3 = Mod3Lut[EMod3]
			EFloat = MultiPrecision.Approx(ETable)
			FTable = MultiPrecision.Sub(DTable, ETable)
			FFloat = MultiPrecision.Approx(FTable)
		end

		buffer.writef64(RuleBuffer, RuleCount * 8, Rule)
		RuleCount = RuleCount + (1)
	end

	local FinalBits, FinalBitCount = RebaseLE(DTable, 11, 2 ^ 24, 2)
	while FinalBitCount > 0 and buffer.readf64(FinalBits, (FinalBitCount - 1) * 8) == 0 do
		FinalBitCount = FinalBitCount - (1)
	end

	return FinalBits, FinalBitCount, RuleBuffer, RuleCount
end

return FieldQuadratic
end)()
local Edwards25519 = (function()
--[=[
	Cryptography library: Edwards25519

	Return type: varies by function
	Example usage:
		local Edwards = require("Edwards25519")
		local FieldQuadratic = require("FieldQuadratic")

		--------Usage Case 1: Point addition--------
		local Point1 = Edwards.Decode(SomeEncodedBuffer)
		local Point2 = Edwards.Decode(AnotherEncodedBuffer)
		local NielsPoint2 = Edwards.Niels(Point2)
		local Sum = Edwards.Add(Point1, NielsPoint2)

		--------Usage Case 2: Scalar multiplication with buffer-based bits--------
		local SomeScalar = FieldQuadratic.Decode(ScalarBytes)
		local ScalarBits, BitCount = FieldQuadratic.Bits(SomeScalar)
		local Result = Edwards.MulG(ScalarBits, BitCount)
		local EncodedResult = Edwards.Encode(Result)
--]=]

--!strict
--!optimize 2
--!native


local POINT_SIZE = 416
local COORD_SIZE = 104
local AFFINE_NIELS_SIZE = 312
local BASE_RADIX_WIDTH = 6
local BASE_POINT_ROW = 2 ^ BASE_RADIX_WIDTH / 2

local CURVE_D = FieldPrime.Mul(FieldPrime.Num(-121665), FieldPrime.Invert(FieldPrime.Num(121666)))
local CURVE_K = FieldPrime.KMul(CURVE_D, 2)

local IDENTITY_O = buffer.create(POINT_SIZE) do
	buffer.copy(IDENTITY_O, 0, FieldPrime.Num(0), 0, COORD_SIZE)
	buffer.copy(IDENTITY_O, COORD_SIZE, FieldPrime.Num(1), 0, COORD_SIZE)
	buffer.copy(IDENTITY_O, 2 * COORD_SIZE, FieldPrime.Num(1), 0, COORD_SIZE)
	buffer.copy(IDENTITY_O, 3 * COORD_SIZE, FieldPrime.Num(0), 0, COORD_SIZE)
end

local COORD_BUFFER_0 = buffer.create(COORD_SIZE)
local COORD_BUFFER_1 = buffer.create(COORD_SIZE)
local COORD_BUFFER_2 = buffer.create(COORD_SIZE)
local COORD_BUFFER_3 = buffer.create(COORD_SIZE)
local COORD_BUFFER_4 = buffer.create(COORD_SIZE)
local COORD_BUFFER_5 = buffer.create(COORD_SIZE)
local COORD_BUFFER_6 = buffer.create(COORD_SIZE)
local COORD_BUFFER_7 = buffer.create(COORD_SIZE)

local MUL_RESULT_POINT = buffer.create(POINT_SIZE)
local MUL_NIELS_POINT = buffer.create(POINT_SIZE)
local MUL_DOUBLE_X = buffer.create(COORD_SIZE)
local MUL_DOUBLE_Y = buffer.create(COORD_SIZE)
local MUL_DOUBLE_Z = buffer.create(COORD_SIZE)
local MUL_DOUBLE_A = buffer.create(COORD_SIZE)
local MUL_DOUBLE_B = buffer.create(COORD_SIZE)
local MUL_DOUBLE_E = buffer.create(COORD_SIZE)
local MUL_DOUBLE_G = buffer.create(COORD_SIZE)
local MUL_P1X = buffer.create(COORD_SIZE)
local MUL_P1Y = buffer.create(COORD_SIZE)
local MUL_P1Z = buffer.create(COORD_SIZE)
local MUL_P1T = buffer.create(COORD_SIZE)
local MUL_N2P = buffer.create(COORD_SIZE)
local MUL_N2M = buffer.create(COORD_SIZE)
local MUL_N2Z = buffer.create(COORD_SIZE)
local MUL_N2T = buffer.create(COORD_SIZE)
local MUL_TMP = buffer.create(COORD_SIZE)

local MULG_RESULT_POINT = buffer.create(POINT_SIZE)
local MULG_AFFINE_NIELS = buffer.create(AFFINE_NIELS_SIZE)
local MULG_DUMMY_POINT = buffer.create(POINT_SIZE)
local MULG_P1X = buffer.create(COORD_SIZE)
local MULG_P1Y = buffer.create(COORD_SIZE)
local MULG_P1Z = buffer.create(COORD_SIZE)
local MULG_P1T = buffer.create(COORD_SIZE)
local MULG_N2P = buffer.create(COORD_SIZE)
local MULG_N2M = buffer.create(COORD_SIZE)
local MULG_N2T = buffer.create(COORD_SIZE)
local MULG_TMP = buffer.create(COORD_SIZE)

local NAF_TABLE_DOUBLED = buffer.create(POINT_SIZE)
local NAF_TABLE_P1X = buffer.create(COORD_SIZE)
local NAF_TABLE_P1Y = buffer.create(COORD_SIZE)
local NAF_TABLE_P1Z = buffer.create(COORD_SIZE)
local NAF_TABLE_P1T = buffer.create(COORD_SIZE)
local NAF_TABLE_N2P = buffer.create(COORD_SIZE)
local NAF_TABLE_N2M = buffer.create(COORD_SIZE)
local NAF_TABLE_N2Z = buffer.create(COORD_SIZE)
local NAF_TABLE_N2T = buffer.create(COORD_SIZE)
local NAF_TABLE_TMP = buffer.create(COORD_SIZE)
local NAF_TABLE_DBL_P = buffer.create(COORD_SIZE)
local NAF_TABLE_DBL_M = buffer.create(COORD_SIZE)
local NAF_TABLE_DBL_Z = buffer.create(COORD_SIZE)
local NAF_TABLE_DBL_T = buffer.create(COORD_SIZE)

local NAF_OUTPUT = buffer.create(512 * 8)
local RADIX_OUTPUT = buffer.create(272 * 8)

local BASEPONT_G = nil
local AFFINE_BASEPOINT_TABLE = nil

local function GetCoord(Point, Index, Storage)
	local Coord = Storage or buffer.create(COORD_SIZE)
	buffer.copy(Coord, 0, Point, Index * COORD_SIZE, COORD_SIZE)
	return Coord
end

local Edwards25519 = {}

function Edwards25519.Double(Point1, Storage)
	local Point1X = GetCoord(Point1, 0, COORD_BUFFER_0)
	local Point1Y = GetCoord(Point1, 1, COORD_BUFFER_1)
	local Point1Z = GetCoord(Point1, 2, COORD_BUFFER_2)

	local SquaredA = FieldPrime.Square(Point1X)
	local SquaredB = FieldPrime.Square(Point1Y)
	FieldPrime.Square(Point1Z, Point1Z)
	FieldPrime.Add(Point1Z, Point1Z, Point1Z)
	local DoubledD = Point1Z
	local SumE = FieldPrime.Add(SquaredA, SquaredB)
	FieldPrime.Add(Point1X, Point1Y, Point1X)
	local SumF = Point1X
	local SquaredG = FieldPrime.Square(SumF)
	FieldPrime.Sub(SquaredG, SumE, SquaredG)
	FieldPrime.Carry(SquaredG, SquaredG)
	local DiffH = SquaredG
	FieldPrime.Sub(SquaredB, SquaredA, SquaredB)
	local DiffI = SquaredB
	FieldPrime.Sub(DoubledD, DiffI, DoubledD)
	FieldPrime.Carry(DoubledD, DoubledD)
	local DiffJ = DoubledD

	local NewX = FieldPrime.Mul(DiffH, DiffJ)
	local NewY = FieldPrime.Mul(DiffI, SumE)
	FieldPrime.Mul(DiffJ, DiffI, DiffJ)
	local NewZ = DiffJ
	FieldPrime.Mul(DiffH, SumE, DiffH)
	local NewT = DiffH

	local Result = Storage or buffer.create(POINT_SIZE)
	buffer.copy(Result, 0 * COORD_SIZE, NewX, 0, COORD_SIZE)
	buffer.copy(Result, 1 * COORD_SIZE, NewY, 0, COORD_SIZE)
	buffer.copy(Result, 2 * COORD_SIZE, NewZ, 0, COORD_SIZE)
	buffer.copy(Result, 3 * COORD_SIZE, NewT, 0, COORD_SIZE)

	return Result
end

function Edwards25519.Add(Point1, NielsPoint2, Storage)
	local Point1X = GetCoord(Point1, 0, COORD_BUFFER_0)
	local Point1Y = GetCoord(Point1, 1, COORD_BUFFER_1)
	local Point1Z = GetCoord(Point1, 2, COORD_BUFFER_2)
	local Point1T = GetCoord(Point1, 3, COORD_BUFFER_3)

	local Niels1Plus = GetCoord(NielsPoint2, 0, COORD_BUFFER_4)
	local Niels1Minus = GetCoord(NielsPoint2, 1, COORD_BUFFER_5)
	local Niels1Z = GetCoord(NielsPoint2, 2, COORD_BUFFER_6)
	local Niels1T = GetCoord(NielsPoint2, 3, COORD_BUFFER_7)

	local DiffA = FieldPrime.Sub(Point1Y, Point1X)
	FieldPrime.Mul(DiffA, Niels1Minus, DiffA)
	local ProductB = DiffA

	local SumC = FieldPrime.Add(Point1Y, Point1X)
	FieldPrime.Mul(SumC, Niels1Plus, SumC)
	local ProductD = SumC

	FieldPrime.Mul(Point1T, Niels1T, Point1T)
	local ProductE = Point1T

	FieldPrime.Mul(Point1Z, Niels1Z, Point1Z)
	local ProductF = Point1Z

	local DiffG = FieldPrime.Sub(ProductD, ProductB)
	local DiffH = FieldPrime.Sub(ProductF, ProductE)

	FieldPrime.Add(ProductF, ProductE, ProductF)
	local SumI = ProductF

	FieldPrime.Add(ProductD, ProductB, ProductD)
	local SumJ = ProductD

	local NewX = FieldPrime.Mul(DiffG, DiffH)
	local NewY = FieldPrime.Mul(SumI, SumJ)
	FieldPrime.Mul(DiffH, SumI, DiffH)
	local NewZ = DiffH
	FieldPrime.Mul(DiffG, SumJ, DiffG)
	local NewT = DiffG

	local Result = Storage or buffer.create(POINT_SIZE)
	buffer.copy(Result, 0 * COORD_SIZE, NewX, 0, COORD_SIZE)
	buffer.copy(Result, 1 * COORD_SIZE, NewY, 0, COORD_SIZE)
	buffer.copy(Result, 2 * COORD_SIZE, NewZ, 0, COORD_SIZE)
	buffer.copy(Result, 3 * COORD_SIZE, NewT, 0, COORD_SIZE)

	return Result
end

function Edwards25519.Sub(Point1, NielsPoint2, Storage)
	local Point1X = GetCoord(Point1, 0, COORD_BUFFER_0)
	local Point1Y = GetCoord(Point1, 1, COORD_BUFFER_1)
	local Point1Z = GetCoord(Point1, 2, COORD_BUFFER_2)
	local Point1T = GetCoord(Point1, 3, COORD_BUFFER_3)

	local Niels1Plus = GetCoord(NielsPoint2, 0, COORD_BUFFER_4)
	local Niels1Minus = GetCoord(NielsPoint2, 1, COORD_BUFFER_5)
	local Niels1Z = GetCoord(NielsPoint2, 2, COORD_BUFFER_6)
	local Niels1T = GetCoord(NielsPoint2, 3, COORD_BUFFER_7)

	local DiffA = FieldPrime.Sub(Point1Y, Point1X)
	FieldPrime.Mul(DiffA, Niels1Plus, DiffA)
	local ProductB = DiffA
	FieldPrime.Add(Point1Y, Point1X, Point1Y)
	local SumC = Point1Y
	FieldPrime.Mul(SumC, Niels1Minus, SumC)
	local ProductD = SumC
	FieldPrime.Mul(Point1T, Niels1T, Point1T)
	local ProductE = Point1T
	FieldPrime.Mul(Point1Z, Niels1Z, Point1Z)
	local ProductF = Point1Z
	local DiffG = FieldPrime.Sub(ProductD, ProductB)
	local SumH = FieldPrime.Add(ProductF, ProductE)
	local DiffI = FieldPrime.Sub(ProductF, ProductE)
	FieldPrime.Add(ProductD, ProductB, ProductD)
	local SumJ = ProductD

	local NewX = FieldPrime.Mul(DiffG, SumH)
	local NewY = FieldPrime.Mul(DiffI, SumJ)
	FieldPrime.Mul(SumH, DiffI, SumH)
	local NewZ = SumH
	FieldPrime.Mul(DiffG, SumJ, DiffG)
	local NewT = DiffG

	local Result = Storage or buffer.create(POINT_SIZE)
	buffer.copy(Result, 0 * COORD_SIZE, NewX, 0, COORD_SIZE)
	buffer.copy(Result, 1 * COORD_SIZE, NewY, 0, COORD_SIZE)
	buffer.copy(Result, 2 * COORD_SIZE, NewZ, 0, COORD_SIZE)
	buffer.copy(Result, 3 * COORD_SIZE, NewT, 0, COORD_SIZE)

	return Result
end

function Edwards25519.Niels(Point1, Storage)
	local Point1X = GetCoord(Point1, 0, COORD_BUFFER_0)
	local Point1Y = GetCoord(Point1, 1, COORD_BUFFER_1)
	local Point1Z = GetCoord(Point1, 2, COORD_BUFFER_2)
	local Point1T = GetCoord(Point1, 3, COORD_BUFFER_3)

	local PlusN3 = FieldPrime.Add(Point1Y, Point1X)
	local MinusN3 = FieldPrime.Sub(Point1Y, Point1X)
	FieldPrime.Add(Point1Z, Point1Z, Point1Z)
	local DoubledN3Z = Point1Z
	FieldPrime.Mul(Point1T, CURVE_K, Point1T)
	local ScaledN3T = Point1T

	local Result = Storage or buffer.create(POINT_SIZE)
	buffer.copy(Result, 0 * COORD_SIZE, PlusN3, 0, COORD_SIZE)
	buffer.copy(Result, 1 * COORD_SIZE, MinusN3, 0, COORD_SIZE)
	buffer.copy(Result, 2 * COORD_SIZE, DoubledN3Z, 0, COORD_SIZE)
	buffer.copy(Result, 3 * COORD_SIZE, ScaledN3T, 0, COORD_SIZE)

	return Result
end

function Edwards25519.AffineNiels(Point1, Storage)
	local Point1X = GetCoord(Point1, 0, COORD_BUFFER_0)
	local Point1Y = GetCoord(Point1, 1, COORD_BUFFER_1)
	local Point1T = GetCoord(Point1, 3, COORD_BUFFER_3)

	local YPlusX = FieldPrime.Add(Point1Y, Point1X)
	local YMinusX = FieldPrime.Sub(Point1Y, Point1X)
	FieldPrime.Mul(Point1T, CURVE_K, Point1T)
	local T2d = Point1T

	local Result = Storage or buffer.create(AFFINE_NIELS_SIZE)
	buffer.copy(Result, 0 * COORD_SIZE, YPlusX, 0, COORD_SIZE)
	buffer.copy(Result, 1 * COORD_SIZE, YMinusX, 0, COORD_SIZE)
	buffer.copy(Result, 2 * COORD_SIZE, T2d, 0, COORD_SIZE)

	return Result
end

function Edwards25519.AddAffine(Point1, AffineNiels2, Storage)
	local Point1X = GetCoord(Point1, 0, COORD_BUFFER_0)
	local Point1Y = GetCoord(Point1, 1, COORD_BUFFER_1)
	local Point1Z = GetCoord(Point1, 2, COORD_BUFFER_2)
	local Point1T = GetCoord(Point1, 3, COORD_BUFFER_3)

	local Niels2YPlusX = GetCoord(AffineNiels2, 0, COORD_BUFFER_4)
	local Niels2YMinusX = GetCoord(AffineNiels2, 1, COORD_BUFFER_5)
	local Niels2T2d = GetCoord(AffineNiels2, 2, COORD_BUFFER_6)

	local DiffA = FieldPrime.Sub(Point1Y, Point1X)
	FieldPrime.Mul(DiffA, Niels2YMinusX, DiffA)
	local ProductB = DiffA

	local SumC = FieldPrime.Add(Point1Y, Point1X)
	FieldPrime.Mul(SumC, Niels2YPlusX, SumC)
	local ProductD = SumC

	FieldPrime.Mul(Point1T, Niels2T2d, Point1T)
	local ProductE = Point1T

	FieldPrime.Add(Point1Z, Point1Z, Point1Z)
	local ProductF = Point1Z

	local DiffG = FieldPrime.Sub(ProductD, ProductB)
	local DiffH = FieldPrime.Sub(ProductF, ProductE)

	FieldPrime.Add(ProductF, ProductE, ProductF)
	local SumI = ProductF

	FieldPrime.Add(ProductD, ProductB, ProductD)
	local SumJ = ProductD

	local NewX = FieldPrime.Mul(DiffG, DiffH)
	local NewY = FieldPrime.Mul(SumI, SumJ)
	FieldPrime.Mul(DiffH, SumI, DiffH)
	local NewZ = DiffH
	FieldPrime.Mul(DiffG, SumJ, DiffG)
	local NewT = DiffG

	local Result = Storage or buffer.create(POINT_SIZE)
	buffer.copy(Result, 0 * COORD_SIZE, NewX, 0, COORD_SIZE)
	buffer.copy(Result, 1 * COORD_SIZE, NewY, 0, COORD_SIZE)
	buffer.copy(Result, 2 * COORD_SIZE, NewZ, 0, COORD_SIZE)
	buffer.copy(Result, 3 * COORD_SIZE, NewT, 0, COORD_SIZE)

	return Result
end

function Edwards25519.SubAffine(Point1, AffineNiels2, Storage)
	local Point1X = GetCoord(Point1, 0, COORD_BUFFER_0)
	local Point1Y = GetCoord(Point1, 1, COORD_BUFFER_1)
	local Point1Z = GetCoord(Point1, 2, COORD_BUFFER_2)
	local Point1T = GetCoord(Point1, 3, COORD_BUFFER_3)

	local Niels2YPlusX = GetCoord(AffineNiels2, 0, COORD_BUFFER_4)
	local Niels2YMinusX = GetCoord(AffineNiels2, 1, COORD_BUFFER_5)
	local Niels2T2d = GetCoord(AffineNiels2, 2, COORD_BUFFER_6)

	local DiffA = FieldPrime.Sub(Point1Y, Point1X)
	FieldPrime.Mul(DiffA, Niels2YPlusX, DiffA)
	local ProductB = DiffA

	FieldPrime.Add(Point1Y, Point1X, Point1Y)
	local SumC = Point1Y
	FieldPrime.Mul(SumC, Niels2YMinusX, SumC)
	local ProductD = SumC

	FieldPrime.Mul(Point1T, Niels2T2d, Point1T)
	local ProductE = Point1T

	FieldPrime.Add(Point1Z, Point1Z, Point1Z)
	local ProductF = Point1Z

	local DiffG = FieldPrime.Sub(ProductD, ProductB)
	local SumH = FieldPrime.Add(ProductF, ProductE)
	local DiffI = FieldPrime.Sub(ProductF, ProductE)
	FieldPrime.Add(ProductD, ProductB, ProductD)
	local SumJ = ProductD

	local NewX = FieldPrime.Mul(DiffG, SumH)
	local NewY = FieldPrime.Mul(DiffI, SumJ)
	FieldPrime.Mul(SumH, DiffI, SumH)
	local NewZ = SumH
	FieldPrime.Mul(DiffG, SumJ, DiffG)
	local NewT = DiffG

	local Result = Storage or buffer.create(POINT_SIZE)
	buffer.copy(Result, 0 * COORD_SIZE, NewX, 0, COORD_SIZE)
	buffer.copy(Result, 1 * COORD_SIZE, NewY, 0, COORD_SIZE)
	buffer.copy(Result, 2 * COORD_SIZE, NewZ, 0, COORD_SIZE)
	buffer.copy(Result, 3 * COORD_SIZE, NewT, 0, COORD_SIZE)

	return Result
end

function Edwards25519.Scale(Point1)
	local Point1X = GetCoord(Point1, 0, COORD_BUFFER_0)
	local Point1Y = GetCoord(Point1, 1, COORD_BUFFER_1)
	local Point1Z = GetCoord(Point1, 2, COORD_BUFFER_2)

	FieldPrime.Invert(Point1Z, Point1Z)
	local ZInverse = Point1Z
	FieldPrime.Mul(Point1X, ZInverse, Point1X)
	local NewX = Point1X
	FieldPrime.Mul(Point1Y, ZInverse, Point1Y)
	local NewY = Point1Y
	local NewZ = FieldPrime.Num(1)
	local NewT = FieldPrime.Mul(NewX, NewY)

	local Result = buffer.create(POINT_SIZE)
	buffer.copy(Result, 0 * COORD_SIZE, NewX, 0, COORD_SIZE)
	buffer.copy(Result, 1 * COORD_SIZE, NewY, 0, COORD_SIZE)
	buffer.copy(Result, 2 * COORD_SIZE, NewZ, 0, COORD_SIZE)
	buffer.copy(Result, 3 * COORD_SIZE, NewT, 0, COORD_SIZE)

	return Result
end

function Edwards25519.Encode(Point1)
	local ScaledPoint = Edwards25519.Scale(Point1)
	local Point1X = GetCoord(ScaledPoint, 0, COORD_BUFFER_0)
	local Point1Y = GetCoord(ScaledPoint, 1, COORD_BUFFER_1)

	local EncodedY = FieldPrime.Encode(Point1Y)
	local CanonicalX = FieldPrime.Canonicalize(Point1X)
	local XSignBit = buffer.readf64(CanonicalX, 0) % 2

	local ResultBuffer = buffer.create(32)
	buffer.copy(ResultBuffer, 0, EncodedY, 0, 32)

	local LastByte = buffer.readu8(ResultBuffer, 31)
	buffer.writeu8(ResultBuffer, 31, LastByte + XSignBit * 128)

	return ResultBuffer
end

function Edwards25519.Decode(EncodedBuffer)
	local WorkingBuffer = buffer.create(32)
	buffer.copy(WorkingBuffer, 0, EncodedBuffer, 0, 32)

	local LastByte = buffer.readu8(WorkingBuffer, 31)
	local SignBit = bit32.extract(LastByte, 7)
	buffer.writeu8(WorkingBuffer, 31, bit32.band(LastByte, 0x7F))

	local YCoord = FieldPrime.Decode(WorkingBuffer)
	local YSquared = FieldPrime.Square(YCoord)
	local Numerator = FieldPrime.Sub(YSquared, FieldPrime.Num(1))
	local Denominator = FieldPrime.Mul(YSquared, CURVE_D)
	local DenomPlusOne = FieldPrime.Add(Denominator, FieldPrime.Num(1))

	local XCoord = FieldPrime.SqrtDiv(Numerator, DenomPlusOne)
	if not XCoord then
		return nil
	end

	local CanonicalX = FieldPrime.Canonicalize(XCoord)
	local XSignBit = buffer.readf64(CanonicalX, 0) % 2

	if XSignBit ~= SignBit then
		XCoord = FieldPrime.Carry(FieldPrime.Neg(XCoord))
	end

	local ZCoord = FieldPrime.Num(1)
	local TCoord = FieldPrime.Mul(XCoord, YCoord)

	local Result = buffer.create(POINT_SIZE)
	buffer.copy(Result, 0 * COORD_SIZE, XCoord, 0, COORD_SIZE)
	buffer.copy(Result, 1 * COORD_SIZE, YCoord, 0, COORD_SIZE)
	buffer.copy(Result, 2 * COORD_SIZE, ZCoord, 0, COORD_SIZE)
	buffer.copy(Result, 3 * COORD_SIZE, TCoord, 0, COORD_SIZE)

	return Result
end

local BASEPOINT_BYTES = buffer.create(32) do
	local BasePointHex = {
		0x58, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66,
		0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66,
		0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66,
		0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66
	}

	for Index = 1, 32 do
		buffer.writeu8(BASEPOINT_BYTES, Index - 1, BasePointHex[Index])
	end

	BASEPONT_G = Edwards25519.Decode(BASEPOINT_BYTES)
end

function Edwards25519.AffineRadixWTable(BasePoint, RadixWidth)
	if RadixWidth <= 0 or RadixWidth > 8 then
		error("Invalid Radix width", 2)
	end

	if buffer.len(BasePoint) ~= POINT_SIZE then
		error("Invalid Basepoint", 2)
	end

	local MaxWindows = math.ceil(256 / RadixWidth)
	local MaxRowSize = 2 ^ RadixWidth / 2

	local TableData = buffer.create(MaxWindows * MaxRowSize * AFFINE_NIELS_SIZE)

	local CurrentBasePoint = buffer.create(POINT_SIZE)
	buffer.copy(CurrentBasePoint, 0, BasePoint, 0, POINT_SIZE)

	local AffineNiels = Edwards25519.AffineNiels
	local Add = Edwards25519.Add
	local Double = Edwards25519.Double
	local Scale = Edwards25519.Scale
	local Niels = Edwards25519.Niels
	local NielsSize = AFFINE_NIELS_SIZE

	for WindowIndex = 1, MaxWindows do
		local BaseOffset = ((WindowIndex - 1) * MaxRowSize * NielsSize)
		local WorkingPoint = buffer.create(POINT_SIZE)
		buffer.copy(WorkingPoint, 0, CurrentBasePoint, 0, POINT_SIZE)

		local ScaledPoint = Scale(WorkingPoint)
		local FirstAffineNiels = AffineNiels(ScaledPoint)
		buffer.copy(TableData, BaseOffset, FirstAffineNiels, 0, NielsSize)

		local FirstNiels = Niels(ScaledPoint)

		for Multiple = 2, MaxRowSize do
			Add(WorkingPoint, FirstNiels, WorkingPoint)
			local Scaled = Scale(WorkingPoint)
			local AffineNielsBuffer = AffineNiels(Scaled)

			local Offset = BaseOffset + ((Multiple - 1) * NielsSize)
			buffer.copy(TableData, Offset, AffineNielsBuffer, 0, NielsSize)
		end

		for _ = 1, RadixWidth do
			CurrentBasePoint = Double(CurrentBasePoint)
		end
	end

	return TableData
end

do
	if BASEPONT_G then
		AFFINE_BASEPOINT_TABLE = Edwards25519.AffineRadixWTable(BASEPONT_G, BASE_RADIX_WIDTH)
	end
end

function Edwards25519.GetAffineBasePointTableEntry(WindowIndex, Multiple, Storage)
	if not AFFINE_BASEPOINT_TABLE then
		return buffer.create(0)
	end

	local BaseOffset = ((WindowIndex - 1) * BASE_POINT_ROW * AFFINE_NIELS_SIZE)
	local Offset = BaseOffset + ((Multiple - 1) * AFFINE_NIELS_SIZE)

	local AffineNielsPoint = Storage or buffer.create(AFFINE_NIELS_SIZE)
	buffer.copy(AffineNielsPoint, 0, AFFINE_BASEPOINT_TABLE, Offset, AFFINE_NIELS_SIZE)

	return AffineNielsPoint
end

function Edwards25519.SignedRadixW(ScalarBits, ScalarBitCount, RadixWidth)
	if ScalarBitCount <= 0 or ScalarBitCount > 256 then
		error("Invalid scalar bit count", 2)
	end

	if RadixWidth <= 0 or RadixWidth > 8 then
		error("Invalid Radix width", 2)
	end

	local RadixValue = 2 ^ RadixWidth
	local HalfRadix = RadixValue / 2
	local MaxOutputLength = 272
	local OutputDigits = RADIX_OUTPUT
	local OutputLength, Accumulator = 0, 0
	local Multiplier = 1

	for BitIndex = 1, ScalarBitCount do
		if BitIndex > ScalarBitCount then
			break
		end

		local BitValue = buffer.readf64(ScalarBits, (BitIndex - 1) * 8)
		Accumulator = Accumulator + (BitValue * Multiplier)
		Multiplier = Multiplier * (2)

		while BitIndex == ScalarBitCount and Accumulator > 0 or Multiplier > RadixValue do
			if OutputLength >= MaxOutputLength then
				error("Output overflow in SignedRadixW")
			end

			local Remainder = Accumulator % RadixValue
			if Remainder >= HalfRadix then
				Remainder = Remainder - (RadixValue)
			end
			Accumulator = (Accumulator - Remainder) / RadixValue
			Multiplier = Multiplier / (RadixValue)
			buffer.writef64(OutputDigits, OutputLength * 8, Remainder)
			OutputLength = OutputLength + (1)
		end
	end

	return OutputDigits, OutputLength
end

function Edwards25519.WindowedNAF(ScalarBits, ScalarBitCount, WindowWidth)
	local WindowValue = 2 ^ WindowWidth
	local HalfWindow = WindowValue / 2
	local OutputNAF = NAF_OUTPUT
	local OutputLength = 0
	local Accumulator = 0
	local Multiplier = 1

	for BitIndex = 1, ScalarBitCount do
		local BitValue = buffer.readf64(ScalarBits, (BitIndex - 1) * 8)
		Accumulator = Accumulator + (BitValue * Multiplier)
		Multiplier = Multiplier * (2)

		while BitIndex == ScalarBitCount and Accumulator > 0 or Multiplier > WindowValue do
			if Accumulator % 2 == 0 then
				Accumulator = Accumulator / (2)
				Multiplier = Multiplier / (2)
				buffer.writef64(OutputNAF, OutputLength * 8, 0)
				OutputLength = OutputLength + (1)
			else
				local Remainder = Accumulator % WindowValue
				if Remainder >= HalfWindow then
					Remainder = Remainder - (WindowValue)
				end
				Accumulator = Accumulator - (Remainder)
				buffer.writef64(OutputNAF, OutputLength * 8, Remainder)
				OutputLength = OutputLength + (1)
			end
		end
	end

	while OutputLength > 0 and buffer.readf64(OutputNAF, (OutputLength - 1) * 8) == 0 do
		OutputLength = OutputLength - (1)
	end

	return OutputNAF, OutputLength
end

function Edwards25519.WindowedNAFTable(BasePoint, WindowWidth)
	local PointSize = POINT_SIZE
	local CoordSize = COORD_SIZE
	local CurveK = CURVE_K
	local MaxOddMultiples = 2 ^ WindowWidth

	Edwards25519.Double(BasePoint, NAF_TABLE_DOUBLED)

	local TableData = buffer.create(MaxOddMultiples * PointSize)

	local FAdd = FieldPrime.Add
	local FSub = FieldPrime.Sub
	local FMul = FieldPrime.Mul

	local P1X = NAF_TABLE_P1X
	local P1Y = NAF_TABLE_P1Y
	local P1Z = NAF_TABLE_P1Z
	local P1T = NAF_TABLE_P1T
	local N2P = NAF_TABLE_N2P
	local N2M = NAF_TABLE_N2M
	local N2Z = NAF_TABLE_N2Z
	local N2T = NAF_TABLE_N2T
	local TMP = NAF_TABLE_TMP
	local DBLP = NAF_TABLE_DBL_P
	local DBLM = NAF_TABLE_DBL_M
	local DBLZ = NAF_TABLE_DBL_Z
	local DBLT = NAF_TABLE_DBL_T
	local Doubled = NAF_TABLE_DOUBLED

	buffer.copy(P1X, 0, Doubled, 0, CoordSize)
	buffer.copy(P1Y, 0, Doubled, CoordSize, CoordSize)
	buffer.copy(P1Z, 0, Doubled, 2 * CoordSize, CoordSize)
	buffer.copy(P1T, 0, Doubled, 3 * CoordSize, CoordSize)

	FAdd(P1Y, P1X, DBLP)
	FSub(P1Y, P1X, DBLM)
	FAdd(P1Z, P1Z, DBLZ)
	FMul(P1T, CurveK, DBLT)

	buffer.copy(P1X, 0, BasePoint, 0, CoordSize)
	buffer.copy(P1Y, 0, BasePoint, CoordSize, CoordSize)
	buffer.copy(P1Z, 0, BasePoint, 2 * CoordSize, CoordSize)
	buffer.copy(P1T, 0, BasePoint, 3 * CoordSize, CoordSize)

	FAdd(P1Y, P1X, N2P)
	FSub(P1Y, P1X, N2M)
	FAdd(P1Z, P1Z, N2Z)
	FMul(P1T, CurveK, N2T)

	buffer.copy(TableData, 0, N2P, 0, CoordSize)
	buffer.copy(TableData, CoordSize, N2M, 0, CoordSize)
	buffer.copy(TableData, 2 * CoordSize, N2Z, 0, CoordSize)
	buffer.copy(TableData, 3 * CoordSize, N2T, 0, CoordSize)

	buffer.copy(P1X, 0, BasePoint, 0, CoordSize)
	buffer.copy(P1Y, 0, BasePoint, CoordSize, CoordSize)
	buffer.copy(P1Z, 0, BasePoint, 2 * CoordSize, CoordSize)
	buffer.copy(P1T, 0, BasePoint, 3 * CoordSize, CoordSize)

	for OddMultiple = 3, MaxOddMultiples, 2 do
		local CurrentOffset = ((OddMultiple - 1) * PointSize)

		FSub(P1Y, P1X, TMP)
		FMul(TMP, DBLM, TMP)
		FAdd(P1Y, P1X, N2P)
		FMul(N2P, DBLP, N2P)
		FMul(P1T, DBLT, P1T)
		FMul(P1Z, DBLZ, P1Z)

		FSub(N2P, TMP, N2M)
		FSub(P1Z, P1T, N2Z)
		FAdd(P1Z, P1T, P1Z)
		FAdd(N2P, TMP, N2P)

		FMul(N2M, N2Z, P1X)
		FMul(P1Z, N2P, P1Y)
		FMul(N2Z, P1Z, P1Z)
		FMul(N2M, N2P, P1T)

		FAdd(P1Y, P1X, N2P)
		FSub(P1Y, P1X, N2M)
		FAdd(P1Z, P1Z, N2Z)
		FMul(P1T, CurveK, N2T)

		buffer.copy(TableData, CurrentOffset, N2P, 0, CoordSize)
		buffer.copy(TableData, CurrentOffset + CoordSize, N2M, 0, CoordSize)
		buffer.copy(TableData, CurrentOffset + 2 * CoordSize, N2Z, 0, CoordSize)
		buffer.copy(TableData, CurrentOffset + 3 * CoordSize, N2T, 0, CoordSize)
	end

	return TableData
end

function Edwards25519.MulG(ScalarBits, ScalarBitCount)
	local PointSize = POINT_SIZE
	local CoordSize = COORD_SIZE
	local AffineNielsSize = AFFINE_NIELS_SIZE
	local IdentityO = IDENTITY_O
	local BaseRadixWidth = BASE_RADIX_WIDTH
	local BasePointRow = BASE_POINT_ROW
	local AffineTable = AFFINE_BASEPOINT_TABLE

	local SignedWindows, WindowCount = Edwards25519.SignedRadixW(ScalarBits, ScalarBitCount, BaseRadixWidth)

	local ResultPoint = MULG_RESULT_POINT
	buffer.copy(ResultPoint, 0, IdentityO, 0, PointSize)

	local AffineNielsPoint = MULG_AFFINE_NIELS
	local DummyPoint = MULG_DUMMY_POINT
	buffer.copy(DummyPoint, 0, IdentityO, 0, PointSize)

	local FAdd = FieldPrime.Add
	local FSub = FieldPrime.Sub
	local FMul = FieldPrime.Mul

	local P1X = MULG_P1X
	local P1Y = MULG_P1Y
	local P1Z = MULG_P1Z
	local P1T = MULG_P1T
	local N2P = MULG_N2P
	local N2M = MULG_N2M
	local N2T = MULG_N2T
	local TMP = MULG_TMP

	for WindowIndex = 1, WindowCount do
		local WindowValue = buffer.readf64(SignedWindows, (WindowIndex - 1) * 8)

		if WindowValue > 0 then
			local BaseOffset = ((WindowIndex - 1) * BasePointRow * AffineNielsSize)
			local Offset = BaseOffset + ((WindowValue - 1) * AffineNielsSize)
			buffer.copy(AffineNielsPoint, 0, AffineTable, Offset, AffineNielsSize)

			buffer.copy(P1X, 0, ResultPoint, 0, CoordSize)
			buffer.copy(P1Y, 0, ResultPoint, CoordSize, CoordSize)
			buffer.copy(P1Z, 0, ResultPoint, 2 * CoordSize, CoordSize)
			buffer.copy(P1T, 0, ResultPoint, 3 * CoordSize, CoordSize)
			buffer.copy(N2P, 0, AffineNielsPoint, 0, CoordSize)
			buffer.copy(N2M, 0, AffineNielsPoint, CoordSize, CoordSize)
			buffer.copy(N2T, 0, AffineNielsPoint, 2 * CoordSize, CoordSize)

			FSub(P1Y, P1X, TMP)
			FMul(TMP, N2M, TMP)
			FAdd(P1Y, P1X, P1X)
			FMul(P1X, N2P, P1X)
			FMul(P1T, N2T, P1T)
			FAdd(P1Z, P1Z, P1Z)

			FSub(P1X, TMP, P1Y)
			FSub(P1Z, P1T, N2P)
			FAdd(P1Z, P1T, P1Z)
			FAdd(P1X, TMP, P1X)

			FMul(P1Y, N2P, TMP)
			FMul(P1Z, P1X, P1T)
			FMul(N2P, P1Z, P1Z)
			FMul(P1Y, P1X, P1X)

			buffer.copy(ResultPoint, 0, TMP, 0, CoordSize)
			buffer.copy(ResultPoint, CoordSize, P1T, 0, CoordSize)
			buffer.copy(ResultPoint, 2 * CoordSize, P1Z, 0, CoordSize)
			buffer.copy(ResultPoint, 3 * CoordSize, P1X, 0, CoordSize)

		elseif WindowValue < 0 then
			local BaseOffset = ((WindowIndex - 1) * BasePointRow * AffineNielsSize)
			local Offset = BaseOffset + (((-WindowValue) - 1) * AffineNielsSize)
			buffer.copy(AffineNielsPoint, 0, AffineTable, Offset, AffineNielsSize)

			buffer.copy(P1X, 0, ResultPoint, 0, CoordSize)
			buffer.copy(P1Y, 0, ResultPoint, CoordSize, CoordSize)
			buffer.copy(P1Z, 0, ResultPoint, 2 * CoordSize, CoordSize)
			buffer.copy(P1T, 0, ResultPoint, 3 * CoordSize, CoordSize)
			buffer.copy(N2P, 0, AffineNielsPoint, 0, CoordSize)
			buffer.copy(N2M, 0, AffineNielsPoint, CoordSize, CoordSize)
			buffer.copy(N2T, 0, AffineNielsPoint, 2 * CoordSize, CoordSize)

			FSub(P1Y, P1X, TMP)
			FMul(TMP, N2P, TMP)
			FAdd(P1Y, P1X, P1X)
			FMul(P1X, N2M, P1X)
			FMul(P1T, N2T, P1T)
			FAdd(P1Z, P1Z, P1Z)

			FSub(P1X, TMP, P1Y)
			FAdd(P1Z, P1T, N2P)
			FSub(P1Z, P1T, P1Z)
			FAdd(P1X, TMP, P1X)

			FMul(P1Y, N2P, TMP)
			FMul(P1Z, P1X, P1T)
			FMul(N2P, P1Z, P1Z)
			FMul(P1Y, P1X, P1X)

			buffer.copy(ResultPoint, 0, TMP, 0, CoordSize)
			buffer.copy(ResultPoint, CoordSize, P1T, 0, CoordSize)
			buffer.copy(ResultPoint, 2 * CoordSize, P1Z, 0, CoordSize)
			buffer.copy(ResultPoint, 3 * CoordSize, P1X, 0, CoordSize)

		else
			local BaseOffset = ((WindowIndex - 1) * BasePointRow * AffineNielsSize)
			buffer.copy(AffineNielsPoint, 0, AffineTable, BaseOffset, AffineNielsSize)

			buffer.copy(P1X, 0, DummyPoint, 0, CoordSize)
			buffer.copy(P1Y, 0, DummyPoint, CoordSize, CoordSize)
			buffer.copy(P1Z, 0, DummyPoint, 2 * CoordSize, CoordSize)
			buffer.copy(P1T, 0, DummyPoint, 3 * CoordSize, CoordSize)
			buffer.copy(N2P, 0, AffineNielsPoint, 0, CoordSize)
			buffer.copy(N2M, 0, AffineNielsPoint, CoordSize, CoordSize)
			buffer.copy(N2T, 0, AffineNielsPoint, 2 * CoordSize, CoordSize)

			FSub(P1Y, P1X, TMP)
			FMul(TMP, N2M, TMP)
			FAdd(P1Y, P1X, P1X)
			FMul(P1X, N2P, P1X)
			FMul(P1T, N2T, P1T)
			FAdd(P1Z, P1Z, P1Z)

			FSub(P1X, TMP, P1Y)
			FSub(P1Z, P1T, N2P)
			FAdd(P1Z, P1T, P1Z)
			FAdd(P1X, TMP, P1X)

			FMul(P1Y, N2P, TMP)
			FMul(P1Z, P1X, P1T)
			FMul(N2P, P1Z, P1Z)
			FMul(P1Y, P1X, P1X)

			buffer.copy(DummyPoint, 0, TMP, 0, CoordSize)
			buffer.copy(DummyPoint, CoordSize, P1T, 0, CoordSize)
			buffer.copy(DummyPoint, 2 * CoordSize, P1Z, 0, CoordSize)
			buffer.copy(DummyPoint, 3 * CoordSize, P1X, 0, CoordSize)
		end
	end

	local Output = buffer.create(PointSize)
	buffer.copy(Output, 0, ResultPoint, 0, PointSize)
	return Output
end

function Edwards25519.Mul(BasePoint, ScalarBits, ScalarBitCount)
	local PointSize = POINT_SIZE
	local CoordSize = COORD_SIZE
	local IdentityO = IDENTITY_O

	local NAFForm, NAFLength = Edwards25519.WindowedNAF(ScalarBits, ScalarBitCount, 5)
	local MultipleTable = Edwards25519.WindowedNAFTable(BasePoint, 5)

	local ResultPoint = MUL_RESULT_POINT
	buffer.copy(ResultPoint, 0, IdentityO, 0, PointSize)

	local NielsPoint = MUL_NIELS_POINT

	local Square = FieldPrime.Square
	local FAdd = FieldPrime.Add
	local FSub = FieldPrime.Sub
	local FMul = FieldPrime.Mul
	local Carry = FieldPrime.Carry

	local DoubleX = MUL_DOUBLE_X
	local DoubleY = MUL_DOUBLE_Y
	local DoubleZ = MUL_DOUBLE_Z
	local DoubleA = MUL_DOUBLE_A
	local DoubleB = MUL_DOUBLE_B
	local DoubleE = MUL_DOUBLE_E
	local DoubleG = MUL_DOUBLE_G

	local P1X = MUL_P1X
	local P1Y = MUL_P1Y
	local P1Z = MUL_P1Z
	local P1T = MUL_P1T
	local N2P = MUL_N2P
	local N2M = MUL_N2M
	local N2Z = MUL_N2Z
	local N2T = MUL_N2T
	local TMP = MUL_TMP

	for NAFIndex = NAFLength, 1, -1 do
		local NAFDigit = buffer.readf64(NAFForm, (NAFIndex - 1) * 8)

		if NAFDigit == 0 then
			buffer.copy(DoubleX, 0, ResultPoint, 0, CoordSize)
			buffer.copy(DoubleY, 0, ResultPoint, CoordSize, CoordSize)
			buffer.copy(DoubleZ, 0, ResultPoint, 2 * CoordSize, CoordSize)

			Square(DoubleX, DoubleA)
			Square(DoubleY, DoubleB)
			Square(DoubleZ, DoubleZ)
			FAdd(DoubleZ, DoubleZ, DoubleZ)
			FAdd(DoubleA, DoubleB, DoubleE)
			FAdd(DoubleX, DoubleY, DoubleX)
			Square(DoubleX, DoubleG)
			FSub(DoubleG, DoubleE, DoubleG)
			Carry(DoubleG, DoubleG)
			FSub(DoubleB, DoubleA, DoubleB)
			FSub(DoubleZ, DoubleB, DoubleZ)
			Carry(DoubleZ, DoubleZ)

			FMul(DoubleG, DoubleZ, DoubleX)
			FMul(DoubleB, DoubleE, DoubleY)
			FMul(DoubleZ, DoubleB, DoubleZ)
			FMul(DoubleG, DoubleE, DoubleE)

			buffer.copy(ResultPoint, 0, DoubleX, 0, CoordSize)
			buffer.copy(ResultPoint, CoordSize, DoubleY, 0, CoordSize)
			buffer.copy(ResultPoint, 2 * CoordSize, DoubleZ, 0, CoordSize)
			buffer.copy(ResultPoint, 3 * CoordSize, DoubleE, 0, CoordSize)

		elseif NAFDigit > 0 then
			buffer.copy(NielsPoint, 0, MultipleTable, ((NAFDigit - 1) * PointSize), PointSize)

			buffer.copy(P1X, 0, ResultPoint, 0, CoordSize)
			buffer.copy(P1Y, 0, ResultPoint, CoordSize, CoordSize)
			buffer.copy(P1Z, 0, ResultPoint, 2 * CoordSize, CoordSize)
			buffer.copy(P1T, 0, ResultPoint, 3 * CoordSize, CoordSize)
			buffer.copy(N2P, 0, NielsPoint, 0, CoordSize)
			buffer.copy(N2M, 0, NielsPoint, CoordSize, CoordSize)
			buffer.copy(N2Z, 0, NielsPoint, 2 * CoordSize, CoordSize)
			buffer.copy(N2T, 0, NielsPoint, 3 * CoordSize, CoordSize)

			FSub(P1Y, P1X, TMP)
			FMul(TMP, N2M, TMP)
			FAdd(P1Y, P1X, P1X)
			FMul(P1X, N2P, P1X)
			FMul(P1T, N2T, P1T)
			FMul(P1Z, N2Z, P1Z)

			FSub(P1X, TMP, P1Y)
			FSub(P1Z, P1T, N2P)
			FAdd(P1Z, P1T, P1Z)
			FAdd(P1X, TMP, P1X)

			FMul(P1Y, N2P, TMP)
			FMul(P1Z, P1X, P1T)
			FMul(N2P, P1Z, P1Z)
			FMul(P1Y, P1X, P1X)

			buffer.copy(ResultPoint, 0, TMP, 0, CoordSize)
			buffer.copy(ResultPoint, CoordSize, P1T, 0, CoordSize)
			buffer.copy(ResultPoint, 2 * CoordSize, P1Z, 0, CoordSize)
			buffer.copy(ResultPoint, 3 * CoordSize, P1X, 0, CoordSize)

		else
			buffer.copy(NielsPoint, 0, MultipleTable, (((-NAFDigit) - 1) * PointSize), PointSize)

			buffer.copy(P1X, 0, ResultPoint, 0, CoordSize)
			buffer.copy(P1Y, 0, ResultPoint, CoordSize, CoordSize)
			buffer.copy(P1Z, 0, ResultPoint, 2 * CoordSize, CoordSize)
			buffer.copy(P1T, 0, ResultPoint, 3 * CoordSize, CoordSize)
			buffer.copy(N2P, 0, NielsPoint, 0, CoordSize)
			buffer.copy(N2M, 0, NielsPoint, CoordSize, CoordSize)
			buffer.copy(N2Z, 0, NielsPoint, 2 * CoordSize, CoordSize)
			buffer.copy(N2T, 0, NielsPoint, 3 * CoordSize, CoordSize)

			FSub(P1Y, P1X, TMP)
			FMul(TMP, N2P, TMP)
			FAdd(P1Y, P1X, P1X)
			FMul(P1X, N2M, P1X)
			FMul(P1T, N2T, P1T)
			FMul(P1Z, N2Z, P1Z)

			FSub(P1X, TMP, P1Y)
			FAdd(P1Z, P1T, N2P)
			FSub(P1Z, P1T, P1Z)
			FAdd(P1X, TMP, P1X)

			FMul(P1Y, N2P, TMP)
			FMul(P1Z, P1X, P1T)
			FMul(N2P, P1Z, P1Z)
			FMul(P1Y, P1X, P1X)

			buffer.copy(ResultPoint, 0, TMP, 0, CoordSize)
			buffer.copy(ResultPoint, CoordSize, P1T, 0, CoordSize)
			buffer.copy(ResultPoint, 2 * CoordSize, P1Z, 0, CoordSize)
			buffer.copy(ResultPoint, 3 * CoordSize, P1X, 0, CoordSize)
		end
	end

	local Output = buffer.create(PointSize)
	buffer.copy(Output, 0, ResultPoint, 0, PointSize)
	return Output
end

return Edwards25519
end)()
local SHA512 = (function()
--!strict
--!optimize 2
--!native

local K_HI = {
	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
	0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
	0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
	0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
	0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
	0xca273ece, 0xd186b8c7, 0xeada7dd6, 0xf57d4f7f, 0x06f067aa, 0x0a637dc5, 0x113f9804, 0x1b710b35,
	0x28db77f5, 0x32caab7b, 0x3c9ebe0a, 0x431d67c4, 0x4cc5d4be, 0x597f299c, 0x5fcb6fab, 0x6c44198c,
}

local K_LO = {
	0xd728ae22, 0x23ef65cd, 0xec4d3b2f, 0x8189dbbc, 0xf348b538, 0xb605d019, 0xaf194f9b, 0xda6d8118,
	0xa3030242, 0x45706fbe, 0x4ee4b28c, 0xd5ffb4e2, 0xf27b896f, 0x3b1696b1, 0x25c71235, 0xcf692694,
	0x9ef14ad2, 0x384f25e3, 0x8b8cd5b5, 0x77ac9c65, 0x592b0275, 0x6ea6e483, 0xbd41fbd4, 0x831153b5,
	0xee66dfab, 0x2db43210, 0x98fb213f, 0xbeef0ee4, 0x3da88fc2, 0x930aa725, 0xe003826f, 0x0a0e6e70,
	0x46d22ffc, 0x5c26c926, 0x5ac42aed, 0x9d95b3df, 0x8baf63de, 0x3c77b2a8, 0x47edaee6, 0x1482353b,
	0x4cf10364, 0xbc423001, 0xd0f89791, 0x0654be30, 0xd6ef5218, 0x5565a910, 0x5771202a, 0x32bbd1b8,
	0xb8d2d0c8, 0x5141ab53, 0xdf8eeb99, 0xe19b48a8, 0xc5c95a63, 0xe3418acb, 0x7763e373, 0xd6b2b8a3,
	0x5defb2fc, 0x43172f60, 0xa1f0ab72, 0x1a6439ec, 0x23631e28, 0xde82bde9, 0xb2c67915, 0xe372532b,
	0xea26619c, 0x21c0c207, 0xcde0eb1e, 0xee6ed178, 0x72176fba, 0xa2c898a6, 0xbef90dae, 0x131c471b,
	0x23047d84, 0x40c72493, 0x15c9bebc, 0x9c100d4c, 0xcb3e42b6, 0xfc657e2a, 0x3ad6faec, 0x4a475817,
}

local W_HI = table.create(80)
local W_LO = table.create(80)
local RESULT_BUFFER = buffer.create(64)

local function PreProcess(Contents)
	local ContentLength = buffer.len(Contents)
	local Padding = (128 - ((ContentLength + 17) % 128)) % 128
	local NewLength = ContentLength + 1 + Padding + 16

	local Result = buffer.create(NewLength)
	buffer.copy(Result, 0, Contents)
	buffer.writeu8(Result, ContentLength, 0x80)
	buffer.fill(Result, ContentLength + 1, 0, Padding + 8)

	local BitLength = ContentLength * 8
	local LengthOffset = ContentLength + 1 + Padding + 8

	for Index = 7, 0, -1 do
		buffer.writeu8(Result, LengthOffset + Index, BitLength % 256)
		BitLength = BitLength // 256
	end

	return Result, NewLength
end

local function SHA512(Message)
	local Blocks, Length = PreProcess(Message)

	local Hi, Lo = W_HI, W_LO
	local KHi, KLo = K_HI, K_LO

	local H1Hi, H2Hi, H3Hi, H4Hi = 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a
	local H5Hi, H6Hi, H7Hi, H8Hi = 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
	local H1Lo, H2Lo, H3Lo, H4Lo = 0xf3bcc908, 0x84caa73b, 0xfe94f82b, 0x5f1d36f1
	local H5Lo, H6Lo, H7Lo, H8Lo = 0xade682d1, 0x2b3e6c1f, 0xfb41bd6b, 0x137e2179

	for Offset = 0, Length - 1, 128 do
		for T = 1, 16 do
			local ByteOffset = Offset + (T - 1) * 8
			Hi[T] = bit32.byteswap(buffer.readu32(Blocks, ByteOffset))
			Lo[T] = bit32.byteswap(buffer.readu32(Blocks, ByteOffset + 4))
		end

		for T = 17, 80 do
			local P15Hi, P15Lo = Hi[T - 15], Lo[T - 15]
			local P2Hi, P2Lo = Hi[T - 2], Lo[T - 2]

			local S0Lo = bit32.bxor(bit32.rshift(P15Lo, 1) + bit32.lshift(P15Hi, 31), bit32.rshift(P15Lo, 8) + bit32.lshift(P15Hi, 24), bit32.rshift(P15Lo, 7) + bit32.lshift(P15Hi, 25))
			local S1Lo = bit32.bxor(bit32.rshift(P2Lo, 19) + bit32.lshift(P2Hi, 13), bit32.lshift(P2Lo, 3) + bit32.rshift(P2Hi, 29), bit32.rshift(P2Lo, 6) + bit32.lshift(P2Hi, 26))

			local TmpLo = Lo[T - 16] + S0Lo + Lo[T - 7] + S1Lo
			Lo[T] = bit32.bor(TmpLo, 0)
			Hi[T] = bit32.bxor(bit32.rshift(P15Hi, 1) + bit32.lshift(P15Lo, 31), bit32.rshift(P15Hi, 8) + bit32.lshift(P15Lo, 24), bit32.rshift(P15Hi, 7)) +
				bit32.bxor(bit32.rshift(P2Hi, 19) + bit32.lshift(P2Lo, 13), bit32.lshift(P2Hi, 3) + bit32.rshift(P2Lo, 29), bit32.rshift(P2Hi, 6)) +
				Hi[T - 16] + Hi[T - 7] + TmpLo // 0x100000000
		end

		local AHi, ALo = H1Hi, H1Lo
		local BHi, BLo = H2Hi, H2Lo
		local CHi, CLo = H3Hi, H3Lo
		local DHi, DLo = H4Hi, H4Lo
		local EHi, ELo = H5Hi, H5Lo
		local FHi, FLo = H6Hi, H6Lo
		local GHi, GLo = H7Hi, H7Lo
		local HHi, HLo = H8Hi, H8Lo

		for T = 1, 79, 2 do
			local Sigma1Lo = bit32.bxor(bit32.rshift(ELo, 14) + bit32.lshift(EHi, 18), bit32.rshift(ELo, 18) + bit32.lshift(EHi, 14), bit32.lshift(ELo, 23) + bit32.rshift(EHi, 9))
			local Sigma1Hi = bit32.bxor(bit32.rshift(EHi, 14) + bit32.lshift(ELo, 18), bit32.rshift(EHi, 18) + bit32.lshift(ELo, 14), bit32.lshift(EHi, 23) + bit32.rshift(ELo, 9))
			local Sigma0Lo = bit32.bxor(bit32.rshift(ALo, 28) + bit32.lshift(AHi, 4), bit32.lshift(ALo, 30) + bit32.rshift(AHi, 2), bit32.lshift(ALo, 25) + bit32.rshift(AHi, 7))
			local Sigma0Hi = bit32.bxor(bit32.rshift(AHi, 28) + bit32.lshift(ALo, 4), bit32.lshift(AHi, 30) + bit32.rshift(ALo, 2), bit32.lshift(AHi, 25) + bit32.rshift(ALo, 7))
			local ChLo = bit32.band(ELo, FLo) + bit32.band(-1 - ELo, GLo)
			local ChHi = bit32.band(EHi, FHi) + bit32.band(-1 - EHi, GHi)
			local MajLo = bit32.band(CLo, BLo) + bit32.band(ALo, bit32.bxor(CLo, BLo))
			local MajHi = bit32.band(CHi, BHi) + bit32.band(AHi, bit32.bxor(CHi, BHi))

			local T1Lo = HLo + Sigma1Lo + ChLo + KLo[T] + Lo[T]
			local T1Hi = HHi + Sigma1Hi + ChHi + KHi[T] + Hi[T] + T1Lo // 0x100000000
			T1Lo = bit32.bor(T1Lo, 0)

			HHi, HLo = GHi, GLo
			GHi, GLo = FHi, FLo
			FHi, FLo = EHi, ELo

			local ELoNew = DLo + T1Lo
			EHi = DHi + T1Hi + ELoNew // 0x100000000
			ELo = bit32.bor(ELoNew, 0)

			DHi, DLo = CHi, CLo
			CHi, CLo = BHi, BLo
			BHi, BLo = AHi, ALo

			local ALoNew = T1Lo + Sigma0Lo + MajLo
			AHi = T1Hi + Sigma0Hi + MajHi + ALoNew // 0x100000000
			ALo = bit32.bor(ALoNew, 0)

			local T2 = T + 1
			Sigma1Lo = bit32.bxor(bit32.rshift(ELo, 14) + bit32.lshift(EHi, 18), bit32.rshift(ELo, 18) + bit32.lshift(EHi, 14), bit32.lshift(ELo, 23) + bit32.rshift(EHi, 9))
			Sigma1Hi = bit32.bxor(bit32.rshift(EHi, 14) + bit32.lshift(ELo, 18), bit32.rshift(EHi, 18) + bit32.lshift(ELo, 14), bit32.lshift(EHi, 23) + bit32.rshift(ELo, 9))
			Sigma0Lo = bit32.bxor(bit32.rshift(ALo, 28) + bit32.lshift(AHi, 4), bit32.lshift(ALo, 30) + bit32.rshift(AHi, 2), bit32.lshift(ALo, 25) + bit32.rshift(AHi, 7))
			Sigma0Hi = bit32.bxor(bit32.rshift(AHi, 28) + bit32.lshift(ALo, 4), bit32.lshift(AHi, 30) + bit32.rshift(ALo, 2), bit32.lshift(AHi, 25) + bit32.rshift(ALo, 7))
			ChLo = bit32.band(ELo, FLo) + bit32.band(-1 - ELo, GLo)
			ChHi = bit32.band(EHi, FHi) + bit32.band(-1 - EHi, GHi)
			MajLo = bit32.band(CLo, BLo) + bit32.band(ALo, bit32.bxor(CLo, BLo))
			MajHi = bit32.band(CHi, BHi) + bit32.band(AHi, bit32.bxor(CHi, BHi))

			T1Lo = HLo + Sigma1Lo + ChLo + KLo[T2] + Lo[T2]
			T1Hi = HHi + Sigma1Hi + ChHi + KHi[T2] + Hi[T2] + T1Lo // 0x100000000
			T1Lo = bit32.bor(T1Lo, 0)

			HHi, HLo = GHi, GLo
			GHi, GLo = FHi, FLo
			FHi, FLo = EHi, ELo

			ELoNew = DLo + T1Lo
			EHi = DHi + T1Hi + ELoNew // 0x100000000
			ELo = bit32.bor(ELoNew, 0)

			DHi, DLo = CHi, CLo
			CHi, CLo = BHi, BLo
			BHi, BLo = AHi, ALo

			ALoNew = T1Lo + Sigma0Lo + MajLo
			AHi = T1Hi + Sigma0Hi + MajHi + ALoNew // 0x100000000
			ALo = bit32.bor(ALoNew, 0)
		end

		H1Lo = H1Lo + ALo
		H1Hi = bit32.bor(H1Hi + AHi + H1Lo // 0x100000000, 0)
		H1Lo = bit32.bor(H1Lo, 0)

		H2Lo = H2Lo + BLo
		H2Hi = bit32.bor(H2Hi + BHi + H2Lo // 0x100000000, 0)
		H2Lo = bit32.bor(H2Lo, 0)

		H3Lo = H3Lo + CLo
		H3Hi = bit32.bor(H3Hi + CHi + H3Lo // 0x100000000, 0)
		H3Lo = bit32.bor(H3Lo, 0)

		H4Lo = H4Lo + DLo
		H4Hi = bit32.bor(H4Hi + DHi + H4Lo // 0x100000000, 0)
		H4Lo = bit32.bor(H4Lo, 0)

		H5Lo = H5Lo + ELo
		H5Hi = bit32.bor(H5Hi + EHi + H5Lo // 0x100000000, 0)
		H5Lo = bit32.bor(H5Lo, 0)

		H6Lo = H6Lo + FLo
		H6Hi = bit32.bor(H6Hi + FHi + H6Lo // 0x100000000, 0)
		H6Lo = bit32.bor(H6Lo, 0)

		H7Lo = H7Lo + GLo
		H7Hi = bit32.bor(H7Hi + GHi + H7Lo // 0x100000000, 0)
		H7Lo = bit32.bor(H7Lo, 0)

		H8Lo = H8Lo + HLo
		H8Hi = bit32.bor(H8Hi + HHi + H8Lo // 0x100000000, 0)
		H8Lo = bit32.bor(H8Lo, 0)
	end

	buffer.writeu32(RESULT_BUFFER, 0, bit32.byteswap(H1Hi))
	buffer.writeu32(RESULT_BUFFER, 4, bit32.byteswap(H1Lo))
	buffer.writeu32(RESULT_BUFFER, 8, bit32.byteswap(H2Hi))
	buffer.writeu32(RESULT_BUFFER, 12, bit32.byteswap(H2Lo))
	buffer.writeu32(RESULT_BUFFER, 16, bit32.byteswap(H3Hi))
	buffer.writeu32(RESULT_BUFFER, 20, bit32.byteswap(H3Lo))
	buffer.writeu32(RESULT_BUFFER, 24, bit32.byteswap(H4Hi))
	buffer.writeu32(RESULT_BUFFER, 28, bit32.byteswap(H4Lo))
	buffer.writeu32(RESULT_BUFFER, 32, bit32.byteswap(H5Hi))
	buffer.writeu32(RESULT_BUFFER, 36, bit32.byteswap(H5Lo))
	buffer.writeu32(RESULT_BUFFER, 40, bit32.byteswap(H6Hi))
	buffer.writeu32(RESULT_BUFFER, 44, bit32.byteswap(H6Lo))
	buffer.writeu32(RESULT_BUFFER, 48, bit32.byteswap(H7Hi))
	buffer.writeu32(RESULT_BUFFER, 52, bit32.byteswap(H7Lo))
	buffer.writeu32(RESULT_BUFFER, 56, bit32.byteswap(H8Hi))
	buffer.writeu32(RESULT_BUFFER, 60, bit32.byteswap(H8Lo))

	return RESULT_BUFFER
end

return SHA512
end)()
local ED25519_PUBLIC_KEY_SIZE, ED25519_SIGNATURE_SIZE = 32, 64
local function ConcatBuffers(...)
	local Buffers = {...}
	local TotalLength = 0

	for _, Buffer in Buffers do
		TotalLength = TotalLength + (buffer.len(Buffer))
	end

	local Result = buffer.create(TotalLength)
	local Offset = 0

	for _, Buffer in Buffers do
		local Length = buffer.len(Buffer)
		buffer.copy(Result, Offset, Buffer, 0, Length)
		Offset = Offset + (Length)
	end

	return Result
end

local function Verify(Message, PublicKey, Signature)
	if PublicKey == nil then
		error("PublicKey cannot be nil", 2)
	end

	if typeof(PublicKey) ~= "buffer" then
		error("invalid signature parameters", 0)
	end

	local PublicKeyLength = buffer.len(PublicKey)
	if PublicKeyLength ~= ED25519_PUBLIC_KEY_SIZE then
		error("invalid signature parameters", 0)
	end

	if Message == nil then
		error("Message cannot be nil", 2)
	end

	if typeof(Message) ~= "buffer" then
		error("invalid signature parameters", 0)
	end

	if Signature == nil then
		error("Signature cannot be nil", 2)
	end

	if typeof(Signature) ~= "buffer" then
		error("invalid signature parameters", 0)
	end

	local SignatureLength = buffer.len(Signature)
	if SignatureLength ~= ED25519_SIGNATURE_SIZE then
		error("invalid signature parameters", 0)
	end

	local LastByte = buffer.readu8(Signature, 63)
	if bit32.band(LastByte, 0xE0) ~= 0x00 then
		return false
	end

	local CommitmentBytes = buffer.create(32)
	buffer.copy(CommitmentBytes, 0, Signature, 0, 32)
	local ResponseBytes = buffer.create(32)
	buffer.copy(ResponseBytes, 0, Signature, 32, 32)

	if not FieldQuadratic.IsValidScalar(ResponseBytes) then
		return false
	end

	local PublicPoint = Edwards25519.Decode(PublicKey)
	if not PublicPoint then
		return false
	end

	local CommitmentPoint = Edwards25519.Decode(CommitmentBytes)
	if not CommitmentPoint then
		return false
	end

	if buffer.tostring(Edwards25519.Encode(CommitmentPoint)) ~= buffer.tostring(CommitmentBytes) then return false end
	local ChallengeInput = ConcatBuffers(CommitmentBytes, PublicKey, Message)
	local ChallengeHash = SHA512(ChallengeInput)
	local ChallengeScalar = FieldQuadratic.DecodeWide(ChallengeHash)

	local ResponseScalar = FieldQuadratic.Decode(ResponseBytes)
	local ResponseBits, ResponseBitCount = FieldQuadratic.Bits(ResponseScalar)
	local SB = Edwards25519.MulG(ResponseBits, ResponseBitCount)

	local ChallengeBits, ChallengeBitCount = FieldQuadratic.Bits(ChallengeScalar)
	local KA = Edwards25519.Mul(PublicPoint, ChallengeBits, ChallengeBitCount)

	local KANiels = Edwards25519.Niels(KA)
	local RKA = Edwards25519.Add(CommitmentPoint, KANiels)

	local SBNiels = Edwards25519.Niels(SB)
	local Difference = Edwards25519.Sub(RKA, SBNiels)

	Difference = Edwards25519.Double(Difference)
	Difference = Edwards25519.Double(Difference)
	Difference = Edwards25519.Double(Difference)

	local DifferenceX = buffer.create(104)
	local DifferenceT = buffer.create(104)
	buffer.copy(DifferenceX, 0, Difference, 0 * 104, 104)
	buffer.copy(DifferenceT, 0, Difference, 3 * 104, 104)

	local XIsZero = FieldPrime.Eqz(DifferenceX)
	local TIsZero = FieldPrime.Eqz(DifferenceT)

	return XIsZero and TIsZero
end


return function(message, publicKey, signature)
 local ok, valid = pcall(Verify, message, publicKey, signature)
 return ok and valid == true
end
end

local _kf_session_check
-- KeyForge VM interpreter (gen 2, tape format 2)
local _kf_unpack = table.unpack or unpack
local _kf_pack = table.pack or function(...) return { n = select("#", ...), ... } end
local _kf_next = next
local _kf_inv = {[2]=1,[30]=2,[34]=3,[39]=4,[24]=5,[1]=6,[16]=7,[31]=8,[29]=9,[33]=10,[32]=11,[26]=12,[21]=13,[41]=14,[25]=15,[20]=16,[4]=17,[22]=18,[15]=19,[23]=20,[42]=21,[3]=22,[45]=23,[37]=24,[36]=25,[13]=26,[28]=27,[27]=28,[8]=29,[40]=30,[35]=31,[9]=32,[10]=33,[43]=34,[44]=35,[18]=36,[17]=37,[12]=38,[6]=39,[14]=40,[38]=41,[11]=42,[5]=43,[19]=44,[7]=45}
local _kf_char, _kf_byte = string.char, string.byte
local _kf_MOD32 = 4294967296
local function _kf_u32(n)
  n = math.floor(tonumber(n) or 0)
  n = n % _kf_MOD32
  if n < 0 then n = n + _kf_MOD32 end
  return n
end
local _kf_band, _kf_bor, _kf_bxor, _kf_shl, _kf_shr
do
  local bx = bit32
  if type(bx) == "table" and type(bx.band) == "function" and type(bx.bor) == "function"
    and type(bx.bxor) == "function" and type(bx.lshift) == "function" and type(bx.rshift) == "function" then
    _kf_band, _kf_bor, _kf_bxor, _kf_shl, _kf_shr = bx.band, bx.bor, bx.bxor, bx.lshift, bx.rshift
  else
    _kf_band = function(a, b)
      a, b = _kf_u32(a), _kf_u32(b)
      local r, bit = 0, 1
      for _ = 1, 32 do
        if a % 2 == 1 and b % 2 == 1 then r = r + bit end
        a = math.floor(a / 2); b = math.floor(b / 2); bit = bit * 2
      end
      return r
    end
    _kf_bor = function(a, b)
      a, b = _kf_u32(a), _kf_u32(b)
      local r, bit = 0, 1
      for _ = 1, 32 do
        if a % 2 == 1 or b % 2 == 1 then r = r + bit end
        a = math.floor(a / 2); b = math.floor(b / 2); bit = bit * 2
      end
      return r
    end
    _kf_bxor = function(a, b)
      a, b = _kf_u32(a), _kf_u32(b)
      local r, bit = 0, 1
      for _ = 1, 32 do
        if a % 2 ~= b % 2 then r = r + bit end
        a = math.floor(a / 2); b = math.floor(b / 2); bit = bit * 2
      end
      return r
    end
    _kf_shl = function(a, n)
      a = _kf_u32(a)
      n = math.floor(tonumber(n) or 0) % 32
      for _ = 1, n do a = (a * 2) % _kf_MOD32 end
      return a
    end
    _kf_shr = function(a, n)
      a = _kf_u32(a)
      n = math.floor(tonumber(n) or 0) % 32
      for _ = 1, n do a = math.floor(a / 2) end
      return a
    end
  end
end
local function _kf_xs(state)
  state = _kf_bxor(state, _kf_shl(state, 13))
  state = _kf_bxor(state, _kf_shr(state, 17))
  state = _kf_bxor(state, _kf_shl(state, 5))
  return state
end
local function _kf_unscramble(s, gen, proto, idx, checkpoint)
  local n = #s
  if n == 0 then return s end
  local state = _kf_bxor(_kf_bxor(_kf_u32(gen * 2246822519), _kf_u32(proto * 3266489917)), _kf_u32(idx * 668265263))
  local out, chunk = {}, {}
  for first = 1, n, 256 do
    local count = math.min(256, n - first + 1)
    for j = 1, count do
      state = _kf_xs(state)
      chunk[j] = _kf_char(_kf_bxor(_kf_byte(s, first + j - 1), _kf_band(state, 255)))
    end
    out[#out + 1] = table.concat(chunk, "", 1, count)
    checkpoint()
  end
  return table.concat(out)
end
local function _kf_vm_run(tape, env, ...)
  if type(tape) ~= "string" then error("kfvm: tape must be a string", 0) end
  env = env or {}
  local byte, sub = string.byte, string.sub
  local pos, total = 1, #tape
  local clock = type(os) == "table" and os.clock
  local pause = type(task) == "table" and task.wait
  local isyieldable = type(coroutine) == "table" and coroutine.isyieldable
  local sliceStart = type(clock) == "function" and clock() or 0
  local function checkpoint()
    if _kf_session_check then _kf_session_check() end
    if type(pause) ~= "function" or type(clock) ~= "function" then return end
    if clock() - sliceStart < 0.008 then return end
    if type(isyieldable) == "function" and not isyieldable() then return end
    pause()
    sliceStart = clock()
  end

  local function u8()
    if pos > total then error("kfvm: truncated tape", 0) end
    local b = byte(tape, pos); pos = pos + 1; return b
  end
  local function u16()
    if pos + 1 > total then error("kfvm: truncated tape", 0) end
    local a, b = byte(tape, pos, pos + 1); pos = pos + 2
    return a + b * 256
  end
  local function u32()
    if pos + 3 > total then error("kfvm: truncated tape", 0) end
    local a, b, c, d = byte(tape, pos, pos + 3); pos = pos + 4
    return a + b * 256 + c * 65536 + d * 16777216
  end
  local function readbytes(n)
    if n < 0 or pos + n - 1 > total then error("kfvm: truncated tape", 0) end
    local s = sub(tape, pos, pos + n - 1); pos = pos + n; return s
  end

  if readbytes(4) ~= "KFVM" then error("kfvm: bad magic", 0) end
  if u8() ~= 2 then error("kfvm: unsupported tape format", 0) end
  if u8() ~= 2 then error("kfvm: tape generation mismatch", 0) end

  local numProtos = u16()
  local protos = {}
  for p = 0, numProtos - 1 do
    local pr = {}
    pr.numRegisters = u16()
    pr.numParams = u8()
    pr.isVararg = (u8() ~= 0)
    local nc = u16(); local K, encoded = {}, {}
    for i = 0, nc - 1 do
      local tag = u8()
      if tag == 0 then K[i] = nil
      elseif tag == 1 then K[i] = (u8() ~= 0)
      elseif tag == 2 then local len = u32(); K[i] = tonumber(readbytes(len))
      elseif tag == 3 then local len = u32(); encoded[i] = readbytes(len)
      else error("kfvm: bad constant tag", 0) end
      if i % 256 == 0 then checkpoint() end
    end
    local protoIndex = p
    setmetatable(K, {
      __index = function(constants, index)
        local value = encoded[index]
        if value == nil then return nil end
        value = _kf_unscramble(value, 2, protoIndex, index, checkpoint)
        constants[index], encoded[index] = value, nil
        return value
      end,
      __metatable = false,
    })
    pr.K = K
    local nu = u16(); local UV = {}
    for i = 0, nu - 1 do
      local kind = u8(); local idx = u16(); UV[i] = { kind, idx }
      if i % 256 == 0 then checkpoint() end
    end
    pr.UV, pr.numUpvals = UV, nu
    local ni = u32(); local OPc, Ac, Bc, Cc = {}, {}, {}, {}
    if ni > math.floor((total - pos + 1) / 13) then error("kfvm: truncated tape", 0) end
    for i = 1, ni do
      local wire, a0, a1, a2, a3, b0, b1, b2, b3, c0, c1, c2, c3 = byte(tape, pos, pos + 12)
      pos = pos + 13
      local canon = _kf_inv[wire]
      if not canon then error("kfvm: bad opcode", 0) end
      local a = a0 + a1 * 256 + a2 * 65536 + a3 * 16777216
      local b = b0 + b1 * 256 + b2 * 65536 + b3 * 16777216
      local c = c0 + c1 * 256 + c2 * 65536 + c3 * 16777216
      if a >= 2147483648 then a = a - 4294967296 end
      if b >= 2147483648 then b = b - 4294967296 end
      if c >= 2147483648 then c = c - 4294967296 end
      OPc[i], Ac[i], Bc[i], Cc[i] = canon, a, b, c
      if i % 256 == 0 then checkpoint() end
    end
    pr.OPc, pr.Ac, pr.Bc, pr.Cc, pr.n = OPc, Ac, Bc, Cc, ni
    protos[p] = pr
  end

  local execProto
  local function makeClosure(pi, U)
    return function(...) return execProto(pi, U, _kf_pack(...)) end
  end

  execProto = function(pi, U, args)
    local pr = protos[pi]
    if not pr then error("kfvm: bad proto", 0) end
    local OPc, Ac, Bc, Cc, K = pr.OPc, pr.Ac, pr.Bc, pr.Cc, pr.K
    local n = pr.n
    local R = {}
    for i = 0, pr.numParams - 1 do R[i] = args[i + 1] end
    -- args is private to this invocation and never mutated. Keep varargs in
    -- that pack instead of allocating and copying a second table per call.
    local varargCount = 0
    if pr.isVararg then
      varargCount = args.n - pr.numParams
      if varargCount < 0 then varargCount = 0 end
    end

    -- top implements the multi-value protocol: a producer (CALL/VARARG with a
    -- negative result count) writes all its values from a base register and sets
    -- top to base+count; the immediately following consumer (CALL/RETURN with a
    -- negative arg/value count) reads registers up to top. Fixed-count ops ignore it.
    local top = 0
    local pc = 1
    local argsBuf
    local preparedFor
    local steps = 0
    while pc <= n do
      steps = steps + 1
      if steps == 256 then steps = 0; checkpoint() end
      local op = OPc[pc]
      local a, b, c = Ac[pc], Bc[pc], Cc[pc]
      if op == 1 then R[a] = K[b]                       -- LOADK
      elseif op == 2 then R[a] = (b ~= 0)               -- LOADBOOL
      elseif op == 3 then R[a] = nil                    -- LOADNIL
      elseif op == 4 then R[a] = R[b]                   -- MOVE
      elseif op == 5 then R[a] = R[b] + R[c]            -- ADD
      elseif op == 6 then R[a] = R[b] - R[c]            -- SUB
      elseif op == 7 then R[a] = R[b] * R[c]            -- MUL
      elseif op == 8 then R[a] = R[b] / R[c]            -- DIV
      elseif op == 9 then R[a] = R[b] % R[c]            -- MOD
      elseif op == 10 then R[a] = -R[b]                 -- NEG
      elseif op == 11 then R[a] = not R[b]              -- NOT
      elseif op == 12 then R[a] = (R[b] == R[c])        -- EQ
      elseif op == 13 then R[a] = (R[b] < R[c])         -- LT
      elseif op == 14 then R[a] = (R[b] <= R[c])        -- LE
      elseif op == 15 then R[a] = R[b] .. R[c]          -- CONCAT
      elseif op == 16 then R[a] = #R[b]                 -- LEN
      elseif op == 17 then R[a] = env[K[b]]             -- GETGLOBAL
      elseif op == 18 then                              -- CALL a=base b=nargs c=nret
        local fn = R[a]
        local nargs = b
        if nargs < 0 then nargs = top - (a + 1) end
        if nargs < 0 then nargs = 0 end
        if c == 0 then
          if nargs == 0 then fn()
          elseif nargs == 1 then fn(R[a + 1])
          elseif nargs == 2 then fn(R[a + 1], R[a + 2])
          elseif nargs == 3 then fn(R[a + 1], R[a + 2], R[a + 3])
          else
            argsBuf = argsBuf or {}
            for i = 1, nargs do argsBuf[i] = R[a + i] end
            fn(_kf_unpack(argsBuf, 1, nargs))
          end
        elseif c == 1 then
          if nargs == 0 then R[a] = fn()
          elseif nargs == 1 then R[a] = fn(R[a + 1])
          elseif nargs == 2 then R[a] = fn(R[a + 1], R[a + 2])
          elseif nargs == 3 then R[a] = fn(R[a + 1], R[a + 2], R[a + 3])
          else
            argsBuf = argsBuf or {}
            for i = 1, nargs do argsBuf[i] = R[a + i] end
            R[a] = fn(_kf_unpack(argsBuf, 1, nargs))
          end
        else
          argsBuf = argsBuf or {}
          for i = 1, nargs do argsBuf[i] = R[a + i] end
          local res = _kf_pack(fn(_kf_unpack(argsBuf, 1, nargs)))
          if c < 0 then
            for i = 0, res.n - 1 do R[a + i] = res[i + 1] end
            top = a + res.n
          else
            for i = 0, c - 1 do R[a + i] = res[i + 1] end
          end
        end
      elseif op == 19 then                              -- RETURN a=base b=count
        if b == 0 then return end
        local cnt = b
        if cnt < 0 then cnt = top - a end
        if cnt <= 0 then return
        elseif cnt == 1 then return R[a]
        elseif cnt == 2 then return R[a], R[a + 1]
        elseif cnt == 3 then return R[a], R[a + 1], R[a + 2]
        else
          argsBuf = argsBuf or {}
          for i = 0, cnt - 1 do argsBuf[i + 1] = R[a + i] end
          return _kf_unpack(argsBuf, 1, cnt)
        end
      elseif op == 20 then pc = pc + c                  -- JMP
      elseif op == 21 then if not R[a] then pc = pc + c end -- TEST
      elseif op == 22 then R[a] = {}                    -- NEWTABLE
      elseif op == 23 then R[a] = R[b][R[c]]            -- GETINDEX  R[a]=R[b][R[c]]
      elseif op == 24 then R[a][R[b]] = R[c]            -- SETINDEX  R[a][R[b]]=R[c]
      elseif op == 25 then                              -- CLOSURE a, proto b
        local child = protos[b]
        if not child then error("kfvm: bad child proto", 0) end
        local U2 = {}
        for i = 0, child.numUpvals - 1 do
          local d = child.UV[i]
          if d[1] == 0 then U2[i] = R[d[2]] else U2[i] = U[d[2]] end
        end
        R[a] = makeClosure(b, U2)
      elseif op == 26 then R[a] = U[b][1]               -- GETUPVAL
      elseif op == 27 then U[a][1] = R[b]               -- SETUPVAL  a=upval idx
      elseif op == 28 then R[a] = {}                    -- BOXNEW (cell; value at [1])
      elseif op == 29 then R[a] = R[b][1]               -- BOXGET
      elseif op == 30 then R[a][1] = R[b]               -- BOXSET
      elseif op == 31 then                              -- VARARG a, b=count
        if b < 0 then                                   -- spread all varargs; set top
          for i = 1, varargCount do R[a + i - 1] = args[pr.numParams + i] end
          top = a + varargCount
        else
          for i = 0, b - 1 do
            if i < varargCount then R[a + i] = args[pr.numParams + i + 1] else R[a + i] = nil end
          end
        end
      elseif op == 32 then                              -- FORPREP a, c=jmp
        -- Keep the initial value exact: subtracting then adding the step can
        -- cancel tiny values, overflow, or lose the sign of zero. Numeric
        -- strings still coerce as in Luau, without arithmetic on the start.
        R[a], R[a + 1], R[a + 2] = tonumber(R[a]), tonumber(R[a + 1]), tonumber(R[a + 2])
        -- FORPREP jumps straight to its matching FORLOOP, including after
        -- block relocation. This marker is private to the invocation/frame.
        preparedFor = a; pc = pc + c
      elseif op == 33 then                              -- FORLOOP a, c=jmp
        if preparedFor == a then preparedFor = nil else R[a] = R[a] + R[a + 2] end
        local idx, step, limit = R[a], R[a + 2], R[a + 1]
        local cont
        if step > 0 then cont = (idx <= limit) else cont = (idx >= limit) end
        if cont then R[a + 3] = idx; pc = pc + c end
      elseif op == 34 then                              -- TFORCALL a, c=nresults
        local fn = R[a]
        if type(fn) ~= "function" then
          -- Luau generalized iteration: first slot is a table, not pairs/ipairs.
          -- Rewrite to the pairs protocol once (covers getgc/GetChildren returns).
          local obj = fn
          local mt = getmetatable(obj)
          local iterMeta = type(mt) == "table" and mt.__iter or nil
          if type(iterMeta) == "function" then
            local ires = _kf_pack(iterMeta(obj))
            fn = ires[1]
            R[a] = fn
            R[a + 1], R[a + 2] = ires[2], ires[3]
          elseif type(obj) == "table" then
            fn = _kf_next
            R[a] = fn
            R[a + 1] = obj
          else
            error("kfvm: for iterator is not a function", 0)
          end
        end
        if type(fn) ~= "function" then error("kfvm: for iterator is not a function", 0) end
        if c <= 2 then
          local r1, r2 = fn(R[a + 1], R[a + 2])
          if c >= 1 then R[a + 3] = r1 end
          if c >= 2 then R[a + 4] = r2 end
        else
          local res = _kf_pack(fn(R[a + 1], R[a + 2]))
          for i = 0, c - 1 do R[a + 3 + i] = res[i + 1] end
        end
      elseif op == 35 then                              -- TFORLOOP a, c=jmp
        if R[a + 3] ~= nil then R[a + 2] = R[a + 3]; pc = pc + c end
      elseif op == 36 then env[K[b]] = R[a]             -- SETGLOBAL
      elseif op == 37 then R[a] = R[b] ^ R[c]           -- POW
      elseif op == 38 then                              -- SETLIST a=table b=first c=startIndex
        local n = top - b
        if n < 0 then n = 0 end
        for i = 0, n - 1 do R[a][c + i] = R[b + i] end
      elseif op == 39 then R[a] = math.floor(R[b] / R[c]) -- FLOORDIV
      elseif op == 40 then R[a] = _kf_band(R[b], R[c])  -- BAND
      elseif op == 41 then R[a] = _kf_bor(R[b], R[c])   -- BOR
      elseif op == 42 then R[a] = _kf_bxor(R[b], R[c])  -- BXOR
      elseif op == 43 then R[a] = _kf_MOD32 - 1 - _kf_u32(R[b]) -- BNOT
      elseif op == 44 then R[a] = _kf_shl(R[b], R[c])   -- SHL
      elseif op == 45 then R[a] = _kf_shr(R[b], R[c])   -- SHR
      else
        error("kfvm: bad opcode", 0)
      end
      pc = pc + 1
    end
  end

  return execProto(0, {}, _kf_pack(...))
end
-- dont even know what this does, i just know i need itS

local sha256K = {
        0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
        0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
        0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
        0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
        0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
        0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
        0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
        0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}

-- Per-decryption scratch state for SHA-256(key[32] .. nonce[16] .. counterBE[4]).
-- The complete 64-round compression and counter-dependent schedule are recomputed.
-- The returned buffer is reused; consume it before requesting the next mask.
local function createSha256Mask(dek, nonce)
    if #dek ~= 32 or #nonce ~= 16 then return nil end
    local prefix, w, out = dek .. nonce, {}, buffer.create(32)
    for i = 0, 11 do
        local a,b,c,d = string.byte(prefix, i*4+1, i*4+4)
        w[i] = a*16777216+b*65536+c*256+d
    end
    w[13],w[14],w[15] = 0x80000000,0,416
    local xor,band,ror,shr,bnot = bit32.bxor,bit32.band,bit32.rrotate,bit32.rshift,bit32.bnot
    local write,swap = buffer.writeu32,bit32.byteswap
    return function(counter)
        w[12] = counter
        for i = 16, 63 do
            local a,b = w[i-15],w[i-2]
            w[i] = (w[i-16]+xor(ror(a,7),ror(a,18),shr(a,3))+w[i-7]+xor(ror(b,17),ror(b,19),shr(b,10)))%4294967296
        end
        local a,b,c,d,e,f,g,v = 0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19
        for i = 0, 63 do
            local t = (v+xor(ror(e,6),ror(e,11),ror(e,25))+xor(band(e,f),band(bnot(e),g))+sha256K[i+1]+w[i])%4294967296
            local u = (xor(ror(a,2),ror(a,13),ror(a,22))+xor(band(a,b),band(a,c),band(b,c)))%4294967296
            v,g,f,e,d,c,b,a = g,f,e,(d+t)%4294967296,c,b,a,(t+u)%4294967296
        end
        write(out,0,swap((a+0x6a09e667)%4294967296))
        write(out,4,swap((b+0xbb67ae85)%4294967296))
        write(out,8,swap((c+0x3c6ef372)%4294967296))
        write(out,12,swap((d+0xa54ff53a)%4294967296))
        write(out,16,swap((e+0x510e527f)%4294967296))
        write(out,20,swap((f+0x9b05688c)%4294967296))
        write(out,24,swap((g+0x1f83d9ab)%4294967296))
        write(out,28,swap((v+0x5be0cd19)%4294967296))
        return out
    end
end

local function sha256(s, raw)
    local k = sha256K
    local h = {0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
    local length = #s * 8
    s = s .. string.char(128) .. string.rep("\0", (55 - #s) % 64)
    for shift = 56, 0, -8 do s = s .. string.char(math.floor(length / 2 ^ shift) % 256) end
    local xor, band, ror, shr, bnot = bit32.bxor, bit32.band, bit32.rrotate, bit32.rshift, bit32.bnot
    local w = {}
    for pos = 1, #s, 64 do
        for i = 0, 15 do local a,b,c,d = string.byte(s, pos + i * 4, pos + i * 4 + 3); w[i] = a*16777216+b*65536+c*256+d end
        for i = 16, 63 do
            local a,b = w[i-15],w[i-2]
            w[i] = (w[i-16] + xor(ror(a,7),ror(a,18),shr(a,3)) + w[i-7] + xor(ror(b,17),ror(b,19),shr(b,10))) % 4294967296
        end
        local a,b,c,d,e,f,g,v = table.unpack(h)
        for i = 0, 63 do
            local t = (v+xor(ror(e,6),ror(e,11),ror(e,25))+xor(band(e,f),band(bnot(e),g))+k[i+1]+w[i]) % 4294967296
            local u = (xor(ror(a,2),ror(a,13),ror(a,22))+xor(band(a,b),band(a,c),band(b,c))) % 4294967296
            v,g,f,e,d,c,b,a = g,f,e,(d+t)%4294967296,c,b,a,(t+u)%4294967296
        end
        h[1],h[2],h[3],h[4] = (h[1]+a)%4294967296,(h[2]+b)%4294967296,(h[3]+c)%4294967296,(h[4]+d)%4294967296
        h[5],h[6],h[7],h[8] = (h[5]+e)%4294967296,(h[6]+f)%4294967296,(h[7]+g)%4294967296,(h[8]+v)%4294967296
    end
    local out = {}
    for i = 1, 8 do
        local value = h[i]
        if raw then
            out[i] = string.char(shr(value,24),band(shr(value,16),255),band(shr(value,8),255),band(value,255))
        else
            out[i] = string.format("%08x",value)
        end
    end
    return table.concat(out)
end

-- requests

local jsonNull = {}
local function jsonError() error("Keyforge: invalid JSON", 0) end
local function validUtf8(s)
    local i = 1
    while i <= #s do
        local a = string.byte(s, i)
        local n, lo, hi = 0, 128, 191
        if a < 128 then n = 0
        elseif a >= 194 and a <= 223 then n = 1
        elseif a >= 224 and a <= 239 then
            n = 2
            if a == 224 then lo = 160 elseif a == 237 then hi = 159 end
        elseif a >= 240 and a <= 244 then
            n = 3
            if a == 240 then lo = 144 elseif a == 244 then hi = 143 end
        else return false end
        if i + n > #s then return false end
        for j = 1, n do
            local b = string.byte(s, i + j)
            if b < (j == 1 and lo or 128) or b > (j == 1 and hi or 191) then return false end
        end
        i = i + n + 1
    end
    return true
end
local function jsonQuote(s)
    if not validUtf8(s) then jsonError() end
    return '"' .. string.gsub(s, '[%z\1-\31\\"]', function(c)
        if c == '"' then return '\\"' elseif c == '\\' then return '\\\\' end
        return string.format('\\u%04x', string.byte(c))
    end) .. '"'
end
-- Preserve canonical flat requests; only the optional telemetry member may
-- contain one bounded object level. No arbitrary recursive tables/metatables.
local function jsonEncode(o)
    local function encode(object,depth)
        if type(object) ~= "table" or getmetatable(object) ~= nil then jsonError() end
        local keys,out={},{}
        for k in pairs(object) do
            if type(k) ~= "string" or #k>64 then jsonError() end
            keys[#keys+1]=k
            if #keys>32 then jsonError() end
        end
        table.sort(keys)
        for _,k in ipairs(keys) do
            local v=object[k]
            if type(v)=="string" then v=jsonQuote(v)
            elseif type(v)=="number" and v==math.floor(v) and math.abs(v)<=9007199254740991 then v=string.format("%.0f",v)
            elseif type(v)=="boolean" and depth==1 then v=v and "true" or "false"
            elseif type(v)=="table" and depth==0 and k=="telemetry" then v=encode(v,1)
            else jsonError() end
            out[#out+1]=jsonQuote(k)..":"..v
        end
        local result="{"..table.concat(out,",").."}"
        if depth==1 and #result>2048 then jsonError() end
        return result
    end
    return encode(o,0)
end
local function jsonDecode(s)
    if type(s) ~= "string" or #s > 32768 or not validUtf8(s) then jsonError() end
    local pos, length = 1, #s
    local function skip()
        while pos <= length do
            local c = string.byte(s, pos)
            if c ~= 32 and c ~= 9 and c ~= 10 and c ~= 13 then break end
            pos = pos + 1
        end
    end
    local function hex4()
        local h = string.sub(s, pos, pos + 3)
        if #h ~= 4 or string.find(h, "[^0-9a-fA-F]") then jsonError() end
        pos = pos + 4
        return tonumber(h, 16)
    end
    local function text()
        if string.byte(s, pos) ~= 34 then jsonError() end
        pos = pos + 1
        local out, start = {}, pos
        while pos <= length do
            local c = string.byte(s, pos)
            if c == 34 then out[#out + 1] = string.sub(s, start, pos - 1); pos = pos + 1; return table.concat(out) end
            if c < 32 then jsonError() end
            if c == 92 then
                out[#out + 1] = string.sub(s, start, pos - 1)
                pos = pos + 1
                local e = string.sub(s, pos, pos)
                pos = pos + 1
                local escapes = {['"']='"', ['\\']='\\', ['/']='/', b='\b', f='\f', n='\n', r='\r', t='\t'}
                if escapes[e] then out[#out + 1] = escapes[e]
                elseif e == "u" then
                    local cp = hex4()
                    if cp >= 0xd800 and cp <= 0xdbff then
                        if string.sub(s, pos, pos + 1) ~= "\\u" then jsonError() end
                        pos = pos + 2
                        local low = hex4()
                        if low < 0xdc00 or low > 0xdfff then jsonError() end
                        cp = 0x10000 + (cp - 0xd800) * 1024 + low - 0xdc00
                    elseif cp >= 0xdc00 and cp <= 0xdfff then jsonError() end
                    if cp < 128 then out[#out + 1] = string.char(cp)
                    elseif cp < 2048 then out[#out + 1] = string.char(192 + math.floor(cp / 64), 128 + cp % 64)
                    elseif cp < 65536 then out[#out + 1] = string.char(224 + math.floor(cp / 4096), 128 + math.floor(cp / 64) % 64, 128 + cp % 64)
                    else out[#out + 1] = string.char(240 + math.floor(cp / 262144), 128 + math.floor(cp / 4096) % 64, 128 + math.floor(cp / 64) % 64, 128 + cp % 64) end
                else jsonError() end
                start = pos
            else pos = pos + 1 end
        end
        jsonError()
    end
    local value
    value = function(depth)
        if depth > 8 then jsonError() end
        skip()
        local c = string.sub(s, pos, pos)
        if c == '"' then return text() end
        if c == "{" or c == "[" then
            local object, out, seen = c == "{", {}, {}
            local close = object and "}" or "]"
            pos = pos + 1; skip()
            if string.sub(s, pos, pos) == close then pos = pos + 1; return out end
            while true do
                skip()
                local k = #out + 1
                if object then
                    k = text(); skip()
                    if seen[k] or string.sub(s, pos, pos) ~= ":" then jsonError() end
                    seen[k] = true; pos = pos + 1
                end
                out[k] = value(depth + 1); skip()
                local sep = string.sub(s, pos, pos); pos = pos + 1
                if sep == close then return out end
                if sep ~= "," then jsonError() end
            end
        end
        for literal, v in pairs({["true"]=true, ["false"]=false, ["null"]=jsonNull}) do
            if string.sub(s, pos, pos + #literal - 1) == literal then pos = pos + #literal; return v end
        end
        local start = pos
        if c == "-" then pos = pos + 1 end
        c = string.sub(s, pos, pos)
        if c == "0" then pos = pos + 1
        elseif string.find(c, "^[1-9]$") then
            repeat pos = pos + 1 until not string.find(string.sub(s, pos, pos), "^[0-9]$")
        else jsonError() end
        if string.sub(s, pos, pos) == "." then
            pos = pos + 1
            if not string.find(string.sub(s, pos, pos), "^[0-9]$") then jsonError() end
            repeat pos = pos + 1 until not string.find(string.sub(s, pos, pos), "^[0-9]$")
        end
        c = string.sub(s, pos, pos)
        if c == "e" or c == "E" then
            pos = pos + 1; c = string.sub(s, pos, pos)
            if c == "+" or c == "-" then pos = pos + 1 end
            if not string.find(string.sub(s, pos, pos), "^[0-9]$") then jsonError() end
            repeat pos = pos + 1 until not string.find(string.sub(s, pos, pos), "^[0-9]$")
        end
        if pos - start > 64 then jsonError() end
        local n = tonumber(string.sub(s, start, pos - 1))
        if not n or n ~= n or math.abs(n) > 9007199254740991 then jsonError() end
        return n
    end
    local result = value(0); skip()
    if pos <= length then jsonError() end
    return result
end


local verify = _kf_create_ed25519_verifier()
local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
local function b64decode(s)
    if type(s) ~= "string" or #s % 4 == 1 or string.find(s, "[^A-Za-z0-9_-]") then error("Keyforge: invalid encoding", 0) end
    local out, n, bits = {}, 0, 0
    for i = 1, #s do
        local p = string.find(chars, string.sub(s, i, i), 1, true)
        n = n * 64 + p - 1
        bits = bits + 6
        if bits >= 8 then bits = bits - 8; out[#out + 1] = string.char(math.floor(n / 2 ^ bits) % 256); n = n % 2 ^ bits end
    end
    if n ~= 0 then error("Keyforge: invalid encoding", 0) end
    return table.concat(out)
end
local function token(s) return type(s) == "string" and #s == 43 and #b64decode(s) == 32 end
local function hex(s) return type(s) == "string" and #s == 64 and not string.find(s, "[^0-9a-f]") end
local function unhex(s)
    if not hex(s) then error("Keyforge: invalid key", 0) end
    return (string.gsub(s, "..", function(v) return string.char(tonumber(v, 16)) end))
end
local function integer(n) return type(n) == "number" and n == math.floor(n) and n >= 0 and n <= 9007199254740991 end
local monoStart, wallStart = os.clock(), os.time()
local lastClock = monoStart
local clockInvalid = false
local function clock()
    compilerCheck(os.clock, "os.clock")
    local n = os.clock()
    if clockInvalid or type(n) ~= "number" or n ~= n or n < lastClock or n == math.huge then
        clockInvalid = true
        error("Keyforge: invalid clock", 0)
    end
    lastClock = n
    return n
end
local function wallClock(monotonic)
    compilerCheck(os.time, "os.time")
    local n = os.time()
    if not integer(n) or math.abs((n - wallStart) - ((monotonic or clock()) - monoStart)) > 15 then
        clockInvalid = true
        error("Keyforge: invalid clock", 0)
    end
    return n
end
if not integer(wallStart) or type(monoStart) ~= "number" or monoStart ~= monoStart then error("Keyforge: invalid clock", 0) end
local executor = "unknown"
if type(identify) == "function" then local ok, v = pcall(identify); if ok and type(v) == "string" then executor = string.sub(string.lower(v), 1, 48) end end
local hwid = ""
if type(hwfn) == "function" then local ok, v = pcall(hwfn); if ok and type(v) == "string" then hwid = v end end
if #hwid<1 or #hwid>256 then error("Keyforge: device identifier unavailable",0) end
local function header(headers, name)
    if type(headers) ~= "table" then error("Keyforge: missing headers", 0) end
    local found, count = nil, 0
    for k, v in next, headers do
        count = count + 1
        if count > 128 or type(k) ~= "string" or #k > 256 then error("Keyforge: invalid headers", 0) end
        if string.lower(k) == name then
            if found ~= nil or type(v) ~= "string" then error("Keyforge: ambiguous proof", 0) end
            found = v
        end
    end
    return found
end
local function call(purpose, raw)
    local started = clock()
    for attempt = 1, 4 do
        local ok, r = checkedHttp({Url = base .. "/v1/runtime/" .. purpose, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = raw})
        if ok and type(r) == "table" then
            local status, body, headers = r.StatusCode, r.Body, r.Headers
            if not integer(status) then error("Keyforge: invalid response", 0) end
            if status == 200 then
                if clock() - started >= 30 then error("Keyforge: request timed out", 0) end
                if type(body) ~= "string" or #body > (purpose == "payload" and 33554432 or 32768) then error("Keyforge: invalid response", 0) end
                return {Body = body, Proof = purpose == "payload" and header(headers, "x-keyforge-proof") or nil}, started
            end
            if status < 500 and status ~= 429 then
                local code = "request_denied"
                local decoded, data = pcall(jsonDecode, body)
                if decoded and type(data) == "table" and type(data.error) == "string" and string.match(data.error, "^[a-z_]+$") and #data.error <= 64 then code = data.error end
                error("Keyforge: " .. code, 0)
            end
        end
        if clock() - started >= 14 then error("Keyforge: request timed out", 0) end
        if attempt < 4 then
            local delay = 2 ^ (attempt - 1)
            if clock() - started + delay >= 14 then break end
            wait(delay)
        end
    end
    error("Keyforge: server unavailable", 0)
end
local function proof(jws, purpose, raw, started)
    compilerCheck(buffer.fromstring, "buffer.fromstring")
    if type(jws) ~= "string" or #jws > 8192 then error("Keyforge: missing proof", 0) end
    local h, p, sig = string.match(jws, "^([A-Za-z0-9_-]+)%.([A-Za-z0-9_-]+)%.([A-Za-z0-9_-]+)$")
    if not h then error("Keyforge: invalid proof", 0) end
    local meta = jsonDecode(b64decode(h))
    if type(meta) ~= "table" or meta.alg ~= "EdDSA" or meta.typ ~= "keyforge-runtime+jws" or type(meta.kid) ~= "string" or not pinned[meta.kid] then error("Keyforge: unknown signing key", 0) end
    for k in pairs(meta) do if k ~= "alg" and k ~= "typ" and k ~= "kid" then error("Keyforge: unsupported proof", 0) end end
    local signature = b64decode(sig)
    if #signature ~= 64 or not verify(buffer.fromstring(h .. "." .. p), buffer.fromstring(unhex(pinned[meta.kid])), buffer.fromstring(signature)) then error("Keyforge: invalid signature", 0) end
    local g = jsonDecode(b64decode(p))
    if type(g) ~= "table" or g.protocol ~= 2 or g.purpose ~= purpose or g.script ~= scriptId
        or not token(g.client_challenge) or (clientChallenge and g.client_challenge ~= clientChallenge)
        or g.request_hash ~= sha256("POST\n/v1/runtime/" .. purpose .. "\n" .. raw)
        or not integer(g.expires) or not integer(g.server_time) or not integer(g.lease_until)
        or g.expires <= g.server_time or g.expires - g.server_time > 30
        or g.server_time > wallClock() + 15 or g.expires <= wallClock()
        or clock() - started >= g.expires - g.server_time then error("Keyforge: mismatched or expired proof", 0) end
    if g.runtime_version ~= runtimeVersion or g.format ~= executionFormat then error("Keyforge: download the updated loader", 0) end
    if type(g.release) ~= "string" or #g.release == 0 or #g.release > 64 or (releaseId and g.release ~= releaseId) then error("Keyforge: release mismatch", 0) end
    if g.terminal ~= nil then
        if purpose ~= "heartbeat" or g.terminal ~= "disconnect_local_player" or not token(g.session)
            or g.lease_until ~= 0 or g.credential ~= nil or g.payload_hash ~= nil or g.dek ~= nil or g.challenge ~= nil or g.telemetry ~= nil
            or type(g.action_id) ~= "string" or #g.action_id ~= 36 or string.find(g.action_id,"[^a-f0-9-]")
            or type(g.consent_revision) ~= "string" or #g.consent_revision < 1 or #g.consent_revision > 64 then error("Keyforge: invalid terminal proof",0) end
        local allowed={protocol=true,purpose=true,request_hash=true,session=true,script=true,release=true,format=true,runtime_version=true,client_challenge=true,server_time=true,expires=true,lease_until=true,terminal=true,action_id=true,consent_revision=true}
        for k in pairs(g) do if not allowed[k] then error("Keyforge: unsupported terminal proof",0) end end
        return g
    end
    if purpose == "challenge" then
        if not token(g.challenge) or g.session ~= "" or g.lease_until ~= 0 or g.credential ~= nil then error("Keyforge: invalid challenge", 0) end
    else
        if not token(g.session) or not hex(g.payload_hash) or g.lease_until < g.expires or g.lease_until - g.server_time > 90 then error("Keyforge: invalid session", 0) end
        if purpose == "close" or purpose=="teleport" then
            if purpose=="teleport" and not token(g.resume) then error("Keyforge: invalid reconnect",0)end
            if g.credential ~= nil then error("Keyforge: invalid close", 0) end
        elseif not token(g.credential) then error("Keyforge: invalid credential", 0) end
        if g.dek ~= nil and (purpose == "close" or not token(g.dek)) then error("Keyforge: invalid payload key", 0) end
    end
    return g
end
local function exchange(purpose, data)
    local raw = jsonEncode(data)
    local r, started = call(purpose, raw)
    local body = jsonDecode(r.Body)
    if type(body) ~= "table" then error("Keyforge: missing proof", 0) end
    return proof(body.proof, purpose, raw, started), started
end
local function leaseDeadline(g, started)
    return math.min(started + g.lease_until - g.server_time, clock() + g.lease_until - wallClock())
end
-- A clock stamp varies request bytes; it is not entropy or a credential.
local stamp = string.format("%.17g:%.0f", monoStart, wallStart)
local context={}
pcall(function()
    context.place_id=string.format("%.0f",game.PlaceId)
    local player=game:GetService("Players").LocalPlayer
    if player then context.player_id=string.format("%.0f",player.UserId)end
end)
local challenge = exchange("challenge", {script = scriptId, format = executionFormat, runtime_version = runtimeVersion, protocol = 2, device = hwid, namespace = "hwid:" .. executor, execution_stamp = stamp, reporting_version = 2,place_id=context.place_id,player_id=context.player_id,executor=executor})
releaseId, clientChallenge = challenge.release, challenge.client_challenge
local auth, authTime = exchange("auth", {challenge = challenge.challenge, key = key,resume=resumeToken})
resumeToken=nil
key, challenge = nil, nil
local session, credential, payloadHash, payloadDek = auth.session, auth.credential, auth.payload_hash, auth.dek
local reconnect=auth.auto_reconnect==true
local deadline = leaseDeadline(auth, authTime)
local leaseUntil = auth.lease_until
-- Required reporting uses a disclosure, not a consent prompt. Legacy v1 stays separate.
local function _kf_required_reporting(policy, services)
    local revision, disclosure = policy.revision, policy.disclosure
    local active, screen = true, nil
    local function supported(p)
        return type(p)=="table" and p.version==2 and p.mode=="required" and p.disclosure=="usage-reporting-v2"
            and type(p.revision)=="string" and #p.revision>0 and #p.revision<=64
            and (p.retention_days==1 or p.retention_days==7 or p.retention_days==30)
    end
    local function destroy() if screen then pcall(function()screen:Destroy()end);screen=nil end end
    local h={destroy=destroy}
    -- Retained API names do not change the required reporting contract.
    function h.withdraw() end
    function h.choose() end
    function h.update(p)
        if not supported(p) or p.revision~=revision then active=false;destroy();return end
        policy=p
    end
    function h.disconnect(expected)
        local allowed=active and supported(policy) and policy.allow_game_disconnect==true and expected==revision
        active=false;destroy()
        if allowed then pcall(services.disconnect) end
        return allowed
    end
    function h.sample()
        if not active or not supported(policy) then return nil end
        local out={version=2,revision=revision,disclosure=disclosure,disconnect_consent=false,disconnect_capability=1}
        if policy.executor then
            local ok,v=pcall(services.executor)
            out.executor=ok and type(v)=="string" and #v<=64 and v or "unknown"
        end
        if policy.advanced then
            local ok,v=pcall(services.game)
            if ok and type(v)=="table" then
                for _,field in ipairs({"username","user_id","place_id","universe_id","job_id"}) do
                    if type(v[field])=="string" and #v[field]<=64 then out[field]=v[field] end
                end
            end
        end
        return out
    end
    if not supported(policy) then active=false;return h end
    return h
end

-- Optional analytics only. Existing license/device security and the separately
-- configured external hook are not controlled by this session privacy choice.
local function _kf_telemetry(policy, services)
    if type(policy)=="table" and policy.version==2 then return _kf_required_reporting(policy,services) end
    local consentExecutor, consentAdvanced, consentDisconnect, withdrawn = false, false, false, false
    local revision = type(policy)=="table" and policy.revision or ""
    local screen, panel, privacy
    local function supported(p)
        return type(p)=="table" and p.version==1 and type(p.revision)=="string" and #p.revision>0 and #p.revision<=64
            and (p.retention_days==1 or p.retention_days==7 or p.retention_days==30)
    end
    local function destroy()
        if screen then pcall(function()screen:Destroy()end);screen=nil end
    end
    local function withdraw()
        consentExecutor,consentAdvanced,consentDisconnect,withdrawn=false,false,false,true
        if panel then panel.Visible=false end
        if privacy then privacy.Text="Optional analytics off";privacy.Active=false end
    end
    local handle={withdraw=withdraw,destroy=destroy}
    function handle.update(p)
        if not supported(policy) then return end
        if not supported(p) or p.revision~=revision then withdraw();return end
        policy=p
        if not p.executor then consentExecutor=false end
        if not p.advanced then consentAdvanced=false end
        if not p.allow_game_disconnect then consentDisconnect=false end
    end
    function handle.choose(executor,advanced,disconnect)
        if withdrawn or not supported(policy) then return end
        consentExecutor=executor==true and policy.executor==true
        consentAdvanced=advanced==true and policy.advanced==true
        consentDisconnect=consentAdvanced and disconnect==true and policy.allow_game_disconnect==true
        if panel then panel.Visible=false end
        if privacy then privacy.Visible=true end
    end
    function handle.disconnect(expectedRevision)
        local allowed=not withdrawn and consentDisconnect and supported(policy) and policy.allow_game_disconnect==true and expectedRevision==revision
        consentDisconnect=false
        destroy()
        if allowed then pcall(services.disconnect) end
        return allowed
    end
    function handle.sample()
        if withdrawn then return {version=1,withdraw=true} end
        if not supported(policy) or (not consentExecutor and not consentAdvanced) then return nil end
        local out={version=1,revision=revision,executor_consent=consentExecutor,advanced_consent=consentAdvanced,disconnect_consent=consentDisconnect,disconnect_capability=1}
        if consentExecutor then
            local ok,v=pcall(services.executor)
            if ok and type(v)=="string" and #v<=64 then out.executor=v else out.executor="unknown" end
        end
        if consentAdvanced then
            local ok,v=pcall(services.game)
            if ok and type(v)=="table" then
                for _,field in ipairs({"username","user_id","place_id","universe_id","job_id"}) do
                    if type(v[field])=="string" and #v[field]<=64 then out[field]=v[field] end
                end
            end
        end
        return out
    end
    if not supported(policy) or (not policy.executor and not policy.advanced) then return handle end
    -- The notice is separate from owner-customizable designs. Script execution
    -- continues privately while the notice waits for an explicit session choice.
    local ok=pcall(function()
        if not Instance or not game then return end
        local parent=game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not parent then return end
        screen=Instance.new("ScreenGui");screen.Name="KeyforgePrivacy";screen.ResetOnSpawn=false;screen.DisplayOrder=110;screen.Parent=parent
        panel=Instance.new("Frame");panel.Size=UDim2.new(1,-32,1,-32);panel.Position=UDim2.fromOffset(16,16);panel.BackgroundColor3=Color3.fromRGB(22,24,28);panel.Parent=screen
        local limit=Instance.new("UISizeConstraint");limit.MaxSize=Vector2.new(460,480);limit.Parent=panel
        local scroll=Instance.new("ScrollingFrame");scroll.Name="PrivacyNoticeScroll";scroll.Size=UDim2.fromScale(1,1);scroll.BackgroundTransparency=1;scroll.BorderSizePixel=0;scroll.ScrollBarThickness=6;scroll.ScrollingDirection=Enum.ScrollingDirection.Y;scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y;scroll.CanvasSize=UDim2.fromOffset(0,0);scroll.Active=true;scroll.Selectable=true;scroll.Parent=panel
        local padding=Instance.new("UIPadding");padding.PaddingTop=UDim.new(0,12);padding.PaddingBottom=UDim.new(0,12);padding.PaddingLeft=UDim.new(0,12);padding.PaddingRight=UDim.new(0,12);padding.Parent=scroll
        local layout=Instance.new("UIListLayout");layout.Padding=UDim.new(0,10);layout.SortOrder=Enum.SortOrder.LayoutOrder;layout.Parent=scroll
        local notice=Instance.new("TextLabel");notice.Name="PrivacyDisclosure";notice.Size=UDim2.new(1,-30,0,0);notice.AutomaticSize=Enum.AutomaticSize.Y;notice.TextYAlignment=Enum.TextYAlignment.Top;notice.LayoutOrder=1;notice.BackgroundTransparency=1;notice.TextColor3=Color3.fromRGB(240,240,245);notice.TextSize=14;notice.TextWrapped=true;notice.RichText=false;notice.Font=Enum.Font.Arial;notice.Parent=scroll
        notice.Text="Optional session analytics\nOwner: "..string.sub(tostring(policy.owner or "Script owner"),1,100).."\nShare executor name"..(policy.advanced and ", Roblox username/user ID, place/universe/job IDs, estimated session time and a script-specific device pseudonym" or "").." for script analytics. Kept up to "..policy.retention_days.." days. Declining does not block your script. Other script/external analytics and license security are separate. Stop sharing here at any time."
        local disconnectChoice=false
        local function button(text,order,action)
            local b=Instance.new("TextButton");b.Text=text;b.Size=UDim2.new(1,-30,0,44);b.LayoutOrder=order;b.BackgroundColor3=Color3.fromRGB(50,53,60);b.TextColor3=Color3.fromRGB(255,255,255);b.TextSize=14;b.Font=Enum.Font.Arial;b.Selectable=true;b.Parent=scroll;b.Activated:Connect(action);return b
        end
        button("Continue privately",2,function()handle.choose(false,false)end)
        if policy.executor then button("Share executor only",3,function()handle.choose(true,false)end) end
        if policy.advanced then button("Share game details"..(policy.executor and " + executor" or ""),4,function()handle.choose(policy.executor,true,disconnectChoice)end) end
        if policy.allow_game_disconnect then
            local choice
            choice=button("Allow game disconnect: Off",5,function()disconnectChoice=not disconnectChoice;choice.Text="Allow game disconnect: "..(disconnectChoice and "On" or "Off")end)
            notice.Text=notice.Text.." If you turn game disconnect on and share game details, this script owner may end your current Roblox connection. This permission is optional and stops when you stop sharing."
        end
        privacy=Instance.new("TextButton");privacy.Name="StopOptionalAnalytics";privacy.Text="Stop optional analytics";privacy.Size=UDim2.fromOffset(210,32);privacy.Position=UDim2.fromOffset(16,16);privacy.BackgroundColor3=Color3.fromRGB(30,32,38);privacy.TextColor3=Color3.fromRGB(240,240,245);privacy.TextSize=14;privacy.Visible=false;privacy.Selectable=true;privacy.Parent=screen;privacy.Activated:Connect(withdraw)
    end)
    if not ok then destroy() end -- Fail privately, never block a valid script.
    return handle
end

local function _kf_notices(send, now)
    local screen
    local destroyed=false
    local stacks,connections={},{}
    local sequence=0
    local seen, panels = {}, {}
    local function make(class, props, parent)
        local v=Instance.new(class)
        for k,x in pairs(props)do v[k]=x end
        v.Parent=parent
        return v
    end
    local function round(v,n)make("UICorner",{CornerRadius=UDim.new(0,n)},v)end
    local function font(name)
        local ok,value=pcall(function()return Enum.Font[name]end)
        return ok and value or Enum.Font.Gotham
    end
    -- Themes: colors, font and shape. Accent comes from the broadcast color.
    -- Built on first render; Roblox types may not exist when this module loads.
    local themes
    local function themeList() if themes then return themes end themes={
        dark={bg=Color3.fromRGB(23,24,29),bgT=0,stroke=Color3.fromRGB(58,60,69),strokeT=0,width=1,text=Color3.fromRGB(235,237,244),muted=Color3.fromRGB(160,164,178),button=Color3.fromRGB(36,38,46),buttonT=0,font="Gotham",bold="GothamMedium",radius=14},
        glass={bg=Color3.fromRGB(255,255,255),bgT=.8,stroke=Color3.fromRGB(255,255,255),strokeT=.5,width=1,text=Color3.fromRGB(255,255,255),muted=Color3.fromRGB(232,237,247),button=Color3.fromRGB(255,255,255),buttonT=.84,font="Gotham",bold="GothamBold",radius=18},
        light={bg=Color3.fromRGB(255,255,255),bgT=0,stroke=Color3.fromRGB(17,24,39),strokeT=.88,width=1,text=Color3.fromRGB(17,24,39),muted=Color3.fromRGB(107,114,128),button=Color3.fromRGB(241,243,246),buttonT=0,font="Gotham",bold="GothamBold",radius=14},
        retro={bg=Color3.fromRGB(29,27,51),bgT=0,stroke=Color3.fromRGB(248,225,108),strokeT=0,width=3,text=Color3.fromRGB(248,225,108),muted=Color3.fromRGB(185,180,230),button=Color3.fromRGB(15,14,31),buttonT=0,font="Arcade",bold="Arcade",radius=0,small=true},
        neon={bg=Color3.fromRGB(7,7,13),bgT=.04,stroke=nil,strokeT=0,width=2,text=Color3.fromRGB(232,253,255),muted=Color3.fromRGB(127,179,189),button=Color3.fromRGB(13,13,26),buttonT=0,font="Michroma",bold="Michroma",radius=10,small=true},
    } return themes end
    local layouts={card={max=480,pad=16},banner={max=760,pad=12},toast={max=380,pad=12},center={max=440,pad=20}}
    local function stackFor(layout,position)
        local key=layout=="card" and position or layout
        if stacks[key] then return stacks[key] end
        local positions={['top-left']={0,0},['top-center']={.5,0},['top-right']={1,0},['bottom-left']={0,1},['bottom-center']={.5,1},['bottom-right']={1,1}}
        local point=layout=="banner" and positions['top-center'] or layout=="toast" and positions['bottom-center'] or layout=="center" and {.5,.5} or positions[position]
        local host=screen
        if layout=="center" then
            -- Centered popups dim the game so the question gets attention.
            host=make("Frame",{Name="CenterBackdrop",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Visible=false,ZIndex=0},screen)
        end
        local offsetY=point[2]==0 and 18 or point[2]==1 and -18 or 0
        local stack=make("ScrollingFrame",{AnchorPoint=Vector2.new(point[1],point[2]),Position=UDim2.new(point[1],point[1]==0 and 18 or point[1]==1 and -18 or 0,point[2],layout=="toast" and -90 or offsetY),Size=UDim2.new(1,-36,0,0),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ClipsDescendants=true},host)
        make("UISizeConstraint",{MaxSize=Vector2.new(layouts[layout].max+10,1000)},stack)
        local list=make("UIListLayout",{Padding=UDim.new(0,10),SortOrder=Enum.SortOrder.LayoutOrder,HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=point[2]==1 and Enum.VerticalAlignment.Bottom or Enum.VerticalAlignment.Top},stack)
        local camera=game:GetService("Workspace").CurrentCamera
        local function fit()
            if not stack.Parent then return end
            local height=camera and camera.ViewportSize.Y or 720
            stack.Size=UDim2.new(1,-36,0,math.min(list.AbsoluteContentSize.Y+6,math.max(100,height*(layout=="center" and .8 or .65))))
        end
        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fit)
        if camera then connections[#connections+1]=camera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)end
        fit()
        make("UIPadding",{PaddingTop=UDim.new(0,3),PaddingBottom=UDim.new(0,3),PaddingLeft=UDim.new(0,3),PaddingRight=UDim.new(0,3)},stack)
        stacks[key]={frame=stack,host=host,count=0}
        return stacks[key]
    end
    local function render(n)
        local player=game:GetService("Players").LocalPlayer
        local parent=player and player:FindFirstChildOfClass("PlayerGui")
        if not parent then return end
        if not screen then screen=make("ScreenGui",{Name="KeyforgeNotices",ResetOnSpawn=false,IgnoreGuiInset=false,DisplayOrder=1000,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},parent)end
        local positions={['top-left']=1,['top-center']=1,['top-right']=1,['bottom-left']=1,['bottom-center']=1,['bottom-right']=1}
        local position=positions[n.position] and n.position or 'top-center'
        local layout=layouts[n.layout] and n.layout or "card"
        local all=themeList();local theme=all[n.theme] or all.dark
        local spec=layouts[layout]
        local accent=Color3.fromRGB(109,153,255)
        if type(n.color)=="string"and string.match(n.color,"^#%x%x%x%x%x%x$")then accent=Color3.fromHex(n.color)end
        local stack=stackFor(layout,position)
        sequence=sequence+1
        local textSize=theme.small and 12 or (layout=="toast" and 14 or 15)
        local panel=make("Frame",{Size=UDim2.new(1,-10,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=theme.bg,BorderSizePixel=0,BackgroundTransparency=1,LayoutOrder=-sequence},stack.frame)
        make("UISizeConstraint",{MaxSize=Vector2.new(spec.max,1000)},panel);round(panel,theme.radius)
        make("UIStroke",{Color=theme.stroke or accent,Transparency=theme.strokeT,Thickness=theme.width},panel)
        if layout=="banner" then make("Frame",{Name="AccentBar",Size=UDim2.new(0,4,1,0),Position=UDim2.new(0,-spec.pad,0,0),BackgroundColor3=accent,BorderSizePixel=0,ZIndex=2},panel) end
        make("UIPadding",{PaddingTop=UDim.new(0,spec.pad),PaddingBottom=UDim.new(0,spec.pad),PaddingLeft=UDim.new(0,spec.pad+2),PaddingRight=UDim.new(0,spec.pad+2)},panel)
        make("UIListLayout",{Padding=UDim.new(0,layout=="toast" and 6 or 10),SortOrder=Enum.SortOrder.LayoutOrder},panel)
        local header=make("Frame",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,LayoutOrder=1},panel)
        make("TextLabel",{Size=UDim2.new(1,-36,1,0),BackgroundTransparency=1,Text=n.sender or "Script update",TextColor3=accent,TextSize=theme.small and 12 or 14,Font=font(theme.bold),TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,RichText=false},header)
        local exit=make("TextButton",{Size=UDim2.fromOffset(28,22),Position=UDim2.new(1,-28,0,0),Text="×",TextColor3=theme.muted,TextSize=23,BackgroundTransparency=1,Font=Enum.Font.Gotham},header)
        make("TextLabel",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Text=n.message,TextColor3=theme.text,TextSize=textSize,Font=font(theme.font),TextWrapped=true,TextXAlignment=layout=="center" and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,RichText=false,LineHeight=1.1,LayoutOrder=2},panel)
        local status=make("TextLabel",{Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,Text="",TextColor3=theme.muted,TextSize=12,Font=font(theme.font),TextXAlignment=Enum.TextXAlignment.Left,RichText=false,LayoutOrder=20},panel)
        panels[#panels+1]=panel
        if #panels>8 then local old=table.remove(panels,1);old:Destroy()end
        stack.count=stack.count+1
        if layout=="center" then stack.host.Visible=true;game:GetService("TweenService"):Create(stack.host,TweenInfo.new(.2),{BackgroundTransparency=.55}):Play() end
        local sending,answered,closed=false,false,false
        local choices={}
        local dismiss
        local function answer(value,chosen)
            if sending or answered or closed or now()>=n.expires then if now()>=n.expires then status.Text="This poll has ended." end return end
            sending=true;status.Text="Sending…"
            task.spawn(function()
                local ok,result=pcall(send,n.id,value)
                if panel.Parent then
                    if ok and result then
                        answered=true;status.Text=n.kind=="poll" and "Vote counted. Thank you!" or "Response sent. Thank you!"
                        -- Show the pick; lock the other options.
                        for _,b in ipairs(choices)do b.Active=false;b.AutoButtonColor=false;if b==chosen then b.BackgroundColor3=accent;b.BackgroundTransparency=0;b.TextColor3=Color3.new(1,1,1);b.Text="✓  "..b.Text else b.TextTransparency=.45 end end
                        task.delay(3,function()if panel.Parent and dismiss then dismiss()end end)
                    else status.Text="Could not send. Tap to try again." end
                end
                sending=false
            end)
        end
        local function button(text,order,fn)
            local b=make("TextButton",{Size=UDim2.new(1,0,0,36),BackgroundColor3=theme.button,BackgroundTransparency=theme.buttonT,Text=text,TextColor3=theme.text,TextSize=theme.small and 12 or 14,Font=font(theme.font),TextWrapped=true,AutomaticSize=Enum.AutomaticSize.Y,RichText=false,LayoutOrder=order},panel)
            round(b,math.min(theme.radius,10));make("UIStroke",{Color=theme.stroke or accent,Transparency=math.max(theme.strokeT,.55),Thickness=1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},b)
            make("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10)},b)
            b.Activated:Connect(function()fn(b)end);return b
        end
        if n.kind=="poll"then
            for i,option in ipairs(n.options)do choices[#choices+1]=button(option,i+3,function(b)answer(option,b)end)end
            status.Text="Choose an option"
        elseif n.questions then
            local input=make("TextBox",{Size=UDim2.new(1,0,0,62),BackgroundColor3=theme.button,BackgroundTransparency=theme.buttonT,Text="",PlaceholderText="Ask your question…",PlaceholderColor3=theme.muted,TextColor3=theme.text,TextSize=14,Font=font(theme.font),TextWrapped=true,ClearTextOnFocus=false,Visible=false,LayoutOrder=5,RichText=false},panel);round(input,8)
            input:GetPropertyChangedSignal("Text"):Connect(function()local at=utf8.offset(input.Text,241);if at and at<=#input.Text then input.Text=string.sub(input.Text,1,at-1)end end)
            local ask
            ask=button("Ask a question",6,function()
                if not input.Visible then input.Visible=true;ask.Text="Send question";input:CaptureFocus()
                elseif string.match(input.Text,"%S")then answer(input.Text,nil)end
            end)
        else status.Visible=false end
        game:GetService("TweenService"):Create(panel,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=theme.bgT}):Play()
        dismiss=function()
            if closed then return end;closed=true
            for i,v in ipairs(panels)do if v==panel then table.remove(panels,i);break end end
            panel:Destroy();stack.count=math.max(0,stack.count-1)
            if layout=="center" and stack.count==0 then stack.host.Visible=false;stack.host.BackgroundTransparency=1 end
        end
        exit.Activated:Connect(dismiss)
        -- Messages stay for their duration; polls and questions stay open until answered or ended.
        local interactive=n.kind=="poll" or n.questions
        local duration=math.max(0,n.expires-now())
        if not interactive then duration=math.min(n.duration_seconds or 10,duration) end
        task.delay(duration,function()if panel.Parent and not sending then dismiss()end end)
        return true
    end
    local function push(n)
        if destroyed or type(n)~="table"or type(n.id)~="string"or #n.id>128 or type(n.message)~="string"or #n.message>1000 or type(n.expires)~="number"or n.expires<=now()or seen[n.id]then return end
        if n.kind=="poll"and(type(n.options)~="table"or #n.options<2 or #n.options>6)then return end
        task.spawn(function()
            for attempt=1,20 do
                if destroyed or seen[n.id] or now()>=n.expires then return end
                local ok,shown=pcall(render,n)
                if ok and shown then seen[n.id]=true;return end
                task.wait(.25)
            end
        end)
    end
    return {push=push,destroy=function()destroyed=true;panels={};for _,connection in ipairs(connections)do connection:Disconnect()end;connections={};if screen then screen:Destroy();screen=nil;stacks={} end end}
end

local telemetry = _kf_telemetry(auth.telemetry, {
    disconnect=function() game:GetService("Players").LocalPlayer:Kick("The script owner ended this connection with your session permission.") end,
    executor=function() return type(identify)=="function" and identify() or "unknown" end,
    game=function()
        local player=game:GetService("Players").LocalPlayer
        local function decimal(n) if type(n)=="number" and n>0 and n<=9007199254740991 and n%1==0 then return string.format("%.0f",n) end end
        return {username=player.Name,user_id=decimal(player.UserId),place_id=decimal(game.PlaceId),universe_id=decimal(game.GameId),job_id=game.JobId}
    end
})
local issueReporting = type(auth.telemetry)=="table" and auth.telemetry.version==2 and auth.telemetry.advanced==true
auth = nil
local alive, closing, busy = true, false, false
local notices,teleportConnection
local lastUpdate
local function withinLease()
    local now = clock()
    return now < deadline and wallClock(now) < leaseUntil
end
local function active(allowClosing)
    if not alive or (closing and not allowClosing) then return false end
    local ok, valid = pcall(withinLease)
    if not ok or not valid then alive, credential = false, nil; telemetry.destroy(); return false end
    return true
end
local function runtime(purpose)
    while busy do
        if not active(purpose == "close") then error("Keyforge: session expired", 0) end
        wait()
    end
    if not active(purpose == "close") then error("Keyforge: session expired", 0) end
    busy = true
    local ok, result = pcall(function()
        local raw = jsonEncode({session = session, credential = credential, telemetry = telemetry.sample()})
        local r, started = call(purpose, raw)
        local jws
        if purpose == "payload" then jws = r.Proof
        else
            local body = jsonDecode(r.Body)
            if type(body) ~= "table" then error("Keyforge: missing proof", 0) end
            jws = body.proof
        end
        local g = proof(jws, purpose, raw, started)
        if g.terminal ~= nil then
            if g.session ~= session or not active() or g.expires>leaseUntil or clock()-started>=g.expires-g.server_time or g.expires<=wallClock() then error("Keyforge: expired terminal session",0) end
            -- Stop script activity before any cooperative local-client action.
            alive,credential,payloadDek=false,nil,nil
            telemetry.disconnect(g.consent_revision)
            return false
        end
        if g.session ~= session or g.payload_hash ~= payloadHash or (purpose ~= "close" and purpose~="teleport" and (g.credential == credential or (g.dek ~= nil and payloadDek ~= nil and g.dek ~= payloadDek))) then error("Keyforge: session mismatch", 0) end
        if purpose == "payload" and sha256(r.Body) ~= payloadHash then error("Keyforge: payload mismatch", 0) end
        if clock() - started >= g.expires - g.server_time or g.expires <= wallClock() then error("Keyforge: mismatched or expired proof", 0) end
        -- Current servers disclose the decryption key only on the signed download grant.
        if purpose == "payload" then payloadDek = g.dek end
        if g.owner_notice~=nil then
            local n=g.owner_notice
            if purpose~="heartbeat" or type(n)~="table" or type(n.id)~="string" or #n.id~=36 or type(n.message)~="string" or #n.message>500 then error("Keyforge: invalid owner message",0)end
            if notices then notices.push({id="owner:"..n.id,sender="Script owner",message=n.message,expires=wallClock()+10,duration_seconds=10}) end
        end
        if notices and purpose=="heartbeat" then
            if type(g.update_release)=="string" and #g.update_release<=128 and g.update_release~=lastUpdate then
                lastUpdate=g.update_release
                notices.push({id="update:"..g.update_release,sender="Script update",message="Your script creator pushed an update. Re-execute to get the latest version.",expires=wallClock()+15,duration_seconds=15})
            end
            if g.broadcast~=nil then notices.push(g.broadcast)end
        end
        telemetry.update(g.telemetry)
        credential = g.credential
        deadline = leaseDeadline(g, started)
        leaseUntil = g.lease_until
        if clock() >= deadline then error("Keyforge: session expired", 0) end
        if purpose == "close" or purpose=="teleport" then alive,closing = false,true; telemetry.destroy() end
        return purpose == "payload" and r.Body or purpose=="teleport" and g or true
    end)
    busy = false
    if not ok then alive, credential = false, nil; telemetry.destroy(); error(result, 0) end
    return result
end
local function close()
    if not active() then return false end
    closing = true
    if teleportConnection then teleportConnection:Disconnect();teleportConnection=nil end
    if notices then notices.destroy()end
    local ok = pcall(runtime, "close")
    alive, credential = false, nil
    return ok
end
sessionCloser=close
notices=_kf_notices(function(id,answer)
    -- A heartbeat may be rotating the credential; wait for it instead of failing the vote.
    for _=1,40 do if not busy then break end;task.wait(.25) end
    if busy or not active()then return false end
    local ok,response=checkedHttp({Url=base.."/v1/runtime/broadcast-response",Method="POST",Headers={["Content-Type"]="application/json"},Body=jsonEncode({session=session,credential=credential,id=id,answer=answer})})
    return ok and type(response)=="table" and response.StatusCode==200
end,wallClock)
if reconnect and type(teleportQueue)=="function" then
    pcall(function()
        local player=game:GetService("Players").LocalPlayer
        teleportConnection=player.OnTeleport:Connect(function(state)
            if state~=Enum.TeleportState.Started or not active()then return end
            local ok,grant=pcall(runtime,"teleport")
            if not ok or type(grant)~="table"or not token(grant.resume)then return end
            local url=base.."/v1/scripts/"..scriptId.."/loader"
            local source="local f=loadstring(game:HttpGet("..string.format("%q",url).."));if f then f({resume="..string.format("%q",grant.resume).."})end"
            pcall(teleportQueue,source)
            if notices then notices.destroy()end
            if teleportConnection then teleportConnection:Disconnect();teleportConnection=nil end
        end)
    end)
end
local issueSequence=0
local function reportIssue(message, trace, severity)
    if not issueReporting or not active() or busy then return false end
    local function bounded(v, limit)
        v=string.sub(tostring(v),1,limit)
        while #v>0 and not validUtf8(v) do v=string.sub(v,1,#v-1) end
        return v
    end
    issueSequence=issueSequence+1
    local raw=jsonEncode({session=session,credential=credential,event_id=sha256(session..stamp..tostring(issueSequence)),severity=severity or "error",message=bounded(message,1000),trace=bounded(trace or "",4000)})
    local ok,r=checkedHttp({Url=base.."/v1/runtime/issues",Method="POST",Headers={["Content-Type"]="application/json"},Body=raw})
    return ok and type(r)=="table" and r.StatusCode==200
end
local function issueHandler(err)
    local trace=""
    if type(traceback)=="function" then local ok,v=pcall(traceback,tostring(err),2);if ok then trace=v end end
    -- Error handlers cannot yield; send only after xpcall returns.
    return {value=err,trace=trace}
end
local function scriptCallback(fn)
    if type(fn)~="function" then return fn end
    return function(...)
        local args=table.pack(...)
        local result=table.pack(xpcall(function()return fn(table.unpack(args,1,args.n))end,issueHandler))
        if not result[1] then pcall(reportIssue,result[2].value,result[2].trace,"error");error(result[2].value,0) end
        return table.unpack(result,2,result.n)
    end
end
local scriptTasks=table.clone(task)
for _,name in ipairs({"spawn","defer"})do
    local native=task[name]
    if type(native)=="function" then scriptTasks[name]=function(fn,...)return native(scriptCallback(fn),...)end end
end
if type(task.delay)=="function" then scriptTasks.delay=function(seconds,fn,...)return task.delay(seconds,scriptCallback(fn),...)end end
freeze(scriptTasks)
local function scriptWarn(...)
    local values={};for i=1,select("#",...)do values[i]=tostring(select(i,...))end
    pcall(reportIssue,table.concat(values," "),"","warning")
    return warn(...)
end
local payload = runtime("payload")
if payloadDek then
    compilerCheck(buffer.fromstring, "buffer.fromstring")
    local dek, nonce = b64decode(payloadDek), string.sub(payload,1,16)
    if #payload<17 then close();error("Keyforge: invalid sealed payload",0) end
    local input, output = buffer.fromstring(payload), buffer.create(#payload-16)
    local maskForCounter = createSha256Mask(dek, nonce)
    local read32,write32,read8,write8,xor = buffer.readu32,buffer.writeu32,buffer.readu8,buffer.writeu8,bit32.bxor
    for offset=17,#payload,32 do
        local counter=math.floor((offset-17)/32)
        local mask
        if maskForCounter then
            mask=maskForCounter(counter)
        else
            local stamp=string.char(math.floor(counter/16777216)%256,math.floor(counter/65536)%256,math.floor(counter/256)%256,counter%256)
            mask=buffer.fromstring(sha256(dek..nonce..stamp, true))
        end
        local count=math.min(32,#payload-offset+1)
        local whole=count-count%4
        for j=0,whole-1,4 do write32(output,offset-17+j,xor(read32(input,offset-1+j),read32(mask,j))) end
        for j=whole,count-1 do write8(output,offset-17+j,xor(read8(input,offset-1+j),read8(mask,j))) end
        if offset%16384==17 and not active() then close();error("Keyforge: session expired",0) end
    end
    payload=buffer.tostring(output)
end
if ui then ui:Progress(70,"Starting script…") end
_kf_session_check = function()
    if cancelled then close();error("Keyforge: cancelled",0) end
    if not active() then error("Keyforge: session expired", 0) end
end
task.spawn(function()
    while alive and not closing do
        wait(1)
        if not active() then
            if not closing then warn("Keyforge: session expired") end
            break
        end
    end
end)
task.spawn(function()
    while alive and not closing do
        wait(30)
        if not alive or closing then break end
        local ok = pcall(runtime, "heartbeat")
        if not ok then alive, credential = false, nil; warn("Keyforge: session ended") end
    end
end)
local handle = freeze({reportError=function(message,trace)return reportIssue(message,trace,"error")end, reportWarning=function(message)return reportIssue(message,"","warning")end, stopOptionalAnalytics = telemetry.withdraw, close = close, isActive = function() return active() end})
local env = setmetatable({keyforge = handle,task=scriptTasks,warn=scriptWarn}, {__index = parent, __newindex = parent})
local function payloadCheck(fn)
    local ok, hooked = pcall(isHooked, fn)
    local checked, actual = pcall(getfenv, fn)
    if not ok or hooked ~= false or not checked or actual ~= env then
        error("Keyforge: payload integrity check failed", 0)
    end
end
if executionFormat == "source" then
    local views, backing, protected = {}, {}, {}
    local function view(t)
        if type(t) ~= "table" then error("Keyforge: invalid environment", 0) end
        if backing[t] then return t end
        if views[t] then return views[t] end
        local proxy = {}
        local mt = {
            __index = function(_, k)
                if k == "_G" then return view(type(globals) == "table" and globals or t) end
                return protected[k] or t[k]
            end,
            __newindex = function(_, k, v)
                if k == "_G" or protected[k] ~= nil then error("Keyforge: protected compiler binding", 0) end
                t[k] = v
            end,
        }
        setmetatable(proxy, mt)
        table.freeze(proxy)
        mt.__metatable = false
        table.freeze(mt)
        local newViews, newBacking = table.clone(views), table.clone(backing)
        newViews[t], newBacking[proxy] = proxy, t
        views, backing = freeze(newViews), freeze(newBacking)
        return proxy
    end
    protected.keyforge = handle
    protected.task = scriptTasks
    protected.warn = scriptWarn
    protected.loadstring = function(source, name)
        _kf_session_check()
        compilerCheck(nativeCompile)
        local fn, err = nativeCompile(source, name)
        if type(fn) == "function" then setfenv(fn, env);payloadCheck(fn) end
        _kf_session_check()
        return fn, err
    end
    protected.getgenv = function() return view(type(getgenv) == "function" and getgenv() or parent) end
    if type(getrenv) == "function" then protected.getrenv = function() return view(getrenv()) end end
    protected.getfenv = function(target)
        if target == nil then target = 1 end
        if type(target) == "number" and target > 0 then target = target + 1 end
        return view(getfenv(target))
    end
    protected.rawget = function(t, k)
        if backing[t] and (k == "_G" or protected[k] ~= nil) then return t[k] end
        return rawget(backing[t] or t, k)
    end
    protected.rawset = function(t, k, v)
        if backing[t] then
            if k == "_G" or protected[k] ~= nil then error("Keyforge: protected compiler binding", 0) end
            rawset(backing[t], k, v)
            return t
        end
        return rawset(t, k, v)
    end
    protected.next = function(t, k)
        local n, v = next(backing[t] or t, k)
        if n == "_G" or protected[n] ~= nil then v = t[n] end
        return n, v
    end
    protected.pairs = function(t)
        if backing[t] then return protected.next, t, nil end
        return pairs(t)
    end
    freeze(protected)
    env = view(parent)
end
local function readyUI()
    if ui then ui:Progress(100,"Ready");ui:Destroy();ui=nil end
end
local function run()
    _kf_session_check()
    if executionFormat == "vm" then readyUI();return _kf_vm_run(payload, env) end
    if type(nativeCompile) ~= "function" or type(setfenv) ~= "function" then error("Keyforge: native compiler unavailable", 0) end
    compilerCheck(nativeCompile)
    local fn = nativeCompile(payload, "@Keyforge")
    if type(fn) ~= "function" then error("Keyforge: payload compilation failed", 0) end
    payload = nil
    setfenv(fn, env)
    _kf_session_check()
    readyUI()
    payloadCheck(fn)
    return fn()
end
local result = table.pack(xpcall(run,issueHandler))
payload = nil
if not result[1] then pcall(reportIssue,result[2].value,result[2].trace,"error");close(); error(result[2].value, 0) end
return table.unpack(result, 2, result.n)

end
local prompted=not resumeToken and type(key)~="string"
showUI("loading")
if prompted then
    -- No key set: try keyless first. Keyed scripts answer key_required, then we ask for a key.
    if ui then ui:Progress(10,"Starting…") end
    local probe=table.pack(pcall(begin,""))
    if probe[1] then
        if ui then ui:Progress(100,"Ready");ui:Destroy() end
        return table.unpack(probe,2,probe.n)
    end
    if probe[2]~="Keyforge: key_required" then
        if ui then ui:Fail();ui:Status(tostring(probe[2]),true) end
        error(probe[2],0)
    end
    if ui then ui:Show("keygui") end
end
repeat
    if prompted then
        if not ui then error("Keyforge: set script_key to your license key",0) end
        while not submitted and not cancelled do wait() end
        if cancelled then error("Keyforge: cancelled",0) end
        key,submitted=submitted,nil
    end
    if ui then ui:Show("loading");ui:Progress(10,"Checking key…") end
    local result=table.pack(pcall(begin,key));key=nil
    if result[1] then
        if ui then ui:Progress(100,"Ready");ui:Destroy() end
        return table.unpack(result,2,result.n)
    end
    if prompted and not cancelled and ui then ui:Show("keygui");ui:Status(tostring(result[2]),true)
    else if ui then ui:Fail();ui:Status(tostring(result[2]),true) end;error(result[2],0) end
until cancelled

local Library = {}

function Library:CreateWindow(titleText)
    -- DETEKSI TEMPAT PENYIMPANAN UI YANG AMAN UNTUK SEMUA EXECUTOR
    local MainParent = nil
    local success, coregui = pcall(function() return game:GetService("CoreGui") end)
    
    if success and coregui then
        MainParent = coregui
    else
        MainParent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Hapus UI lama jika sudah ada agar tidak menumpuk saat di-execute ulang
    if MainParent:FindFirstChild("MyCustomHackMenu") then
        MainParent.MyCustomHackMenu:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MyCustomHackMenu"
    ScreenGui.Parent = MainParent
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 280, 0, 520) 
    MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.BorderSizePixel = 2
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 14
    Title.Parent = MainFrame

    self.MainFrame = MainFrame
    self.ElementCount = 0
    
    return MainFrame
end

function Library:CreateDropdown(labelText, options, callback)
    if not self.MainFrame then return end

    local Container = Instance.new("Frame")
    local yPosition = 50 + (self.ElementCount * 45)
    Container.Size = UDim2.new(0, 240, 0, 35)
    Container.Position = UDim2.new(0, 20, 0, yPosition)
    Container.BackgroundTransparency = 1
    Container.Parent = self.MainFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 100, 1, 0)
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Container

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 140, 1, 0)
    Button.Position = UDim2.new(0, 100, 0, 0)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    Button.Text = options[1].Name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 13
    Button.Parent = Container

    local currentIndex = 1
    Button.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then currentIndex = 1 end
        Button.Text = options[currentIndex].Name
        callback(options[currentIndex].Value)
    end)

    self.ElementCount = self.ElementCount + 1
end

function Library:CreateNumericInput(labelText, placeholder, callback)
    if not self.MainFrame then return end

    local Container = Instance.new("Frame")
    local yPosition = 50 + (self.ElementCount * 45)
    Container.Size = UDim2.new(0, 240, 0, 35)
    Container.Position = UDim2.new(0, 20, 0, yPosition)
    Container.BackgroundTransparency = 1
    Container.Parent = self.MainFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 100, 1, 0)
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Container

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0, 140, 1, 0)
    TextBox.Position = UDim2.new(0, 100, 0, 0)
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TextBox.Text = ""
    TextBox.PlaceholderText = placeholder
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Font = Enum.Font.SourceSans
    TextBox.TextSize = 13
    TextBox.Parent = Container

    TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        local cleanText = TextBox.Text:gsub("%D", "")
        if TextBox.Text ~= cleanText then
            TextBox.Text = cleanText
        end
    end)

    TextBox.FocusLost:Connect(function()
        local num = tonumber(TextBox.Text)
        if num then
            callback(num)
        else
            callback(0)
        end
    end)

    self.ElementCount = self.ElementCount + 1
end

function Library:CreateToggle(labelText, callback)
    if not self.MainFrame then return end

    local Container = Instance.new("Frame")
    local yPosition = 50 + (self.ElementCount * 45)
    Container.Size = UDim2.new(0, 240, 0, 35)
    Container.Position = UDim2.new(0, 20, 0, yPosition)
    Container.BackgroundTransparency = 1
    Container.Parent = self.MainFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 160, 1, 0)
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Container

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 60, 0, 28)
    ToggleButton.Position = UDim2.new(0, 180, 0, 3)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    ToggleButton.Text = "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.TextSize = 12
    ToggleButton.Parent = Container

    local isToggled = false
    ToggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        if isToggled then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
            ToggleButton.Text = "ON"
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
            ToggleButton.Text = "OFF"
        end
        callback(isToggled)
    end)

    self.ElementCount = self.ElementCount + 1
end

-- BUTTON TUTUP MENU MANDIRI (DITAMBAHKAN DI BAWAH INSTANCE)
function Library:CreateCloseButton()
    if not self.MainFrame then return end
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 240, 0, 30)
    Button.Position = UDim2.new(0, 20, 1, -45) -- Selalu nempel di dasar frame utama
    Button.BackgroundColor3 = Color3.fromRGB(150, 35, 35)
    Button.Text = "Close Exploit Menu"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 13
    Button.Parent = self.MainFrame

    Button.MouseButton1Click:Connect(function()
        self.MainFrame.Parent:Destroy()
        print("Menu berhasil dihancurkan.")
    end)
end

function Library:CreateSeparator(text)
    if not self.MainFrame then return end
    
    local SeparatorFrame = Instance.new("Frame")
    local yPosition = 50 + (self.ElementCount * 45)
    SeparatorFrame.Size = UDim2.new(0, 240, 0, 25)
    SeparatorFrame.Position = UDim2.new(0, 20, 0, yPosition)
    SeparatorFrame.BackgroundTransparency = 1
    SeparatorFrame.Parent = self.MainFrame
    
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 0.5, 0)
    Line.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
    Line.BorderSizePixel = 0
    Line.Parent = SeparatorFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 120, 1, 0)
    Label.Position = UDim2.new(0.5, -60, 0, 0)
    Label.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Label.Text = text:upper()
    Label.TextColor3 = Color3.fromRGB(120, 120, 130)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 11
    Label.Parent = SeparatorFrame
    
    self.ElementCount = self.ElementCount + 0.7
end

function Library:CreateButton(text, color, callback)
    if not self.MainFrame then return end
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 240, 0, 35)
    local yPosition = 50 + (self.ElementCount * 45)
    Button.Position = UDim2.new(0, 20, 0, yPosition)
    
    Button.BackgroundColor3 = color
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 14
    Button.Parent = self.MainFrame

    Button.MouseButton1Click:Connect(callback)
    
    self.ElementCount = self.ElementCount + 1
    return Button
end

return Library

local Library = {}

function Library:CreateWindow(titleText)
    local CoreGui = game:GetService("CoreGui")
    if CoreGui:FindFirstChild("MyCustomHackMenu") then
        CoreGui.MyCustomHackMenu:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MyCustomHackMenu"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 280, 0, 420) -- Diperlebar sedikit agar muat dropdown teks
    MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
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

-- FUNGSI BARU: MEMBUAT DROPDOWN / PILIHAN ITEM
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
    Button.Text = options[1].Name -- Default pilihan pertama
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

-- FUNGSI BARU: MEMBUAT INPUT KHUSUS NOMOR (VALIDASI OTOMATIS)
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

    -- Validasi Real-time: Hapus paksa jika ada huruf atau karakter spesial
    TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        local cleanText = TextBox.Text:gsub("%D", "") -- Hanya menyisakan digit [0-9]
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

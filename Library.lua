local Library = {}

function Library:CreateWindow(titleText)
    local MainParent = nil
    local success, coregui = pcall(function() return game:GetService("CoreGui") end)
    
    if success and coregui then
        MainParent = coregui
    else
        MainParent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    if MainParent:FindFirstChild("MyCustomHackMenu") then
        MainParent.MyCustomHackMenu:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MyCustomHackMenu"
    ScreenGui.Parent = MainParent
    ScreenGui.ResetOnSpawn = false

    -- Ukuran tinggi disesuaikan agar pas dengan navigasi tab bawah
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 280, 0, 420) 
    MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.BorderSizePixel = 2
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 14
    Title.Parent = MainFrame

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Position = UDim2.new(1, -40, 0, 0)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.TextSize = 16
    MinimizeButton.Parent = MainFrame

    -- CONTAINER UTAMA UNTUK HALAMAN TAB
    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, 0, 1, -85) -- Menyisakan ruang untuk title dan tab bar
    PageContainer.Position = UDim2.new(0, 0, 0, 40)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    -- BARIS NAVIGASI TAB DI BAGIAN BAWAH
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 45)
    TabBar.Position = UDim2.new(0, 0, 1, -45)
    TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabBar.BorderSizePixel = 0
    TabBar.Parent = MainFrame

    local TabBarLayout = Instance.new("UIListLayout")
    TabBarLayout.FillDirection = Enum.FillDirection.Horizontal
    TabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabBarLayout.Parent = TabBar

    local isMinimized = false
    local originalSize = MainFrame.Size

    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            MainFrame.Size = UDim2.new(0, 280, 0, 40)
            MinimizeButton.Text = "+"
            PageContainer.Visible = false
            TabBar.Visible = false
        else
            MainFrame.Size = originalSize
            MinimizeButton.Text = "-"
            PageContainer.Visible = true
            TabBar.Visible = true
        end
    end)

    self.MainFrame = MainFrame
    self.PageContainer = PageContainer
    self.TabBar = TabBar
    self.Tabs = {}
    self.ActivePage = nil
    self.TabCount = 0
    
    return MainFrame
end

function Library:CreateTab(tabName)
    if not self.PageContainer or not self.TabBar then return end
    
    self.TabCount = self.TabCount + 1
    local currentTabOrder = self.TabCount

    -- Pembuatan objek Halaman (Page)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)
    Page.Visible = false
    Page.Parent = self.PageContainer

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.Parent = Page
    
    -- Padding bagian dalam agar elemen tidak menempel batas atas
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.Parent = Page

    -- Tombol Navigasi Tab
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.5, 0, 1, 0) -- Otomatis membagi rata jika ada 2 tab
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TabButton.BorderSizePixel = 0
    TabButton.Text = tabName:upper()
    TabButton.TextColor3 = Color3.fromRGB(150, 150, 155)
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.TextSize = 13
    TabButton.LayoutOrder = currentTabOrder
    TabButton.Parent = self.TabBar

    -- Logika perpindahan halaman saat tab diklik
    local function SwitchToThisTab()
        for _, t in pairs(self.Tabs) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            t.Button.TextColor3 = Color3.fromRGB(150, 150, 155)
        end
        Page.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        self.ActivePage = Page
        
        -- Sesuaikan CanvasSize otomatis berdasarkan jumlah elemen di dalam tab
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
    end

    TabButton.MouseButton1Click:Connect(SwitchToThisTab)
    
    table.insert(self.Tabs, {Page = Page, Button = TabButton})
    
    -- Jika ini tab pertama, langsung aktifkan secara otomatis
    if #self.Tabs == 1 then
        SwitchToThisTab()
    end

    -- Update ukuran tombol tab secara dinamis menyesuaikan total tab yang ada
    local buttonWidth = 1 / #self.Tabs
    for _, t in pairs(self.Tabs) do
        t.Button.Size = UDim2.new(buttonWidth, 0, 1, 0)
    end

    -- Membuat object helper khusus agar elemen bisa dimasukkan langsung ke halaman ini
    local TabObject = {ElementCount = 0, Page = Page, PageLayout = PageLayout}
    
    function TabObject:CreateToggle(labelText, callback)
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(0, 240, 0, 35)
        Container.BackgroundTransparency = 1
        Container.LayoutOrder = self.ElementCount
        Container.Parent = self.Page

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
        self.Page.CanvasSize = UDim2.new(0, 0, 0, self.PageLayout.AbsoluteContentSize.Y + 20)
    end

    function TabObject:CreateNumericInput(labelText, placeholder, callback)
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(0, 240, 0, 35)
        Container.BackgroundTransparency = 1
        Container.LayoutOrder = self.ElementCount
        Container.Parent = self.Page

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
            local cleanText = TextBox.Text:gsub("[^%d%.%-]", "")
            if TextBox.Text ~= cleanText then
                TextBox.Text = cleanText
            end
        end)

        TextBox.FocusLost:Connect(function()
            local num = tonumber(TextBox.Text)
            callback(num or 0)
        end)

        self.ElementCount = self.ElementCount + 1
        self.Page.CanvasSize = UDim2.new(0, 0, 0, self.PageLayout.AbsoluteContentSize.Y + 20)
    end

    function TabObject:CreateButton(text, color, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 240, 0, 35)
        Button.BackgroundColor3 = color
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.SourceSansBold
        Button.TextSize = 14
        Button.LayoutOrder = self.ElementCount
        Button.Parent = self.Page

        Button.MouseButton1Click:Connect(callback)
        
        self.ElementCount = self.ElementCount + 1
        self.Page.CanvasSize = UDim2.new(0, 0, 0, self.PageLayout.AbsoluteContentSize.Y + 20)
        return Button
    end

    function TabObject:CreateSeparator(text)
        local SeparatorFrame = Instance.new("Frame")
        SeparatorFrame.Size = UDim2.new(0, 240, 0, 25)
        SeparatorFrame.BackgroundTransparency = 1
        SeparatorFrame.LayoutOrder = self.ElementCount
        SeparatorFrame.Parent = self.Page
        
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
        
        self.ElementCount = self.ElementCount + 1
        self.Page.CanvasSize = UDim2.new(0, 0, 0, self.PageLayout.AbsoluteContentSize.Y + 20)
    end

    return TabObject
end

function Library:CreateCloseButton()
    if not self.MainFrame then return end
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 240, 0, 30)
    Button.BackgroundColor3 = Color3.fromRGB(150, 35, 35)
    Button.Text = "Close Exploit Menu"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 13
    -- Nempel permanen di dasar Frame utama, di atas TabBar sedikit
    Button.Position = UDim2.new(0, 20, 1, -82)
    Button.Parent = self.MainFrame
    
    Button.MouseButton1Click:Connect(function()
        self.MainFrame.Parent:Destroy()
    end)
end

return Library

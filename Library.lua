local Library = {}

function Library:CreateWindow(titleText)
    local MainParent = nil
    local success, coregui = pcall(function() return game:GetService("CoreGui") end)
    if success and coregui then MainParent = coregui else MainParent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end
    
    if MainParent:FindFirstChild("TrashTycoonUI") then MainParent.TrashTycoonUI:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TrashTycoonUI"
    ScreenGui.Parent = MainParent
    ScreenGui.ResetOnSpawn = false

    -- FRAME UTAMA (Dibuat agak lebar untuk mengakomodasi Sidebar samping)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 380, 0, 320)
    MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    -- Membuat rounded corner biar estetik mirip premium hub
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    -- TITLE BAR TOP
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 35, 1, 0)
    CloseButton.Position = UDim2.new(1, -35, 0, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.TextSize = 14
    CloseButton.Parent = TitleBar
    CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- SIDEBAR NAVIGASI (KIRI)
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 100, 1, -35)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Sidebar.BorderSizePixel = 0
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.ScrollBarThickness = 2
    Sidebar.Parent = MainFrame

    local SideLayout = Instance.new("UIListLayout")
    SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SideLayout.Padding = UDim.new(0, 2)
    SideLayout.Parent = Sidebar

    -- CONTAINER UTAMA HALAMAN (KANAN)
    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -105, 1, -40)
    PageContainer.Position = UDim2.new(0, 105, 0, 38)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    self.PageContainer = PageContainer
    self.Sidebar = Sidebar
    self.Tabs = {}
    self.TabCount = 0
    return MainFrame
end

function Library:CreateTab(tabName)
    self.TabCount = self.TabCount + 1
    local currentOrder = self.TabCount

    -- Halaman Konten Kanan
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 75)
    Page.Visible = false
    Page.Parent = self.PageContainer

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 6)
    PageLayout.Parent = Page

    -- Tombol Menu di Kiri
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 32)
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabButton.BorderSizePixel = 0
    TabButton.Text = "  " .. tabName
    TabButton.TextColor3 = Color3.fromRGB(160, 160, 165)
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.TextSize = 12
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.LayoutOrder = currentOrder
    TabButton.Parent = self.Sidebar

    local function SwitchTab()
        for _, t in pairs(self.Tabs) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            t.Button.TextColor3 = Color3.fromRGB(160, 160, 165)
        end
        Page.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(33, 33, 40)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 15)
    end

    TabButton.MouseButton1Click:Connect(SwitchTab)
    table.insert(self.Tabs, {Page = Page, Button = TabButton})

    if #self.Tabs == 1 then SwitchTab() end
    self.Sidebar.CanvasSize = UDim2.new(0, 0, 0, SideLayout.AbsoluteContentSize.Y)

    local TabObject = {ElementCount = 0, Page = Page, PageLayout = PageLayout}

    -- 🟢 SEKARANG FIX: FUNGSI LABEL RESMI DISEDIAKAN!
    function TabObject:CreateLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0, 250, 0, 50) -- Tinggi otomatis muat multi-line text
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(210, 210, 215)
        Label.Font = Enum.Font.SourceSans
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextYAlignment = Enum.TextYAlignment.Top
        Label.LayoutOrder = self.ElementCount
        Label.Parent = self.Page

        self.ElementCount = self.ElementCount + 1
        self.Page.CanvasSize = UDim2.new(0, 0, 0, self.PageLayout.AbsoluteContentSize.Y + 15)

        -- Me-return object agar text-nya bisa diupdate via fungsi eksternal
        local LabelControl = {}
        function LabelControl:UpdateText(newText)
            Label.Text = newText
        end
        return LabelControl
    end

    function TabObject:CreateToggle(labelText, callback)
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(0, 250, 0, 30)
        Container.BackgroundTransparency = 1
        Container.LayoutOrder = self.ElementCount
        Container.Parent = self.Page

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0, 180, 1, 0)
        Label.Text = labelText
        Label.TextColor3 = Color3.fromRGB(230, 230, 230)
        Label.Font = Enum.Font.SourceSansBold
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Parent = Container

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 50, 0, 24)
        ToggleButton.Position = UDim2.new(0, 195, 0, 3)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
        ToggleButton.Text = "OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.Font = Enum.Font.SourceSansBold
        ToggleButton.TextSize = 11
        ToggleButton.Parent = Container

        local isToggled = false
        ToggleButton.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            ToggleButton.BackgroundColor3 = isToggled and Color3.fromRGB(40, 150, 75) or Color3.fromRGB(160, 40, 40)
            ToggleButton.Text = isToggled and "ON" or "OFF"
            callback(isToggled)
        end)

        self.ElementCount = self.ElementCount + 1
        self.Page.CanvasSize = UDim2.new(0, 0, 0, self.PageLayout.AbsoluteContentSize.Y + 15)
    end

    function TabObject:CreateNumericInput(labelText, placeholder, callback)
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(0, 250, 0, 30)
        Container.BackgroundTransparency = 1
        Container.LayoutOrder = self.ElementCount
        Container.Parent = self.Page

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0, 90, 1, 0)
        Label.Text = labelText
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.Font = Enum.Font.SourceSansBold
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Parent = Container

        local TextBox = Instance.new("TextBox")
        TextBox.Size = UDim2.new(0, 150, 1, 0)
        TextBox.Position = UDim2.new(0, 95, 0, 0)
        TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        TextBox.Text = ""
        TextBox.PlaceholderText = placeholder
        TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.Font = Enum.Font.SourceSans
        TextBox.TextSize = 12
        TextBox.Parent = Container

        TextBox:GetPropertyChangedSignal("Text"):Connect(function()
            local clean = TextBox.Text:gsub("[^%d%.%-]", "")
            if TextBox.Text ~= clean then TextBox.Text = clean end
        end)

        TextBox.FocusLost:Connect(function()
            callback(tonumber(TextBox.Text) or 0)
        end)

        self.ElementCount = self.ElementCount + 1
        self.Page.CanvasSize = UDim2.new(0, 0, 0, self.PageLayout.AbsoluteContentSize.Y + 15)
    end

    function TabObject:CreateButton(text, color, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 250, 0, 32)
        Button.BackgroundColor3 = color
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.SourceSansBold
        Button.TextSize = 13
        Button.LayoutOrder = self.ElementCount
        Button.Parent = self.Page

        Button.MouseButton1Click:Connect(callback)
        
        self.ElementCount = self.ElementCount + 1
        self.Page.CanvasSize = UDim2.new(0, 0, 0, self.PageLayout.AbsoluteContentSize.Y + 15)
        return Button
    end

    function TabObject:CreateSeparator(text)
        local Sep = Instance.new("Frame")
        Sep.Size = UDim2.new(0, 250, 0, 20)
        Sep.BackgroundTransparency = 1
        Sep.LayoutOrder = self.ElementCount
        Sep.Parent = self.Page
        
        local Line = Instance.new("Frame")
        Line.Size = UDim2.new(1, 0, 0, 1)
        Line.Position = UDim2.new(0, 0, 0.5, 0)
        Line.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        Line.Parent = Sep
        
        local Lbl = Instance.new("TextLabel")
        Lbl.Size = UDim2.new(0, 100, 1, 0)
        Lbl.Position = UDim2.new(0.5, -50, 0, 0)
        Lbl.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        Lbl.Text = text:upper()
        Lbl.TextColor3 = Color3.fromRGB(110, 110, 115)
        Lbl.Font = Enum.Font.SourceSansBold
        Lbl.TextSize = 10
        Lbl.Parent = Sep
        
        self.ElementCount = self.ElementCount + 1
        self.Page.CanvasSize = UDim2.new(0, 0, 0, self.PageLayout.AbsoluteContentSize.Y + 15)
    end

    return TabObject
end

return Library

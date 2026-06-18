local Library = {}

function Library:CreateWindow(titleText)
    local CoreGui = game:GetService("CoreGui")
    
    -- Hapus UI lama jika nama sama agar tidak menumpuk
    if CoreGui:FindFirstChild("MyCustomHackMenu") then
        CoreGui.MyCustomHackMenu:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MyCustomHackMenu"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 260, 0, 370)
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

    -- Simpan referensi mainframe agar fungsi Button tahu harus nempel di mana
    self.MainFrame = MainFrame
    self.ButtonCount = 0
    
    return MainFrame
end

function Library:CreateButton(text, color, callback)
    if not self.MainFrame then return end
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 220, 0, 40)
    
    -- Posisi otomatis ke bawah berdasarkan jumlah tombol yang sudah dibuat
    local yPosition = 50 + (self.ButtonCount * 50)
    Button.Position = UDim2.new(0, 20, 0, yPosition)
    
    Button.BackgroundColor3 = color
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 14
    Button.Parent = self.MainFrame

    -- Jalankan fungsi exploit ketika tombol diklik
    Button.MouseButton1Click:Connect(callback)
    
    self.ButtonCount = self.ButtonCount + 1
    return Button
end

return Library

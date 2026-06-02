local PANEL = {}

local grey = Color(209, 209, 209)

function PANEL:Init()
    local padding = ScreenScale(32)

    self.startTime = SysTime()
    
    self:SetSize(ScrW(), scrH)
    self:Center()
    self:MakePopup()
    self:DockPadding(padding, 0, padding, padding)

    local label = self:Add("DLabel")
    label:Dock(TOP)
    label:DockMargin(0, padding, 0, padding)
    label:SetFont("Impulse-TitleFont")
    label:SetText("")
    label:SetTextColor(impulse.Config.MainColour)
    label:SetContentAlignment(5)
    label:SizeToContents()
    label:SetExpensiveShadow(4, ColorAlpha(color_black, 100))

    self:SetupItems()
end

function PANEL:PaintOver(w, h)
    local padding = ScreenScale(32)

    if self.invWeight then
        draw.SimpleText(self.invWeight.."kg/"..impulse.Config.InventoryMaxWeight.."kg", "Impulse-Elements27", w / 2 - padding / 2, padding * 2, grey, TEXT_ALIGN_RIGHT)
    end

    if self.storageWeight then
        draw.SimpleText(self.storageWeight.."kg/"..LocalPlayer():GetMaxInventoryStorage().."kg", "Impulse-Elements27", w / 2 + padding / 2, padding * 2, grey, TEXT_ALIGN_LEFT)
    end
end

function PANEL:SetupItems(invscroll, storescroll)
    local padding = ScreenScale(32)

    local w,h = self:GetSize()

    if self.invScroll and IsValid(self.invScroll) then
        self.invScroll:Remove()
    end

    if self.invStorageScroll and IsValid(self.invStorageScroll) then
        self.invStorageScroll:Remove()
    end

    self.invScroll = vgui.Create("DScrollPanel", self)
    self.invScroll:Dock(LEFT)
    self.invScroll:SetWide(w / 2 - padding * 1.5)

    self.invStorageScroll = vgui.Create("DScrollPanel", self)
    self.invStorageScroll:Dock(RIGHT)
    self.invStorageScroll:SetWide(w / 2 - padding * 1.5)


    self.items = {}
    self.itemPanels = {}
    self.itemsStorage = {}
    self.itemPanelsStorage = {}
    local invWeight = 0
    local realInv = impulse.Inventory.Data[0][1]
    local localInv = table.Copy(impulse.Inventory.Data[0][1]) or {}
    local storageWeight = 0
    local realInvStorage = impulse.Inventory.Data[0][2]
    local localInvStorage = table.Copy(impulse.Inventory.Data[0][2]) or {}
    local reccurTemp = {}
    local sortMethod = impulse.GetSetting("inv_sortweight", "Inventory only")
    local invertSort = true

    for v,k in pairs(localInv) do -- fix for fucking table.sort desyncing client/server itemids!!!!!!!
        k.realKey = v

        if sortMethod == "Always" or sortMethod == "Containers only" then
            reccurTemp[k.id] = (reccurTemp[k.id] or 0) + (impulse.Inventory.Items[k.id].Weight or 0)
            k.sortWeight = reccurTemp[k.id]
        else
            k.sortWeight = impulse.Inventory.Items[k.id].Name
            invertSort = false
        end
    end

    local reccurTemp = {}

    for v,k in pairs(localInvStorage) do
        k.realKey = v

        if sortMethod == "Always" or sortMethod == "Containers only" then
            reccurTemp[k.id] = (reccurTemp[k.id] or 0) + (impulse.Inventory.Items[k.id].Weight or 0)
            k.sortWeight = reccurTemp[k.id]
        else
            k.sortWeight = impulse.Inventory.Items[k.id].Name
            invertSort = false
        end
    end

    if localInv and table.Count(localInv) > 0 then
        for v,k in SortedPairsByMemberValue(localInv, "sortWeight", invertSort) do
            local otherItem = self.items[k.id]
            local itemX = impulse.Inventory.Items[k.id]

            if not (itemX.Illegal or itemX.NoStore) then
                if itemX.CanStack and otherItem then
                    otherItem.Count = (otherItem.Count or 1) + 1
                else
                    local item = self.invScroll:Add("impulseInventoryItem")
                    item:Dock(TOP)
                    item:DockMargin(0, 0, 0, 5)
                    item.Basic = true
                    item.Type = 1
                    item:SetItem(k, w)
                    item.InvID = k.realKey
                    item.InvPanel = self
                    self.items[k.id] = item
                end
            end
            invWeight =  invWeight + (itemX.Weight or 0)
        end
    else
        self.empty = self.invScroll:Add("DLabel", self)
        self.empty:SetContentAlignment(5)
        self.empty:Dock(TOP)
        self.empty:SetText("Empty")
        self.empty:SetFont("Impulse-Elements27")
        self.empty:SizeToContents()
    end

    if localInvStorage and table.Count(localInvStorage) > 0 then
        for v,k in SortedPairsByMemberValue(localInvStorage, "sortWeight", invertSort) do
            local otherItem = self.itemsStorage[k.id]
            local itemX = impulse.Inventory.Items[k.id]

            if not (itemX.Illegal or itemX.NoStore) then
                if itemX.CanStack and otherItem then
                    otherItem.Count = (otherItem.Count or 1) + 1
                else
                    local item = self.invStorageScroll:Add("impulseInventoryItem")
                    item:Dock(TOP)
                    item:DockMargin(0, 0, 0, 5)
                    item.Basic = true
                    item.Type = 2
                    item:SetItem(k, w)
                    item.InvID = k.realKey
                    item.InvPanel = self
                    self.itemsStorage[k.id] = item
                end
            end
            storageWeight =  storageWeight + (itemX.Weight or 0)
        end
    else
        self.empty = self.invStorageScroll:Add("DLabel", self)
        self.empty:SetContentAlignment(5)
        self.empty:Dock(TOP)
        self.empty:SetText("Empty")
        self.empty:SetFont("Impulse-Elements27")
        self.empty:SizeToContents()
    end

    self.invWeight = invWeight
    self.storageWeight = storageWeight

    if invscroll then
        self.invScroll:GetVBar():AnimateTo(invscroll, 0)
        self.invStorageScroll:GetVBar():AnimateTo(storescroll, 0)
    end
end

function PANEL:Think()
    if ( input.IsKeyDown(KEY_ESCAPE) or input.IsKeyDown(KEY_SPACE) ) then
        self:Remove()
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.systime)
end

vgui.Register("impulseInventoryStorageLegal", PANEL, "EditablePanel")
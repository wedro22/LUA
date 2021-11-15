--storagedrawers:controller_0 --turtle_0
local storagedrawers = "storagedrawers:controller"  --�������� �����
local tur  --������ ��� ����� �����
local device_all = {}  --������ ���� ��������� ����, ����������� refrechDevices()

--������������� ������
local modem = peripheral.find("modem")
modem.open(15)

--���������� ������ ��������� device_all
local function refrechDevices()
	device_all = modem.getNamesRemote()
	table.insert(device_all, 0, modem.getNameLocal() --�������� ���� �� ������ 0
end

--[[���������� ������ ��������� � ������ ���� �� ���������-��������� �����.
��� ������������ ���������, ����� �������� �� �������� (������),
������� �������� ���� � 1 �����������, ��� �� �������, �������� --]]
local function getDeviceList(device_name)
	if (not device_name) or (#device_name == 0) then
		return nil
	end
	local dev_list = {}
	for _, dev in pairs(device_all) do
		if string.sub(dev, 1, #device_name) == device_name then
			table.insert(dev_list, dev)
		end
	end
	return dev_list
end

refrechDevices()
for k, v in pairs(device_all) do
	print(k, v)
end
print("____")
for k, v in pairs(getDeviceList(tur)) do
	print(k, v)
end
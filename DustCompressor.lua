--storagedrawers:controller_0 --turtle_0
local storagedrawers = "storagedrawers:controller"  --�������� �����
local turtle = "turtle"  --������ ��� ����� �����
local device_all = {}  --������ ���� ��������� ����, ����������� refrechDevices()

--������������� ������
local modem = peripheral.find("modem")
modem.open(15)

--���������� ������ ��������� device_all
local function refrechDevices()
	device_all = modem.getNamesRemote()
end

--[[���������� ������ ��������� � ������ ���� �� ���������-��������� �����.
��� ������������ ���������, ����� �������� �� �������� (������),
������� �������� ���� � 1 �����������, ��� �� �������, �������� --]]
local function getDeviceList(device_name)
	local dev_list = {}
	for _, dev in pairs(device_all) do
		if string.sub(device_name, 1, #device_name) == device_name then
			table.insert(dev_list, dev)
		end
	end
	return dev_list
end

refrechDevices()
print(getDeviceList(storagedrawers))
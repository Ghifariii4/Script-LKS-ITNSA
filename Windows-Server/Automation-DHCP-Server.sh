Install-WindowsFeature DHCP -IncludeManagementTools

# Authorize DHCP Server ini di Active Directory domain itnsa.id
Add-DhcpServerInDC -DnsName "FW.itnsa.id" -IPAddress "192.168.1.254"

# Membuat DHCP Scope "itnsa.id Client" dengan Lease Time 1 hari 39 menit 39 detik
Add-DhcpServerv4Scope -Name "itnsa.id Client" -StartRange 192.168.2.10 -EndRange 192.168.2.200 -SubnetMask 255.255.255.0 -LeaseDuration 1.00:39:39

# Menambahkan Excluded Address (IP yang tidak boleh disewakan)
Add-DhcpServerv4ExclusionRange -ScopeId 192.168.2.0 -StartRange 192.168.2.110 -EndRange 192.168.2.120

# Mengatur DHCP Options: Gateway (Router), Domain Name, dan DNS Servers
Set-DhcpServerv4OptionValue -ScopeId 192.168.2.0 -Router 192.168.2.254 -DnsDomain "itnsa.id" -DnsServer "192.168.1.1", "10.1.1.10"

# Mengatur DHCP agar selalu melakukan Dynamic DNS Updates untuk klien
Set-DhcpServerv4DnsSetting -ComputerName "FW.itnsa.id" -DynamicUpdates "Always"

# Restart service DHCP agar semua perubahan langsung diterapkan
Restart-Service dhcpserver


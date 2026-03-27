# --- 1. Membuat A Records (Sekaligus membuat PTR/Reverse record otomatis) ---
# Format: Nama Record, IP Address
Add-DnsServerResourceRecordA -Name "CORE" -ZoneName "itnsa.id" -IPv4Address "192.168.1.1" -CreatePtr -AllowUpdateAny
Add-DnsServerResourceRecordA -Name "SRV" -ZoneName "itnsa.id" -IPv4Address "192.168.1.100" -CreatePtr -AllowUpdateAny
Add-DnsServerResourceRecordA -Name "FW" -ZoneName "itnsa.id" -IPv4Address "192.168.1.254" -CreatePtr -AllowUpdateAny
Add-DnsServerResourceRecordA -Name "CLIENT-GW" -ZoneName "itnsa.id" -IPv4Address "192.168.2.254" -CreatePtr -AllowUpdateAny

# --- 2. Membuat CNAME Records (Alias) ---
# Format: Nama Alias, Target Host
Add-DnsServerResourceRecordCName -Name "CSDRIVE" -HostNameAlias "SRV.itnsa.id" -ZoneName "itnsa.id"
Add-DnsServerResourceRecordCName -Name "FILE" -HostNameAlias "SRV.itnsa.id" -ZoneName "itnsa.id"
Add-DnsServerResourceRecordCName -Name "WWW" -HostNameAlias "SRV.itnsa.id" -ZoneName "itnsa.id"
Add-DnsServerResourceRecordCName -Name "Internal" -HostNameAlias "SRV.itnsa.id" -ZoneName "itnsa.id"
Add-DnsServerResourceRecordCName -Name "Extra" -HostNameAlias "SRV.itnsa.id" -ZoneName "itnsa.id"
Add-DnsServerResourceRecordCName -Name "DC" -HostNameAlias "CORE.itnsa.id" -ZoneName "itnsa.id"

# Membuat zona reverse untuk subnet Server dan Client
Add-DnsServerPrimaryZone -NetworkId "192.168.1.0/24" -ReplicationScope "Domain"
Add-DnsServerPrimaryZone -NetworkId "192.168.2.0/24" -ReplicationScope "Domain"
# Definisi variabel dasar
$domainPath = "DC=itnsa,DC=id"
$ous = @("Employee", "Finance", "Engineer", "Manager")
$password = ConvertTo-SecureString "Skill39@2025" -AsPlainText -Force

# 1. Membuat OU dan Security Group
foreach ($ou in $ous) {
    # Membuat OU
    New-ADOrganizationalUnit -Name $ou -Path $domainPath
    
    # Membuat Security Group di dalam OU masing-masing
    $ouPath = "OU=$ou,$domainPath"
    New-ADGroup -Name $ou -GroupCategory Security -GroupScope Global -Path $ouPath
}

# 2. Fungsi untuk membuat user secara massal
Function Create-ITNSAUsers {
    param($prefix, $count, $ouName, $hasHomeFolder)
    $ouPath = "OU=$ouName,$domainPath"

    # Perulangan for membungkus seluruh proses pembuatan user
    for ($i = 1; $i -le $count; $i++) {

        # Format angka 3 digit (contoh: 001, 002)
        $num = "{0:D3}" -f $i
        $username = "$prefix-$num"

        $userParams = @{
            SamAccountName = $username
            UserPrincipalName = "$username@itnsa.id"
            Name = $username
            GivenName = $username
            Path = $ouPath
            AccountPassword = $password
            Enabled = $true
            PasswordNeverExpires = $true
        }

        # Menambahkan konfigurasi Home Folder jika diperlukan
        if ($hasHomeFolder) {
            $userParams.HomeDrive = "H:"
            $userParams.HomeDirectory = "\\itnsa.id\CSDrive\Home\$username"
        }

        # Eksekusi pembuatan user
        New-ADUser @userParams

        # Memasukkan user ke dalam Security Group yang sesuai dengan OU
        Add-ADGroupMember -Identity $ouName -Members $username
        
    }
}

# 3. Menjalankan fungsi berdasarkan tabel kebutuhan
Create-ITNSAUsers -prefix "employee" -count 514 -ouName "Employee" -hasHomeFolder $false
Create-ITNSAUsers -prefix "engineer" -count 182 -ouName "Engineer" -hasHomeFolder $false
Create-ITNSAUsers -prefix "finance" -count 56 -ouName "Finance" -hasHomeFolder $true
Create-ITNSAUsers -prefix "manager" -count 15 -ouName "Manager" -hasHomeFolder $true

Write-Host "Pembuatan OU, Group, dan User selesai!" -ForegroundColor Green
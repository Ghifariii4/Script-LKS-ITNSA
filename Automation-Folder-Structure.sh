# 1. Install fitur FSRM untuk kuota dan file screening nanti
Install-WindowsFeature FS-Resource-Manager -IncludeManagementTools

# 2. Membuat Root Directory dan Sub-foldernya
New-Item -Path "C:\Shared Folder\Home" -ItemType Directory -Force
New-Item -Path "C:\Shared Folder\Group\Employee" -ItemType Directory -Force
New-Item -Path "C:\Shared Folder\Group\Engineer" -ItemType Directory -Force
New-Item -Path "C:\Shared Folder\Group\Finance" -ItemType Directory -Force
New-Item -Path "C:\Shared Folder\Group\Manager" -ItemType Directory -Force

# 3. Membuat Shared Folder (Home dan Group)
New-SmbShare -Name "Home" -Path "C:\Shared Folder\Home" -ChangeAccess "Authenticated Users"
New-SmbShare -Name "Group" -Path "C:\Shared Folder\Group" -ChangeAccess "Authenticated Users"

# 4. Memastikan akses 'Everyone' dihapus sesuai instruksi soal
Revoke-SmbShareAccess -Name "Home" -AccountName "Everyone" -Force
Revoke-SmbShareAccess -Name "Group" -AccountName "Everyone" -Force
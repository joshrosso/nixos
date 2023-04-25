
[global]
  workgroup = WORKGROUP
  server string = Samba Server %v
  netbios name = samba
  security = user
  map to guest = bad user
  dns proxy = no
  hosts allow = 192.168.64.

[homes]
  comment = Home Directories
  browseable = no
  writable = yes

[josh]
  comment = Josh's Share
  path = /home/josh
  valid users = josh
  read only = no
  browseable = yes

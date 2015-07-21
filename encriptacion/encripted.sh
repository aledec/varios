#!/bin/bash
cryptsetup luksOpen /dev/VolGroup01/LogVolEncrypted crypt_VolGroup01_LogVolEncrypted
udevadm settle
dmsetup table crypt_VolGroup01_LogVolEncrypted 
mount /dev/mapper/crypt_VolGroup01_LogVolEncrypted /encrypted/

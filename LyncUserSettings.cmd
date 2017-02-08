REG ADD "HKCU\Software\Microsoft\Office\15.0\Lync" /v TwoLineView /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Office\15.0\Lync" /v ShowPhoto /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Office\15.0\Lync" /v ShowFavoriteContacts /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Office\15.0\Lync" /v MinimizeWindowToNotificationArea /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\Microsoft\Office\15.0\Lync" /v AutoOpenMainWindowWhenStartup /t REG_DWORD /d 0 /f
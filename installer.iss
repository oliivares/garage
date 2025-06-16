[Setup]
AppName=Garage X
AppVersion=1.0.0
DefaultDirName={pf}\Garage X
DefaultGroupName=Garage X
OutputDir=dist
OutputBaseFilename=GarageX_Installer
SetupIconFile=windows\runner\resources\app_icon.ico

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\Garage X"; Filename: "{app}\garage.exe"; IconFilename: "{app}\app_icon.ico"
Name: "{commondesktop}\Garage X"; Filename: "{app}\garage.exe"; IconFilename: "{app}\app_icon.ico"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Crear icono en el escritorio"; GroupDescription: "Opciones adicionales"
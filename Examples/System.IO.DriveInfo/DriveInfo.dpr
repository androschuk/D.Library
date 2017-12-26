program DriveInfo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, System.IO.DriveInfo;

procedure PrintDrivesInformation;
var
  Drives: TArray<IDriveInfo>;
  DriveInfo: IDriveInfo;
begin
  Drives := TDriveInfo.GetDrives;
  for DriveInfo in Drives do
  begin
    Writeln('Drive ' + DriveInfo.Name);
    Writeln('  Drive type: ' + DriveInfo.DriveType.ToString);

    if DriveInfo.IsReady then
    begin
      Writeln('  Volume label: '+ DriveInfo.VolumeLabel);
      Writeln('  File system: '+ DriveInfo.DriveFormat);
      Writeln('  Available space to current user: '+ DriveInfo.AvailableFreeSpace.ToString + ' bytes');
      Writeln('  Total available space: ' + DriveInfo.TotalFreeSpace.ToString + ' bytes');
      Writeln('  Total size of drive: ' + DriveInfo.TotalSize.ToString + ' bytes');
      Writeln('');
    end;
  end;
end;

begin
  try
    PrintDrivesInformation;

    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
